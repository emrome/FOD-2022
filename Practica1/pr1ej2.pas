{Realizar un algoritmo, que utilizando el archivo de números enteros no ordenados
creados en el ejercicio 1, informe por pantalla cantidad de números menores a 1500 y
el promedio de los números ingresados. El nombre del archivo a procesar debe ser
proporcionado por el usuario una única vez. Además, el algoritmo deberá listar el
contenido del archivo en pantalla
}


program pr1ej2;
const
	MENOR=1500;
type
	archivo_enteros=file of integer;
	
procedure Recorrido(var arch:archivo_enteros;var cantMenor,suma:integer);
var
	num:integer;
begin
	reset(arch);
	writeln('Elementos del archivo');
	while not eof(arch)do begin
		read(arch,num);
		write(num);
		if num<MENOR then
			cantMenor:=cantMenor+1;
		suma:=suma+num;
	end;
	close(arch);
end;
function promedio(cant,suma:integer):real;
begin
	promedio:=suma/cant;
end;

var
	enteros:archivo_enteros;
	nombre:string[20];
	cant_menores,suma_elementos:integer;
begin
	writeln('Ingrese nombre del archivo');
	readln(nombre);
	assign(enteros,nombre);
	
	cant_menores:=0;
	suma_elementos:=0;

	Recorrido(enteros,cant_menores,suma_elementos);
	writeln('');
	writeln('Cantidad de numeros menores a ',MENOR,': ',cant_menores);
	writeln('Promedio de los numeros ingresados: ',promedio(fileSize(enteros),suma_elementos):2:2);
	close(enteros);
end.

