{
    Definir un programa que genere un archivo con registros de longitud fija conteniendo
información de asistentes a un congreso a partir de la información obtenida por
teclado. Se deberá almacenar la siguiente información: nro de asistente, apellido y
nombre, email, teléfono y D.N.I. Implementar un procedimiento que, a partir del
archivo de datos generado, elimine de forma lógica todos los asistentes con nro de
asistente inferior a 1000.
Para ello se podrá utilizar algún carácter especial situándolo delante de algún campo
String a su elección. Ejemplo: ‘@Saldaño’.

}
program ej2;
const
    CORTE=-1;
    COND=1000;
type
    asistente=record
        nro:integer;
        apellido:string;
        nombre:string;
        email:string;
        telefono:longint;
        DNI:longint;
    end;
maestro=file of asistente;

procedure leerAsistente(var a:asistente);
begin
    writeln('Ingrese nro de asistente');
    readln(a.nro);
    if(a.nro<>CORTE)then begin
        writeln('Ingrese apellido ');
        readln(a.apellido);
        writeln('Ingrese nombre ');
        readln(a.nombre);
        writeln('Ingrese email ');
        readln(a.email);
        writeln('Ingrese telefono ');
        readln(a.telefono);
        writeln('Ingrese DNI ');
        readln(a.DNI);
    end;
end;
procedure generarMaestro(var mae:maestro);
var
    asis:asistente;
begin
    rewrite(mae);
    leerAsistente(asis);
    while(asis.nro<>CORTE)do begin
        write(mae,asis);
        leerAsistente(asis);
    end;
    close(mae);
end;
procedure eliminarAsistentes(var mae:maestro);
var
    reg:asistente;
begin
    reset(mae);
    while(not eof(mae))do begin
        read(mae,reg);
        if(reg.nro<COND)then begin
            reg.apellido:='@'+reg.apellido;
            seek(mae,filepos(mae)-1)
            write(mae,reg);
        end;
    end;
    close(mae);
end;
var
    archivoMaestro:maestro;
begin
    assign(archivoMaestro,'maestro');
    generarMaestro(archivoMaestro);
    eliminarAsistentes(archivoMaestro);
end.