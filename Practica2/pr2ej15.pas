{   Se desea modelar la información de una ONG dedicada a la asistencia de personas con
    carencias habitacionales. La ONG cuenta con un archivo maestro conteniendo información
    como se indica a continuación: Código pcia, nombre provincia, código de localidad, nombre
    de localidad, #viviendas sin luz, #viviendas sin gas, #viviendas de chapa, #viviendas sin
    agua,# viviendas sin sanitarios.
    Mensualmente reciben detalles de las diferentes provincias indicando avances en las obras
    de ayuda en la edificación y equipamientos de viviendas en cada provincia. La información
    de los detalles es la siguiente: Código pcia, código localidad, #viviendas con luz, #viviendas
    construidas, #viviendas con agua, #viviendas con gas, #entrega sanitarios.
    Se debe realizar el procedimiento que permita actualizar el maestro con los detalles
    recibidos, se reciben 10 detalles. Todos los archivos están ordenados por código de
    provincia y código de localidad.
    Para la actualización se debe proceder de la siguiente manera:
        1. Al valor de vivienda con luz se le resta el valor recibido en el detalle.
        2. Idem para viviendas con agua, gas y entrega de sanitarios.
        3. A las viviendas de chapa se le resta el valor recibido de viviendas construidas
    
    La misma combinación de provincia y localidad aparecen a lo sumo una única vez.
    Realice las declaraciones necesarias, el programa principal y los procedimientos que
    requiera para la actualización solicitada e informe cantidad de localidades sin viviendas de
    chapa (las localidades pueden o no haber sido actualizadas).
}
program ej15;
const
    VALOR_ALTO='ZZZZ';
    CANT_DET=10;
type
    informacion=record
        codPcia:string[15];
        nomPcia:string[15];
        codLoc:string[15];
        nomLoc:string[15];
        sinLuz:integer;
        sinGas:integer;
        deChapa:integer;
        sinAgua:integer;
        sinSanitarios:integer;
    end;
    info_detalle=record
        codPcia:string[15];
        codLoc:string[15];
        conLuz:integer;
        construidas:integer;
        conAgua:integer;
        conGas:integer;
        sanitarios:integer;
    end;
maestro=file of informacion;
detalle=file of info_detalle;
vDetalles=array[1..CANT_DET]of detalle;
vRegistros=array[1..CANT_DET]of info_detalle;



procedure leer(var det:detalle;var regD:info_detalle);
begin
    if(not eof(det))then
        read(det,regD)
    else
        regD:=VALOR_ALTO;
end;

procedure minimo(var vDet:vDetalles;var vInfo:vRegistros;var min:info_detalle)
var
    indMin,i:=integer;
begin
    indMin:=-1;
    min.codPcia:=VALOR_ALTO;
    for(i:=1 to CANT_DET)do begin
        if(vInfo[i].codPcia<>VALOR_ALTO)then begin
            if(vInfo[i].codPcia<min.codPcia)or((vInfo[i].codPcia=min.codPcia)and(vInfo[i].codLoc<min.codLoc))then begin
                min.codPcia:=vInfo[i].codPcia;
                min.codLoc:=vInfo[i].codLoc;
                indMin:=i;
            end;
        end;
    end;
    if(indMin<>-1)then begin
        min:=vInfo[indMin];
        leer(vDet[indMin],vInfo[indMin]);
    end;
end;
{
    1. Al valor de vivienda con luz se le resta el valor recibido en el detalle.
    2. Idem para viviendas con agua, gas y entrega de sanitarios.
    3. A las viviendas de chapa se le resta el valor recibido de viviendas construidas
}
procedure actualizarMaestro(var mae:maestro;var vDet:vDetalles);
var
    regM:informacion;
    min:info_detalle;
    arregloInfo:vRegistros;
    i:integer;
begin
    reset(mae);
    for(i:=1 to CANT_DET)do begin
        reset(vDet[i]);
        leer(vDet[i],arregloInfo[i]);
    end;
    minimo(vDet,arregloInfo,min);
    while(min.codPcia<>VALOR_ALTO)do begin
        read(mae,regM);
        while(min.codPcia<>regM.codPcia)do 
            read(mae,regM);
        regM.sinLuz:=regM.sinLuz-min.conLuz;
        regM.sinAgua:=regM.sinAgua-min.conAgua;
        regM.sinGas:=regM.sinGas-min.conGas;
        regM.sinSanitarios:=regM.sinSanitarios-min.sanitarios;
        regM.deChapa:=regM.deChapa-min.construidas;
        seek(mae,filepos(mae)-1);
        write(mae,regM);
        minimo(vDet,arregloInfo,min);
    end;
    for(i:=1 to CANT_DET)do 
        close(vDet[i]);
    close(mae);
end;

procedure informarSinViviendasDeChapa(var mae:maestro);
var
    regM:informacion;
    cant:integer;
begin
    cant:=0;
    reset(mae);
    while(not eof(mae))do begin
        read(mae,regM);
        if(regM.deChapa<1)then
            cant:=cant+1; 
    end;
    writeln('Cantidad de Localidades sin viviendas de chapa: 'cant);
    close(mae);
end;
//Programa Ppal
var
    archivoMaestro:maestro;
    arregloDetalles:vDetalles;
    i:integer;
    nombre:string[15];
begin
    assign(archivoMaestro,'maestro');
    for(i:=1 to CANT_DET)do begin
        nombre:='detalle'+IntToStr(i);
        assign(arregloDetalles[i],nombre);
    end;

    actualizarMaestro(archivoMaestro);
    informarSinViviendasDeChapa(archivoMaestro);
end.