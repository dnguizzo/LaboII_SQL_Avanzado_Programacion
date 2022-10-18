

/* Problema 1_1_1*/
select cod_cliente 'Código', nom_cliente+'  '+ape_cliente 'Nombre', 'Cliente' Tipo
from clientes
UNION
select cod_vendedor, nom_vendedor+'  '+ape_vendedor,'Vendedor'
from vendedores
ORDER BY 3


/* Problema 1_1_2*/
select cod_cliente 'Código', nom_cliente+'  '+ape_cliente 'Nombre', 'Cliente' Tipo
from clientes
where nro_tel is not null and [e-mail] is not null
UNION
select cod_vendedor, nom_vendedor+'  '+ape_vendedor,'Vendedor'
from vendedores
where nro_tel is not null and [e-mail] is not null
ORDER BY 3,2

/* Problema 1_1_3*/

select cod_cliente 'Código', nom_cliente+'  '+ape_cliente 'Nombre', 'Cliente' Tipo
from clientes
UNION
select cod_vendedor, nom_vendedor+'  '+ape_vendedor,'Vendedor'
from vendedores
UNION
select cod_articulo, descripcion,'Articulo'
from articulos
ORDER BY 3,2

/* Problema 1_1_4*/
Select count(*) 'Cantidad de clientes',
count([e-mail])' Cantidad de clientes con e-mail conocido'
from clientes

/* Problema 3_4_1*/
Select cod_cliente 'Código',
ape_cliente + ' '+ nom_cliente Nombre,
'Cliente' Tipo
from clientes
where nro_tel is not null or [e-mail] is not null

UNION
Select cod_vendedor 'Código',
ape_vendedor + ' '+ nom_vendedor Nombre,
'Vendendor' Tipo
from vendedores
where nro_tel is not null or [e-mail] is not null
order by 3,2

/* Problema 3_4_2*/
Select cod_cliente 'Código',
ape_cliente + ' '+ nom_cliente Nombre,
'Cliente' Tipo
from clientes
where nro_tel is not null or [e-mail] is not null

UNION
Select cod_vendedor 'Código',
ape_vendedor + ' '+ nom_vendedor Nombre,
'Vendendor' Tipo
from vendedores
where nro_tel is not null or [e-mail] is not null
order by 3,2

/* Problema 3_4_3*/
Select cod_cliente 'Código',
ape_cliente + ' '+ nom_cliente Nombre,
'Cliente' Tipo
from clientes
UNION
Select cod_vendedor 'Código',
ape_vendedor + ' '+ nom_vendedor Nombre,
'Vendendor' Tipo
from vendedores
UNION
Select cod_articulo 'Código',
descripcion Nombre,
'Articulo' Tipo
from articulos
order by 3,2

/* Problema 3_4_4*/
Select c.ape_cliente +' '+ c.nom_cliente NOMBRE,
c.calle + ' ' + STR(c.altura) DIRECCION,
b.barrio BARRIO,
'Cliente' INTEGRANTE
from clientes c
INNER JOIN barrios b on c.cod_barrio=b.cod_barrio
UNION
Select v.ape_vendedor +' '+ v.nom_vendedor NOMBRE,
v.calle + ' ' + STR(v.altura) DIRECCION,
b.barrio 'BARRIO',
'Vendendor' INTEGRANTE
from vendedores v
INNER JOIN barrios b on v.cod_barrio=b.cod_barrio
WHERE v.cod_vendedor between 3 and 12
order by 1,4


/* Problema 3_4_6*/
Select a.cod_articulo 'Código',
descripcion Nombre,
'Articulo' Tipo
from articulos a
where a.pre_unitario between 1 and 60
UNION
Select a.cod_articulo 'Código',
descripcion Nombre,
'Articulo' Tipo
from detalle_facturas df
INNER JOIN articulos a ON a.cod_articulo=df.cod_articulo
INNER JOIN facturas f ON df.nro_factura=f.nro_factura
INNER JOIN clientes c ON f.cod_cliente=c.cod_cliente
--where c.ape_cliente like 'M%' or c.ape_cliente like 'P%'
where c.ape_cliente like '[MP]%'
