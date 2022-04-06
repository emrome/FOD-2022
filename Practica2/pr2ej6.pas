{ 6. Se desea modelar la información necesaria para un sistema de recuentos de casos de covid para el 
    ministerio de salud de la provincia de buenos aires.
    Diariamente se reciben archivos provenientes de los distintos municipios, la información
    contenida en los mismos es la siguiente: código de localidad, código cepa, cantidad casos
    activos, cantidad de casos nuevos, cantidad de casos recuperados, cantidad de casos fallecidos.
    El ministerio cuenta con un archivo maestro con la siguiente información: código localidad,
    nombre localidad, código cepa, nombre cepa, cantidad casos activos, cantidad casos
    nuevos, cantidad recuperados y cantidad de fallecidos.
    Se debe realizar el procedimiento que permita actualizar el maestro con los detalles
    recibidos, se reciben 10 detalles. Todos los archivos están ordenados por código de
    localidad y código de cepa.

    Para la actualización se debe proceder de la siguiente manera:
        1. Al número de fallecidos se le suman el valor de fallecidos recibido del detalle.
        2. Idem anterior para los recuperados.
        3. Los casos activos se actualizan con el valor recibido en el detalle.
        4. Idem anterior para los casos nuevos hallados.

    Realice las declaraciones necesarias, el programa principal y los procedimientos que
    requiera para la actualización solicitada e informe cantidad de localidades con más de 50
    casos activos (las localidades pueden o no haber sido actualizadas).

}

program ej6;
const
    CANT_INF=50;
    CANT_DET=10;
    VALOR_ALTO='ZZZZ'
var
    informacion=record
        cod:string[20];
        cepa:string[20];
        activos:integer;
        nuevos:integer;
        recuperados:integer;
        fallecidos:integer;
    end;

    info_ministerio=record
        loc:string;
        info:informacion;
    end;

detalle=file of informacion;
vDetalles=array[1..CANT_DET]of detalle;
vInfo=array[1..CANT_DET]of informacion;


maestro=file of info_ministerio;


procedure cargarDetalles(var vD:vDetalles);
var 
    nombre:string[20];
    i:integer;
begin
    for (i:=1 to CANT_DET)do begin
        nombre:='detalle'+IntToStr(i);
        assign(vD[i],nombre);
    end;
end;

procedure leer(var det:detalle;var reg:informacion);
begin
    if(not eof(det))then
        read(det,reg)
    else
        reg.cod:=VALOR_ALTO;
end;

procedure abrirDetalles(var vD:vDetalles;var vInf:vInfo);//cargar en un vector todos los archivos detalle
var
    i:integer;
begin
    for(i:=1 to CANT_DET) do begin
        reset(vD[i]);
        leer(vD[i],vInf[i]);
    end;
end;

procedure minimo(var vD:vDetalles;var vInf:vInfo;var min:informacion);
var
    i,indMin:integer;
begin
    indMin:=-1
    min.cod:=VALOR_ALTO;
    for(i:=1 to CANT_DET)do 
        if(vInf[i].cod<>VALOR_ALTO)then
            if(vInf[i].cod<min.cod)then begin
                min.cod:=vInf[i].cod;
                indMin:=-1;
            end;

    if(indMin<>-1)then begin
        min:=vInf[i];
        leer(vD[i],vInf[i]);//avanzo en el detalle y lo guardo en el vector de informacions
    end;
end;

procedure actualizarMaestro(var mae:maestro;var vD:vDetalles);
var
    i:integer;
    min:informacion;
    vInf:vInfo;
    axuCepa:string[20];
    auxLoc:string[20];
    regM:info_ministerio;
begin   
    abrirDetalles(vInfo);
    reset(mae);
    minimo(vD,vInf,min);
    while(min.cod<>VALOR_ALTO)do begin
        read(mae,regM);
        while((regM.info.cod<>min.cod)and(regM.info.cepa<>min.cepa))do 
           read(mae,regM);
        {   Para la actualización se debe proceder de la siguiente manera:
            1. Al número de fallecidos se le suman el valor de fallecidos recibido del detalle.
            2. Idem anterior para los recuperados.
            3. Los casos activos se actualizan con el valor recibido en el detalle.
            4. Idem anterior para los casos nuevos hallados.
        s}
        regM.info.fallecidos:=regM.info.fallecidos+min.fallecidos;
        regM.info.recuperados:=regM.info.recuperados+min.recuperados;
        regM.info.activos:=min.activos;
        regM.info.nuevos:=min.nuevos;
        
        seek(mae,filePos(mae)-1);
        write(mae,regM);
        minimo(vD,vInf,min);
    end;
    for(i:=1 to CANT_DET)do 
        close(vD[i]);
    close(mae);
end;

//informe cantidad de localidades con más de 50 casos activos

procedure informarMas50(var mae:maestro);
var
    reg:info_ministerio;
    cant:integer;
begin
    cant:=0;
    while(not eof(mae))do begin
        read(mae,reg);
        if(reg.info.activos>CANT_INF)then
            cant:=Cant+1;
    end;
    writeln('Localidades con mas de ',CANT_INF,' casos activos: ',cant);

end;

var
    archivoMinisterio:maestro;
    arreglo_detalles:vDetalles;

begin
    cargarDetalles(arreglo_detalles);
    actualizarMaestro(archivoMinisterio,arreglo_detalles);
    informarMas50(archivoMinisterio);
end.