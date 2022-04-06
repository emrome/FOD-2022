{ 11. A partir de información sobre la alfabetización en la Argentina, se necesita actualizar un
    archivo que contiene los siguientes datos: nombre de provincia, cantidad de personas
    alfabetizadas y total de encuestados. Se reciben dos archivos detalle provenientes de dos
    agencias de censo diferentes, dichos archivos contienen: nombre de la provincia, código de
    localidad, cantidad de alfabetizados y cantidad de encuestados. Se pide realizar los módulos
    necesarios para actualizar el archivo maestro a partir de los dos archivos detalle.

    NOTA: Los archivos están ordenados por nombre de provincia y en los archivos detalle
    pueden venir 0, 1 ó más registros por cada provincia.
}
program ej11;
const
    CANT_DET=2;
    VALOR_ALTO='ZZZZ'
type
    provincia=record
        nombre:string[20];
        alfabetizados:integer;
        encuestados:integer;
    end;
    info=record
        prov:string[20];
        codLocalidad:string[20];
        alfabetizados:integer;
        encuestados:integer;
    end;

maestro=file of provincia;
detalle=file of info;


procedure leer(var det:detalle;var reg:info);
begin
    if(not eof(det))then
        read(det,reg)
    else
        reg.prov:=VALOR_ALTO;
end;



procedure minimo(var det1,det2:detalles;var min,reg1,reg2:info);
begin
    if(reg1.prov<>VALOR_ALTO)then
        if(reg1.prov<=reg2.prov)then begin
            min:=reg1;
            leer(det1,reg1);
        end
        else begin
            min:=reg2;
            leer(det2,reg2);
        end;
    
end;

procedure actualizarMaestro(var mae:maestro;var det1,det2:detalle);
var
    i,encProv,alfProv:integer;
    min,regD1,regD2:info;
    regM:provincia;
    auxProv:string[20];
begin
    reset(mae);
    leer(det1,regD1);
    leer(det2,regD2);
    minimo(det1,det2,min,regD1,regD2);
    
    while(min.prov<>VALOR_ALTO)do begin
        read(mae,regM);
        while(regM.nombre<>min.prov)do
            read(mae,regM);

        encProv:=0;
        alfProv:=0;
        auxProv:=min.prov;
        while(min.prov=auxProv)do begin
            encProv:=encProv+min.encuestados;
            alfProv:=alfProv+min.alfabetizados;
            minimo(det1,det2,min,regD1,regD2);
        end;
        
        
        regM.encuestados:=encProv;
        regM.alfabetizados:=alfProv;
        seek(mae,filepos(mae)-1);
        write(mae,regM);
    end;
    close(det1);
    close(det2);
    close(mae);
end;


var
    archivoMaestro:maestro;
    detalle1,detalle2:detalle;
begin
    assign(archivoMaestro,'maestro');
    assign(detalle1,'detalle1');
    assign(detalle2,'detalle2');
    actualizarMaestro(archivoMaestro,detalle1,detalle2);
end;