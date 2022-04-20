{   Realizar un programa que genere un archivo de novelas filmadas durante el presente
    año. De cada novela se registra: código, género, nombre, duración, director y precio.
    El programa debe presentar un menú con las siguientes opciones:
    a. Crear el archivo y cargarlo a partir de datos ingresados por teclado. Se
        utiliza la técnica de lista invertida para recuperar espacio libre en el
        archivo. Para ello, durante la creación del archivo, en el primer registro del
        mismo se debe almacenar la cabecera de la lista. Es decir un registro
        ficticio, inicializando con el valor cero (0) el campo correspondiente al
        código de novela, el cual indica que no hay espacio libre dentro del
        archivo.
    b. Abrir el archivo existente y permitir su mantenimiento teniendo en cuenta el
        inciso a., se utiliza lista invertida para recuperación de espacio. En
        particular, para el campo de ´enlace´ de la lista, se debe especificar los
        números de registro referenciados con signo negativo, (utilice el código de
        novela como enlace).
        Una vez abierto el archivo, brindar operaciones para:
        i. Dar de alta una novela leyendo la información desde teclado. Para
            esta operación, en caso de ser posible, deberá recuperarse el
            espacio libre. Es decir, si en el campo correspondiente al código de
            novela del registro cabecera hay un valor negativo, por ejemplo -5,
            se debe leer el registro en la posición 5, copiarlo en la posición 0
            (actualizar la lista de espacio libre) y grabar el nuevo registro en la
            posición 5. Con el valor 0 (cero) en el registro cabecera se indica
            que no hay espacio libre.
        ii. Modificar los datos de una novela leyendo la información desde
            teclado. El código de novela no puede ser modificado.
        iii. Eliminar una novela cuyo código es ingresado por teclado. Por
            ejemplo, si se da de baja un registro en la posición 8, en el campo
            código de novela del registro cabecera deberá figurar -8, y en el
            registro en la posición 8 debe copiarse el antiguo registro cabecera.
    c. Listar en un archivo de texto todas las novelas, incluyendo las borradas, que
        representan la lista de espacio libre. El archivo debe llamarse “novelas.txt”.
    NOTA: Tanto en la creación como en la apertura el nombre del archivo debe ser
    proporcionado por el usuario.

}
program ej3;
const
    CORTE=-1;
    VALOR_ALTO=9999;
type
    novela=record
        cod:integer;
        genero:string[20];
        nombre:string[50];
        duracion:integer;
        director:string[20];
        precio:real;
    end;

novelas=file of novela;

procedure leerNovela(var n:novelas);
begin
    writeln('INGRESE CODIGO ');readln(n.cod);
    if(n.cod<>CORTE)then begin
        writeln('INGRESE GENERO: ');readln(n.genero);
        writeln('INGRESE NOMBRE: ');readln(n.nombre);
        writeln('INGRESE DURACION ');readln(n.duracion);
        writeln('INGRESE DIRECTOR ');readln(n.director);
        writeln('INGRESE PRECIO ');readln(n.precio);
        
    end;
end;
procedure crearArchivo(var mae:novelas);
var
    nombre:string;
    nov:novela;
begin 
    writeln('INGRESE NOMBRE DEL ARCHIVO A CREAR');
    readln(nombre);
    assign(mae,nombre);
    rewrite(mae);
    nov.cod:=0;
    write(mae,nov);
    leerNovela(nov);
    while(nov.cod<>CORTE)do begin
        write(mae,nov);
        leerNovela(nov);
    end;
    close(mae);
end;

procedure agregarNovela(var mae:novelas);
var
    nombre:string;
    aux,nov:novela;
begin
    reset(mae);
    leerNovela(nov);
    read(mae,aux);
    if aux.cod<>0 then begin 
        seek(mae,(aux.cod*-1))
        read(mae,aux);
        seek(mae,filepos(mae)-1)
        write(mae,nov);
        seek(mae,0);
        write(mae,aux);
        writeln ('NOVELA AGREGADA')
    end
    else begin //no hay espacio libre
        seek(mae,filesize(mae));
        write(mae,nov);
    end;
    close(mae);
end;


procedure modificar(var n:novela);
var
    op:string;
begin
    writeln('CODIGO DE NOVELA A MODIFICAR: ',nov.cod);
    writeln('INFO: ');
    writeln('Nombre: ',n.nombre,' Genero: ',n.genero,' Duracion: ',n.duracion,
    ' Director: ',n.director,' Precio: ',n.precio);
    
    writeln('INGRESE LOS NUEVOS DATOS ');
    writeln('Ingrese nuevo nombre ');readln(n.nombre);
    writeln('Ingrese nuevo genero ');readln(n.genero);
    writeln('Ingrese nuevo precio ');readln(n.precio);
    writeln('Ingrese nueva duracion ');readln(n.duracion);
    writeln('Ingrese nuevo director ');readln(n.director);
end;

procedure leer(var mae:novelas;var reg:novela);
begin
    if(not eof(mae))then
        read(mae,reg)
    else
        reg.cod:=VALOR_ALTO;
end;
procedure modificarNovela(var mae:novelas);
var
    nombre:string;
    cod:integer;
    nov:novela;
begin

    reset(mae);
    writeln('Ingrese codigo de la novela a modificar: ')
    readln(cod);
    leer(mae,nov);
    while((nov.cod<>VALOR_ALTO)and(cod<>nov.cod))do 
        leer(mae,nov);//es necesario o con el read esta

    if((nov.cod<>VALOR_ALTO)and(cod=nov.cod))then begin
        modificar(nov);
        seek(mae,filepos(mae)-1);
        write(mae,nov);
        writeln ('NOVELA MODIFICADA')
    end
    else
        writeln('CODIGO NO ENCONTRADO');
    close(mae);
end;
procedure eliminarNovela(var mae:novelas);
var
    cod:integer;
    nov,aux:novela;
begin
    writeln('Ingrese codigo de novela a eliminar');
    readln(cod);
    read(mae,aux);//leo reg cabecera
    while(not eof(mae))and(cod<>nov.cod))do 
        read(mae,nov);//es necesario o con el read esta

    if((not eof(mae))and(cod=nov.cod))then begin
        nov.cod:=aux.cod;
        seek(mae,filepos(mae)-1);
        aux.cod:=filepos(mae)*-1;
        write(mae,nov);
        seek(mae,0);
        write(mae,aux);
        writeln ('NOVELA ELIMINADA');
    end
    else
        writeln('CODIGO NO ENCONTRADO');

end;

procedure abrirArchivo(var mae:novelas);
var
    nombre,opcion:string;
begin
    writeln('INGRESE NOMBRE DEL ARCHIVO A ABRIR');
    readln(nombre);
    assign(mae,nombre);
    reset(mae);
    repeat
        writeln('INGRESE POR TECLADO LA OPCION QUE DESEA REALIZAR CON EL ARCHIVO ABIERTO');
        writeln('1: DAR DE ALTA NOVELA');
        writeln('2: MODIFICAR NOVELA ');
        writeln('3: ELIMINAR NOVELA');
        writeln('4: SALIR')
        write('OPCION: ');
        readln(opcion);
        case opcion of:
            '1':agregarNovela(mae);
            '2':modificarNovela(mae);
            '3':eliminarNovela(mae);
    until opcion='4'
    close(mae);
end;

procedure listarEnTxt(var mae:novelas;var fText:text);
var
    nov:novela;
begin
    reset(mae);
    rewrite(fText);
    read(mae,nov);
    while(not eof(mae)) do begin
        read(mae,nov);
        if(nov.cod>0)then begin
            writeln(fTExt,nov.cod,' ',nov.nombre,);
            writeln(fTExt,nov.duracion,' ',nov.genero);
            writeln(fTExt,nov.precio,' ',nov.director);
        end
        else
            writeln(fText,'ESPACIO LIBRE');

    end;
    close(mae);
    close(fText);
end;



procedure menu(var mae:novelas;var fText:text);
var
    opcion:string;
begin
    writeln('-------------MENU--------------');
    repeat
        writeln('1: CREAR ARCHIVO DE NOVELAS');
        writeln('2: ABRIR ARCHIVO DE NOVELAS ');
        writeln('3: LISTAR EN ARCHIVO DE TEXTO');
        writeln('4: SALIR')
        write('OPCION: ');
        readln(opcion);
        case opcion of:
            '1':crearArchivo(mae);
            '2':abrirArchivo(mae);
            '3':listarEnTxt(mae,fText);
    until opcion='4'
end;

var
    archivo_texto:text;
    archivo_novelas:novelas;
begin
    assign(archivo_texto,'novelas.txt');
    menu(archivo_novelas,archivo_texto);
end;
    