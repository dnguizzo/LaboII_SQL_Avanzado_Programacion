--Ejercicio 1.3.

ALTER VIEW vista_vendedores
as
select format(f.fecha,'dd/MM/yyyy')'FECHA'
, df.nro_factura 'NRO_FACTURA',f.cod_vendedor 'CODIGO_VENDEDOR'
,v.ape_vendedor+' '+v.nom_vendedor 'NOMBRE_VENDEDOR'
,v.calle+ ' N° ' +trim(str(v.altura))+ ' B° ' +b.barrio 'DIRECICON'
,a.descripcion 'ARTICULO'
,df.cantidad 'CANTIDAD'
,sum(df.pre_unitario * df.cantidad) 'IMPORTE'
from
detalle_facturas df
join facturas f on df.nro_factura= f.nro_factura
join vendedores v on f.cod_vendedor= v.cod_vendedor
join articulos a on df.cod_articulo= a.cod_articulo
join barrios b on v.cod_barrio = b.cod_barrio
where year(f.fecha) = YEAR(GETDATE())
AND MONTH(F.FECHA) = MONTH(GETDATE()) - 1
group by  f.cod_vendedor,
v.ape_vendedor+' '+v.nom_vendedor,
df.nro_factura,
format(f.fecha,'dd/MM/yyyy'),
a.descripcion,
df.cantidad




--Ejercicio 1.2.1.a
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



--Ejercicio 1.2.1.b
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


--Ejercicio 1.2.1.c

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


--Ejercicio 1.2.1.d


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