

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
