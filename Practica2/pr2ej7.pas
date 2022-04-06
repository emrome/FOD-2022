{ 7. El encargado de ventas de un negocio de productos de limpieza desea administrar el
    stock de los productos que vende. Para ello, genera un archivo maestro donde figuran todos
    los productos que comercializa. De cada producto se maneja la siguiente información:
    código de producto, nombre comercial, precio de venta, stock actual y stock mínimo.
    Diariamente se genera un archivo detalle donde se registran todas las ventas de productos
    realizadas. De cada venta se registran: código de producto y cantidad de unidades vendidas.

    Se pide realizar un programa con opciones para:
        a. Actualizar el archivo maestro con el archivo detalle, sabiendo que:
            ● Ambos archivos están ordenados por código de producto.
            ● Cada registro del maestro puede ser actualizado por 0, 1 ó más registros del archivo detalle.
            ● El archivo detalle sólo contiene registros que están en el archivo maestro.
        b. Listar en un archivo de texto llamado “stock_minimo.txt” aquellos productos cuyo stock actual esté 
        por debajo del stock mínimo permitido.
}
program ej7;
const   
    NOMBRE='stock_minimo';
    VALOR_ALTO='ZZZZ';
type
    producto=record
        cod:string[20];
        nombre:string[20];
        precio:real;
        stockAc:integer;
        stockMin:integer;
    end;
    venta=record
        cod_prod:string[20];
        cant_vendida:integer;
    end;

maestro=file of producto;
detalle=file of venta;

procedure leer(var det:detalle;var v:venta);
begin
    if(eof(det))then
        v.cod_prod:=VALOR_ALTO;
    else
        read(det,v);
end;

procedure actualizarMaestro(var mae:maestro;var det:detalle);
var
    regD:venta;
    regM:producto;
    auxCod:string[20];
    cant:integer;
begin
    reset(mae);
    reset(det);
    leer(det,regD);
    while(regD.cod_prod<>VALOR_ALTO)do begin
        read(mae,regM);
        while(regM.cod<>regD.cod_prod)do 
            read(mae,regM);
        
        auxCod:=regD.cod_prod;
        cant:=0;
        while(auxCod=regD.cod_prod)do begin
            cant:=cant+regD.cant_vendida;
            leer(det,regD);
        end;
        regM.stockAc:=regM.stockAc-cant;
        seek(mae,filepos(mae)-1);
        write(mae,regM);
    end;
    close(det);
    close(mae);
end;

{
    Listar en un archivo de texto llamado “stock_minimo.txt” aquellos productos cuyo stock actual esté 
por debajo del stock mínimo permitido.
}
procedure listar_StockMinimo(var mae:maestro;var fText:text);
var
    regM:producto;
begin
    assign(fText,NOMBRE);
    rewrite(fText);
    reset(mae);
    while(not eof(mae))do begin
        read(mae,regM)
        if(regM.stockAc<regM.stockMin)then begin
            with regM do begin
                writeln(fText,precio:2:2,' ',cod);
                writeln(fText,stockAc,' ',stockMin,' ',nombre);
            end;
        end;
    end;
    close(fText);
    close(mae);
end;

var
    archivo_maestro:maestro;
    archivo_detalle:detalles;
    archivo_stockMin:text;
begin
    assign(archivo_maestro,'maestro');
    assign(archivo_detalle,'detalle');
    actualizarMaestro(archivo_maestro,archivo_detalle);
    listar_StockMinimo(archivo_maestro,archivo_stockMin);
end.