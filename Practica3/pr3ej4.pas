{   Las bajas se realizan apilando registros borrados y las altas reutilizando registros
    borrados. El registro 0 se usa como cabecera de la pila de registros borrados: el
    número 0 en el campo código implica que no hay registros borrados y -N indica que el
    próximo registro a reutilizar es el N, siendo éste un número relativo de registro válido.
    a. Implemente el siguiente módulo:
        Abre el archivo y agrega una flor, recibida como parámetro manteniendo la política descripta anteriormente
        
        procedure agregarFlor (var a: tArchFlores ; nombre: string;
        codigo:integer);

    b. Liste el contenido del archivo omitiendo las flores eliminadas. Modifique lo que
    considere necesario para obtener el listado.
}

program ej4;
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
begin
    assign(archivo_flores,'archivo_flores');
    agregarFlor(archivo_flores,'tulipan',4578);
    listarFlores(archivo_flores);
end.