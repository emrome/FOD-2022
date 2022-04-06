{  1. Una empresa posee un archivo con información de los ingresos percibidos por diferentes
        empleados en concepto de comisión, de cada uno de ellos se conoce: código de empleado,
        nombre y monto de la comisión. La información del archivo se encuentra ordenada por
        código de empleado y cada empleado puede aparecer más de una vez en el archivo de
        comisiones.
        Realice un procedimiento que reciba el archivo anteriormente descripto y lo compacte. En
        consecuencia, deberá generar un nuevo archivo en el cual, cada empleado aparezca una
        única vez con el valor total de sus comisiones.
        NOTA: No se conoce a priori la cantidad de empleados. Además, el archivo debe ser
        recorrido una única vez.
}
program ej2;
const
    VALOR_CORTE=9999;
type
    empleado=record
        code:integer;
        name:string[20];
        monto:real;
    end;

comisiones=file of empleado;

procedure leer(var aux:comisiones;var emp:empleado);
begin   
    if(not eof(aux))then
        read(aux,emp);
    else
        emp.code:=VALOR_ALTO;
end;


procedure compactarArchivo(var detalle,compactado:comisiones);
var
    reg_det,aux:empleado;

begin
    reset(detalle);
    rewrite(compactado);
    leer(detalle,reg_det);
    while(reg_det.code<>VALOR_ALTO)do begin
        aux.code:=reg_det.code;
        aux.name:=reg_det.name;
        aux.monto:=0;
        while(aux.code=reg_det.code)do begin
            aux.monto:=aux.monto+reg_det.monto;
            leer(detalle,reg_det);
        end;
        write(maestro,aux);
    end;
    close(detalle);
    close(maestro);
end;

//programa principal
var 
    archivoComisiones:comisiones;
    archivoCompactado:comisiones;
begin
    assign(archivoComisiones,'archivo_comisiones');
    assign(archivoCompactado,'archivo_compactado');
    compactarArchivo(archivoComisiones,archivoCompactado);

end.