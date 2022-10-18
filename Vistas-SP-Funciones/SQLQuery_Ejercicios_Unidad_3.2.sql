use LIBRERIALCII
go


--Ejercicio 1.2
--Parametros de entrada
Create Proc pa_articulos_precios
as
select * from articulos 
where pre_unitario < 100

exec pa_articulos_precios

Create Proc pa_articulos_precios2
@precio money
as
select * from articulos 
where pre_unitario < @precio

exec pa_articulos_precios2 '100';


Create Proc pa_articulos_precios3
@precio1 money,
@precio2 money
as
select * from articulos 
where pre_unitario between @precio1 and @precio2

exec pa_articulos_precios3 @precio1= 50,  @precio2 = 100

-- empleo de comodines como valor por defecto
create procedure pa_articulo_descripcion
@descripcion varchar (100) = '%'
as
select descripcion , pre_unitario, observaciones
from articulos
where descripcion like @descripcion;

exec pa_articulo_descripcion '%lápi%';



-- Parametros de salida

create proc pa_ventas_articulo
@codigo int,
@total decimal (10,2) output,
@precioprom decimal (6,2) output
as
select descripcion
from articulos
where cod_articulo = @codigo

select @total = sum(cantidad * pre_unitario)
from detalle_facturas
where cod_articulo = @codigo

select @precioprom = sum(pre_unitario)/ sum(cantidad)
from detalle_facturas
where cod_articulo = @codigo

declare @s decimal (12,2)
declare @p decimal (10,2)
exec pa_ventas_articulo 5, @s output,@p output
select @s 'total', @p 'Precio promedio ponderado' 

-- Procedimientos comn return



/*Inyecciòn de datos con SP*/

create procedure pa_articulos_ingreso
@descripcion nvarchar (50) null,
@stock_minimo smallint  null,
@stock smallint  null,
@pre_unitario decimal (10,2) null,
@observaciones nvarchar (50) = null-- valor por defecto
as
if (@pre_unitario is null)
return 0
else 
begin
insert into articulos
values (@descripcion, @stock_minimo,@stock,@pre_unitario,@observaciones)
return 1
end;

declare @retorno int
exec @retorno = pa_articulos_ingreso 'cartuchera', 80,50,1000.00,'marca acme'
select 'Ingreso realizado = 1' = @retorno


declare @retorno int
exec @retorno = pa_articulos_ingreso 'goma blanca', 30,55,60.00,'marca pindonga'
if @retorno = 1 
print 'Ingreso realizado = 1'
else 
select 'Ingreso no realizado'

sp_helptext pa_articulos_ingreso

alter procedure pa_articulos_ingreso

@descripcion nvarchar (50) null,
@stock_minimo smallint  null,
@stock smallint  null,
@pre_unitario decimal (10,2) null,
@observaciones nvarchar (50) = null-- valor por defecto
with encryption
as
if (@pre_unitario is null)
return 0
else 
begin
insert into articulos
values (@descripcion, @stock_minimo,@stock,@pre_unitario,@observaciones)
return 1
end;


/* Creacion de un Sp para insertar en una tabla o poblar una tabla*/

create proc pa_articulos_ofertas
as
select descripcion, pre_unitario, observaciones
from articulos
where pre_unitario < 100;

insert into ofertas exec pa_articulos_ofertas;

/* Procedimientos anidados*/

alter proc pa_multiplicar
@num1 int,
@num2 int,
@resultado int output
as
begin
set @resultado = @num1 * @num2
end;


alter proc pa_factorial
@numero int /*parametro de entrada*/
as 
declare @resultado int -- variables del sp 
declare @num int -- variables del sp 
set @resultado=1
set @num = @numero
While (@num > 1)
begin 
exec pa_multiplicar @resultado, @num, @resultado output /* me guarda el resutlado de la multiplñicacion en la variable resutlado*/
set @num=@num-1 /* condicion qyue se va reduciendo el numero*/
end 
select rtrim (convert(char,@numero))+' != ' + convert(char,@resultado);

exec pa_factorial @numero = 4

select @@nestlevel pa_multiplicar
select @@nestlevel pa_factorial
----------------------------------------------------------


--Ejercicio 1.a
/*Detalle_Ventas: liste la fecha, la factura, el vendedor, el cliente, el artículo,
cantidad e importe. Este SP recibirá como parámetros de E un rango de fechas.*/

Create Proc pa_Detalle_Ventas
--declare
@fecha1 datetime,
--declare
@fecha2 datetime
as
--set @fecha1 = '2021/01/01'
--set @fecha2 =  '2021/06/30'

select format(f.fecha,'dd/MM/yyyy')'FECHA'
, df.nro_factura 'NRO_FACTURA',f.cod_vendedor 'CODIGO_VENDEDOR'
,v.ape_vendedor+' '+v.nom_vendedor 'NOMBRE_VENDEDOR'
,c.ape_cliente+' '+c.nom_cliente 'NOMBRE_CLIENTE'
,a.descripcion 'ARTICULO'
,df.cantidad 'CANTIDAD'
,sum(df.pre_unitario * df.cantidad) 'IMPORTE'
from
detalle_facturas df
join facturas f on df.nro_factura= f.nro_factura
join vendedores v on f.cod_vendedor= v.cod_vendedor
join articulos a on df.cod_articulo= a.cod_articulo
join clientes c on f.cod_cliente= c.cod_cliente
where f.fecha between @fecha1 and @fecha2
group by  f.cod_vendedor,
v.ape_vendedor+' '+v.nom_vendedor,
df.nro_factura,
c.ape_cliente+' '+c.nom_cliente,
format(f.fecha,'dd/MM/yyyy'),
a.descripcion,
df.cantidad
 


exec pa_Detalle_Ventas @fecha1= '2021/01/01' ,  @fecha2 = '2021/06/30'



--Ejercicio 1.b
/*CantidadArt_Cli : este SP me debe devolver la cantidad de artículos o clientes (según se pida) que existen en la empresa.*/
create Proc pa_CantidadArt_Cli
@seleccion int,
@CantArt decimal (10,2) output,
@CantClien decimal (10,2) output
as
if @seleccion = 1
select @CantClien = count(cod_cliente)
from clientes
if @seleccion = 2
begin
select @CantArt = count(cod_articulo)
from articulos
end;

declare @a decimal (10,2)
declare @c decimal (10,2)
exec pa_CantidadArt_Cli 2, @a output,@c output
select @a 'Cantidad de Articulos'


--Ejercicio 1.c
/*INS_Vendedor: Cree un SP que le permita insertar registros en la tabla vendedores.*/
create procedure pa_INS_Vendedor
@nom_vendedor nvarchar (50) null,
@ape_vendedor nvarchar (50) null,
@calle nvarchar (50) null,
@altura smallint  null,
@cod_barrio int  null,
@nro_tel smallint  null,
@e_mail nvarchar (50)  null,
@fec_nac datetime  null
as
if (@ape_vendedor is null)
return 0
else 
begin
insert into vendedores
values (@nom_vendedor,
@ape_vendedor,
@calle,
@altura,
@cod_barrio,
@nro_tel,
@e_mail,
@fec_nac)
return 1
end;

exec pa_INS_Vendedor 'diego','guizzo','la voz',1522,2,3124,'dguizzo','06/07/1978' 


--Ejercicio 1.d
/*UPD_Vendedor: cree un SP que le permita modificar un vendedor cargado.*/

alter procedure pa_UPD_Vendedor
@e_mail nvarchar (50)  null,
@cod_vendedor int
as
if (@cod_vendedor is null)
return 0
else 
begin
update  vendedores
set  [e-mail] = @e_mail
where cod_vendedor = @cod_vendedor
return 1
end;
declare @retorno int;
exec @retorno = pa_UPD_Vendedor @e_mail = 'dguizzo@gmail.com', @cod_vendedor=7
if @retorno = 1 print 'Registro ingresado'
else
select 'Registro no ingresado'


select 'Actulizacion realizada=1' =
exec pa_INS_Vendedor 'diego','guizzo','la voz',1522,2,3124,'dguizzo','06/07/1978' 



/*Ejercicio 1.e DEL_Vendedor: cree un SP que le permita eliminar un vendedor ingresado.*/

alter procedure pa_DEL_Vendedor
@cod_vendedor int
as
if exists (select cod_vendedor from vendedores where cod_vendedor=@cod_vendedor)
begin
delete from vendedores where cod_vendedor = @cod_vendedor
return 1 print 'se elimino el vendedor'
end
else
return 0 print 'debe ingresar un codigo de vendedor existente'

declare @retorno int;
exec @retorno = pa_DEL_Vendedor @cod_vendedor=9
if @retorno = 1 print 'Registro ELIMINADO'
else
select 'Registro no eliminado'



use LIBRERIALCII
go



/* Ejercicio 2  Modifique el SP 1-a, permitiendo que los resultados del SP puedan 
filtrarse por una fecha determinada, por un rango de fechas y por un rango de vendedores; según se pida.  */

alter Proc pa_Detalle_Ventas
--declare
@fecha1 datetime null,
--declare
@fecha2 datetime null,
@fechaDet datetime null,
@cod_vendedor1 int null,
@cod_vendedor2 int null
as
--set @fecha1 = '2021/01/01'
--set @fecha2 =  '2021/06/30'
if (@fechaDet is null) and (@fecha1 is not null) and (@fecha2 is not null)
begin
select format(f.fecha,'dd/MM/yyyy')'FECHA'
, df.nro_factura 'NRO_FACTURA',f.cod_vendedor 'CODIGO_VENDEDOR'
,v.ape_vendedor+' '+v.nom_vendedor 'NOMBRE_VENDEDOR'
,c.ape_cliente+' '+c.nom_cliente 'NOMBRE_CLIENTE'
,a.descripcion 'ARTICULO'
,df.cantidad 'CANTIDAD'
,sum(df.pre_unitario * df.cantidad) 'IMPORTE'
from
detalle_facturas df
join facturas f on df.nro_factura= f.nro_factura
join vendedores v on f.cod_vendedor= v.cod_vendedor
join articulos a on df.cod_articulo= a.cod_articulo
join clientes c on f.cod_cliente= c.cod_cliente
where f.fecha between @fecha1 and @fecha2
and v.cod_vendedor between @cod_vendedor1 and @cod_vendedor2
group by  f.cod_vendedor,
v.ape_vendedor+' '+v.nom_vendedor,
df.nro_factura,
c.ape_cliente+' '+c.nom_cliente,
format(f.fecha,'dd/MM/yyyy'),
a.descripcion,
df.cantidad
end
else
if (@fecha1 is null and @fecha2 is null and @fechaDet is not null)
begin
select format(f.fecha,'dd/MM/yyyy')'FECHA'
, df.nro_factura 'NRO_FACTURA',f.cod_vendedor 'CODIGO_VENDEDOR'
,v.ape_vendedor+' '+v.nom_vendedor 'NOMBRE_VENDEDOR'
,c.ape_cliente+' '+c.nom_cliente 'NOMBRE_CLIENTE'
,a.descripcion 'ARTICULO'
,df.cantidad 'CANTIDAD'
,sum(df.pre_unitario * df.cantidad) 'IMPORTE'
from
detalle_facturas df
join facturas f on df.nro_factura= f.nro_factura
join vendedores v on f.cod_vendedor= v.cod_vendedor
join articulos a on df.cod_articulo= a.cod_articulo
join clientes c on f.cod_cliente= c.cod_cliente
where f.fecha = @fechaDet
and v.cod_vendedor between @cod_vendedor1 and @cod_vendedor2
group by  f.cod_vendedor,
v.ape_vendedor+' '+v.nom_vendedor,
df.nro_factura,
c.ape_cliente+' '+c.nom_cliente,
format(f.fecha,'dd/MM/yyyy'),
a.descripcion,
df.cantidad
end
else
return print 'debe ingresar una fecha'


exec pa_Detalle_Ventas @fecha1= '2021/01/01' ,  @fecha2 = '2021/06/30',@fechaDet=null, @cod_vendedor1 = 1, @cod_vendedor2=7



--Ejercicio 4.
/*Elimine los SP creados en el punto 1.*/

drop proc pa_Detalle_Ventas

--------------------------------------------------------------------------------------------

/*FUNCIONES*/


select * from sys.objects where type = 'fn'


-- Funcion escalar

create function f_promedio
(@valor1 decimal(4,2), -- parametros de entrada
@valor2 decimal(4,2))
returns decimal (6,2)
as
begin
declare @resultado decimal (6,2)
set @resultado = (@valor1+@valor2)/2
return @resultado
end;

select dbo.f_promedio(10.00,45.10)


create function f_nombreMes
(@fecha datetime='2021/01/01') 
returns varchar(10)
as
begin
declare @nombre varchar (10)
set @nombre = case datename(MONTH,@fecha) -- Devuelve el nombre del mes de la fecha
when 'january' then 'Enero'
when 'February' then 'Febrero'
when 'March' then 'Marzo'
when 'April' then 'Abril'
when 'May' then 'Mayo'
when 'June' then 'Junio'
when 'July' then 'Julio'
when 'August' then 'Agosto'
when 'September' then 'Septiembre'
when 'October' then 'Octubre'
when 'November' then 'Noviembre'
when 'December' then 'Diciembre'
end -- fin del case
return @nombre
end; -- fin del begin

select year(f.fecha) 'año',dbo.f_nombreMes(f.fecha) as 'mes de facturacion', max(pre_unitario*cantidad) 'ValorMaximo', min(pre_unitario*cantidad) 'ValorMinimo'
from facturas f
inner join detalle_facturas df on f.nro_factura = df.nro_factura
group by year(f.fecha),dbo.f_nombreMes(f.fecha)
order by 1,2

--Devuelve el valor del parametro por defecto
select dbo.f_nombreMes(default)
 

 -- Funciones de tablas de varias instrucciones

 create function f_ofertas
 (@minimo decimal (8,2))
 returns @ofertas table 
 (cod_articulo int,
 descripcion varchar (100),
 pre_unitario money,
 observaciones varchar(100))
 as
 begin
 insert @ofertas
 select cod_articulo,descripcion,pre_unitario,observaciones
 from articulos
 where pre_unitario < @minimo
 return -- devuelve una tabla
 end; -- fin del begin


 select * from articulos a
 inner join dbo.f_ofertas (60) as o on a.cod_articulo=o.cod_articulo

 -- Ver la tabla de la funcion

 select descripcion, pre_unitario
 from dbo.f_ofertas (60)


--Funciones con valores de tabla en linea.

Create function f_articulos
(@desc varchar (50) = 'Lapiz')
Returns TABLE
as
Return (select descripcion,stock_minimo from articulos
where descripcion like @desc+'%')

select * from f_articulos ('pa')

/*Ejercicio 5.a. Hora: una función que les devuelva la hora del sistema en el formato HH:MM:SS (tipo carácter de 8).*/

alter function f_hora_sistema
()
returns char (8)
as
begin
declare @horadev char(8) 
set @horadev = convert(char,concat(datepart(hour,getdate()),':',datepart(minute,getdate()),':',datepart(second,getdate())),8) -- Devuelve el nombre del mes de la fecha
return @horadev
end; -- fin del begin

select dbo.f_hora_sistema() 'Hora actual'

/*Ejercicio 5.b. Fecha: una función que devuelva la fecha en el formato AAAMMDD (en carácter de 8), 
a partir de una fecha que le ingresa como parámetro (ingresa como tipo fecha).*/

alter function f_fecha_AAAMMDD
(@fecha datetime = '2020/01/01')
returns char (8)
as
begin
declare @fecformt char(8) 
set @fecformt = convert(char,(concat(year(@fecha),month(@fecha),day(@fecha))),8) -- Devuelve el nombre del mes de la fecha
return @fecformt
end; -- fin del begin

select dbo.f_fecha_AAAMMDD('2022/10/08') 'Fecha'

/*Ejercicio 5.c. Dia_Habil: función que devuelve si un día es o no hábil (considere como días no hábiles los sábados y domingos). 
Debe devolver 1 (hábil), 0 (no hábil)*/

alter function f_dia_habil
(@fecha datetime='2021/01/01') 
returns int
as
begin
declare @dia int
set @dia = case datename(WEEKDAY,@fecha) -- Devuelve el nombre del dia de la semana
when 'Saturday' then 0
when 'Sanday' then 0
when 'Monday' then 1
when 'Tusday' then 1
when 'Wednesday' then 1
when 'Thursday' then 1
when 'Friday' then 1
end
-- fin del case
return @dia
end; -- fin del begin

select dbo.f_dia_habil('2022/10/17') 'Fecha'

select datename(WEEKDAY,'2022/10/17')

--8. Elimine las funciones creadas en el punto 1.

drop dbo.f_dia_habil