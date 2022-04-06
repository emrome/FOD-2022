{  9. Se necesita contabilizar los votos de las diferentes mesas electorales registradas por
    provincia y localidad. Para ello, se posee un archivo con la siguiente información: código de
    provincia, código de localidad, número de mesa y cantidad de votos en dicha mesa.
    Presentar en pantalla un listado como se muestra a continuación:

    Código de Provincia
    Código de Localidad                 Total de Votos
    ................................    ......................
    ................................    ......................
    Total de Votos Provincia: ____
    Código de Provincia
    Código de Localidad                 Total de Votos
    ................................    ......................
    Total de Votos Provincia: ___
    …………………………………………………………..
    Total General de Votos: ___
    NOTA: La información se encuentra ordenada por código de provincia y código de localidad.
}

program ej9;
const
    VALOR_ALTO='ZZZZ';
type
    mesa=record
        codProv:string[20];
        codLoc:string[20];
        numMesa:integer;
        cant:integer;
    end;

archivo=file of mesa;

procedure leer(var mae:archivo;var reg:mesa);
begin
    if(not eof(mae))then
        read(mae,reg)
    else
        reg.codProv:=VALOR_ALTO;
end;

procedure listaVotos(var arc:archivo);
var
    auxProv,auxLoc:string[20];
    cantLoc,cantProv,total:integer;
    regA:mesa;
begin
    reset(arc);
    leer(arc,regA);
    total:=0;
    while(regA.codProv<>VALOR_ALTO)do begin
        cantProv:=0;
        auxProv:=regA.codProv;
        writeln('Código de Provincia: ',auxProv);
        while(auxProv=regA.codProv)do begin
            cantLoc:=0;
            auxLoc:=regA.codLoc;
            while((auxProv=regA.codProv)and (auxLoc=regA.codLoc))do begin
                cantLoc:=cantLoc+regA.cant;
                total:=total+regA.cant;
                leer(arc,regA);
            end;
            writeln('Código de Localidad: ',auxLoc,' Total votos: ',cantLoc);
            cantProv:=cantProv+cantLoc;
        end;
        writeln('Total de Votos Provincia: ',cantProv);
    end;
    writeln('Total General de Votos: ',total);
    close(arc);
end;

var
    maestro:archivo;
begin
    assign(maestro,'maestroEj9');
    crear_maestro(maestro);
    listaVotos(maestro);
end.
