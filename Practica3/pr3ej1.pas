{   Modificar el ejercicio 4 de la práctica 1 (programa de gestión de empleados),
    agregándole una opción para realizar bajas copiando el último registro del archivo en
    la posición del registro a borrar y luego truncando el archivo en la posición del último
    registro de forma tal de evitar duplicados
}


program ej1;
const
	CORTE='fin';
	EDAD=70;
    VALOR_ALTO=9999;
type
	str8:string[8];
	empleado=record
		numero:integer;
		edad:integer;
		dni:str8;
		apellido:string;
		nombre:string;
	end;
	archivo_empleados=file of empleado;

procedure leerEmpleado(var emp:empleado); 
begin
	writeln('Ingrese apellido del empleado');
	readln(emp.apellido);
	if emp.apellido<>CORTE then begin
		writeln('Ingrese nombre del empleado');
		readln(emp.nombre);
		writeln('Ingrese numero de empleado');
		readln(emp.numero);
		writeln('Ingrese edad del empleado');
		readln(emp.edad);
		writeln('Ingrese DNI del empleado');
		readln(emp.dni);
	end;
end;

procedure cargar_empleados(var arch:archivo_empleados);
var
	emp:empleado;
	nombreArchivo:string;
begin
	writeln('Ingrese nombre del archivo a crear');
	readln(nombreArchivo);
	assign(arch,nombreArchivo);
	rewrite(arch);
	leerEmpleado(emp);
	while emp.apellido<>CORTE do begin
		write(arch,emp);
		leerEmpleado(emp);
	end;
	close(arch);
	writeln('Archivo creado');
end;

procedure imprimirEmpleado(dato:empleado);
begin
	writeln('Numero de empleado: ',dato.numero,' Apellido: ',dato.apellido,' Nombre: ',dato.nombre,' Edad: ',dato.edad);
	if dato.dni<>'00' then
		writeln(' DNI: ',dato.dni);
end;
 
procedure listarEmpleadosDeterminados(var archivo:archivo_empleados);
var
	name:string;
	aux:empleado;
	nombreArchivo:string;
begin
	writeln('Ingrese nombre del archivo');
	readln(nombreArchivo);
	assign(archivo,nombreArchivo);
	
	writeln('Ingrese nombre o apellido a buscar');
	readln(name);
	
	reset(archivo);
	while(not eof(archivo))do begin
		read(archivo,aux);
		if ((aux.nombre =name) or (aux.apellido=name))then
			imprimirEmpleado(aux);
	end;
	close(archivo);
end;

procedure listarEmpleados(var arc:archivo_empleados);
var
	nombreArchivo:string;
	aux:empleado;
begin
	writeln('Ingrese nombre del archivo');
	readln(nombreArchivo);
	assign(arc,nombreArchivo);
	reset(arc);
	while (not eof(arc))do begin
		read(arc,aux);
		imprimirEmpleado(aux);
	end;
	close(arc);
end;

procedure listarEmpleadosJubilarse(var archi:archivo_empleados);
var
	aux:empleado;
	nombreArchivo:string;
begin
	writeln('Ingrese nombre del archivo');
	readln(nombreArchivo);
	assign(archi,nombreArchivo);
	reset(archi);
	while(not eof(archi))do begin
		read(archi,aux);
		if (aux.edad>EDAD)then
			imprimirEmpleado(aux);
	end;
	close(archi);
end;

//---------------parte nueva---------------------
procedure agregarEmpleado(var arc:archivo_empleados);
var
	emp:empleado;
	nombre:string;
begin
	writeln('Ingresar nombre del archivo que desea abrir: ');
	readln(nombre);
	assign(arc,nombre);
	
	reset(arc);
	seek(arc,fileSize(arc));
	writeln('Ingrese datos del empleado a agregar, para finalizar ingrese fin');
	leerEmpleado(emp);
	while (emp.apellido<>'fin')do begin
		write(arc,emp);
		leerEmpleado(emp);
	end;
	close(arc);
end;

procedure buscarEmpleado(var archi:archivo_empleados;var emp:empleado;numEmp:integer);
var
	encontre:boolean;
begin
	encontre:=false;
	seek(archi,0);
	while(not eof(archi)and (not encontre))do begin
		read(archi,emp);
		encontre:=(emp.numero=numEmp);
	end;
end;


function quiereSeguir:boolean;
var
	aux:integer;
begin
	writeln('¿Quiere modificar la edad de otro empleado? Si: 1 /No: 0 ');
	readln(aux);
	quiereSeguir:=(aux=1);
end;
procedure modificarEdad(var arc:archivo_empleados);
var
	aux:empleado;
	nuevaEdad,numbEmp:integer;
	seguir:boolean;
	nombre:string;
begin
	writeln('Ingresar nombre del archivo que desea abrir: ');
	readln(nombre);
	assign(arc,nombre);
	
	reset(arc);
	repeat 
		writeln('Ingrese numero de empleado a modificar la edad');
		readln(numbEmp);
		writeln('Ingrese nueva edad');
		readln(nuevaEdad);

		buscarEmpleado(arc,aux,numbEmp);
		aux.edad:=nuevaEdad;
		seek(arc,filePos(arc)-1);
		write(arc,aux);

		seguir:=quiereSeguir;
	until not seguir;
	close(arc)
end;

procedure exportToText(var fEmp:archivo_empleados);
var
	arcText:text;
	emp:empleado;
	nameText:string;
	nombre:string;
begin
	writeln('Ingresar nombre del archivo que desea abrir: ');
	readln(nombre);
	assign(fEmp,nombre);
	
	writeln('Ingrese nombre para el archivo de texto ');
	readln(nameText);
	reset(fEmp);
	assign(arcText,nameText);
	rewrite(arcText);
	while (not eof(fEmp))do begin
		read(fEmp,emp);
		with emp do begin
			writeln(arcText,numero,' ',dni);
			writeln(arcText,edad,' ',nombre);
			writeln(arcText,apellido);
		end;
	end;
	close(fEmp);
	close(arcText);
end;


procedure exportText_notDni(var archivo:archivo_empleados);
var
	arcText:text;
	emp:empleado;
begin
	writeln('Ingresar nombre del archivo que desea abrir: ');
	readln(nombre);
	assign(archivo,nombre);
	reset(archivo);
	assign(arcText,'faltaDNIEmpleado.txt');
	rewrite(arcText);
	while (not eof(archivo))do begin
		read(archivo,emp);
		if emp.dni='00' then
			with emp do begin
				writeln(arcText,' ',numero);
				writeln(arcText,' ',edad);
				writeln(arcText,' ',apellido);
				writeln(arcText,' ',nombre);
			end;
	end;
	close(archivo);
	close(arcText);
end;
procedure leer(var mae:archivo_empleados;var reg:empleado);
begin
    if(not eof(mae))then
        read(mae,reg)
    else
        reg.num:=VALOR_ALTO;
end;
procedure eliminarEmpleado(var mae:archivo_empleados);
var
    numBuscado:integer;
    reg,ultReg:empleado;
begin
    reset(mae);
    writeln('Ingrese numero de empleado a eliminar');
    readln(numBuscado);
    seek(mae,filesize(mae)-1);
    read(mae,ultReg);
    if(ultReg.num<>numBuscado)then begin
        seek(mae,0);
        leer(mae,reg);
        while(reg.num<>VALOR_ALTO)and(reg.num<>numBuscado)do 
            leer(mae,reg);
        if((reg.num<>VALOR_ALTO)and(reg.num=numBuscado))then begin
            seek(mae,filepos(mae)-1);
            write(mae,ultReg);
            seek(mae,filesize(mae)-1);
            truncate(mae);
        end
        else 
            writeln('El empleado no se encuentra en el archivo');
               
    end
    else begin
        seek(mae,filesize(mae)-1);
        truncate(mae);
    end;
    close(mae);
end;


procedure menu(var fileE:archivo_empleados);
var
	opcion:string;
begin
    repeat
	writeln(#10+'================== MENU ==================');
    writeln('1. Crear archivo de empleados.');
    writeln('2. Listar nombre o apellido de empleado determinado.');
    writeln('3. Listar todos los empleados.');
    writeln('4. Listar empleados mayores a 70 años.');
    writeln('5. Agregar empleados a un archivo de empleados.');
    writeln('6. Modificar la edad de uno o mas empleados.');
    writeln('7. Exportar archivo a un archivo de texto.');
    writeln('8. Exportar empleados sin dni a un archivo de texto.');
    writeln('9. Realizar baja.');
    writeln('10. Salir.');
    writeln('Ingrese una opcion: ');
    readln(opcion);
	case opcion of
		'1':cargar_empleados(fileE);
		'2':listarEmpleadosDeterminados(fileE);
		'3':listarEmpleados(fileE);
		'4':listarEmpleadosJubilarse(fileE);
		'5':agregarEmpleado(fileE);
		'6':modificarEdad(fileE);
		'7':exportToText(fileE);
		'8':exportText_notDni(fileE);
        '9':eliminarEmpleado(fileE);
    
	until opcion='10'
end;

var
	empleados:archivo_empleados;
begin
	menu(empleados);
end.
