use LIBRERIA_2
select * from articulos
select * from barrios
select * from clientes
select * from detalle_facturas
select * from facturas
select * from vendedores

SET DATEFORMAT DMY

select CONVERT(nvarchar(10),GETDATE(),103)
select convert(nvarchar(10),getdate(),103)
--select convert(nvarchar(10),fecha,103)


--la referencia externa del having tiene que pertenecer al group by
--listar importe total facturado por año solo aquellos cuyo promedio sea
--menor al importe promedio los últimos dos años


select year(fecha) as año,sum(cantidad*pre_unitario) as 'importe total'
from facturas f 
join detalle_facturas d on f.nro_factura=d.nro_factura
group by year(fecha)
having sum(cantidad*pre_unitario)/count(distinct f.nro_factura)<
							(select sum(cantidad*pre_unitario)/count(distinct f.nro_factura)
							from detalle_facturas
							where year(fecha) between year(getdate()) and year(getdate())-1
							)


--listar importe total facturado por vendedor, por año solo aquellos cuyo promedio de venta
--sea menor al importe promedio general de ese año

select year(fecha) as año,ape_vendedor,sum(cantidad*pre_unitario) as 'importe total'
	from facturas f join detalle_facturas d on f.nro_factura=d.nro_factura
	join vendedores v on f.cod_vendedor=v.cod_vendedor
	group by year(fecha),ape_vendedor
	having sum(cantidad*pre_unitario)/count(distinct f.nro_factura)<
								(select sum(cantidad*pre_unitario)/count(distinct f.nro_factura)
									from facturas f1 
									join detalle_facturas d1 on f1.nro_factura = d1.nro_factura
									where year(f1.fecha) = year(f.fecha)
									)

--1. Se quiere saber ¿cuándo realizó su primer venta cada vendedor? y
--¿cuánto fue el importe total de las ventas que ha realizado? Mostrar
--estos datos en un listado solo para los casos en que su importe
--promedio de vendido sea superior al importe promedio general (importe
--promedio de todas las facturas).

SELECT v.ape_vendedor + ', ' + v.nom_vendedor AS 'Vendedor'
		,convert(DATE, min(f.fecha)) AS 'Primer venta'
		,sum(df.cantidad * df.pre_unitario) AS 'Importe total'
	FROM vendedores v
	INNER JOIN facturas f ON f.cod_vendedor = v.cod_vendedor
	INNER JOIN detalle_facturas df ON df.nro_factura = f.nro_factura
	GROUP BY v.ape_vendedor + ', ' + v.nom_vendedor
	HAVING sum(df.cantidad * df.pre_unitario) / 
			count(DISTINCT df.nro_factura) > (SELECT sum(d.cantidad * d.pre_unitario) / count(DISTINCT d.nro_factura)
												FROM detalle_facturas d
												)


--2 Liste los montos totales mensuales facturados por cliente y además del
--promedio de ese monto y el promedio de precio de artículos Todos esto
--datos correspondientes a período que va desde el 1° de febrero al 30 de
--agosto del 2016. Sólo muestre los datos si esos montos totales son
--superiores o iguales al promedio global.
set dateformat dmy

select c.cod_cliente,ape_cliente 'apellido', year(fecha) 'anio', MONTH(fecha) 'mes',
		sum(cantidad*pre_unitario)'total de ventas del mes',
		sum(cantidad*pre_unitario)/count(distinct f.nro_factura)'promedio importe',
		avg(pre_unitario) 'promedio precio unitario'
	from facturas f join detalle_facturas df on df.nro_factura=f.nro_factura
	join clientes c on c.cod_cliente=f.cod_cliente
	where f.fecha between '01/02/2014' and '30/08/2016'
	group by c.cod_cliente,ape_cliente, year(fecha) ,MONTH(fecha)
	having sum(cantidad*pre_unitario) >= (select sum(pre_unitario*cantidad)/count(distinct nro_factura)
											from detalle_facturas df2)


--3. Por  cada  artículo  que  se  tiene  a  la  venta,  se  quiere  saber  el  importe
--promedio vendido, la cantidad total vendida  por artículo, para los casos
--en que los números de factura no sean uno de los siguientes: 2, 10, 7, 13,
--22  y  que  ese  importe  promedio  sea  inferior  al  importe  promedio  de  ese
--artículo.  

select art.descripcion as Articulo,
		cast((avg(det.pre_unitario * det.cantidad)) as decimal(20,2)) as 'Promedio x Articulo', 
		sum(det.cantidad) as 'Cantidad Vendida'
	from detalle_facturas det
	join facturas fac on fac.nro_factura = det.nro_factura
	join articulos art on art.cod_articulo = det.cod_articulo
	where fac.nro_factura not in (2, 10, 7, 13, 22)
	group by det.cod_articulo, art.descripcion
	having (avg(det.pre_unitario * det.cantidad)) < (select (avg(deta.pre_unitario * deta.cantidad))
														from detalle_facturas deta
														where deta.cod_articulo = det.cod_articulo
														)



--ver los otros en el foro

