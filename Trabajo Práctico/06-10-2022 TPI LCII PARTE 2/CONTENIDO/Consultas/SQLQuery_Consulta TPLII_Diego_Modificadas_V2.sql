use AUTOMOTRIZ2
GO




/*El Area de Finanzas necesita llevar un control de las distintas
formas de cobro de las ventas realizadas para evaluar posibles inversiones
de efectivo a lo largo del año,mes por mes, para ello require una vista que
le permita obtener la información de los productos mas vendidos
en efectivo y su conversion en dolares al TC $ 300 por dolar*/

ALTER VIEW vista_inv_efectivo
as
select year(p.fecha_pedido) 'AÑO'
,MONTH(p.fecha_pedido) 'MES'
,ma.marca 'MARCA'
,UPPER(SUBSTRING(pr.descripcion,1,1))+LOWER(SUBSTRING(pr.descripcion,2,LEN(pr.descripcion)-1)) 'PRODUCTOS'
,m.metodo_pago 'METODO_DE_PAGO'
,round(convert(money,sum(dp.precio_unitario * dp.cantidad)),2) 'IMPORTE'
,(case m.metodo_pago when 'efectivo' then round(convert(money,sum(dp.precio_unitario * dp.cantidad)/ 300,1),2) else round(0,2) end) 'DOLARES A COMPRAR'   
from
detalles dp
join PEDIDOS p on dp.id_pedido= p.id_pedido
join FACTURAS f on p.id_factura= f.id_factura
join METODO_PAGOS m on f.id_metodo_pago = m.id_metodo_pago
join PRODUCTOS pr on pr.id_producto = dp.id_producto
join MARCAS ma on pr.id_marca = ma.id_marca
where year(p.fecha_pedido) = YEAR(GETDATE())
group by  year(p.fecha_pedido)
,MONTH(p.fecha_pedido)
,m.metodo_pago
,ma.marca
,UPPER(SUBSTRING(pr.descripcion,1,1))+LOWER(SUBSTRING(pr.descripcion,2,len(pr.descripcion)-1))


select * from vista_inv_efectivo

/* creación de SP consulta 1*/

Create procedure SP_GUIZZO_1
as
select * from vista_inv_efectivo vv

/*************************************************************************************************************************/


/* El Area de RRHH y Comercializaciònd, a los efcetos de evaluar
el objetivo de ventas por volumen e importe y 
determniación de Bono para empleados anual en funcion
de su histórico de pedidos, se necesita determinar una consulta que verifique
aquellos empleados cuyo promedio de pedidos sea mayor al promedio de pedidos
general de este año, la cantidad total de unidades vendidas,
y determinar el importe del bono como un % del promedio ponderado
de acuerdo a una escala 15% para importes superiores a $1000.000 y el resto 10%,
y siempre que en los ultimos 6 meses haya vendido al menos una unidad.*/

select year(fecha_pedido) as 'Año',pf.apellido 'Apellido'
,sum(cantidad*precio_unitario) as 'Importe total'
, count (cantidad) as 'Unidades Vendidas'
, round(convert(money,avg (cantidad*precio_unitario)),2) as 'Promedio'
, iif(sum(cantidad*precio_unitario) > 1000000, 0.15, 0.10) 'Porcentaje del Bono'
,round(convert(money,(avg (cantidad*precio_unitario) * iif(sum(cantidad*precio_unitario) > 1000000, 0.15, 0.10))),2) 'Importe del Bono'
	from PEDIDOS P join DETALLES dp on p.id_pedido=dp.id_pedido
	join empleados e on p.id_empleado=e.id_empleado
	join PERSONAS pf on e.id_empleado = pf.id_persona
	Where exists ( select p1.id_empleado
	               from detalles dp1
				   inner join PEDIDOS p1 on p1.id_pedido=dp1.id_pedido
	               inner join FACTURAS f on f.id_factura=dp1.id_factura
				   where year(f.fecha_factura) = year(getdate())
				   and datediff(month,f.fecha_factura,getdate())< 6)	                      
	group by year(fecha_pedido),pf.apellido
	having sum(cantidad*precio_unitario)/count(distinct p.id_pedido)<
								(select sum(cantidad*precio_unitario)/count(distinct p.id_pedido)
									from PEDIDOS p1 
									join DETALLES dp1 on p1.id_pedido = dp1.id_pedido
									where year(p1.fecha_pedido) = year(p.fecha_pedido))

							
/* creación de SP consulta 2*/	
CREATE PROC SP_GUIZZO_2
AS
select year(fecha_pedido) as 'Año',pf.apellido 'Apellido'
,sum(cantidad*precio_unitario) as 'Importe total'
, count (cantidad) as 'Unidades Vendidas'
, round(convert(money,avg (cantidad*precio_unitario)),2) as 'Promedio'
, iif(sum(cantidad*precio_unitario) > 1000000, 0.15, 0.10) 'Porcentaje del Bono'
,round(convert(money,(avg (cantidad*precio_unitario) * iif(sum(cantidad*precio_unitario) > 1000000, 0.15, 0.10))),2) 'Importe del Bono'
	from PEDIDOS P join DETALLES dp on p.id_pedido=dp.id_pedido
	join empleados e on p.id_empleado=e.id_empleado
	join PERSONAS pf on e.id_empleado = pf.id_persona
	Where exists ( select p1.id_empleado
	               from detalles dp1
				   inner join PEDIDOS p1 on p1.id_pedido=dp1.id_pedido
	               inner join FACTURAS f on f.id_factura=dp1.id_factura
				   where year(f.fecha_factura) = year(getdate())
				   and datediff(month,f.fecha_factura,getdate())< 6)	                      
	group by year(fecha_pedido),pf.apellido
	having sum(cantidad*precio_unitario)/count(distinct p.id_pedido)<
								(select sum(cantidad*precio_unitario)/count(distinct p.id_pedido)
									from PEDIDOS p1 
									join DETALLES dp1 on p1.id_pedido = dp1.id_pedido
									where year(p1.fecha_pedido) = year(p.fecha_pedido))


EXEC SP_GUIZZO_2

