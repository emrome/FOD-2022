{ 12. La empresa de software ‘X’ posee un servidor web donde se encuentra alojado el sitio de
    la organización. En dicho servidor, se almacenan en un archivo todos los accesos que se
    realizan al sitio.
    La información que se almacena en el archivo es la siguiente: año, mes, dia, idUsuario y
    tiempo de acceso al sitio de la organización. El archivo se encuentra ordenado por los
    siguientes criterios: año, mes, dia e idUsuario.

    Se debe realizar un procedimiento que genere un informe en pantalla, para ello se indicará
    el año calendario sobre el cual debe realizar el informe. El mismo debe respetar el formato
    mostrado a continuación:

    Año : ---
    Mes:-- 1
    día:-- 1
    idUsuario 1 Tiempo Total de acceso en el dia 1 mes 1
    --------
    idusuario N Tiempo total de acceso en el dia 1 mes 1
    Tiempo total acceso dia 1 mes 1

    -------------

    día N
    idUsuario 1 Tiempo Total de acceso en el dia N mes 1
    --------
    idusuario N Tiempo total de acceso en el dia N mes 1
    Tiempo total acceso dia N mes 1
    Total tiempo de acceso mes 1
    ------

    Mes 12
    día 1
    idUsuario 1 Tiempo Total de acceso en el dia 1 mes 12
    --------
    idusuario N Tiempo total de acceso en el dia 1 mes 12
    Tiempo total acceso dia 1 mes 12
    -------------
    día N
    idUsuario 1 Tiempo Total de acceso en el dia N mes 12
    --------
    idUsuario N Tiempo total de acceso en el dia N mes 12
    Tiempo total acceso dia N mes 12
    Total tiempo de acceso mes 12

    Total tiempo de acceso año

    Se deberá tener en cuenta las siguientes aclaraciones:
        - El año sobre el cual realizará el informe de accesos debe leerse desde teclado.
        - El año puede no existir en el archivo, en tal caso, debe informarse en pantalla “año no encontrado”.
        - Debe definir las estructuras de datos necesarias.
        - El recorrido del archivo debe realizarse una única vez procesando sólo la información necesaria
}
program ej12;
const   
    VALOR_ALTO=9999;
type
    subDia=1..31;
    subMes=1..12;
    acceso=record
        anio:integer;
        mes:subMes;
        dia:sudDia;
        idUsuario:string[20];
        tiempo:integer;
    end;

archivo=file of acceso;

procedure leer(var m:archivo;var reg:acceso);
begin
    if(not eof(m))then
        read(m,reg)
    else
        reg.anio:=VALOR_ALTO;
end;

procedure reporteAnio(var mae:archivo;anioBuscado:integer);
var
    totalDia,totalMes,totalAnio,totalId:integer;
    auxMes:subMes;
    auxDia:subDia;
    auxId:string[20];
    regM:acceso;

begin
    reset(mae);
    leer(mae,regM);
    while((regM.anio<>VALOR_ALTO)and(regM.anio<>anioBuscado))do 
        leer(mae,regM)

    if(regM.anio=anioBuscado)then begin
        writeln('Anio: ',anioBuscado); 
        totalAnio:=0;

        while(regM.anio=anioBuscado)then begin//ordenado por: año, mes, dia e idUsuario.
            auxMes:=regM.mes;
            totalMes:=0;
            writeln('Mes: ',auxMes);

            while((auxMes=regM.mes)and(regM.anio=anioBuscado))do begin
                auxDia:=regM.dia;
                totalDia:=0;
                writeln('Dia: ',auxDia);

                while((auxDia=regM.dia)and(auxMes=regM.mes)and()and(regM.anio=anioBuscado))do begin
                    auxId:=regM.idUsuario;
                    totalId:=0;
                
                    while((auxId=regM.idUsuario)and(auxDia=regM.dia)and(auxMes=regM.mes)and()and(regM.anio=anioBuscado))do begin
                        totalId:=totalId+regM.tiempo;
                        leer(mae,regM);             
                    end;
                    totalDia:=totalDia+totalId;
                    writeln('idUsuario: ',auxId,'Tiempo Total de acceso en el dia ',auxDia,' mes ',auxMes,': ',totalId);
                end;
            
                totalMes:=totalMes+totalDia;
                writeln('Tiempo total acceso dia 'auxDia,' mes 'auxMes,': ',totalDia);
            end;
        
            totalAnio:=totalAnio+totalMes;
            writeln('Total tiempo de acceso mes ',auxMes,': 'totalMes);

        end;
        writeln('Total tiempo de acceso año: ',totalAnio);
    end
    else
        writeln('Anio no encontrado')

    close(mae);
end;

var
    anio:integer;
    maestro:archivo;
begin
    assign(maestro,'maestroEj12');
    writeln('Ingrese anio a hacer informe: ');
    readln(anio);
    reporteAnio(maestro,anio);
end.