create database if not exists pp_ayer;
use pp_ayer;

-- Tabla de usuarios (ya en 2NF)
create table usuario (
    id_usuario int auto_increment primary key,
    nombre varchar(255) not null,
    apellido varchar(255) not null,
    email varchar(255) unique not null,
    contrasena varchar(255) not null, 
    telefono varchar(255) not null,
    direccion varchar(255) not null
);

-- Tabla de ciudades (nueva tabla para normalizar)
create table ciudad (
    id_ciudad int auto_increment primary key,
    nombre_ciudad varchar(255) not null unique
);

-- Insertar las ciudades
INSERT INTO ciudad (nombre_ciudad) VALUES 
('La Plata'),
('San Fernando del Valle de Catamarca'),
('Resistencia'),
('Rawson'),
('Córdoba'),
('Corrientes'),
('Paraná'),
('Formosa'),
('San Salvador de Jujuy'),
('Santa Rosa'),
('La Rioja'),
('Mendoza'),
('Posadas'),
('Neuquén'),
('Viedma'),
('Salta'),
('San Juan'),
('San Luis'),
('Río Gallegos'),
('Santa Fe'),
('Santiago del Estero'),
('Ushuaia'),
('San Miguel de Tucumán');

-- Tabla de tipos de comercio (nueva tabla para normalizar)
create table tipo_comercio (
    id_tipo_comercio int auto_increment primary key,
    nombre_tipo varchar(50) not null unique
);

-- Insertar tipos de comercio
INSERT INTO tipo_comercio (nombre_tipo) VALUES 
('restaurante'),
('farmacia'),
('libreria'),
('supermercado'),
('otros');

-- Tabla comercio normalizada
create table comercio(
    id_comercio int auto_increment primary key,
    nombre varchar(255) not null,
    id_tipo_comercio int not null,
    cuit varchar(12) unique not null,
    direccion varchar(255) not null,
    email varchar(255) unique not null,
    telefono varchar(255) not null,
    id_ciudad int not null,
    foreign key (id_tipo_comercio) references tipo_comercio(id_tipo_comercio),
    foreign key (id_ciudad) references ciudad(id_ciudad)
);

-- Tabla de categorías de productos (nueva tabla para normalizar)
create table categoria_producto (
    id_categoria int auto_increment primary key,
    nombre_categoria varchar(50) not null unique
);

-- Insertar categorías
INSERT INTO categoria_producto (nombre_categoria) VALUES 
('Alimentos'),
('Bebidas'),
('Limpieza'),
('Electrodomésticos'),
('Indumentaria'),
('Ferretería'),
('Tecnología'),
('Hogar'),
('Juguetería'),
('Farmacia'),
('Libreria');

-- Tabla producto normalizada
create table producto (
    id_producto int auto_increment primary key,
    nombre_producto varchar(255) not null,
    stock int unsigned not null default 0,
    precio float unsigned not null default 0,
    id_comercio int not null,
    id_categoria int not null,
    foreign key (id_comercio) references comercio(id_comercio),
    foreign key (id_categoria) references categoria_producto(id_categoria)
);

-- Tabla de turnos (nueva tabla para normalizar)
create table turno (
    id_turno int auto_increment primary key,
    nombre_turno varchar(20) not null unique
);

-- Insertar turnos
INSERT INTO turno (nombre_turno) VALUES 
('Mañana'),
('Tarde'),
('Noche');

-- Tabla repartidor normalizada
create table repartidor (
    id_repartidor int auto_increment primary key,
    nombre varchar(255) not null,
    apellido varchar(255) not null,
    cuit varchar(12) unique not null, 
    email varchar(255) unique not null,
    telefono varchar(255) not null,
    valoracion float check (valoracion between 1 and 5),
    estado_repartidor boolean default true,
    id_turno int not null,
    foreign key (id_turno) references turno(id_turno)
);

-- Tabla de métodos de pago (nueva tabla para normalizar)
create table metodo_pago (
    id_metodo_pago int auto_increment primary key,
    nombre_metodo varchar(20) not null unique
);

-- Insertar métodos de pago
INSERT INTO metodo_pago (nombre_metodo) VALUES 
('Transferencia'),
('Tarjeta'),
('Efectivo');

-- Tabla pago normalizada
create table pago(
    id_pago int auto_increment primary key,
    fecha_pago timestamp default current_timestamp,
    id_metodo_pago int not null,
    monto float not null,
    foreign key (id_metodo_pago) references metodo_pago(id_metodo_pago)
);

-- Tabla de vehículos (nueva tabla para normalizar)
create table vehiculo (
    id_vehiculo int auto_increment primary key,
    tipo_vehiculo varchar(20) not null unique
);

-- Insertar vehículos
INSERT INTO vehiculo (tipo_vehiculo) VALUES 
('moto'),
('bicicleta'),
('auto');

-- Tabla de estados de pedido (nueva tabla para normalizar)
create table estado_pedido (
    id_estado int auto_increment primary key,
    nombre_estado varchar(20) not null unique
);

-- Insertar estados
INSERT INTO estado_pedido (nombre_estado) VALUES 
('En preparacion'),
('En camino'),
('Entregado'),
('Cancelado');

-- Tabla pedido normalizada
create table pedido(
    id_pedido int auto_increment primary key,
    id_repartidor int,
    id_comercio int not null,
    id_usuario int not null,
    id_pago int not null,
    id_vehiculo int not null,
    id_estado int not null,
    fecha timestamp default current_timestamp,
    foreign key (id_repartidor) references repartidor(id_repartidor),
    foreign key (id_comercio) references comercio(id_comercio),
    foreign key (id_usuario) references usuario(id_usuario),
    foreign key (id_pago) references pago(id_pago),
    foreign key (id_vehiculo) references vehiculo(id_vehiculo),
    foreign key (id_estado) references estado_pedido(id_estado)
);

-- Tabla intermedia para pedidos y productos (relación muchos a muchos)
create table pedido_producto (
    id_pedido int not null,
    id_producto int not null,
    cantidad int unsigned not null default 1,
    precio_unitario float unsigned not null,
    primary key (id_pedido, id_producto),
    foreign key (id_pedido) references pedido(id_pedido) on delete cascade,
    foreign key (id_producto) references producto(id_producto)
);

-- Índices adicionales para optimizar consultas
create index idx_usuario_email on usuario(email);
create index idx_comercio_email on comercio(email);
create index idx_repartidor_email on repartidor(email);
create index idx_pedido_fecha on pedido(fecha);
create index idx_producto_comercio on producto(id_comercio);

-- Ejemplo de inserción con password encriptada
-- INSERT INTO usuario(nombre, apellido, email, contrasena, telefono, direccion) 
-- VALUES ('John', 'Doe', 'john@example.com', MD5('john123'), '123456789', 'Calle 123');
