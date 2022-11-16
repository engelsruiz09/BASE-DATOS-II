create table cuenta (
	idcuenta int identity(1,1),
	nombrecuenta varchar(100),
	nocuenta varchar(10), --numero de cuenta
	saldo decimal(10,2),
	vigente bit,

	constraint PK_idcuenta primary key(idcuenta)
)

create table tipodocumento(
	idtipodocumento int identity(1,1),
	descripcion varchar(20),
	suma bit,
	limiteoperacion int,

	constraint PK_idtipodocumento primary key(idtipodocumento)

)

create table cuentadetalle(
	idcuentadetalle int identity(1,1),
	idcuenta int,
	idtipodocumento int,
	nodocumento varchar(10), --numero documento
	monto decimal(10,2),
	fechahora datetime,
	usuario varchar(50),

	constraint PK_idcuentadetalle primary key(idcuentadetalle),
	constraint FK_idcuenta foreign key(idcuenta) references cuenta(idcuenta),
	constraint FK_idtipodocumento foreign key(idtipodocumento) references tipodocumento(idtipodocumento)
)
drop table cuenta
drop table tipodocumento
drop table cuentadetalle



insert into cuenta(nombrecuenta,nocuenta,saldo,vigente)
values('julio','1234',2500.93,1)
insert into cuenta(nombrecuenta,nocuenta,saldo,vigente)
values('ramirez','4321',34500.96,1)
insert into cuenta(nombrecuenta,nocuenta,saldo,vigente)
values('checha','9087',34500.96,1)
select*  from cuenta

insert into tipodocumento(descripcion,suma,limiteoperacion)
values('cheque',0,25000)
insert into tipodocumento(descripcion,suma,limiteoperacion)
values('cheque',0,25000)
insert into tipodocumento(descripcion,suma,limiteoperacion)
values('deposito',1,25000)
select* from tipodocumento

insert into cuentadetalle(idcuenta,idtipodocumento ,nodocumento,monto,fechahora,usuario)
values(1,1,'1',1500.09,getdate(),'eljulios')
insert into cuentadetalle(idcuenta,idtipodocumento ,nodocumento,monto,fechahora,usuario)
values(1,3,'2',1500.09,getdate(),'ramirezgt')

select* from cuentadetalle