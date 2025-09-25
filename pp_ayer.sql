create database if not exists pp_ayer;
use pp_ayer;

create table usuario (
	id_usuario int auto_increment primary key,
    nombre varchar(255) not null,
    apellido varchar(255) not null,
    email varchar(255) unique not null,
    telefono varchar(255) not null,
    direccion varchar(255) not null
);

create table comercio(
	id_comercio int auto_increment primary key,
    nombre varchar(255) not null,
    tipo_comercio enum ("restaurante","farmacia","libreria","supermercado","otros"),
    direccion varchar(255) not null,
	email varchar(255) unique not null,
    telefono varchar(255) not null,
    ciudad ENUM(
        'La Plata',
        'San Fernando del Valle de Catamarca',
        'Resistencia',
        'Rawson',
        'Córdoba',
        'Corrientes',
        'Paraná',
        'Formosa',
        'San Salvador de Jujuy',
        'Santa Rosa',
        'La Rioja',
        'Mendoza',
        'Posadas',
        'Neuquén',
        'Viedma',
        'Salta',
        'San Juan',
        'San Luis',
        'Río Gallegos',
        'Santa Fe',
        'Santiago del Estero',
        'Ushuaia',
        'San Miguel de Tucumán'
    ) not null
);

create table producto (
	id_producto int auto_increment primary key,
    nombre_producto varchar(255) not null,
    stock  int unsigned not null default 0 ,
    precio float unsigned not null default 0 ,
    id_comercio int not null,
    categoria ENUM(
        'Alimentos',
        'Bebidas',
        'Limpieza',
        'Electrodomésticos',
        'Indumentaria',
        'Ferretería',
        'Tecnología',
        'Hogar',
        'Juguetería',
        'Farmacia',
        'Libreria'
    ) not null,
    
    foreign key (id_comercio) references comercio(id_comercio)
);

create table repartidor (
	id_repartidor int auto_increment primary key,
    nombre varchar(255) not null,
    apellido varchar(255) not null,
    email varchar(255) unique not null,
    telefono varchar(255) not null,
    valoracion float check (valoracion between 1 and 5),
    estado_repartidor boolean default true
);

create table pago(
	id_pago int auto_increment primary key,
    fecha_pago timestamp default current_timestamp,
    metodo_pago enum("Transferencia","Tarjeta","Efectivo"),
    monto float 
);


create table pedido(
	id_pedido int auto_increment primary key,
    id_repartidor int,
    id_comercio int,
    id_usuario int,
    id_pago int,
    vehiculo enum("moto","bicicleta","auto"),
    estado enum("En preparacion","En camino","Entregado","Cancelado"),
    fecha timestamp default current_timestamp,
    foreign key (id_repartidor) references repartidor(id_repartidor),
    foreign key (id_comercio) references comercio(id_comercio),
    foreign key (id_usuario) references usuario(id_usuario),
    foreign key (id_pago) references pago(id_pago)
);



