{ 8. Se cuenta con un archivo que posee información de las ventas que realiza una empresa a
    los diferentes clientes. Se necesita obtener un reporte con las ventas organizadas por
    cliente. Para ello, se deberá informar por pantalla: los datos personales del cliente, el total
    mensual (mes por mes cuánto compró) y finalmente el monto total comprado en el año por el
    cliente.
    Además, al finalizar el reporte, se debe informar el monto total de ventas obtenido por la
    empresa.
    El formato del archivo maestro está dado por: cliente (cod cliente, nombre y apellido), año,
    mes, día y monto de la venta.
    El orden del archivo está dado por: cod cliente, año y mes.
    Nota: tenga en cuenta que puede haber meses en los que los clientes no realizaron compras.
}

program ej8;
const
    VALOR_ALTO=9999;
type
    cliente=record
        cod:integer;
        nombre:string[15];
        apellido:string[20];
    end;
    
    venta=record
        cli:cliente;
        anio:integer;
        mes:integer;
        dia:integer;
        monto:real;
    end;

maestro=file of venta; //orden: cod cliente, año y mes.


procedure leer(var mae:maestro;var regM:venta);
begin
    if(not eof(mae))then
        read(mae,regM)
    else
        regM.cli.cod:=VALOR_ALTO;
end;
procedure imprimirCliente(cli:cliente);
begin
    writeln('Datos cliente: ');
    writeln('Nombre: ',cli.nombre,' Apellido: ',cli.apellido,' Codigo: ',cli.cod);
end;

{
    Reporte: datos personales del cliente, el total mensual (mes por mes cuánto compró) y 
el monto total comprado en el año por el cliente.
    Orden archivo: cod cliente, año y mes.
}

procedure reporteVentas(var mae:maestro);
var
    v:venta;
    mensual,total,ventasEmp:real;
    anioAnio,auxCod,i:integer;
begin
    reset(mae);
    leer(mae,v);
    ventasEmp:=0;
    while(v.cli.cod<>VALOR_ALTO)do begin
        imprimirCliente(v.cli);
        auxCod:=v.cli.cod;
        while(auxCod=v.cli.cod)do begin
            anio:=v.fec.anio;
            totalAnio:=0;
            while((auxCod=v.cli.cod)and(v.fec.anio=anio))do begin
                for (i:=1 to 12)do begin
                    mensual:=0;
                    while((auxCod=v.cli.cod)and(v.fec.anio=anio)and(v.mes=i))do begin
                        mensual:=mensual+v.monto;
                        leer(mae,v);
                        ventasEmp:=ventasEmp+v.monto;   
                    end;

                    writeln('Mes: ',i,' Monto total: ',mensual:2:2);
                    totalAnio:=totalAnio+mensual;
                end;
            end;

            writeln('Anio: ',anio,' Monto total: ',totalAnio:2:2);
        end;
    end;
    writeln('Ventas totales de la Empresa: ', ventasEmp:2:2);
    close(mae);
end;


var
    archivo_maestro:maestro;
begin
    assign(archivo_maestro,'maestroEj8');
    crear_maestro(archivo_maestro);
    reporteVentas(archivo_maestro);
end.
