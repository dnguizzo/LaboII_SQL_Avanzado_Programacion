--Problema Vistas

--Ejercicio 1.

CREATE VIEW vista_clientes
as
select cod_cliente Cordigo,ape_cliente+' ' +nom_cliente Cliente, calle+ ' N° ' +trim(str(altura))+ ' B° ' +barrio Direccion
from
clientes c
join barrios b on c.cod_barrio= b.cod_barrio




--Ejercicio 2.

CREATE VIEW vista_vendedores
as
select format(f.fecha,'dd/MM/yyyy')'FECHA'
, df.nro_factura 'NRO_FACTURA',f.cod_vendedor 'CODIGO_VENDEDOR'
,v.ape_vendedor+' '+v.nom_vendedor 'NOMBRE_VENDEDOR'
,a.descripcion 'ARTICULO'
,df.cantidad 'CANTIDAD'
,sum(df.pre_unitario * df.cantidad) 'IMPORTE'
from
detalle_facturas df
join facturas f on df.nro_factura= f.nro_factura
join vendedores v on f.cod_vendedor= v.cod_vendedor
join articulos a on df.cod_articulo= a.cod_articulo
where year(f.fecha) = YEAR(GETDATE())
group by  f.cod_vendedor,
v.ape_vendedor+' '+v.nom_vendedor,
df.nro_factura,
format(f.fecha,'dd/MM/yyyy'),
a.descripcion,
df.cantidad

-- consultar listado de vistas creadas
select top 100 * from sys.objects where type = 'v'

--consultar text definido en una vista
sp_helptext vista_vendedores 

-- encriptar el text de una vista
ALTER VIEW vista_vendedores
With encryption
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



--Ejercicio 3.

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

--Ejercicio 4.

--a.
Select * from vista_vendedores vv
where importe < 120

--b.
Select * from vista_vendedores vv
where vv.NOMBRE_VENDEDOR like '%miranda%'

--c.
Select * from vista_vendedores vv
where importe < 50000

--Ejercicio 1.5.

drop view vista_vendedores

