use AUTOMOTRIZ2
GO

-- Este SP permite determinar la cantidad de clientes o de articulos dados de alta en la empresa automotriz
--segùn se indique en el parámetro de salida a los findes de evaluar las polìticas de expansión de ventas y/o 
-- incremento en la variedad de productos vendidos.

create Proc pa_CantidadArt_Cli
@seleccion int,
@CantArt decimal (10,2) output,
@CantClien decimal (10,2) output
as
if @seleccion = 1
select @CantClien = count(id_cliente)
from clientes
if @seleccion = 2
begin
select @CantArt = count(id_producto)
from PRODUCTOS
end;

declare @a decimal (10,2)
declare @c decimal (10,2)
exec pa_CantidadArt_Cli 2, @a output,@c output
select @a 'Cantidad de Productos'


-- A los efcetos de evaluar el objetivo de ventas por volumen e importe y determniación de Bono para empleados anual en funcion de su histórico de pedidos, se necesita determinar una consulta que verifique
-- aquellos empleados cuyo promedio de pedidos sea mayor al promedio de pedidos general de este año. 

select year(fecha_pedido) as 'Año',pf.apellido 'Apellido',sum(cantidad*precio_unitario) as 'Importe total'
	from PEDIDOS P join DETALLES dp on p.id_pedido=dp.id_pedido
	join empleados e on p.id_empleado=e.id_empleado
	join PERSONAS pf on e.id_empleado = pf.id_persona
	group by year(fecha_pedido),pf.apellido
	having sum(cantidad*precio_unitario)/count(distinct p.id_pedido)<
								(select sum(cantidad*precio_unitario)/count(distinct p.id_pedido)
									from PEDIDOS p1 
									join DETALLES dp1 on p1.id_pedido = dp1.id_pedido
									where year(p1.fecha_pedido) = year(p.fecha_pedido)
									)

-- La gente de Finanzas necesita llevar un control de las distintas formas de cobro de las ventas realizadas para evaluar posibles inversiones de efectivo
-- a lo largo del año, para ello require una vista que le permita obtener la información: 

CREATE VIEW vista_inv_efectivo
as
select format(p.fecha_pedido,'dd/MM/yyyy')'FECHA'
, dp.id_pedido 'NRO_PEDIDO',m.id_metodo_pago 'CODIGO_METODO_PAGO'
,m.metodo_pago 'METODO_DE_PAGO'
,sum(dp.precio_unitario * dp.cantidad) 'IMPORTE'
from
detalles dp
join PEDIDOS p on dp.id_pedido= p.id_pedido
join FACTURAS f on p.id_factura= f.id_factura
join METODO_PAGOS m on f.id_metodo_pago = m.id_metodo_pago
where year(p.fecha_pedido) = YEAR(GETDATE())
group by  m.id_metodo_pago,
m.metodo_pago,
dp.id_pedido,
format(p.fecha_pedido,'dd/MM/yyyy')

select * from vista_inv_efectivo
