{   Una cadena de tiendas de indumentaria posee un archivo maestro no ordenado
    con la información correspondiente a las prendas que se encuentran a la venta. De
    cada prenda se registra: cod_prenda, descripción, colores, tipo_prenda, stock y
    precio_unitario. Ante un eventual cambio de temporada, se deben actualizar las prendas
    a la venta. Para ello reciben un archivo conteniendo: cod_prenda de las prendas que
    quedarán obsoletas. Deberá implementar un procedimiento que reciba ambos archivos
    y realice la baja lógica de las prendas, para ello deberá modificar el stock de la prenda
    correspondiente a valor negativo.
    Por último, una vez finalizadas las bajas lógicas, deberá efectivizar las mismas
    compactando el archivo. Para ello se deberá utilizar una estructura auxiliar, renombrando
    el archivo original al finalizar el proceso.. Solo deben quedar en el archivo las prendas
    que no fueron borradas, una vez realizadas todas las bajas físicas.
}

program ej6;
const
    VALOR_ALTO=9999;
type
    prenda=record
        cod_prenda:integer;
        descripcion:string[50];
        colores:string[20];
        tipo_prenda:string[20]; 
        stock:integer;
        precio_unitario:real;
    end;

maestro=file of prenda;
absoletas=file of integer;

procedure leer(var det:absoletas;var reg:integer);
begin
    if(not eof(det))then
        read(det,reg)
    else
        reg:=VALOR_ALTO;
end;

procedure actualizarMaestro(var m:maestro;var det:absoletas);
var
    regM:prenda;
    cod:integer;
begin
    reset(m);
    reset(det);
    leer(det,cod);
    while(cod<>VALOR_ALTO)do begin begin 
        read(m,regM)
        while(cod<>regM.cod_prenda)do 
            read(m,regM);
        regM.stock:=regM.stock*-1;
        seek(m,filepos(m)-1)
        write(m,regM);
        seek(m,0);
        leer(det,cod);
    end;
    close(m);
    close(det);
end;
procedure compactacion(var nuevo,m:maestro);
var
    regM:prenda;
begin
    reset(m);
    rewrite(nuevo);
    while(not eof(m))do begin
        read(m,regM);
        if(regM.stock>=0)then 
            write(nuevo,regM);
        
    end;
    close(nuevo);
    close(m);
end;

var
    archivo_maestro,archivoCompactado:maestro;
    prendas_absoletas:absoletas;
begin
    assign(archivo_maestro,'maestro');
    assign(prendas_absoletas,'prendas_absoletas');
    actualizarMaestro(archivo_maestro,prendas_absoletas);
    assign(archivoCompactado,'maestro_actualizado');
    compactacion(archivo_maestro,archivoCompactado);
    {erase(archivo_maestro);
    rename(archivoCompactado,'maestro');}
end.