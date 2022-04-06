{ 4. Suponga que trabaja en una oficina donde está montada una LAN (red local). La misma
    fue construida sobre una topología de red que conecta 5 máquinas entre sí y todas las
    máquinas se conectan con un servidor central. Semanalmente cada máquina genera un
    archivo de logs informando las sesiones abiertas por cada usuario en cada terminal y por
    cuánto tiempo estuvo abierta. Cada archivo detalle contiene los siguientes campos:
    cod_usuario, fecha, tiempo_sesion. Debe realizar un procedimiento que reciba los archivos
    detalle y genere un archivo maestro con los siguientes datos: cod_usuario, fecha,
    tiempo_total_de_sesiones_abiertas.
    Notas:
        - Cada archivo detalle está ordenado por cod_usuario y fecha.
        - Un usuario puede iniciar más de una sesión el mismo día en la misma o en diferentes
        máquinas.
        - El archivo maestro debe crearse en la siguiente ubicación física: /var/log.
}

program ej4;
const
    CANT=5;
    VALOR_ALTO=9999;
type
    log=record
        cod:integer;
        fecha:string[10];
        tiempo_sesion:integer;
    end;

archivo=file of log;
arreglo_detalles=array[1..CANT]of archivo;
arreglo_log=array[1..CANT]of log;

procedure leer(var det:archivo,var dato:log);
begin
    if(not eof(det))then
        read(det,dato)
    else
        dato.cod:=VALOR_ALTO;
end;


procedure cargarDetalles(var arrDet:arreglo_detalles);//cargar en un vector todos los archivos detalle
var
    det:archivo;
    i:integer;
    nombre:string[20];
begin
    nombre:='detalle'
    for(i:=1 to CANT) do begin
        nombre:=nombre+IntToStr(i);
        assign(arrDet[i]);
    end;
end;



procedure minimo(var arrDet:arreglo_detalles;var min:log;var arrLog:arreglo_log);
var
    indMin,i:integer;
begin
    indMin:=-1;
    min.cod:=VALOR_ALTO;
    for(i:=1 to CANT)do begin 
        if(arrLog[i].cod<>VALOR_ALTO)then begin                 
            if((arrLog[i].cod<min.cod)or((arrLog[i].cod=min.cod)and(arrLog[i].fecha<min.fecha)))then begin         
                indMin:=i;                                           
                min.cod:=arrLog[i].cod;
        end;
    end;
    if(indMin<>-1)then begin
        min:=arrLog[indMin];
        leer(arrDet[indMin],arrLog[indMin]);//avanzo en el detalle y lo guardo en el vector de logs
    end;
end;
        
procedure mergeMaestro(var mae:archivo;var arrDet:arreglo_detalles);
var 
    logs:arreglo_log;
    min:log;
    i,total_tiempo,auxCod:integer;
    fecha:string[20];
    auxReg:log;
begin
    for(i:=1 to CANT) do begin//Abre los detalles y pone el primer registro en el arreglo de logs
        reset(arrDet[i]);
        leer(arrDet[i],logs[i]);
    end;
    
    assign(mae,'/var/log/maestro.dat');
    rewrite(mae);
    
    minimo(arrDet,min,logs);
    while(min.cod<>VALOR_ALTO)do begin
        auxReg:=min;
        auxReg.tiempo_sesion:=0;
        while((auxReg.cod=min.cod)and(min.fecha=auxReg.fecha))do begin
                auxReg.tiempo_sesion:=auxReg.tiempo_sesion+min.tiempo_sesion;
                minimo(arrDet,min,logs);
        end;
        write(mae,auxReg);
    end;
    
    for i:=1 to CANT do 
        close(arrDet[i]);
    close(mae);
end;

var
    maestro:archivo;
    detalles:arreglo_detalles;
begin
    cargarDetalles(detalles);
    mergeMaestro(mae,detalles);
end.
