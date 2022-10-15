/*
Legajo :  113842 
Alumno :  Ahumada Federico 

1)
Se necesita saber que impacto tuvieron las ventas a concesionarias en articulos mayores
o iguales a $10000 en la provincia de Córdoba en septiembre.
-Detallar el promedio, la cantidad de ventas y el monto facturado por empleado.
CONDICION: Mostrar los datos solicitados si el promedio de ventas  supera al 
promedio de venta del mes anterior.*/


CREATE VIEW VIS_IMPACTO_VTAS_SEPTIEMBRE_POR_EMPLEADO
AS
select e2.empleado'EMPLEADO', year(f.fecha_factura)'AÑO', month(f.fecha_factura)'MES', prov.provincia'PROVINCIA',
	convert(int,avg(d.cantidad*d.precio_unitario))'PROMEDIO FACTURACION', sum(d.cantidad*d.precio_unitario)
	'FACTURACION', count(f.id_factura)'CANT. VENTAS'

from pedidos p
join facturas f on p.id_factura = f.id_factura
join detalles d on p.id_pedido = d.id_pedido
join clientes c on p.id_cliente = c.id_cliente
join personas per on per.id_persona = c.id_persona
join barrios b on b.id_barrio = per.id_barrio
join ciudades ciu on ciu.id_ciudad = b.id_ciudad
join provincias prov on prov.id_provincia = ciu.id_provincia
join
	(select c.id_cliente
		from clientes c
		join tipo_clientes tc on tc.id_tipo_cliente = c.id_tipo_cliente
		where tc.tipo_cliente = 'concesionario'
	) as c2 on c2.id_cliente = c.id_cliente
join 
	(select e.id_empleado,upper(substring(p.nombre,1,1))+'.'+
		upper(substring(p.apellido,1,1))+lower(substring(p.apellido,2,100))'empleado'
		from empleados e
		join personas p on p.id_persona = e.id_persona
		join tipo_empleados te on te.id_tipo_empleado = e.id_tipo_empleado
		where te.tipo_empleado = 'empleado' 
		and id_empleado in (select id_empleado
								from pedidos
								where id_factura is not null
							)
	) as e2 on e2.id_empleado = p.id_empleado
where datediff(month,f.fecha_factura,getdate())<2 and d.id_factura is not null 
	 and prov.provincia = 'Córdoba'
group by e2.empleado, year(f.fecha_factura), month(f.fecha_factura),prov.provincia 
having avg(d.cantidad*d.precio_unitario)>=(select avg(d.cantidad*d.precio_unitario)
											from facturas f
											join detalles d on d.id_factura = f.id_factura
											where datediff(month,f.fecha_factura,getdate())=2)

-- EJECUCION DE LA VISTA
select * from dbo.VIS_IMPACTO_VTAS_SEPTIEMBRE_POR_EMPLEADO


/*
2)
Buscando implementar el email marketing, se requiere saber el listado 
de clientes con e-mail registrado en la base de datos que hayan hecho ordenes de compra
en los ultimos 30 dias. El equipo se contactará con ellos a fin de ofrecer cupones de
descuento en productos seleccionados.
Se aplicaran descuentos del 7% a consumidor final y del 13% a vendedores de autopartes.*/


CREATE VIEW VIS_ENCRYPT_EMAIL_MARKETING 
(tipo,cliente,provincia,ciudad,barrio,contacto,descuento)
WITH ENCRYPTION
AS
select c2.tcliente TIPO, upper(substring(p.nombre,1,1))+lower(substring(p.apellido,2,100))+' '+
		upper(substring(p.apellido,1,1))+lower(substring(p.apellido,2,100))CLIENTE, 
		prov.provincia PROVINCIA, ciu.ciudad CIUDAD, upper(substring(b.barrio,1,1))+
		lower(substring(b.barrio,2,100)) BARRIO, lower(tc.contacto) CONTACTO,'17%' DESCUENTO
from personas p
join clientes c on p.id_persona = c.id_persona
join tipo_clientes tc on tc.id_tipo_cliente = c.id_tipo_cliente
join barrios b on b.id_barrio = p.id_barrio
join ciudades ciu on ciu.id_ciudad = b.id_ciudad
join provincias prov on prov.id_provincia = ciu.id_provincia
join
	(select c.id_cliente, tc.tipo_cliente 'tcliente'
		from clientes c
		join tipo_clientes tc on tc.id_tipo_cliente = c.id_tipo_cliente
		where tc.tipo_cliente = 'consumidor final'
	) as c2 on c2.id_cliente = c.id_cliente
where c.id_cliente in (select id_cliente
								from pedidos pe
								join facturas f on pe.id_factura = f.id_factura
								where datediff(day,f.fecha_factura,getdate())<=30
							)
	and tc.contacto LIKE '%@%' and tc.contacto is not null

union

select c2.tcliente, upper(substring(p.nombre,1,1))+lower(substring(p.apellido,2,100))+' '+
		upper(substring(p.apellido,1,1))+lower(substring(p.apellido,2,100)), 
		prov.provincia, ciu.ciudad, upper(substring(b.barrio,1,1))+
		lower(substring(b.barrio,2,100)), lower(tc.contacto),'13%'
from personas p
join clientes c on p.id_persona = c.id_persona
join tipo_clientes tc on tc.id_tipo_cliente = c.id_tipo_cliente
join barrios b on b.id_barrio = p.id_barrio
join ciudades ciu on ciu.id_ciudad = b.id_ciudad
join provincias prov on prov.id_provincia = ciu.id_provincia
join
	(select c.id_cliente, tc2.tipo_cliente 'tcliente'
		from clientes c
		join tipo_clientes tc2 on tc2.id_tipo_cliente = c.id_tipo_cliente
		where tc2.tipo_cliente = 'autopartes'
	) as c2 on c2.id_cliente = c.id_cliente
where c.id_cliente in (select id_cliente
								from pedidos pe
								join facturas f on pe.id_factura = f.id_factura
								where datediff(day,f.fecha_factura,getdate())<=30
							)
	and tc.contacto LIKE '%@%' and tc.contacto is not null

-- EJECUCION DE LA VISTA
select * from dbo.VIS_ENCRYPT_EMAIL_MARKETING
