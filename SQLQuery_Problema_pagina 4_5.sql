
select det.cod_articulo,art.descripcion as Articulo,
		cast((avg(det.pre_unitario * det.cantidad)) as decimal(20,2)) as 'Promedio x Articulo', 
		sum(det.cantidad) as 'Cantidad Vendida', 
		format(min(fac.fecha),'dd/MM/yyyy') 'Fecha 1ª venta'
	from detalle_facturas det
	join facturas fac on fac.nro_factura = det.nro_factura
	join articulos art on art.cod_articulo = det.cod_articulo
	where det.cantidad between 5 and 20
	group by det.cod_articulo, art.descripcion
	having (avg(det.pre_unitario * det.cantidad)) > (select (avg(det1.pre_unitario * det1.cantidad))
														from detalle_facturas det1
														where det1.cod_articulo = det.cod_articulo
														)
