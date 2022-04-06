{ 10.Se tiene información en un archivo de las horas extras realizadas por los empleados de
    una empresa en un mes. Para cada empleado se tiene la siguiente información:
    departamento, división, número de empleado, categoría y cantidad de horas extras
    realizadas por el empleado. Se sabe que el archivo se encuentra ordenado por
    departamento, luego por división, y por último, por número de empleados. Presentar en
    pantalla un listado con el siguiente formato:

    Departamento
    División
    Número de Empleado      Total de Hs. Importe a cobrar
    ...... ..........       .........
    ...... ..........       .........
    Total de horas división: ____
    Monto total por división: ____
    División
    .................
    Total horas departamento: ____
    Monto total departamento: ____

    Para obtener el valor de la hora se debe cargar un arreglo desde un archivo de texto al
    iniciar el programa con el valor de la hora extra para cada categoría. La categoría varía
    de 1 a 15. En el archivo de texto debe haber una línea para cada categoría con el número
    de categoría y el valor de la hora, pero el arreglo debe ser de valores de horas, con la
    posición del valor coincidente con el número de categoría.
}
program ej10;
const
    VALOR_ALTO='ZZZZ';
type
    subCat=1..15;
    empleado=record
        departamento:string[20];
        division:string[15];
        numero:string;
        categoria:subCat;
        horas:integer;
    end;
    

archivo=file of empleado;
vValorHora=array[subCat]of real; 

procedure cargarValorCategorias(var fText:text;var vH:vValorHora);
var
    i:integer;
    monto:real;
begin
    reset(fText);
    while(not eof(fText))do begin
        readln(fText,i,monto);
        vH[i]:=monto;
    end;
end;

procedure leer(var mae:archivo;regE:empleado);
begin
    if(not eof(mae))then
        read(mae,regE)
    else
        regE.departamento:=VALOR_ALTO;
end;

procedure listarHorasExtras(var mae:archivo;vValores:vValorHora);
var
    auxDep,auxDiv,auxEmp:string[20];
    horasDep,horasDiv,horasEmp:integer;
    montoDep,montoDiv,montoEmp:integer;
    regEmp:empleado;
begin   
    reset(mae);
    leer(mae,regEmp);
    while(regEmp.departamento<>VALOR_ALTO)do begin
        horasDep:=0;
        montoDep:=0;
        auxDep:=regEmp.departamento;
        writeln('Departamento: ',auxDep);

        while(auxDep=regEmp.departamento)do begin
            auxDiv:=regEmp.division;
            horasDiv:=0;
            montoDiv:=0;
            writeln('Division: ',auxDiv);
            writeln('Numero de empleado     Total de Hs       Importe a cobrar');
            while((auxDep=regEmp.departamento)and(auxDiv=regEmp.division))do begin
                auxEmp:=regEmp.numero;
                horasEmp:=0;
                montoEmp:=0;

                while((auxDep=regEmp.departamento)and(auxDiv=regEmp.division)and(auxEmp=regEmp.numero))do begin
                    horasEmp:=horasEmp+regEmp.horas;
                    montoEmp:=montoEmp+(regEmp.horas*vValores[regEmp.categoria]);
                    leer(mae,regEmp);
                end;
                
                horasDiv:=horasDiv+horasEmp;
                montoDiv:=montoDiv+montoEmp;
                writeln(auxEmp,'        ',horasEmp,'       ',montoEmp:2:2);
            
            end;
            writeln('Total horas division: ',horasDiv);
            writeln('Monto total division: ',montoDiv:2:2);
            horasDep:=horasDep+horasDiv;
            montoDep:=montoDep+montoDiv;
        
        end;
        writeln('Total horas departamento: ',horasDep);
        writeln('Monto total departamento: ',montoDep:2:2);

    end;
    close(mae);
end;


var
    maestro:archivo;
    montoCategorias:vValorHora;
    fTextMontos:text;
begin
    assign(maestro,'maestroEj10');
    assign(fTextMontos,'montosPorCategoria_Ej10');
    cargarValorCategorias(fTextMontos,montoCategorias);
    listarHorasExtras(maestro);
end;