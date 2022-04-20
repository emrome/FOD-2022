{   Se cuenta con un archivo con información de las diferentes distribuciones de linux
    existentes. De cada distribución se conoce: nombre, año de lanzamiento, número de
    versión del kernel, cantidad de desarrolladores y descripción. El nombre de las
    distribuciones no puede repetirse.
    Este archivo debe ser mantenido realizando bajas lógicas y utilizando la técnica de
    reutilización de espacio libre llamada lista invertida.
    Escriba la definición de las estructuras de datos necesarias y los siguientes
    procedimientos:
        ExisteDistribucion: módulo que recibe por parámetro un nombre y devuelve verdadero si
    la distribución existe en el archivo o falso en caso contrario.
        AltaDistribución: módulo que lee por teclado los datos de una nueva distribución y la
    agrega al archivo reutilizando espacio disponible en caso de que exista. (El control de
    unicidad lo debe realizar utilizando el módulo anterior). En caso de que la distribución que
    se quiere agregar ya exista se debe informar “ya existe la distribución”.
        BajaDistribución: módulo que da de baja lógicamente una distribución  cuyo nombre se
    lee por teclado. Para marcar una distribución como borrada se debe utilizar el campo
    cantidad de desarrolladores para mantener actualizada la lista invertida. Para verificar
    que la distribución a borrar exista debe utilizar el módulo ExisteDistribucion. En caso de no
    existir se debe informar “Distribución no existente”
}
program ej8;
type
    distribucion=record
        nombre=string[20];
        anio=longint;
        version=string[20];
        desarrolladores:integer;
        descripcion:string[50];
    end;

archivo=file of distribucion;

procedure leerDistribucion(var d:distribucion);
begin
    writeln('Ingrese nombre de la distribucion ');readln(d.nombre);
    writeln('Ingrese anio de la distribucion ');readln(d.anio);
    writeln('Ingrese numero de version del kernel ');readln(d.version);
    writeln('Ingrese cantidad de desarrolladores ');readln(d.desarrolladores);
    writeln('Ingrese descripcion ');readln(d.descripcion);
end;

function existeDistribucion(var m:archivo;nombre:string):boolean;
var
    reg:distribucion;
    esta,estaBorrado:boolean;
begin
    esta:=false;
    reset(m);
    while((not eof(m))and(not esta))do begin //solo deberia comprobar que no este, no importa si ya aparece como baja logica??
        read(m,reg);
        if((reg.nombre=nombre))then begin 
            esta:=true;
            estaBorrado:=(reg.desarrolladores<=0);
        end;
    end;
    close(m);
    existeDistribucion:=(esta and (not estaBorrado));
end;

procedure AltaDistribucion(var m:archivo);
var
    reg,aux:distribucion;
begin
    leerDistribucion(reg);
    if(not existeDistribucion(m,reg.nombre))then begin
        reset(m);
        read(m,aux); //leo cabecera
        if(aux.desarrolladores<0)then begin//hay lugar libre
            seek(m,(aux.desarrolladores*-1))//voy al lugar libre
            read(m,aux);//leo el num de la lista invertida
            seek(m,filepos(m)-1);
            write(m,reg); //alta de la distribucion
            seek(m,0);      //voy a la cabecera
            write(m,aux);   //escribo el nrr del sig libre
        end
        else begin
            seek(m,filesize(m))
            write(m,reg);
        end;
        writeln('Se agrego la distribucion ');
        close(m);
    end
    else
        writeln('La distribucion ya existe ')
end;

procedure BajaDistribucion(var m:archivo);
var
    nombre:string;
    cabecera:integer;
    aux:distribucion;
begin
    writeln('Ingrese nombre de la distribucion a eliminar');
    readln(nombre);
    if(existeDistribucion(m,nombre))then begin
        reset(m);
        read(m,aux);//leo el reg cabecera
        cabecera:=aux.desarrolladores;
        
        read(m,aux);
        while(aux.nombre<>nombre)do 
            read(m,aux);
        //encontre distribucion a eliminar
        aux.desarrolladores:=cabecera; //escribo el reg cabecera en el eliminado
        seek(m,filepos(m)-1);        // vuelvo a la pos del eliminado
        cabecera:=(filepos(m)*-1);  //me guardo el nrr del eliminado
            
        write(m,aux);               //escribo en el archivo el reg

        aux.desarrolladores:=cabecera; //es la posicion del reg recien eliminado
        seek(m,0);
        write(m,aux);                   //queda en cabecera la pos del reciente eliminado
        
        writeln('Se elimino la distribucion ');
        close(m);
    end
    else
        writeln('La distribucion no existe ');
end;

var
    a:archivo;
begin
    assign(a,'archivo_distribuciones');
    AltaDistribucion(a);
    BajaDistribucion(a)
end.