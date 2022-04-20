{   A partir de un siniestro ocurrido se perdieron las actas de nacimiento y fallecimientos de
    toda la provincia de buenos aires de los últimos diez años. En pos de recuperar dicha
    información, se deberá procesar 2 archivos por cada una de las 50 delegaciones distribuidas
    en la provincia, un archivo de nacimientos y otro de fallecimientos y crear el archivo maestro
    reuniendo dicha información.
    Los archivos detalles con nacimientos, contendrán la siguiente información: nro partida
    nacimiento, nombre, apellido, dirección detallada (calle,nro, piso, depto, ciudad), matrícula
    del médico, nombre y apellido de la madre, DNI madre, nombre y apellido del padre, DNI del
    padre.
    En cambio, los 50 archivos de fallecimientos tendrán: nro partida nacimiento, DNI, nombre y
    apellido del fallecido, matrícula del médico que firma el deceso, fecha y hora del deceso y
    lugar.
    Realizar un programa que cree el archivo maestro a partir de toda la información de los
    archivos detalles. Se debe almacenar en el maestro: nro partida nacimiento, nombre,
    apellido, dirección detallada (calle,nro, piso, depto, ciudad), matrícula del médico, nombre y
    apellido de la madre, DNI madre, nombre y apellido del padre, DNI del padre y si falleció,
    además matrícula del médico que firma el deceso, fecha y hora del deceso y lugar. Se
    deberá, además, listar en un archivo de texto la información recolectada de cada persona.

    Nota: Todos los archivos están ordenados por nro partida de nacimiento que es única.
    Tenga en cuenta que no necesariamente va a fallecer en el distrito donde nació la persona y
    además puede no haber fallecido.
}
program ej5;
const
    DELEGACIONES=50;
    VALOR_ALTO=9999;
type
    persona=record
        nombre:string[20];
        apellido:string[20];
        DNI:integer;
    end;

    direccion=record
        calle:string[20];
        nro:integer;
        piso:integer;
        depto:string[10];
        ciudad:string[20];
    end;
{
    nacimientos: nro partida nacimiento, nombre, apellido, dirección detallada (calle,nro, piso, depto, ciudad), 
    matrícula del médico, nombre y apellido de la madre, DNI madre, nombre y apellido del padre, DNI del
    padre.
}
    nacimiento=record
        partida:integer;
        nombre:string[20];
        apellido:string[20];
        direc:direccion;
        matricula_medico:string[20];
        madre:persona;
        padre:persona;
    end;
{   fallecimientos tendrán: nro partida nacimiento, DNI, nombre y
    apellido del fallecido, matrícula del médico que firma el deceso, fecha y hora del deceso y
    lugar.
}
    fallecimiento=record
        partida:integer;
        fallecido:persona;
        matricula_medico:string[20];
        fecha:longInt;
        hora:longInt;
        lugar:string[20];
    end;
{
    maestro: nro partida nacimiento, nombre, apellido, dirección detallada (calle,nro, piso, depto, ciudad), 
    matrícula del médico, nombre y apellido de la madre, DNI madre, nombre y apellido del padre, DNI del padre 
    y si falleció, además matrícula del médico que firma el deceso, fecha y hora del deceso y lugar.
}
    info_maestro=record
        acta_nacimiento:nacimiento;
        fallecio:boolean;
        matricula_medico:string[20];
        fecha:longInt;
        hora:longInt;
        lugar:string[20];
    end;

detalleNacimientos=file of nacimiento;
detalleFallecimientos=file of fallecimiento;

maestro=file of info_maestro;

vDetFallecimientos=array[1..DELEGACIONES]of detalleFallecimientos;
vDetNacimientos=array[1..DELEGACIONES]of detalleNacimientos;

vFallecimiento=array[1..DELEGACIONES]of fallecimiento;
vDetNacimiento=array[1..DELEGACIONES]of nacimiento;

procedure leerNacimiento(var det:detalleNacimientos; var regN:nacimiento);
begin
    if(not eof(det))then
        read(det,regN)
    else
        regN.partida:=VALOR_ALTO;
end;

procedure leerFallecimiento(var det:detalleFallecimiento; var regF:nacimiento);
begin
    if(not eof(det))then
        read(det,regN)
    else
        regF.partida:=VALOR_ALTO;
end;

procedure cargarDetallesFallecimientos(var vDF:vDetFallecimientos);
var
    i:integer;
    nombre:string[15];
begin
    for i:=1 to DELEGACIONES do begin
        nombre:='detalleNacimiento'+IntToStr(i);
        assign(vDF[i],nombre);
    end;
end;



procedure cargarDetallesNacimientos(var vDN:vDetNacimientos);
var
    i:integer;
    nombre:string[15];
begin
    for i:=1 to DELEGACIONES do begin
        nombre:='detalleFallecimiento'+IntToStr(i);
        assign(vDN[i],nombre);
    end;
end;


procedure minimoNacimiento(var vDN:vDetNacimiento; var vN:vNacimiento;var min:nacimiento);
var
    i,indMin:integer;
begin
    indMin:=-1;
    min.partida:=VALOR_ALTO;
    for(i:=1 to DELEGACIONES)do begin
        if(vN[i].partida<min.partida)then begin
            indMin:=i;
            min.partida:=vN[i].partida
        end;
    end;
    if(indMin<>-1) then begin
        min:=vN[indMin];
        leerNacimiento(vDN[indMin],vN[indMin]);
    end;
end;



procedure minimoFallecimiento(var vDF:vDetFallecimientos;var vF:vFallecimiento;var min:fallecimiento);
var
    i,indMin:integer;
begin
    indMin:=-1;
    min.partida:=VALOR_ALTO;
    for(i:=1 to DELEGACIONES)do begin
        if(vF[i].partida<min.partida)then begin
            indMin:=i;
            min.partida:=vF[i].partida
        end;
    end;
    if(indMin<>-1) then begin
        min:=vF[indMin];
        leerFallecimiento(vDF[indMin],vF[indMin]);
    end;
end;

procedure inicializarFallecido_info(var regM:info_maestro);
begin
    regM.fallecio:=false;
    regM.matricula_medico:=0;
    regM.fecha:=0;
    regM.hora:=0;
    regM.lugar:='';
end;
procedure crearMaestro(var mae:maestro;var arrDetF:vDetFallecimientos;arrDetN:vDetNacimientos);
var
    vF:fallecimiento;
    vN:nacimiento;
    minNac:nacimiento;
    minFallec:fallecimiento;
    i:integer;
    regM:info_maestro;
begin
    for i:=1 to DELEGACIONES do begin
        reset(arrDetN[i]);
        leerFallecimiento(arrDetN[i],vF[i]);
        reset(arrDetN[i]);
        leerFallecimiento(arrDetN[i],vN[i]);
    end;

    minimoNacimiento(arrDetN,vN,minNac);

    while(minNac.partida<>VALOR_ALTO)do begin
        minimoFallecimiento(arrDetF,vF,minFallec);
        regM.acta_nacimiento:=minNac;
         
        while((minNac.partida<>minFallec.partida)and(minNac.partida<>VALOR_ALTO))do begin
            inicializarFallecido_info(regM);//inicializa en falso y los valores por defecto
            write(mae,regM);
            minimoNacimiento(arrDet,vN,minNac);
            regM.acta_nacimiento:=minNac;
        end;

        if((minNac.partida<>VALOR_ALTO)and(minNac.partida=minFallec.partida))then begin
            regM.fallecio:=true;
            regM.matricula_medico:=minFallec.matricula_medico;
            regM.fecha:=minFallec.fecha;
            regM.hora:=minFallec.hora;
            regM.lugar:=minFallec.lugar;
            write(mae,regM);
        end;

        minimoNacimiento(arrDet,vN,minNac);
    end;
 
    //cierro archivos detalles y maestro
    for(i:=1to DALEGACIONES)do 
        close(arrDetN[i]);
    for(i:=1to DALEGACIONES)do 
        close(arrDetF[i]);
    close(mae);
end;


procedure listarEnTexto(var mae:maestro;var fText:text);
var
    regM:info_maestro;
begin
    rewrite(fText);
    reset(mae);
    while(not eof(mae))do begin
        read(mae,regM);
        with regM.acta_nacimiento do begin
            writeln(fText,partida,' ',nombre);
            writeln(fText,apellido);
            writeln(fText,direc.calle,' ',direc.nro,' ',direc.piso,' ',direc.depto);
            writeln(fText,direc.ciudad);
            writeln(fText,matricula_medico);
            writeln(fText,madre.DNI,' ',madre.apellido);
            writeln(fText,madre.nombre);
            writeln(fText,padre.DNI,' ',padre.apellido);
            writeln(fText,padre.nombre);
        end;
        writeln(fText,regM.fallecio);//o tengo que poner 'fallecio'
        if(regM.fallecio)then begin
            writeln(fText,regM.fecha,' ',regM.hora,' ',regM.lugar);
            writeln(fText,regM.matricula_medico);
        end;
    end;
    close(mae);
    close(fText);
end;

var
    archivoMaestro:maestro;
    archivoTexto:text;
    arregloDetallesNacimientos:vDetNacimientos;
    arregloDetallesFallecimientos:vDetFallecimientos;
begin
    assign(archivoMaestro,'maestroActasBSAS');
    assign(archivoTexto,'textoActasBSAS');
    cargarDetallesFallecimientos(arregloDetallesFallecimientos);
    cargarDetallesNacimientos(arregloDetallesNacimientos);
    crearMaestro(archivoMaestro,arregloDetalleFallecimientos,arregloDetallesNacimientos);
    listarEnTexto(archivoMaestro,archivoTexto);
end.