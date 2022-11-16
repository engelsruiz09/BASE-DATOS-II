
create table astronauta(
	idastronauta int identity(1,1),
	nombre varchar(50),
	direccion varchar(50),
	telefono varchar(50),
	pais varchar(50),
	num_viajes int,

	constraint PK_idastronauta primary key (idastronauta)
)

create table tripulante(
	idastronauta int,
	idviaje int 

	constraint FK_idastronauta foreign key (idastronauta) references astronauta(idastronauta),
	constraint FK_idviaje foreign key (idviaje) references viaje(idviaje)
)

create table viaje(
	idviaje int identity(1,1),
	idnave int,
	idbase int,
	fechasalida date,
	fechallegada date,
	viajestatus varchar(50),

	constraint  PK_idviaje primary key (idviaje),
	constraint FK_idnave foreign key (idnave) references nave(idnave),
	constraint FK_idbase foreign key (idbase) references base(idbase)
)
 create table nave(
	idnave int identity(1,1),
	nombre varchar(50),
	costo int 
 
	constraint  PK_idnave primary key (idnave)
 
 )

 create table base(
	idbase int identity(1,1),
	direccion varchar(100),
	pais varchar (3)

	constraint  PK_idbase primary key (idbase)
 

 )

 insert into astronauta(nombre,direccion,telefono,pais,num_viajes)
 values('julio','zona 23','23348909','guatemala',1)
 select* from astronauta

 insert into tripulante(idastronauta,idviaje)
 values(1,1)
 select* from tripulante

 insert into viaje(idnave,idbase,fechasalida,fechallegada,viajestatus)
 values(1,1,getdate(),'2023/05/11','en viaje')
 select* from viaje

 insert into nave(nombre,costo)
 values('lanasa',50)
 select* from nave

insert into base(direccion,pais)
values('zona 14','GTM')
 select* from base