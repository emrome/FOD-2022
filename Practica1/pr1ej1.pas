{Realizar un algoritmo que cree un archivo de números enteros no ordenados y permita
incorporar datos al archivo. Los números son ingresados desde teclado. El nombre del
archivo debe ser proporcionado por el usuario desde teclado. La carga finaliza cuando
se ingrese el número 30000, que no debe incorporarse al archivo.
}
program pr1ej1;
const
	CORTE=3000;
type
	archivo_enteros=file of integer;
var
	enteros:archivo_enteros;
	num:integer;
	nombre_fisico:string[20];
begin
	write('Ingrese el nombre del archivo: ');
	readln(nombre_fisico);
	assign(enteros,nombre_fisico);
	rewrite(enteros);{apertura del archivo para creación}
	
	writeln('Ingrese un numero');
	readln(num);
	while(num <>CORTE)do begin
		write(enteros,num);
		writeln('Ingrese un numero');
		readln(num);
	end;
	close(enteros);
end.

