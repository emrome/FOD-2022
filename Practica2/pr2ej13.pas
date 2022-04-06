{ 13. Suponga que usted es administrador de un servidor de correo electrónico. En los logs
    del mismo (información guardada acerca de los movimientos que ocurren en el server) que
    se encuentra en la siguiente ruta: /var/log/logmail.dat se guarda la siguiente información:
    nro_usuario, nombreUsuario, nombre, apellido, cantidadMailEnviados. Diariamente el
    servidor de correo genera un archivo con la siguiente información: nro_usuario,
    cuentaDestino, cuerpoMensaje. Este archivo representa todos los correos enviados por los
    usuarios en un día determinado. Ambos archivos están ordenados por nro_usuario y se
    sabe que un usuario puede enviar cero, uno o más mails por día.
    
    a- Realice el procedimiento necesario para actualizar la información del log en un día particular. 
    Defina las estructuras de datos que utilice su procedimiento.
    b- Genere un archivo de texto que contenga el siguiente informe dado un archivo detalle de un día determinado:
        nro_usuarioX…………..cantidadMensajesEnviados
        ………….
        nro_usuarioX+n………..cantidadMensajesEnviados

    Nota: tener en cuenta que en el listado deberán aparecer todos los usuarios que
    existen en el sistema
}
program ej13;
const
    VALOR_ALTO=9999;
type
    log=record
        nro_usuario:integer;
        nombreUsuario:string[20];
        nombre:string[20];
        apellido:string[20];
        cantidadMailEnviados:integer;
    end;
    informacion=record
        nro_usuario:integer;
        cuentaDestino:string[50];
        cuerpoMensaje:string[250];
    end;

maestro=file of log;
detalle=file of informacion;

procedure leer(var det:detalle;var reg:informacion);
begin
    if(not eof(det))then
        read(det,reg)
    else
        reg.nro_suario:=VALOR_ALTO;
end;

{   Ordenados por nro_usuario
    Maestro:nro_usuario, nombreUsuario, nombre, apellido, cantidadMailEnviados.
    Detalle:nro_usuario,cuentaDestino, cuerpoMensaje
}
procedure actualizarMaestro(var mae:maestro;var det:detalle);
var
    regM:log;
    regD:informacion;
begin
    reset(mae);
    reset(det);
    leer(det,regD);
    while(regD.nro_usuario<>VALOR_ALTO)do begin
        read(mae,regM);
        while(regD.nro_usuario<>regM.nro_usuario)do 
            read(mae.redM);


        while(regM.nro_usuario=regD.nro_usuario)do begin
            regM.cantidadMailEnviados:=regM.cantidadMailEnviados+1;
            leer(det,regD);
        end;
        
        seek(mae,filepos(mae)-1);
        write(mae,regM);
    end;
    close(mae);
    close(det);
end;

procedure leerDeMaestro(var det:maestro;var reg:log);
begin
    if(not eof(det))then
        read(det,reg)
    else
        reg.nro_usuario:=VALOR_ALTO;
end;

{
    nro_usuarioX…………..cantidadMensajesEnviados
        ………….
    nro_usuarioX+n………..cantidadMensajesEnviados
}
procedure archivoTextoDiaX(var fText:text;var det:detalle;var mae:maestro);
var
    regM:log;
    regD:informacion;

begin
    rewrite(fText);
    reset(det);
    leerDeMaestro(mae,regM);
    leer(det,regD);
    while(regM.nro_usuario<>VALOR_ALTO)do begin
        regM.cantidadMailEnviados:=0;
        while((regD.nro_usuario<>regM.nro_usuario)and(regM.nro_usuario<>VALOR_ALTO))do begin        
            writeln(fText,regM.nro_usuario,regM.cantidadMailEnviados);
            leerDeMaestro(mae,regM);
            regM.cantidadMailEnviados:=0;
        end;
        if(regM.nro_usuario<>VALOR_ALTO)then begin
            while(regM.nro_usuario=regD.nro_usuario)do begin
                regM.cantidadMailEnviados:=regM.cantidadMailEnviados+1;
                leer(det,regD);
            end;
            
            writeln(fText,regM.nro_usuario,regM.cantidadMailEnviados);
            leerDeMaestro(mae,regM);
        end;
    end;
        
    close(mae);
    close(det);
    close(fText);
end;

var
    archivo_maestro:archivo;
    archivo_detalle:detalle;
    archivo_txt:text;
begin
    assign(archivo_maestro,'/var/log/logmail.dat');
    assign(archivo_detalle,'detalleDia2');
    assign(fText,'informeDiaX');
    
    actualizarMaestro(archivo_maestro,archivo_detalle);
    archivoTextoDiaX(archivo_txt,arch)
end.