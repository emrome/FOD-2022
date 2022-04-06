{5. Realizar un programa para una tienda de celulares, que presente un menú con
opciones para:
a. Crear un archivo de registros no ordenados de celulares y cargarlo con datos
ingresados desde un archivo de texto denominado “celulares.txt”. Los registros
correspondientes a los celulares, deben contener: código de celular, el nombre,
descripcion, marca, precio, stock mínimo y el stock disponible.

b. Listar en pantalla los datos de aquellos celulares que tengan un stock menor al
stock mínimo.

c. Listar en pantalla los celulares del archivo cuya descripción contenga una
cadena de caracteres proporcionada por el usuario.

d. Exportar el archivo creado en el inciso a) a un archivo de texto denominado
“celulares.txt” con todos los celulares del mismo.

NOTA 1: El nombre del archivo binario de celulares debe ser proporcionado por el usuario
una única vez.

NOTA 2: El archivo de carga debe editarse de manera que cada celular se especifique en
tres líneas consecutivas: en la primera se especifica: código de celular, el precio y
marca, en la segunda el stock disponible, stock mínimo y la descripción y en la tercera
nombre en ese orden. Cada celular se carga leyendo tres líneas del archivo
“celulares.txt”
}


program pr1ej5;
const
    NAME='celulares.txt';
type
    phone=record
        code:integer;
        name:string;
        description:string;
        price:real;
        brand:string;
        minStock:integer;
        stockAv:integer;
    end;
    phoneFile=file of phone;

//INCISO A
{tres líneas consecutivas: en la primera se especifica: código de celular, el precio y
marca, en la segunda el stock disponible, stock mínimo y la descripción y en la tercera
nombre en ese orden}
procedure createFile(var pFile:phoneFile);
var 
    p:phone;
    fileText:text;
begin
    assign(fileText,NAME);
    reset(fileText);
    rewrite(pFile);
    while(not eof(fileText))do begin
        readln(fileText,p.code,p.price,p.brand);
        readln(fileText,p.stockAv,p.minStock,p.description);
        readln(fileText,p.name);
        write(pFile,p)
    end;
    close(fileText);
    close(pFile);
    writeln('Se creo el archivo binario a partir de celulares.txt');
end;

//INCISO B
{b. Listar en pantalla los datos de aquellos celulares que tengan un stock menor al
stock mínimo.}
procedure printPhone(p:phone);
begin   
    with p do begin
        writeln('Codigo :',code);
        writeln('Nombre: ', name);
        writeln('Descripcion: ',description);
        writeln('Marca: ',brand);
        writeln('Precio: $',price:2:2);
        writeln('Stock minimo: ',minStock);
        writeln('Stock disponible: ',stockAv);
    end;
end;

procedure printLowerMinStock(var fileP:phoneFile);
var 
    p:phone;
begin   
    reset(fileP);
    while(not eof(fileP))do begin   
        read(fileP,p);
        if (p.stockAv<p.minStock)then
            printPhone(p);
    end;
    close(fileP);
end;

//INCISO C
{c. Listar en pantalla los celulares del archivo cuya descripción contenga una
cadena de caracteres proporcionada por el usuario.}
procedure printMatchDescription(var pFile:phoneFile);
var 
    chain:string;
    p:phone;
begin   
    writeln('Ingrese descripcion a buscar ');
    readln(chain);
    reset(pFile);

    writeln('Los celulares con la cadena ', chain, 'en su descripcion son:');
    while(not eof(pFile))do begin   
        read(pFile,p);
        if(p.description=chain)then 
            printPhone(p);
    end;
    close(pFile);
end;

//INCISO D
{d. Exportar el archivo creado en el inciso a) a un archivo de texto denominado
“celulares.txt” con todos los celulares del mismo.}
procedure exportToText(var pF:phoneFile);
var 
    fText:text;
    p:phone;
begin   
    assign(fText,'celulares.txt');
    writeln('pase el assign');
    rewrite(fText);
    writeln('pase el rewrite');
    reset(pF);
    writeln('pase el reset');
    while(not eof(pf))do begin
        read(pF,p);
        with p do begin
            writeln(fText,code,' ',price:2:2,' ',brand);
            writeln(fText,stockAv,' ',minStock,' ',description);
            writeln(fText,name);
        end;
    end;
    close(pF);
    close(fText);
end;

procedure menu(var fileP:phoneFile);
var 
    option:string;
begin
    repeat 
		writeln('======== MENU ========');
		writeln('1. Crear archivo binario.');
		writeln('2. Listar celulares con stock menor al minimo.');
		writeln('3. Listar celulares con determinada descripcion.');
		writeln('4. Exportar archivo binario a texto.');
		writeln('5. Salir.');
		writeln('Ingrese una opcion: ');
		readln(option);
		case option of 
			'1':createFile(fileP);
			'2':printLowerMinStock(fileP);
			'3':printMatchDescription(fileP);
			'4':exportToText(fileP);
		end;
    until option='5';
end;

var     
    archivoC:phoneFile;
    fileName:string;
begin   
    write('Ingrese nombre para el archivo binario con el que va a trabajar: ');
    readln(fileName);
    assign(archivoC,fileName);
    menu(archivoC);
end.
