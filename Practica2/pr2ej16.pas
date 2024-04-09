{   La editorial X, autora de diversos semanarios, posee un archivo maestro con la
    información correspondiente a las diferentes emisiones de los mismos. De cada emisión se
    registra: fecha, código de semanario, nombre del semanario, descripción, precio, total de
    ejemplares y total de ejemplares vendido.
    Mensualmente se reciben 100 archivos detalles con las ventas de los semanarios en todo el
    país. La información que poseen los detalles es la siguiente: fecha, código de semanario y
    cantidad de ejemplares vendidos. Realice las declaraciones necesarias, la llamada al
    procedimiento y el procedimiento que recibe el archivo maestro y los 100 detalles y realice la
    actualización del archivo maestro en función de las ventas registradas. Además deberá
    informar fecha y semanario que tuvo más ventas y la misma información del semanario con
    menos ventas.
    
    Nota: Todos los archivos están ordenados por fecha y código de semanario. No se realizan
    ventas de semanarios si no hay ejemplares para hacerlo
}
program ej16;
const
    VALOR_ALTO=9999;
    CANT_DET=100;
type
    emision=record
        fecha:longInt;
        codSemanario:string[20];
        nombreSemanario:string[20];
        descripcion:string[15];
        precio:real;
        totalEjemplares:integer;
        ejemplaresVendidos:integer;
    end;
    infoDetalle=record
        fecha:longInt;
        codSemanario:string[20];
        vendidos:integer;
    end;

maestro=file of emision;
detalle=file of infoDetalle;

vDetalles=array[1..CANT_DET]of detalle;
vInfo=array[1..CANT_DET]of infoDetalle;

procedure leer(var det:detalle;var reg:infoDetalle);
begin
    if(not eof(det))then
        read(det,reg)
    else
        reg.fecha:=VALOR_ALTO;
end;

procedure minimo(var vDet:vDetalles;vI:vInfo;var min:infoDetalle);
var
    indMin,i:integer;
begin
    indMin:=-1;
    min.fecha:=VALOR_ALTO;
    for(i:=1 to CANT_DET)do begin
        if(vI[i].fecha<>VALOR_ALTO)then
            if((vI[i].fecha<min.fecha)or((vI[i].fecha=min.fecha)and(vI[i].codSemanario<min.codSemanario))then begin
                indMin:=i;
                min.fecha:=vI[i].fecha;
                min.codSemanario:=vI[i].codSemanario
            end;
    end;
    if(indMin<>-1)then begin
        min:=vI[i];
        leer(vDet[indMin],vI[indMin]);
    end;
end;

procedure actualizarMaestro(var mae:maestro;var vDet:vDetalles);
var
    i:integer;
    min:infoDetalle;
    maxS,minS:infoDetalle;
    arregloInfo:=vInfo;
    regM:emision;
    aux:infoDetalle;
begin
    maxS.vendidos:=0;
    minS.vendidos:=9999;
    reset(mae);
    for(i:=1 to CANT_DET)do begin
        reset(vDet[i]);
        leer(vDet[i],arregloInfo[i]);
    end;
    minimo(vDet,arregloInfo,min);
    while(min.fecha<>VALOR_ALTO) do begin
        aux:= min;
        while((regM.fecha=min.fecha)and(regM.codSemanario=min.codSemanario))do begin
            aux.vendidos:= aux.vendidos + min.ejemplaresVendidos;
            minimo(vDet,arregloInfo,min);
        end;

        // Busqueda en Maestro
        read(mae,regM);
        while((regM.fecha<>aux.fecha)and(regM.codSemanario<>aux.codSemanario))do 
            read(mae,regM);
        
        // Minimo y Máximo
        if(aux.vendidos > maxS.vendidos) then max:=aux;
        if(aux.vendidos < minS.vendidos) then min:=aux;

        // Actualizo información
        seek(mae,filepos(mae)-1);
        write(mae,regM);
    end;
    writeln('Emision con menos ventas: ')
    writeln('Fecha: 'minS.fecha,' Código de Semanario: ',minS.codSemanario)
    writeln('Emision con mas ventas: ')
    writeln('Fecha': maxS.fecha,' Código de Semanario: ', maxS.codSemanario);
end;

var
    arregloDetalles:vDetalles;
    archivoMaestro:maestro;
    i:integer;
    nombre:string[15];
begin
    assign(archivoMaestro,'maestro');
    for i:=1 to CANT_DET do begin
        nombre:='detalle'+IntToStr(i);
        assign(arregloDetalles[i],nombre);
    end;
    actualizarMaestro(archivoMaestro,arregloDetalles);
    informarMaxMin(archivoMaestro);
end.

    
