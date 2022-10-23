use libreriaLCII
go





----------------------------------------------------------------------------------------------------------------

--2.1 Introducción a la programación PL/SQL


/*Ejercicio 1.1.Declarar 3 variables que se llamen codigo, stock y stockMinimo respectivamente. A la variable codigo setearle un valor. 
Las variables stock y stockMinimo almacenarán el resultado de las columnas de la tabla artículos stock y stockMinimo respectivamente 
filtradas por el código que se corresponda con la variable codigo.*/

declare @codigo int
declare @stock decimal (10,2)
declare @stockMinimo decimal (10,2)

set @codigo = 3
set @stock = (select stock from articulos where cod_articulo = @codigo)
set @stockMinimo = (select stock_minimo from articulos where cod_articulo = @codigo)

select @codigo 'Codigo',@stock 'Stock',@stockMinimo 'Stock Minimo'

/*Ejercicio 1.2.Utilizando el punto anterior, verificar si la variable stock o stockMinimo tienen algún valor.
Mostrar un mensaje indicando si es necesario realizar reposición de artículos o no.*/

alter proc pa_consulta_repo_stock
@codigo int = 3,
@stock decimal (10,2) output,
@stockMinimo decimal (10,2) output
as
set @stock = (select stock from articulos where cod_articulo = @codigo)
set @stockMinimo = (select stock_minimo from articulos where cod_articulo = @codigo)
if (@stock < @stockMinimo)
begin
select 'Es necesario reponer'+ trim(str(@codigo))
return 1
end;
else
begin
select 'No es necesario reponer'+ trim(str(@codigo))
return 0 
end;


declare @s decimal(10,2)
declare @sm decimal (10,2)
declare @retorno char(50)
exec @retorno= pa_consulta_repo_stock 30 ,@s output, @sm output
select  @s 'Stock', @sm 'Stock Minimo',@retorno 'Reposicion' 


/*Ejercicio 1.3.Modificar el ejercicio 1 agregando una variable más donde se almacene el precio del artículo.
En caso que el precio sea menor a $500, aplicarle un incremento del 10%. En caso de que el precio sea mayor a
$500 notificar dicha situación y mostrar el precio del artículo.
*/
alter procedure pa_actualizacion_precio
@codigo int
as
declare @stock decimal (10,2)
declare @stockMinimo decimal (10,2)
declare @precio decimal (10,2)

set @stock = (select stock from articulos where cod_articulo = @codigo)
set @stockMinimo = (select stock_minimo from articulos where cod_articulo = @codigo)
set @precio = (select pre_unitario from articulos where cod_articulo = @codigo)
if (@precio > 500)
begin
select 'precio mayor al mínimo'
select @codigo 'Codigo',@stock 'Stock',@stockMinimo 'Stock Minimo',@precio 'Precio'
return
end
else
begin
update articulos
set pre_unitario = @precio * 1.1
where cod_articulo = @codigo
select 'Se actuliazo el precio'
select @codigo 'Codigo',@stock 'Stock',@stockMinimo 'Stock Minimo',@precio 'Precio'
end;

exec pa_actualizacion_precio @codigo = 21




/*Ejercicio 1.4. Declarar dos variables enteras, 
y mostrar la suma de todos los números comprendidos entre ellos. 
En caso de ser ambos números iguales mostrar un mensaje informando dicha situación*/

select * from sys.objects where type = 'fn'


ALTER function fn_suma
(@numero1 int, @numero2 int)
    returns varchar(50)
    as
    begin
        declare @suma int
        SET @SUMA = 0
        DECLARE @numero int

        if(@numero1 = @numero2)
            return 'Los numeros son iguales'
        else
        if (@numero1>=@numero2)
	        return 'n1 debe ser menor que n2'   
        else
		SET @numero = @numero1
        while (@numero <= @numero2)
        begin
            set @suma += @numero
            SET @numero += 1
        end
        return CAST(@suma as varchar)
    end

select dbo.fn_suma (15,10)



/*Ejercicio 1.5. Mostrar nombre y precio de todos los artículos. Mostrar en una tercer columna 

--la leyenda ‘Muy caro’ para precios mayores a $500, ‘Accesible’ para precios 

--entre $300 y $500, ‘Barato’ para precios entre $100 y $300 y ‘Regalado’ para 

--precios menores a $100.*/

select descripcion,pre_unitario,tipoprecio= 

case

when pre_unitario>500 then 'Muy caro'

when pre_unitario>=300 and pre_unitario<=500 then 'Accesible'

when pre_unitario>=100 and pre_unitario<300 then 'Barato'

when pre_unitario<100 then 'regalado'

end

from articulos


/*Ejercicio 1.6.  Modificar el punto 2 reemplazando el mensaje de que es necesario reponer artículos por una excepción.*/

declare @codigo int=30, @stock int, @stockMinimo int
select @stock=stock ,@stockminimo=stock_minimo
	from articulos
	where cod_articulo=@codigo
if @stock is null or @stockMinimo is null 
	raiserror ('hay valores nulos',11,1)
else
	if @stock<=@stockMinimo
		raiserror ('realizar la reposición del stock',10,1)
	else
		raiserror ('No es necesario realizar la reposición del stock',10,1)




alter proc pa_consulta_repo_stock3
@codigo int = 3,
@stock decimal (10,2) output,
@stockMinimo decimal (10,2) output
as
set @stock = (select stock from articulos where cod_articulo = @codigo)
set @stockMinimo = (select stock_minimo from articulos where cod_articulo = @codigo)
begin
if (@stock > @stockMinimo)
raiserror ('No es necesario realizar la reposición del stock',10,1)
else
raiserror ('realizar la reposición del stock',10,1)
return 1
end


declare @s decimal(10,2)
declare @sm decimal (10,2)
declare @retorno int
exec @retorno= pa_consulta_repo_stock3 30 ,@s output, @sm output
select  @s 'Stock', @sm 'Stock Minimo',@retorno 'Reposicion' 

---------------------------------------------------------------------
/*Manejo de Errores*/

-- Try.....Catch

begin try 
select 15/0 as error;
end try
begin catch
select 'se produjo el siguiente error',
error_number () as Número,
error_state () as Estado,
error_severity () as Gravedad,
error_procedure () as Procedimiento,
error_line () as Linea,
error_message () as Mensaje
end catch


select * from sys.messages
where message_id = 8134

/*1. Modificar el ejercicio 2 de la sección 1.1 reemplazando los mensajes mostrados en
consola con print, por excepciones. Verificar el comportamiento en el SQL Server
Management.*/

declare @codigo int=30, @stock int, @stockMinimo int
select @stock=stock ,@stockminimo=stock_minimo
	from articulos
	where cod_articulo=@codigo
if @stock is null or @stockMinimo is null 
	raiserror ('hay valores nulos',11,1)
else
	if @stock<=@stockMinimo
		raiserror ('realizar la reposición del stock',10,1)
	else
		raiserror ('No es necesario realizar la reposición del stock',10,1)




/*2. Modificar el ejercicio anterior agregando las cláusulas de try catch para manejo de
errores, y mostrar el mensaje capturado en la excepción con print.*/

declare @codigo int=30, @stock int, @stockMinimo int
select @stock=stock ,@stockminimo=stock_minimo
	from articulos
	where cod_articulo=@codigo
if @stock is null or @stockMinimo is null 
	raiserror ('hay valores nulos',11,1)
else
	begin try
	if @stock<=@stockMinimo
	print  'realizar la reposición del stock'
	end try
	begin catch
	select ERROR_NUMBER() AS ErrorNumber,  
          ERROR_MESSAGE() AS ErrorMessage;
	end catch;
	

/******************************************************************************/


/* Programacion aplicada a procediminetos y Funciones
Ejercicio Procedimiento 1.a Mostrar los artículos cuyo precio sea mayor o igual que un valor que se envía por parámetro.*/

Create Proc pa_articulos_precios4
@precio money
as
select * from articulos 
where pre_unitario >= @precio

exec pa_articulos_precios2 '100';

/*Ejercicio Procedimiento 1.b
Ingresar un artículo nuevo, verificando que la cantidad de stock que se pasa por parámetro 
sea un valor mayor a 30 unidades y menor que 100. Informar un error caso contrario.
*/
alter procedure pa_articulos_alta
@descripcion nvarchar (50) null,
@stock_minimo smallint  null,
@stock smallint  null,
@pre_unitario decimal (10,2) null,
@observaciones nvarchar (50) = null-- valor por defecto
as
if (@stock < 30 or @stock > 100)
begin
select 'Ingresar un stock entre 30 y 100 unidades'
return 0
end
begin
insert into articulos
values (@descripcion, @stock_minimo,@stock,@pre_unitario,@observaciones)
end;
return 1

exec pa_articulos_alta 'engrmapadora', 50,35,5000.00,'cuchuflito'

/*Ejercicio Procedimiento 1.c

Mostrar un mensaje informativo acerca de si hay que reponer o no stock de un artículo cuyo código sea enviado por parámetro
*/

alter proc pa_consulta_repo_stock
@codigo int = 3,
@stock decimal (10,2) output,
@stockMinimo decimal (10,2) output
as
set @stock = (select stock from articulos where cod_articulo = @codigo)
set @stockMinimo = (select stock_minimo from articulos where cod_articulo = @codigo)
if (@stock < @stockMinimo)
begin
select 'Es necesario reponer'
return 1
end;
else
begin
select 'No es necesario reponer'
return 0 
end;


declare @s decimal(10,2)
declare @sm decimal (10,2)
declare @retorno char(50)
exec @retorno= pa_consulta_repo_stock 30 ,@s output, @sm output
select  @s 'Stock', @sm 'Stock Minimo',@retorno 'Reposicion' 

/* *Ejercicio Procedimiento 1.d

Actualizar el precio de los productos que tengan un precio menor a uno ingresado por parámetro en un porcentaje que también 
se envíe por parámetro. Si no se modifica ningún elemento informar dicha situación*/

create procedure pa_actualizacion_precioG
@precio money,
@porc decimal (4,2)
as
if exists ( select * from articulos where pre_unitario < @precio)
begin
update articulos
set pre_unitario = pre_unitario * ( 1 + @porc / 100)
where pre_unitario < @precio
select 'precios actualizados'
end
else
select 'no hay articulo con precio inferior al indcado'


exec pa_actualizacion_precioG @precio = 60, @porc = 15.00



/*Ejercicio Procedimiento 1.e
Mostrar el nombre del cliente al que se le realizó la primer venta en un parámetro de salida.
*/

create procedure pa_cliente_primera_venta
@nombre nvarchar (100) output
as
begin
declare @primeraVenta int
set @primeraVenta = (select min(f.nro_factura) from facturas f)
set @nombre = (select c.nom_cliente+' '+c.ape_cliente
from facturas f1
inner join clientes c on c.cod_cliente = f1.cod_cliente
where f1.nro_factura = @primeraVenta) 
end;

declare @nom nvarchar (100)
exec pa_cliente_primera_venta @nom output
select @nom 'Cliente'


/*Ejercicio Procedimiento 1.f
Realizar un select que busque el artículo cuyo nombre empiece con un valor enviado por parámetro 
y almacenar su nombre en un parámetro de salida.En caso que haya varios artículos ocurrirá una 
excepción que deberá ser manejada con try catch.
*/


ALTER PROCEDURE pa_buscArticulo
@descripcion nvarchar(500) = '%',
@nombre nvarchar(500) output
AS  
BEGIN TRY
begin
select @nombre = descripcion from articulos where descripcion like @descripcion+'%'
end      
END TRY  
BEGIN CATCH  
    SELECT   
        ERROR_NUMBER() AS ErrorNumber,  
        ERROR_MESSAGE() AS ErrorMessage;
		print 'Mas de un articulo'
END CATCH;  

declare @n nvarchar (500)
EXECUTE pa_buscArticulo 'l%', @n output
select @n 'descripcion'

/* Programación de Funciones*/


/*a. Devolver una cadena de caracteres compuesto por los siguientes datos:
Apellido, Nombre, Telefono, Calle, Altura y Nombre del Barrio, de un
determinado cliente, que se puede informar por codigo de cliente o email.*/

alter function fn_Datos_Cliente
(@parametro1 int = null, /* se recomienda pasar parametros por defecto*/
@parametro2 nvarchar(100) = null)
Returns nvarchar(100) 
as
begin
declare @cadena nvarchar(500) 
if (@parametro1 is not null and @parametro2 is null)
     set @cadena = (select 'Nombre '+c.ape_cliente+','+c.nom_cliente+'Tel. '+c.nro_tel+'Calle '+c.calle+'N° '+c.altura+'B° '+b.barrio 
     from clientes c inner join barrios b on c.cod_barrio = b.cod_barrio
     where c.cod_cliente = @parametro1)
else
    if @parametro1 is null and @parametro2 is not null
      set @cadena = (select 'Nombre '+c.ape_cliente+','+c.nom_cliente+'Tel. '+c.nro_tel+'Calle '+c.calle+'N° '+c.altura+'B° '+b.barrio
      from clientes c inner join barrios b on c.cod_barrio = b.cod_barrio
      where [e-mail] like @parametro2)
    else
	if @parametro1 is not null and @parametro2 is not null
      set @cadena = (select 'Nombre '+c.ape_cliente+','+c.nom_cliente+'Tel. '+c.nro_tel+'Calle '+c.calle+'N° '+c.altura+'B° '+b.barrio
      from clientes c inner join barrios b on c.cod_barrio = b.cod_barrio
      where [e-mail] like @parametro2 and c.cod_cliente = @parametro1)
    else
	set @cadena= 'Debe ingresar un codigo de cliente o un mail' -- se puede usar el set y luego la consulta o se puede seleccionar y asigna como campo la consulta a la
  return @cadena --el rerturn siempre hace referencia a un unicop SP y siempre esta dentro del begin.
end;

select dbo.fn_Datos_Cliente(1,default)



/*b. Devolver todos los artículos, se envía un parámetro que permite ordenar el
resultado por el campo precio de manera ascendente (‘A’), o descendente
(‘D’).*/

create function f_articulos2
(@orden char(1) = null)
returns table
as
if (@orden = 'A')
return 
(select * from articulos order by pre_unitario asc)
else
   if(@orden = 'D')
   return 
   (select * from articulos order by pre_unitario desc)
   else
   return 
   (select 'debe ingresar A o D')


select * f_articulos2

--------------------------------------------------

alter function f_art_ord_pre
(@orden varchar(1) = null)
returns @art_ord table
(cod int, descrip varchar(100), pre money)
as
begin
if (@orden = 'A')
   insert @art_ord
   select a.cod_articulo,a.descripcion,a.pre_unitario
   from articulos a
   order by a.pre_unitario
 
else
   if(@orden = 'D')
     insert @art_ord
     select a.cod_articulo,a.descripcion,a.pre_unitario
     from articulos a
     order by a.pre_unitario desc
return
end;

select * from dbo.f_art_ord_pre('D')



/*c. Crear una función que devuelva el precio al que quedaría un artículo en
caso de aplicar un porcentaje de aumento pasado por parámetro.*/

create function f_art_act_pre
(@cod int,@por decimal(3,1))
returns @pre_art table
(cod int, descrip varchar(100),pre money)
as 
begin
	insert @pre_art
	select cod_articulo,descripcion,pre_unitario*(1+@por/100)
	from articulos
	where cod_articulo=@cod
return
end

select * from dbo.f_art_act_pre(1,10)


/**********************************************************************************************/

/*TRIGGERS*/

/*1. Crear un desencadenador para las siguientes acciones:
a. Restar stock DESPUES de INSERTAR una VENTA*/
/*b. Para no poder modificar el nombre de algún artículo
create trigger dis_articulos_actualizar_nombre */

 on articulos
 for update
 as
 if update(descripcion)
 begin
 raiserror('No se puede modificar el nombre de un
  artículo', 10, 1)
 rollback transaction
 end;


/* c. Insertar en la tabla HistorialPrecio el precio anterior de un artículo si el
mismo ha cambiado


d. Bloquear al vendedor con código 4 para que no pueda registrar ventas en el
sistema.*/

create trigger dis_ventas_vendedor_4
on facturas	
for insert
as
declare @vendedor int
select @vendedor=fa.cod_vendedor from facturas fa join inserted
on inserted.cod_vendedor=fa.cod_vendedor
if(@vendedor=4)
begin
raiserror('Error el vendedor 4 no puede cargar facturas', 10, 1)
rollback transaction
end;

 -- 2.5. Tablas Temporales

--Ejercicio 2.5.2. 

create procedure pa_452

@mes int,

@año int

as

select *

from facturas

where year(fecha) = @año and month(fecha) = @mes

and day(fecha) not in (2,4,6,8,10,12,14,16,18,20,22,24,26,28,30)
-----------------------------------------

create function fn_cadena
(@parametro1 string,
@parametro2 string)
Returns string 
as
begin 
declare @cadena string 
set @cadena = concat(@parametro1,@parametro2)
return @cadena
end

select dbo.fn_cadena ('Diego','Guizzo')



alter function fn_VentxAño
(@año int)
returns table
as
return
(Select c.nom_cliente+' '+c.ape_cliente as 'Cliente',v.nom_vendedor+' '+v.ape_vendedor 'Vendedor',f.nro_factura 'Nro_Factura'
from facturas f
inner join clientes c on c.cod_cliente=f.cod_cliente
inner join vendedores v on v.cod_vendedor=f.cod_vendedor
where convert(int,year(f.fecha)) = @año);

select * from dbo.fn_VentxAño(2021)



ALTER function fn_conversion 
(@pesos1 decimal(10,2),
@dolar2 decimal (10,2))
    returns decimal (10,2)
    as
    begin
        declare @equivalente decimal (10,2)
        SET @equivalente = @pesos1 / @dolar2
        return @equivalente
end;

select dbo.fn_conversion (50000,280);




CREATE function fn_conversion1 
(@importe decimal(10,2),
@dolarxpeso decimal (10,2),
@Tipoconv varchar(20) = '%')
    returns decimal (10,2)
    as
	if (@Tipoconv = 'pesos')
	begin
        declare @equivalente decimal (10,2)
        SET @equivalente = @importe * @dolarxpeso
        return @equivalente
    end
	else
	begin
        
        SET @equivalente = @importe / @dolarxpeso
        return @equivalente
    end;


select dbo.fn_conversion1 (50000,280,'pesos');




-- Tablas Temporales
create table ##T_TEMPORAL_GLOBAL
(COD_TABLA_TEMPORAL_BLOBAL INT,
 ESTUDIANTE VARCHAR(100),
 MATERIA VARCHAR(100));
 -- Ver una tabla temporal
 select*from tempdb.sys.objects
 order by name desc
 -- Crear una tabla temporal local
 create table #articulos(
cod_articulo int identity(1,1),
stock_minimo int,
stock int,
pre_unitario money,
observaciones varchar(125))



--1. Crear un procedimiento almacenado que devuelva la primera y la última venta en una sola tabla.



