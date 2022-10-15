CREATE DATABASE AUTOMOTRIZ
GO
USE AUTOMOTRIZ;
GO

--CREACION TABLAS

CREATE TABLE PROVINCIAS(
id_provincia	int IDENTITY(1,1),
provincia		varchar(100) NOT NULL,
	CONSTRAINT pk_provincias PRIMARY KEY (id_provincia)
)

CREATE TABLE CIUDADES(
id_ciudad		int IDENTITY(1,1),
ciudad			varchar(100) NOT NULL,
id_provincia	int NOT NULL,
	CONSTRAINT pk_ciudades PRIMARY KEY (id_ciudad),
	CONSTRAINT fk_ciudades_provincias FOREIGN KEY (id_provincia)
		REFERENCES PROVINCIAS (id_provincia)
)

CREATE TABLE BARRIOS(
id_barrio	int IDENTITY(1,1),
barrio		varchar(100) NOT NULL,
id_ciudad	int NOT NULL,
	CONSTRAINT pk_barrios PRIMARY KEY (id_barrio),
	CONSTRAINT fk_barrios_ciudades FOREIGN KEY (id_ciudad)
		REFERENCES CIUDADES (id_ciudad)
)

CREATE TABLE PERSONAS(
id_persona		int IDENTITY(1,1),
nombre			varchar(100) NOT NULL,
apellido		varchar(100) NOT NULL,
documento		bigint,
contacto		varchar(200),
dire_persona	varchar(100),
id_barrio		int,
	CONSTRAINT pk_personas PRIMARY KEY (id_persona),
	CONSTRAINT fk_personas_barrios FOREIGN KEY (id_barrio)
		REFERENCES BARRIOS (id_barrio)
)

CREATE TABLE TIPO_CLIENTES(
id_tipo_cliente		int IDENTITY(1,1),
tipo_cliente		varchar(100) NOT NULL,
razon_social		varchar(100),
dire_empresa		varchar(100),
cuit				bigint,
contacto			varchar(200),
descuento			numeric(5,2),
id_barrio			int,
	CONSTRAINT pk_tipo_clientes PRIMARY KEY (id_tipo_cliente),
	CONSTRAINT fk_tipo_clientes_barrios FOREIGN KEY (id_barrio)
		REFERENCES BARRIOS (id_barrio)
)

CREATE TABLE CLIENTES(
id_cliente			int IDENTITY(1,1),
id_persona			int NOT NULL,
id_tipo_cliente		int NOT NULL,
	CONSTRAINT pk_clientes PRIMARY KEY (id_cliente),
	CONSTRAINT fk_clientes_personas FOREIGN KEY (id_persona)
		REFERENCES PERSONAS (id_persona),
	CONSTRAINT fk_clientes_tipo_clientes FOREIGN KEY (id_tipo_cliente)
		REFERENCES TIPO_CLIENTES (id_tipo_cliente)
)

CREATE TABLE TIPO_EMPLEADOS(
id_tipo_empleado	int IDENTITY(1,1),
tipo_empleado		varchar(100) NOT NULL,
	CONSTRAINT pk_tipo_empleados PRIMARY KEY (id_tipo_empleado)
)

CREATE TABLE EMPLEADOS(
id_empleado			int IDENTITY(1,1),
id_persona			int NOT NULL,
id_tipo_empleado	int NOT NULL,
cuit				bigint NOT NULL,
	CONSTRAINT pk_empleados PRIMARY KEY (id_empleado),
	CONSTRAINT fk_empleados_tipo_empleados FOREIGN KEY (id_tipo_empleado)
		REFERENCES TIPO_EMPLEADOS (id_tipo_empleado),
	CONSTRAINT fk_empleados_personas FOREIGN KEY (id_persona)
		REFERENCES PERSONAS (id_persona)
)

CREATE TABLE MARCAS(
id_marca	int IDENTITY(1,1),
marca		varchar(100) NOT NULL,
	CONSTRAINT pk_marcas PRIMARY KEY (id_marca)
)

CREATE TABLE TIPO_PRODUCTOS(
id_tipo_producto	int IDENTITY(1,1),
tipo_producto		varchar(100) NOT NULL,
	CONSTRAINT pk_tipo_productos PRIMARY KEY (id_tipo_producto)
)

CREATE TABLE PRODUCTOS(
id_producto			int IDENTITY(1,1),
descripcion			varchar(100) NOT NULL,
anio				int NOT NULL,
stock				bit NOT NULL,
precio_vta			numeric (10,2) NOT NULL,
id_marca			int NOT NULL,	
id_tipo_producto	int NOT NULL,
	CONSTRAINT pk_productos PRIMARY KEY (id_producto),
	CONSTRAINT fk_productos_marcas FOREIGN KEY (id_marca)
		REFERENCES MARCAS (id_marca),
	CONSTRAINT fk_productos_tipo_productos FOREIGN KEY (id_tipo_producto)
		REFERENCES TIPO_PRODUCTOS (id_tipo_producto)
)

CREATE TABLE METODO_PAGOS(
id_metodo_pago		int IDENTITY(1,1),
metodo_pago			varchar(100),
	CONSTRAINT pk_metodo_pagos PRIMARY KEY (id_metodo_pago)
)

CREATE TABLE TIPO_ENVIOS(
id_tipo_envio		int IDENTITY(1,1),
tipo_envio			varchar(100),
	CONSTRAINT pk_tipo_envios PRIMARY KEY (id_tipo_envio)
)

CREATE TABLE FACTURAS(
id_factura				int IDENTITY(1,1),
fecha_factura			datetime NOT NULL,
id_metodo_pago			int NOT NULL,
id_tipo_envio			int,
	CONSTRAINT pk_facturas PRIMARY KEY (id_factura),
	CONSTRAINT fk_facturas_metodo_pagos FOREIGN KEY (id_metodo_pago)
		REFERENCES METODO_PAGOS (id_metodo_pago),
	CONSTRAINT fk_facturas_tipo_envios FOREIGN KEY (id_tipo_envio)
		REFERENCES TIPO_ENVIOS (id_tipo_envio)
)

CREATE TABLE PEDIDOS(
id_pedido			int IDENTITY(1,1),
id_factura			int,
id_empleado			int NOT NULL,
id_cliente			int NOT NULL,
fecha_pedido		datetime NOT NULL,
fecha_entrega		datetime NOT NULL,
	CONSTRAINT pk_pedidos PRIMARY KEY (id_pedido),
	CONSTRAINT fk_pedidos_facturas FOREIGN KEY (id_factura)
		REFERENCES FACTURAS (id_factura),
	CONSTRAINT fk_pedidos_empleados FOREIGN KEY (id_empleado)
		REFERENCES EMPLEADOS (id_empleado),
	CONSTRAINT fk_pedidos_clientes FOREIGN KEY (id_cliente)
		REFERENCES CLIENTES (id_cliente),
)

CREATE TABLE DETALLES(
id_detalle				int IDENTITY(1,1),
id_factura				int,
id_pedido				int NOT NULL,
id_producto				int NOT NULL,
precio_unitario			numeric(10,2) NOT NULL,
cantidad				smallint NOT NULL,
	CONSTRAINT pk_detalles PRIMARY KEY (id_detalle),
	CONSTRAINT fk_detalles_facturas FOREIGN KEY (id_factura)
		REFERENCES FACTURAS (id_factura),
	CONSTRAINT fk_detalles_pedidos FOREIGN KEY (id_pedido)
		REFERENCES PEDIDOS (id_pedido),
	CONSTRAINT fk_detalles_productos FOREIGN KEY (id_producto)
		REFERENCES PRODUCTOS (id_producto)
)


;



