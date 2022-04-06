{ 3. Se cuenta con un archivo de productos de una cadena de venta de alimentos congelados.
    De cada producto se almacena: código del producto, nombre, descripción, stock disponible,
    stock mínimo y precio del producto.
    Se recibe diariamente un archivo detalle de cada una de las 30 sucursales de la cadena. Se
    debe realizar el procedimiento que recibe los 30 detalles y actualiza el stock del archivo
    maestro. La información que se recibe en los detalles es: código de producto y cantidad vendida. 
    Además, se deberá informar en un archivo de texto: nombre de producto,
    descripción, stock disponible y precio de aquellos productos que tengan stock disponible por
    debajo del stock mínimo.

    Nota: todos los archivos se encuentran ordenados por código de productos. En cada detalle
    puede venir 0 o N registros de un determinado producto.
}

program ej3;
const
    VALOR_ALTO=99999;
    CANT=30;
type
    producto=record
        code:integer;
        nombre:string[20];
        descripcion:string[50];
        stockAv:integer;
        minStock:integer;
        precio:real;
    end;

    actualizacion=record
        cod:integer;
        cantVendida:integer;
    end;

maestro=file of producto;
detalle=file of actualizacion;

detalles=array [1..CANT] of detalle;
arreglo_act=array[1..CANT]of actualizacion

procedure cargarDetalles(var vDet:detalles);
var
    i:integer;
    nombre:string;
begin
    for(i:=1 to CANT)do begin
        nombre:='detalle'+IntToStr(i);
        assign(vDet,nombre);
    end;
end;

procedure leer (var archivo:detalle; var dato:actualizacion);
begin
    if (not eof( archivo ))then 
        read(archivo, dato)
    else dato.cod := VALOR_ALTO;
end;


procedure minimo(var aux:detalles;var min:actualizacion;var det:arreglo_act);
var
    i,minInd,minCod:integer;
begin
    minInd:=-1;
    minCod:=32767;
    for (i:=1 to CANT)do begin
        if(det[i].cod<minCod)then begin
            minCod:=aux[i].code;
            minInd:=i;
            min:=det[i];
        end;    
    end;
    if (minInd<>-1)then 
        leer(aux[minInd],det[minInd]);
end;

procedure actualizarMaestro(var mae:maestro;var arrDet:detalles);
var
    i,total:integer;
    arreglo_act:arreglo_act;
    min,codAct:actualizacion;
    prod:producto;
begin
    for(i:=1 to CANT)do begin
        reset(arrDet[i]);
        leer(arrDet[i],arreglo_act[i]);
    end;
    reset(mae);

    minimo(arrDet,min,arreglo_act);
    while(min.cod<>VALOR_ALTO)do begin
        read(mae,prod);
        while(prod.code<>min.cod)do
            read(mae,prod);
        
        total:=0;
        codAct:=min.cod;
        while(codAct=min.code)do begin
            total:=total+min.cantVendida;    
            minimo(arrDet,min,arreglo_act);
        end;
        prod.stockAv:=prod.stockAv-total;
        seek(mae,filePos(mae)-1);
        write(mae.prod);
    end;
    for(i:=1 to CANT)do 
        close(arrDet[i]);

    close(mae);
end;

{Se deberá informar en un archivo de texto: nombre de producto,
descripción, stock disponible y precio de aquellos productos que tengan stock disponible por
debajo del stock mínimo.
}
procedure textMenorStockMin(fText:text;var mae:maestro);
var
    prod:producto;
begin
    reset(mae);
    assign(fText,'stockDisponibleMenorMinimo.txt');
    rewrite(fText);
    while(not eof(mae))do begin
        read(mae,prod);
        if(prod.stockAv<prod.minStock)then begin
            writeln(fText,prod.precio:2:2,' ',prod.nombre);
            writeln(fText,prod.stockAv,' ',prod.descripcion);
        end;
    end;
    close(mae);
    close(fText);
end;

var
    arc_maestro:maestro;
    arreglo_detalles:detalles;
begin
	assign(arc_maestro, 'maestro');
	cargarDetalles(arreglo_detalles); //carga los N detalles, hace assigns
    actualizarMaestro(arc_maestro,arreglo_detalles);
    textMenorStockMin(fText,arc_maestro);
end.