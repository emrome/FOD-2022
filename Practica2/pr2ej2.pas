{ 2. Se dispone de un archivo con información de los alumnos de la Facultad de Informática. Por
    cada alumno se dispone de su código de alumno, apellido, nombre, cantidad de materias
    (cursadas) aprobadas sin final y cantidad de materias con final aprobado. Además, se tiene
    un archivo detalle con el código de alumno e información correspondiente a una materia
    (esta información indica si aprobó la cursada o aprobó el final).
    Todos los archivos están ordenados por código de alumno y en el archivo detalle puede
    haber 0, 1 ó más registros por cada alumno del archivo maestro. 
    Se pide realizar un programa con opciones para:
        a. Actualizar el archivo maestro de la siguiente manera:
            i.Si aprobó el final se incrementa en uno la cantidad de materias con final aprobado.
            ii.Si aprobó la cursada se incrementa en uno la cantidad de materias aprobadas sin final.
    
        b. Listar en un archivo de texto los alumnos que tengan más de cuatro materias con cursada aprobada 
        pero no aprobaron el final. Deben listarse todos los campos.

    NOTA: Para la actualización del inciso a) los archivos deben ser recorridos sólo una vez.
}
program ej2;
const
    VALOR_ALTO=9999;
    COND=4;
type
    alumno=record
        code:integer;
        nombre=string[20];
        apellido:string[20];
        cursadas:integer;
        finales:integer;
    end;
    info=record
        codAlum:integer;
        materia:string[20];
        final:boolean;
    end;

meastro=file of alumno;
detalle=file of info;

procedure leerAlumno(var al:alumno);
procedure crearMaestro(var mae:maestro);
procedure crearDetalle(var det:detalle);

procedure leer(var det:detalle;var reg:info);
begin
    if (not eof(det))then
        read(det,reg)
    else
        reg.codAlum:=VALOR_ALTO;
end;

procedure actualizarMaestro(var mae:maestro;var det:detalle);
var
    reg_det:info;
    reg_mae:alumno;
begin
    reset(mae);
    reset(det);
    leer(det,reg_det);
   
    while(det_reg.codAlum<>VALOR_ALTO)do begin
        read(mae,reg_mae);
        while(reg_mae.code<>reg_det.codAlum)do
            read(mae,reg_mae);
        
        while(reg_det.codAlum=reg_mae.code)do begin
            if(aux.final)then
                reg_mae.finales:=reg_mae.finales+1;
            else
                reg_mae.cursadas:=reg_mae.cursadas+1;
            leer(det,reg_det);
        end;
        seek(mae,filePos(mae)-1);
        write(mae,reg_mae);
    end;
    close(mae);
    close(det);
end;


procedure listarEnTexto4C(var fText:text;var mae:maestro);
var
    aux:alumno;
begin
    rewrite(fText);
    reset(mae);
    while(not eof(mae))do begin
        read(mae,aux);
        if(aux.cursadas>COND)then begin
            writeln(fText,aux.code,' ',aux.cursadas,' ',aux.nombre);
            writeln(fText,aux.finales,' ',aux.apellido);
        end;
    end;
    close(mae);
    close(fText)
end;


var
    archivoMaestro:maestro;
    archivoDetalle:detalle;
    fileText:text;
begin
    assign(archivoMaestro,'maestro');
    assign(archivoDetalle, 'detalle');
    assign(fileText, 'masDeCuatroSinFinal.txt');

    actualizarMaestro(archivo_maestro, archivo_detalle); 
    listarEnTexto4C(archivoMaestro,fileText);
end.
