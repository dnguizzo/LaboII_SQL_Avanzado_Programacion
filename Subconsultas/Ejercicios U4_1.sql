--1. Se solicita un listado de artículos cuyo precio es inferior al promedio de precios de todos los artículos.
--(está resuelto en el material teórico)


select * from articulos
where pre_unitario > (select avg(pre_unitario) from articulos)


--2. Emitir un listado de los artículos que no fueron vendidos este año. 
--En ese listado solo incluir aquellos cuyo precio unitario del artículo oscile entre 50 y 100.

select descripcion as 'Artículo',year(fecha) as 'Año'
	from articulos a
	join detalle_facturas d on a.cod_articulo = d.cod_articulo
	join facturas f on d.nro_factura = f.nro_factura
	where year(fecha) != year(getdate())
	and a.pre_unitario IN (select pre_unitario
							from articulos
							where pre_unitario between 50 and 100
							)
--3. Genere un reporte con los clientes que vinieron más de 2 veces el año pasado.


select c.nom_cliente, c.ape_cliente as Cliente
from clientes c
where 2 < (select count(f.nro_factura) 
			from facturas f   
			where year(getdate())-1 = year(f.fecha)
			and f.cod_cliente = c.cod_cliente)                                  

--otra forma
select c.nom_cliente+' '+c.ape_cliente from clientes c
where c.cod_cliente in (
	select f.cod_cliente
	from facturas f
	where year(f.fecha) = year(dateadd(year, -1, getdate()))
	group by f.cod_cliente
	having count(f.nro_factura) > 2)

	--4. Se quiere saber qué clientes no vinieron entre el 12/12/2015 y el 13/7/2020

set dateformat dmy
	select nom_cliente+' '+ape_cliente 
	from clientes 	
	where cod_cliente NOT IN (select cod_cliente
								from facturas 
								where fecha between '2/12/2010' and '13/07/2015')

--5. Listar los datos de las facturas de los clientes que solo vienen a comprar en febrero
--es decir que todas las veces que vienen a comprar haya sido en el mes de febrero (y no otro mes).

select nro_factura as 'Nº Fc', convert(nvarchar(10),fecha,103) as 'Fecha',
		nom_cliente+', '+ape_cliente as 'Cliente'
	from facturas f
	join clientes c on f.cod_cliente = c.cod_cliente
	where 2 = ALL (select month(f.fecha)
					from facturas f
					where f.cod_cliente = c.cod_cliente) -- REF EXTERNA

--6. Mostrar los datos de las facturas para los casos en que por año se hayan hecho menos de 9 facturas.

select nro_factura, fecha
	from facturas f
	where 9 > (select count(nro_factura)
				from facturas
				where year(fecha) = year(f.fecha) -- REF EXTERNA
				)
--otra forma
select f.nro_factura as 'Factura', convert(date, f.fecha) as 'Fecha'	from facturas f	where year(f.fecha) in (select year(fecha) 							from facturas f							group by year(f.fecha)							having count(f.nro_factura) < 9)

--7. Emitir un reporte con las facturas cuyo importe total haya sido superior a 1.500 (incluir en el reporte los datos de los artículos vendidos y los importes).

select df.nro_factura,a.descripcion, df.pre_unitario*cantidad as 'Importe'
from facturas f
join detalle_facturas df on f.nro_factura = df.nro_factura
join articulos a on a.cod_articulo = df.cod_articulo
where 1500 < ANY (select sum(pre_unitario*cantidad)
				from detalle_facturas d
				where d.nro_factura = f.nro_factura
				)

--8. Se quiere saber qué vendedores nunca atendieron a estos clientes: 1 y 6. Muestre solamente el nombre del vendedor.

select v.nom_vendedor as Nombre
from vendedores v
where cod_vendedor not in ( select cod_vendedor
							from facturas f
							where f.cod_cliente in (1,6)
							)

--9. Listar los datos de los artículos que superaron el promedio del Importe de ventas de $ 1.000.

select a.descripcion, a.pre_unitario
from articulos a
where 1000 < (select sum(pre_unitario*cantidad)/count(distinct nro_factura)
				from detalle_facturas d
				where d.cod_articulo = a.cod_articulo
				)
--10. ¿Qué artículos nunca se vendieron? Tenga además en cuenta que su nombre comience con letras que van de la “d” a la “p”. 
--Muestre solamente la descripción del artículo.

select a.descripcion 'Articulo'
from articulos a
where a.cod_articulo not in (select cod_articulo
								from detalle_facturas df
								)
and a.descripcion like '[d-p]%'

--11. Listar número de factura, fecha y cliente para los casos en que ese cliente haya sido atendido alguna vez por el vendedor de código 3.

select f.nro_factura, f.fecha, c.ape_cliente
from facturas f
join clientes c on f.cod_cliente = c.cod_cliente
where 3 = any (select cod_vendedor 
				from facturas fa
				where fa.cod_cliente = c.cod_cliente
				)
--12. Listar número de factura, fecha, artículo, cantidad e importe para los casos en que todas las cantidades
--(de unidades vendidas de cada artículo) de esa factura sean superiores a 40.


select f.nro_factura,convert(date,f.fecha) 'Fecha', a.descripcion,
		det.cantidad, det.cantidad * det.pre_unitario Importe
	from facturas f
	join detalle_facturas det on f.nro_factura = det.nro_factura
	join articulos a on det.cod_articulo = a.cod_articulo
	where 40 < all (select d.cantidad 
						from detalle_facturas d  --devuelve falso si no hay valores mayores a 40 en al menos uno de los detalles
						where d.nro_factura = f.nro_factura  --referencia externa compara el 4 con cada f.nro_factura
						)
--13. Emitir un listado que muestre número de factura, fecha, artículo, cantidad e importe;
--para los casos en que la cantidad total de unidades vendidas sean superior a 80.

select F.nro_factura 'Nro Factura', f.fecha 'Fecha', a.descripcion 'Articulo', 
		df.cantidad 'Cantidad', df.pre_unitario * df.cantidad 'Importe'
from facturas f
inner join detalle_facturas df on f.nro_factura = df.nro_factura
inner join articulos a on a.cod_articulo = df.cod_articulo
where 80 < (select SUM(df1.cantidad)
			from detalle_facturas df1
			where df.nro_factura = df1.nro_factura
			)

--14. Realizar un listado de número de factura, fecha, cliente, artículo e importe para los casos en que al menos uno de los importes
--de esa factura sea menor a 3.000.

SELECT f.nro_factura, f.fecha, c.ape_cliente +', '+c.nom_cliente AS 'Cliente',
		a.descripcion, cantidad*df.pre_unitario AS 'Importe'
FROM facturas f
JOIN clientes c ON c.cod_cliente=f.cod_cliente
JOIN detalle_facturas df ON df.nro_factura=f.nro_factura
JOIN articulos a ON df.cod_articulo=a.cod_articulo
WHERE 3000 > ANY (SELECT cantidad*pre_unitario AS 'Importe'
					FROM detalle_facturas
					WHERE nro_factura= f.nro_factura
					)
