--Mostrar el promedio de facturacion por vendedor en lo que va del mes junto con el nombre y el ID --del empleado que les corresponda, Siempre y cuando:--1) El apellido del empleado empiece con letras entre "A" y "L"--2) El promedio debe ser mayor al promedio de facturacion por vendedor del mes anteriorSELECT	e.id_empleado as 'ID EMPLEADO', pers.apellido + ', ' + pers.nombre as 'NOMBRE EMPLEADO',		AVG(d.cantidad*d.precio_unitario) as 'PROM. FACTURADO ESTE MES'FROM DETALLES d join PRODUCTOS p on d.id_producto=p.id_producto
     join FACTURAS f on f.id_factura=d.id_detalle join PEDIDOS ped on ped.id_factura = f.id_factura
	 join EMPLEADOS e on e.id_empleado=ped.id_empleado join PERSONAS pers on 
	 pers.id_persona = e.id_personaWHERE	pers.apellido like '[A-L]%' and YEAR(f.id_factura) = YEAR(GETDATE())		and MONTH(f.id_factura) = MONTH(GETDATE())GROUP BY e.id_empleado, pers.apellido + ', ' + pers.nombreHAVING AVG(d.cantidad*d.precio_unitario) >	( SELECT AVG(d.cantidad*d.precio_unitario)											  FROM DETALLES d											  WHERE YEAR(d.id_factura) = YEAR(GETDATE()) and 													MONTH(d.id_factura) = MONTH(GETDATE())-1											)--Listar en una misma tabla de resultados:
--valor promedio de todos los productos filtrados por su descripcion 
--(Solo de los prodcutos que valen mas de $1300, que estén en stock y sean modelos de los ultimo 10 años.)
--Valor total de todos los productos filtrados por su descripcion, que estén en stock 
--y sean modelos de los ultimo 10 años
--De cada uno de los productos, el precio mínimo histórico al cual se vendieron
--De cada uno de los productos, el precio máximo histórico al cual se vendieron



SELECT	p.descripcion as 'DESCRIPCIÓN',
	   (SELECT MIN(d.precio_unitario) 
		FROM PRODUCTOS p JOIN DETALLES d ON d.id_producto=p.id_producto
		WHERE p.descripcion like 'baul') as 'PRECIO MINIMO HIST.',
	   (SELECT MAX(d.precio_unitario) 
		FROM PRODUCTOS p JOIN DETALLES d ON d.id_producto=p.id_producto
		WHERE p.descripcion like 'baul') as 'PRECIO MÁXIMO HIST.',
		SUM(p.precio_vta) as 'VALOR TOTAL',
	   (SELECT	AVG(precio_vta)
	    FROM PRODUCTOS 
		WHERE descripcion like 'baul' and precio_vta >= 1300 and stock != 0 
		and (anio between YEAR(GETDATE())-10 and YEAR(GETDATE()))) as 'VALOR PROMEDIO'
FROM PRODUCTOS p
WHERE	descripcion like 'baul' and precio_vta >= 1000 and stock != 0 
		and (anio between YEAR(GETDATE())-10 and YEAR(GETDATE()))
GROUP BY descripcion 

	UNION	

SELECT	p.descripcion as 'DESCRIPCIÓN',
	   (SELECT MIN(d.precio_unitario) 
		FROM PRODUCTOS p JOIN DETALLES d ON d.id_producto=p.id_producto
		WHERE p.descripcion like 'capot') as 'PRECIO MINIMO',
	   (SELECT MAX(d.precio_unitario) 
		FROM PRODUCTOS p JOIN DETALLES d ON d.id_producto=p.id_producto
		WHERE p.descripcion like 'capot') as 'PRECIO MÁXIMO',
		SUM(p.precio_vta) as 'VALOR TOTAL',
	   (SELECT	AVG(precio_vta)
	    FROM PRODUCTOS 
		WHERE descripcion like 'capot' and precio_vta >= 1300 and stock != 0 
		and (anio between YEAR(GETDATE())-10 and YEAR(GETDATE()))) as 'VALOR PROMEDIO'
FROM PRODUCTOS p
WHERE	descripcion like 'capot' and precio_vta >= 1000 and stock != 0 
		and (anio between YEAR(GETDATE())-10 and YEAR(GETDATE()))
GROUP BY descripcion 

	UNION

SELECT	p.descripcion as 'DESCRIPCIÓN',
	   (SELECT MIN(d.precio_unitario) 
		FROM PRODUCTOS p JOIN DETALLES d ON d.id_producto=p.id_producto
		WHERE p.descripcion like 'carroceria') as 'PRECIO MINIMO HIST.',
	   (SELECT MAX(d.precio_unitario) 
		FROM PRODUCTOS p JOIN DETALLES d ON d.id_producto=p.id_producto
		WHERE p.descripcion like 'carroceria') as 'PRECIO MÁXIMO HIST.',
		SUM(p.precio_vta) as 'VALOR TOTAL',
	   (SELECT	AVG(precio_vta)
	    FROM PRODUCTOS 
		WHERE descripcion like 'carroceria' and precio_vta >= 1300 and stock != 0 
		and (anio between YEAR(GETDATE())-10 and YEAR(GETDATE()))) as 'VALOR PROMEDIO'
FROM PRODUCTOS p
WHERE	descripcion like 'carroceria' and precio_vta >= 1000 and stock != 0 
		and (anio between YEAR(GETDATE())-10 and YEAR(GETDATE()))
GROUP BY descripcion 

	UNION	
	
SELECT	p.descripcion as 'DESCRIPCIÓN',
	   (SELECT MIN(d.precio_unitario) 
		FROM PRODUCTOS p JOIN DETALLES d ON d.id_producto=p.id_producto
		WHERE p.descripcion like 'freno') as 'PRECIO MINIMO HIST.',
	   (SELECT MAX(d.precio_unitario) 
		FROM PRODUCTOS p JOIN DETALLES d ON d.id_producto=p.id_producto
		WHERE p.descripcion like 'freno') as 'PRECIO MÁXIMO HIST.',
		SUM(p.precio_vta) as 'VALOR TOTAL',
	   (SELECT	AVG(precio_vta)
	    FROM PRODUCTOS 
		WHERE descripcion like 'freno' and precio_vta >= 1300 and stock != 0 
		and (anio between YEAR(GETDATE())-10 and YEAR(GETDATE()))) as 'VALOR PROMEDIO'
FROM PRODUCTOS p
WHERE	descripcion like 'freno' and precio_vta >= 1000 and stock != 0 
		and (anio between YEAR(GETDATE())-10 and YEAR(GETDATE()))
GROUP BY descripcion 

	UNION	
	
SELECT	p.descripcion as 'DESCRIPCIÓN',
	   (SELECT MIN(d.precio_unitario) 
		FROM PRODUCTOS p JOIN DETALLES d ON d.id_producto=p.id_producto
		WHERE p.descripcion like 'luneta') as 'PRECIO MINIMO HIST.',
	   (SELECT MAX(d.precio_unitario) 
		FROM PRODUCTOS p JOIN DETALLES d ON d.id_producto=p.id_producto
		WHERE p.descripcion like 'luneta') as 'PRECIO MÁXIMO HIST.',
		SUM(p.precio_vta) as 'VALOR TOTAL',
	   (SELECT	AVG(precio_vta)
	    FROM PRODUCTOS 
		WHERE descripcion like 'luneta' and precio_vta >= 1300 and stock != 0 
		and (anio between YEAR(GETDATE())-10 and YEAR(GETDATE()))) as 'VALOR PROMEDIO'
FROM PRODUCTOS p
WHERE	descripcion like 'luneta' and precio_vta >= 1000 and stock != 0 
		and (anio between YEAR(GETDATE())-10 and YEAR(GETDATE()))
GROUP BY descripcion 

	UNION	
	
SELECT	p.descripcion as 'DESCRIPCIÓN',
	   (SELECT MIN(d.precio_unitario) 
		FROM PRODUCTOS p JOIN DETALLES d ON d.id_producto=p.id_producto
		WHERE p.descripcion like 'motor') as 'PRECIO MINIMO HIST.',
	   (SELECT MAX(d.precio_unitario) 
		FROM PRODUCTOS p JOIN DETALLES d ON d.id_producto=p.id_producto
		WHERE p.descripcion like 'motor') as 'PRECIO MÁXIMO HIST.',
		SUM(p.precio_vta) as 'VALOR TOTAL',
	   (SELECT	AVG(precio_vta)
	    FROM PRODUCTOS 
		WHERE descripcion like 'motor' and precio_vta >= 1300 and stock != 0 
		and (anio between YEAR(GETDATE())-10 and YEAR(GETDATE()))) as 'VALOR PROMEDIO'
FROM PRODUCTOS p
WHERE	descripcion like 'motor' and precio_vta >= 1000 and stock != 0 
		and (anio between YEAR(GETDATE())-10 and YEAR(GETDATE()))
GROUP BY descripcion 

	UNION	
	
SELECT	p.descripcion as 'DESCRIPCIÓN',
	   (SELECT MIN(d.precio_unitario) 
		FROM PRODUCTOS p JOIN DETALLES d ON d.id_producto=p.id_producto
		WHERE p.descripcion like 'puerta') as 'PRECIO MINIMO HIST.',
	   (SELECT MAX(d.precio_unitario) 
		FROM PRODUCTOS p JOIN DETALLES d ON d.id_producto=p.id_producto
		WHERE p.descripcion like 'puerta') as 'PRECIO MÁXIMO HIST.',
		SUM(p.precio_vta) as 'VALOR TOTAL',
	   (SELECT	AVG(precio_vta)
	    FROM PRODUCTOS 
		WHERE descripcion like 'puerta' and precio_vta >= 1300 and stock != 0 
		and (anio between YEAR(GETDATE())-10 and YEAR(GETDATE()))) as 'VALOR PROMEDIO'
FROM PRODUCTOS p
WHERE	descripcion like 'puerta' and precio_vta >= 1000 and stock != 0 
		and (anio between YEAR(GETDATE())-10 and YEAR(GETDATE()))
GROUP BY descripcion 

	UNION	
	
SELECT	p.descripcion as 'DESCRIPCIÓN',
	   (SELECT MIN(d.precio_unitario) 
		FROM PRODUCTOS p JOIN DETALLES d ON d.id_producto=p.id_producto
		WHERE p.descripcion like 'parabrisa') as 'PRECIO MINIMO HIST.',
	   (SELECT MAX(d.precio_unitario) 
		FROM PRODUCTOS p JOIN DETALLES d ON d.id_producto=p.id_producto
		WHERE p.descripcion like 'parabrisa') as 'PRECIO MÁXIMO HIST.',
		SUM(p.precio_vta) as 'VALOR TOTAL',
	   (SELECT	AVG(precio_vta)
	    FROM PRODUCTOS 
		WHERE descripcion like 'parabrisa' and precio_vta >= 1300 and stock != 0 
		and (anio between YEAR(GETDATE())-10 and YEAR(GETDATE()))) as 'VALOR PROMEDIO'
FROM PRODUCTOS p
WHERE	descripcion like 'parabrisa' and precio_vta >= 1000 and stock != 0 
		and (anio between YEAR(GETDATE())-10 and YEAR(GETDATE()))
GROUP BY descripcion 

	UNION	
	
SELECT	p.descripcion as 'DESCRIPCIÓN',
	   (SELECT MIN(d.precio_unitario) 
		FROM PRODUCTOS p JOIN DETALLES d ON d.id_producto=p.id_producto
		WHERE p.descripcion like 'rueda') as 'PRECIO MINIMO HIST.',
	   (SELECT MAX(d.precio_unitario) 
		FROM PRODUCTOS p JOIN DETALLES d ON d.id_producto=p.id_producto
		WHERE p.descripcion like 'rueda') as 'PRECIO MÁXIMO HIST.',
		SUM(p.precio_vta) as 'VALOR TOTAL',
	   (SELECT	AVG(precio_vta)
	    FROM PRODUCTOS 
		WHERE descripcion like 'rueda' and precio_vta >= 1300 and stock != 0 
		and (anio between YEAR(GETDATE())-10 and YEAR(GETDATE()))) as 'VALOR PROMEDIO'
FROM PRODUCTOS p
WHERE	descripcion like 'rueda' and precio_vta >= 1000 and stock != 0 
		and (anio between YEAR(GETDATE())-10 and YEAR(GETDATE()))
GROUP BY descripcion 

	UNION	

SELECT	p.descripcion as 'DESCRIPCIÓN',
	   (SELECT MIN(d.precio_unitario) 
		FROM PRODUCTOS p JOIN DETALLES d ON d.id_producto=p.id_producto
		WHERE p.descripcion like 'ventanilla') as 'PRECIO MINIMO HIST.',
	   (SELECT MAX(d.precio_unitario) 
		FROM PRODUCTOS p JOIN DETALLES d ON d.id_producto=p.id_producto
		WHERE p.descripcion like 'ventanilla') as 'PRECIO MÁXIMO HIST.',
		SUM(p.precio_vta) as 'VALOR TOTAL',
	   (SELECT	AVG(precio_vta)
	    FROM PRODUCTOS 
		WHERE descripcion like 'ventanilla' and precio_vta >= 1300 and stock != 0 
		and (anio between YEAR(GETDATE())-10 and YEAR(GETDATE()))) as 'VALOR PROMEDIO'
FROM PRODUCTOS p
WHERE	descripcion like 'ventanilla' and precio_vta >= 1000 and stock != 0 
		and (anio between YEAR(GETDATE())-10 and YEAR(GETDATE()))
GROUP BY descripcion 

	UNION	
	
SELECT	p.descripcion as 'DESCRIPCIÓN',
	   (SELECT MIN(d.precio_unitario) 
		FROM PRODUCTOS p JOIN DETALLES d ON d.id_producto=p.id_producto
		WHERE p.descripcion like '3 puertas') as 'PRECIO MINIMO HIST.',
	   (SELECT MAX(d.precio_unitario) 
		FROM PRODUCTOS p JOIN DETALLES d ON d.id_producto=p.id_producto
		WHERE p.descripcion like '3 puertas') as 'PRECIO MÁXIMO HIST.',
		SUM(p.precio_vta) as 'VALOR TOTAL',
	   (SELECT	AVG(precio_vta)
	    FROM PRODUCTOS 
		WHERE descripcion like '3 puertas' and precio_vta >= 1300 and stock != 0 
		and (anio between YEAR(GETDATE())-10 and YEAR(GETDATE()))) as 'VALOR PROMEDIO'
FROM PRODUCTOS p
WHERE	descripcion like '3 puertas' and precio_vta >= 1000 and stock != 0 
		and (anio between YEAR(GETDATE())-10 and YEAR(GETDATE()))
GROUP BY descripcion 

	UNION	
	
SELECT	p.descripcion as 'DESCRIPCIÓN',
	   (SELECT MIN(d.precio_unitario) 
		FROM PRODUCTOS p JOIN DETALLES d ON d.id_producto=p.id_producto
		WHERE p.descripcion like '5 puertas') as 'PRECIO MINIMO HIST.',
	   (SELECT MAX(d.precio_unitario) 
		FROM PRODUCTOS p JOIN DETALLES d ON d.id_producto=p.id_producto
		WHERE p.descripcion like '5 puertas') as 'PRECIO MÁXIMO HIST.',
		SUM(p.precio_vta) as 'VALOR TOTAL',
	   (SELECT	AVG(precio_vta)
	    FROM PRODUCTOS 
		WHERE descripcion like '5 puertas' and precio_vta >= 1300 and stock != 0 
		and (anio between YEAR(GETDATE())-10 and YEAR(GETDATE()))) as 'VALOR PROMEDIO'
FROM PRODUCTOS p
WHERE	descripcion like '5 puertas' and precio_vta >= 1000 and stock != 0 
		and (anio between YEAR(GETDATE())-10 and YEAR(GETDATE()))
GROUP BY descripcion 

	