{ 14. Una compañía aérea dispone de un archivo maestro donde guarda información sobre
    sus próximos vuelos. En dicho archivo se tiene almacenado el destino, fecha, hora de salida
    y la cantidad de asientos disponibles. La empresa recibe todos los días dos archivos detalles
    para actualizar el archivo maestro. En dichos archivos se tiene destino, fecha, hora de salida
    y cantidad de asientos comprados. Se sabe que los archivos están ordenados por destino
    más fecha y hora de salida, y que en los detalles pueden venir 0, 1 ó más registros por cada
    uno del maestro. 
    Se pide realizar los módulos necesarios para:
        c. Actualizar el archivo maestro sabiendo que no se registró ninguna venta de pasaje sin asiento disponible.
        d. Generar una lista con aquellos vuelos (destino y fecha y hora de salida) que
        tengan menos de una cantidad específica de asientos disponibles. La misma debe ser ingresada por teclado.
    NOTA: El archivo maestro y los archivos detalles sólo pueden recorrerse una vez
}
program ej14;
const
    VALOR_ALTO='ZZZZ';
type
    vuelo=record
        destino:string[20];
        fecha:longInt;
        horaSalida:longInt;
        asientos:integer;
    end;

    regLista=record
        destino:string[20];
        fecha:longInt;
        horaSalida:longInt;
    end;

    lista=^nodo;
    nodo=record
        dato:regLista;
        sig:lista;
    end;

archivo=file of vuelo;


procedure leer(var det:archivo;var reg:vuelo);
begin
    if(not eof(det))then
        read(det,reg)
    else
        reg.destino:=VALOR_ALTO;
end;

procedure minimo(var det1,det2:archivo;var reg1,reg2,min:vuelo);
begin
    if((reg1.destino<=reg2.destino)and (reg1.fecha<=reg2.fecha)and((reg1.horaSalida<=reg2.horaSalida))then begin
        min:=reg1;
        leer(det1,reg1);
    end
    else begin
        min:=reg2;
        leer(det2,reg2);
    end;
end;

procedure agregarNodo(dato:regLista;var l,pri,ult:lista);
var
    nuevo:nodo;
begin
    new(nuevo); 
    nuevo^.dato:=dato;
    nuevo^.sig:=nil;
    if(pri=nil)then 
        pri:=nuevo
    else 
        ult^.sig:=nuevo;
    ult:=nuevo;
end;

procedure actualizarMaestro_GenerarLista(var mae,det1,det2:archivo;var l:lista);
var
    reg1,reg2,regM,min:vuelo;
    ult:lista;
    datoLista:regLista;
    asientosLista,auxHora,cantAsientos:integer;
    auxDes:string[20];
    auxFec:longInt;
begin
    writeln('Ingrese cantidad disponible de asientos de lo vuelos para crear la lista ');
    readln(asientosLista);
    ult:=nil;

    reset(mae);
    reset(det1);
    reset(det2);
    leer(det1,reg1);leer(det2,reg2);
    minimo(det1,det2,reg1,reg2,min);
    while(min.destino<>VALOR_ALTO)do begin
        read(mae,regM);
        if((min.destino=regM.destino))then begin
            auxVuelo:=min;
            auxVuelo.asientos:=0;
            while((auxVuelo.horaSalida=min.horaSalida)and(auxVuelo.fecha=min.fecha)and(auxVuelo.destino=min.destino))do begin
                auxVuelo:=auxVuelo+min.asientos;
                minimo(det1,det2,reg1,reg2,min);
            end;
            //auxVuelo.asientos acumula asientos vendidos en total en el dia
            //regM.asientos tiene los asientos disponibles del vuelo
            regM.asientos:=regM.asientos-auxVuelo.asientos; //actualizo la cantidad de asientos disponibles
            seek(mae,filepos(mae)-1);                  
            write(mae,regM);
        end;
        if(regM.asientos<asientosLista)then begin
            dato.destino:=regM.destino;
            dato.fecha:=regM.fecha;
            dato.horaSalida:=regM.horaSalida;
            agregarNodo(dato,l);
        end;
    end;
    close(mae);
    close(det1);
    close(det2);
end;




var 
    maestro:archivo;
    detalle:archivo;
    listaAsientosDisponiblesMenorA:lista;
begin
    assign(maestro,'maestroEj14');
    assign(det1,'detalle1');
    assign(det2,'detalle2');
    actualizarMaestro_GenerarLista(maestro,det1,det2,listaAsientosDisponiblesMenorA);
end.