{Realizar un programa que presente un menú con opciones para:
a. Crear un archivo de registros no ordenados de empleados y completarlo con datos ingresados desde teclado. De cada empleado se registra: número de
empleado, apellido, nombre, edad y DNI. Algunos empleados se ingresan con DNI 00. La carga finaliza cuando se ingresa el String ‘fin’ como apellido.
b. Abrir el archivo anteriormente generado y
i. Listar en pantalla los datos de empleados que tengan un nombre o apellidodeterminado.
ii. Listar en pantalla los empleados de a uno por línea.
iii. Listar en pantalla empleados mayores de 70 años, próximos a jubilarse.
NOTA: El nombre del archivo a crear o utilizar debe ser proporcionado por el usuario una
única vez
}

program pr1ej3;
const
	CORTE='fin';
	EDAD=70;
type
	empleado=record
		numero:integer;
		edad:integer;
		dni:integer;
		apellido:string;
		nombre:string
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
	writeln('Numero de empleado: ',dato.numero,' Apellido: ',dato.apellido,' Nombre: ',dato.nombre,' DNI: ',dato.dni,' Edad: ',dato.edad);
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

procedure menu(var arc:archivo_empleados);
var
	opcion:string;
begin
	writeln(#10+'================== MENU ==================');
    writeln('1. Crear archivo de empleados.');
    writeln('2. Listar nombre o apellido de empleado determinado.');
    writeln('3. Listar todos los empleados.');
    writeln('4. Listar empleados mayores a 70 años.');
    writeln('5. Salir.');
    write('Ingrese una opcion: ');
    readln(opcion);
	if opcion<>'5'then begin
		case opcion of
			'1':cargar_empleados(arc);
			'2':listarEmpleadosDeterminados(arc);
			'3':listarEmpleados(arc);
			'4':listarEmpleadosJubilarse(arc);
		end;
		menu(arc);
	end;
end;

var
	empleados:archivo_empleados;
begin
	menu(empleados);
end.
