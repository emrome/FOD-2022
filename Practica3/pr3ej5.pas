{
    5. Dada la estructura planteada en el ejercicio anterior, implemente el siguiente módulo:
    Abre el archivo y elimina la flor recibida como parámetro manteniendo la política descripta anteriormente
    procedure eliminarFlor (var a: tArchFlores; flor:reg_flor);
}

program ej5;
const
    VALOR_ALTO=9999;
type
    reg_flor = record
        nombre:string[45];
        codigo:integer;
    end;
tArchFlores = file of reg_flor;

procedure agregarFlor(var a: tArchFlores;nombre:string;codigo:integer);
var
    flor,cabecera:reg_flor;
begin
    flor.nombre:=nombre;
    flor.codigo:=codigo;
    reset(a);
    read(a,cabecera);
    if(cabecera.codigo<0)then begin//hay registros borrados
        seek(a,(cabecera.codigo*-1))
        read(a,cabecera); //me guardo el sig espacio libre
        seek(a,filepos(a)-1) 
        write(a,flor);
        seek(a,0)
        write(a,cabecera);
    end
    else begin
        seek(a,filesize(a))
        write(a,flor);
    end;
    close(a);
end;

procedure leer(var a:tArchFlores;var reg:reg_flor); 
begin
    if(not eof(a))then
        read(a,reg)
    else
        reg.codigo:=VALOR_ALTO;
end;

procedure eliminarFlor(var a: tArchFlores; flor:reg_flor);
var
    regF:reg_flor;
    cabecera:integer;
begin
    reset(a);
    leer(a,regF)
    cabecera:=regF.codigo;//me guardo el codigo del primer espacio libre

    leer(a,regF)//leo el sig a cabecera
    while((regF.codigo<>VALOR_ALTO)and(regF.codigo<>flor.codigo))do 
        leer(a,regF);

    if((regF.codigo<>VALOR_ALTO)and(regF.codigo=flor.codigo))then begin
        regF.codigo:=cabecera;//guardo el cod que estaba en cabecera 
        cabecera:=(filepos(a)-1)*-1 //es la pos donde se elimino el registro
        seek(a,filepos(a)-1))
        write(a,regF);//elimino el registro
        
        regF.codigo:=cabecera; //guardo el lugar del nuevo lugar libre
        seek(a,0)
        write(a,regF)
        writeln('Flor eliminada');
    end
    else
        writeln('Flor no encontrada');
    close(a);
end;

procedure listarFlores(var a:tArchFlores);
var
    reg:reg_flores;
begin
    reset(a);
    while(not eof(a))do begin
        read(a,reg)
        if(reg.codigo>0)then 
            writeln('Flor: ',reg.nombre,' Codigo: ',reg.codigo);
    end;
    close(a);
end;


var
    archivo_flores:rArchFlores;
    flor:reg_flores;
begin
    assign(archivo_flores,'archivo_flores');
    agregarFlor(archivo_flores,'Tulipan',4);
    agregarFlor(archivo_flores,'Rosa',4);
    listarFlores(archivo_flores);
    flor.nombre:='Rosa';
    flor.codigo:=4;
    eliminarFlor(archivo_flores,flor);
    listarFlores(archivo_flores);
end.