{   Se cuenta con un archivo que almacena información sobre especies de aves en
    vía de extinción, para ello se almacena: código, nombre de la especie, familia de ave,
    descripción y zona geográfica. El archivo no está ordenado por ningún criterio. Realice
    un programa que elimine especies de aves, para ello se recibe por teclado las especies a
    eliminar. 
    Deberá realizar todas las declaraciones necesarias, implementar todos los
    procedimientos que requiera y una alternativa para borrar los registros. Para ello deberá
    implementar dos procedimientos, uno que marque los registros a borrar y posteriormente
    otro procedimiento que compacte el archivo, quitando los registros marcados. 
    Para quitar los registros se deberá copiar el último registro del archivo en la posición del registro
    a borrar y luego eliminar del archivo el último registro de forma tal de evitar registros
    duplicados.
    Nota: Las bajas deben finalizar al recibir el código 500000
}
program ej7;
const
    CORTE=500000;
type
    especie=record
        codigo:longint;
        nombre:string[20];
        familia:string[20];
        descripcion:string[20];
        zona_geografica:string[20];
    end;
archivo=file of especie;

procedure leer_ave(var a: especie);
begin
    with a do begin
        writeln('Ingresar codigo de especie: ');
        readln(codigo);
        if(codigo <> -1)then begin
            writeln('Ingresar nombre de especie: ');
            readln(nombre);
            writeln('Ingresar familia de ave: ');
            readln(familia);
            writeln('Ingresar descripcion del ave: ');
            readln(descripcion);
            writeln('Ingresar zona geografica de la especie: ');
            readln(zona_geografica);
        end;
    end;
end;

procedure crear_archivo_aves(var a: archivo);
var
    r: especie;
begin
    rewrite(a);
    leer_ave(r);
    while(r.codigo <> -1)do begin
        write(a, r);    
        leer_ave(r);
    end;
    close(a);
end;

function estaBorrado(car:char;nombre:string):boolean;
begin
    estaBorrado:=(nombre[1]=car);
end;


procedure eliminarAves(var arc:archivo);
var
    cod:longint;
    regM:especie;
    ok:boolean;
begin
    reset(arc);
    writeln('Ingrese codigo de especie a eliminar (',CORTE,' para finalizar) ');
    readln(cod);
    
    while(cod<>CORTE)do begin
        ok:=false;
        while(not eof(arc))and(not ok)do begin
            read(arc,regM);
            if((regM.codigo=cod)and (not estaBorrado('@',regM.nombre)))then begin
			    regM.nombre:='@'+regM.nombre;
			    seek(arc,filepos(arc)-1);
			    write(arc,regM);
                ok:=true;
		    end;
        end;
        if(ok)then //salio porque estaba la especie
            writeln('La especie con codigo ',cod,' fue eliminada ')
        else
            writeln('La especie con codigo ',cod,' no fue encontrada ');

        seek(arc,0);
        writeln('Ingrese codigo de especie a eliminar (',CORTE,' para finalizar) ');
        readln(cod);
    end;
    close(arc);
end;


procedure compactar(var a:archivo);
var
    regM,aux:especie;
    pos,cont:integer;
begin
    reset(a);
    cont:=0;
    pos:=filepos(a);
    
    
    while(pos<(filesize(a)-cont))do begin

        read(a,regM);
        
        if(estaBorrado('@',regM.nombre))then begin
            cont:=cont+1;
            seek(a,(filesize(a)-cont));
            read(a,regM);
            while(estaBorrado('@',regM.nombre))and(pos<(filesize(a)-cont))do begin
                cont:=cont+1;
                seek(a,(filesize(a)-cont));
                read(a,regM);
            end;
            
                
            if(not estaBorrado('@',regM.nombre))then begin
                seek(a,pos);
                write(a,regM);
            end;
        end;

        pos:=filepos(a);
    end;
    seek(a,(filesize(a)-cont));
    truncate(a);
    
    
    close(a);
end; 

procedure imprimir(var arc:archivo);
var
    regm: especie;
begin
    reset(arc);
    while(not eof(arc))do begin
        read(arc, regm);
        writeln('codigo ', regm.codigo, ' nombre ', regm.nombre);
    end;
    close(arc);
end;
var
    archivo_aves:archivo;
begin
    assign(archivo_aves,'especies_en_via_de_extincion');
    //crear_archivo_aves(archivo_aves);
    imprimir(archivo_aves);
    
    eliminarAves(archivo_aves);
    writeln('ARCHIVO CON BAJAS');
    imprimir(archivo_aves);
 
    compactar(archivo_aves);
    writeln('ARCHIVO COMPACTADO');
    imprimir(archivo_aves);
end.
