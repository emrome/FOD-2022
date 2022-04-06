{7. Realizar un programa que permita:
a. Crear un archivo binario a partir de la información almacenada en un archivo de texto.
El nombre del archivo de texto es: “novelas.txt”
b. Abrir el archivo binario y permitir la actualización del mismo. Se debe poder agregar
una novela y modificar una existente. Las búsquedas se realizan por código de novela.
NOTA: La información en el archivo de texto consiste en: código de novela,
nombre,género y precio de diferentes novelas argentinas. De cada novela se almacena la
información en dos líneas en el archivo de texto. La primera línea contendrá la siguiente
información: código novela, precio, y género, y la segunda línea almacenará el nombre
de la novela.}

program ej7;
const
    NAME='novelas.txt';
    N_NAME='novelas';
type
    novela=record
        cod:integer;
        nombre:string;
        genero:string;
        precio:real;
    end;
    novelas_file=file of novela;

procedure cearBinario(var n:novelas_file);
var
    fText:text;
    nov:novela;
begin
    assign(fText,NAME);
    assign(n,N_NAME);
    reset(fText);
    rewrite(n);
    while(not eof(fText))do begin
        readln(fText,nov.cod,nov.precio,nov.genero);
        readln(fText,nov.nombre);
        write(n,nov);
    end;
    close(fText);
    close(n);
end;


procedure leerNovela(var n:novela);
begin
    write('Ingrese codigo de novela: ');
    readln(n.cod);
    write('Ingrese nombre de novela: ');
    readln(n.nombre);
    write('Ingrese genero de novela: ');
    readln(n.genero);
    write('Ingrese precio de novela: ');
    readln(n.precio);
end;

procedure agregarNovela(var nov:novelas_file);
var     
    n:novela;
begin   
    reset(nov);
    seek(nov,fileSize(nov));
    leerNovela(n);
    write(nov,n);
    close(nov);
end;

procedure modificarNovela(var nov:novelas_file);
var     
    nombre:string;
    n:novela;
    encontre:boolean;
begin   
    encontre:=false;
    reset(nov);
    writeln('Ingrese nombre de la novela a modificar');
    readln(nombre);
    while((not eof(nov))and (not encontre))do begin
        read(nov,n);
        if(n.nombre=nombre)then begin
            writeln('Ingrese datos actualizados de la novela');
            leerNovela(n);
            seek(nov,filePos(nov)-1);
            write(nov,n);
            encontre:=true;
        end;
    end;
    close(nov);
end;

procedure menu(var n:novelas_file);
var
    opcion:string;
begin   
    repeat 
    writeln('-----MENU------');
    writeln('1. Crear archivo binario.');
    writeln('2. Agregar una novela');
    writeln('3. Editar una novela.');
    writeln('4. Salir del programa.');
    writeln('---------------');
    writeln('Ingrese una opcion: ');
    readln(opcion);
    
        case opcion of 
            '1':cearBinario(n);
            '2':agregarNovela(n);
            '3':modificarNovela(n);
        end;
    until opcion='4';
end;

var
    novelas:novelas_file;
begin   
    menu(novelas);
end.
