{6. Agregar al menú del programa del ejercicio 5, opciones para:
a. Añadir uno o más celulares al final del archivo con sus datos ingresados por
teclado.
b. Modificar el stock de un celular dado.
c. Exportar el contenido del archivo binario a un archivo de texto denominado:
”SinStock.txt”, con aquellos celulares que tengan stock 0.
NOTA: Las búsquedas deben realizarse por nombre de celular.}

program ej6;
const
    NAME='celulares2.txt';
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

//INCISO 5A
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

//INCISO 5B
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

//INCISO 5C
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

//INCISO 5D
{d. Exportar el archivo creado en el inciso a) a un archivo de texto denominado
“celulares.txt” con todos los celulares del mismo.}
procedure exportToText(var pF:phoneFile);
var 
    fText:text;
    p:phone;
begin   
    assign(fText,NAME);
    rewrite(fText);
    reset(pF);
    while(not eof(pf))do begin
        read(pF,p);
        writeln(fText,p.code,' ',p.price,' ',p.brand);
        writeln(fText,p.stockAv,' ',p.minStock,' ',p.description);
        writeln(fText,p.name);
    
    end;
    close(pF);
    close(fText);
end;


//------------------ Ej 6-----------------
//INCISO 6A
//a. Añadir uno o más celulares al final del archivo con sus datos ingresados por teclado.
procedure readPhone(var p:phone);
begin   
    writeln('Ingrese codigo de celular ');
    readln(p.code);
    if(p.code<>-1)then begin    
        writeln('Ingrese nombre');
        readln(p.name);
        writeln('Ingrese descripcion ');
        readln(p.description);
        writeln('Ingrese precio');
        readln(p.price);
        writeln('Ingrese marca');
        readln(p.brand);
        writeln('Ingrese minimo stock');
        readln(p.minStock);
        writeln('Ingrese stock disponible');
        readln(p.stockAv);
    end;
end;

procedure addPhone(var pF:phoneFile);
var 
    p:phone;
begin   
    writeln('Agregar celular, para finalizar ingrese -1');
    reset(pF);
    readPhone(p);
    seek(pF,filesize(pF));
    while(p.code<>-1)do begin   
        write(pF,p);
        readPhone(p);
    end;
    close(pF);
end;
//INCISO 6B
//b. Modificar el stock de un celular dado.
procedure modifyStock(var p:phoneFile);
var 
    name:string;
    newStock:integer;
    aux:phone;
    found:boolean;
begin   
    found:=false;
    writeln('Ingrese nombre del celular a moficar stock');
    readln(name);

    reset(p);
    while((not eof(p))and (not found))do begin   
        read(p,aux);
        if(aux.name=name)then begin 
            found:=true;
    
            writeln('Ingrese nuevo stock disponible');
            readln(newStock);

            aux.stockAv:=newStock;
            seek(p,(filePos(p)-1));
            write(p,aux);
        end;
    end;
    close(p);
end;   


//INCISO 6C
//c. Exportar el contenido del archivo binario a un archivo de texto denominado: ”SinStock.txt”, con aquellos celulares que tengan stock 0.
procedure exportSinStock(var pF:phoneFile);
var 
    fText:text;
    aux:phone;
begin
    assign(fText,'SinStock.txt');
    rewrite(fText);
    reset(pF);
    while (not eof(pF))do begin
        read(pF,aux);
        if(aux.stockAv=0)then begin
            writeln(fText,aux.code,' ',aux.price:2:2,' ',aux.brand);
            writeln(fText,aux.minStock,' ',aux.description);
            writeln(fText,aux.name);
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
        writeln('5. Añadir uno o mas celulares al final del archivo con sus datos ingresados por teclado.');
        writeln('6. Modificar el stock de un celular dado.');
        writeln('7. Exportar el contenido del archivo binario a un archivo de texto denominado: "SinStock.txt", ');
        writeln('con aquellos celulares que tengan stock 0.');
        writeln('8. Salir.');
        
        writeln('Ingrese una opcion: ');
        readln(option);
        case option of 
            '1':createFile(fileP);
            '2':printLowerMinStock(fileP);
            '3':printMatchDescription(fileP);
            '4':exportToText(fileP);
            '5':addPhone(fileP);
            '6':modifyStock(fileP);
            '7':exportSinStock(fileP);
        
    until option='8'
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
