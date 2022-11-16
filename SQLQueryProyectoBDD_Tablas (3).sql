create database  Aeropuerto;
use Aeropuerto;

CREATE TABLE TipoAvion(
	idTipoAvion INT IDENTITY(1,1),
	Tipo VARCHAR(20) NOT NULL,

	CONSTRAINT PK_TIPOAVION PRIMARY KEY(idTipoAvion)
)


insert into TipoAVION VALUES('Privado');
select * from TipoAVION;
CREATE TABLE Avion(
	idAvion INT IDENTITY(1,1),
	idTipoAvion INT,
	Compania VARCHAR(50) NOT NULL,
	Carga DECIMAL (10,2) NOT NULL,
	Alcance INT NOT NULL,

	CONSTRAINT PK_AVION PRIMARY KEY(idAvion),
	CONSTRAINT FK_AVION_TIPOAVION FOREIGN KEY(idTipoAvion) REFERENCES TipoAvion(idTipoAvion)
)

insert into Avion values (1,'TAME',1000,2);
insert into Avion values (1,'LATAM',1000,2);
select * from Avion;
CREATE TABLE TipoAsiento(
	idTipoAsiento INT IDENTITY(1,1),
	Tipo VARCHAR(20) NOT NULL,

	CONSTRAINT PK_TIPOASIENTO PRIMARY KEY(idTipoAsiento)
)

CREATE TABLE Asiento(
	idAsiento INT IDENTITY(1,1),
	idAvion INT,
	idTipoAsiento INT,
	Cantidad SMALLINT NOT NULL,

	CONSTRAINT PK_ASIENTO PRIMARY KEY(idAsiento),
	CONSTRAINT FK_AVION FOREIGN KEY(idAvion) REFERENCES Avion(idAvion),
	CONSTRAINT FK_TIPOASIENTO FOREIGN KEY(idTipoAsiento) REFERENCES TipoAsiento(idTipoAsiento)
)

CREATE TABLE TipoPasajero(
	idTipoPasajero INT IDENTITY(1,1),
	Tipo VARCHAR(20) NOT NULL,

	CONSTRAINT PK_TIPOPASAJERO PRIMARY KEY(idTipoPasajero)
)
insert into TipoPasajero values ('clase alta');

CREATE TABLE Pasajero(
	idPasajero INT IDENTITY(1,1),
	idTipoPasajero INT,
	Nombres VARCHAR(100) NOT NULL,
	Apellidos VARCHAR(100) NOT NULL,
	Pasaporte VARCHAR(9) NOT NULL,
	FechaNacimiento DATE NOT NULL,

	CONSTRAINT PK_PASAJERO PRIMARY KEY(idPasajero),
	CONSTRAINT FK_PASAJERO_TIPOPASAJERO FOREIGN KEY(idTipoPasajero) REFERENCES TipoPasajero(idTipoPasajero)
)
insert into Pasajero values (1,'Jose','Cedeno','45556222','2000-01-02');

CREATE TABLE Vuelo(
	idVuelo INT IDENTITY(1,1),
	idAvion INT,
	Estatus BIT NOT NULL DEFAULT 1,
	CiudadOrigen VARCHAR(20) NOT NULL,
	CiudadDestino VARCHAR(20) NOT NULL,
	AeropuertoOrigen VARCHAR(3) NOT NULL,
	AeropuertoDestino VARCHAR(3) NOT NULL,
	FechaSalida SMALLDATETIME NOT NULL,
	FechaLlegada SMALLDATETIME NOT NULL,
	Jornada VARCHAR(1) NOT NULL,

	CONSTRAINT PK_VUELO PRIMARY KEY(idVuelo),
	CONSTRAINT FK_VUELO_AVION FOREIGN KEY(idAvion) REFERENCES Avion(idAvion)
)
select * from Vuelo;
CREATE TABLE Escala(
	idEscala INT IDENTITY(1,1),
	idVuelo INT,
	Destino VARCHAR(20) NOT NULL,
	FechaHora SMALLDATETIME NOT NULL,
	
	CONSTRAINT PK_ESCALA PRIMARY KEY(idEscala),
	CONSTRAINT FK_ESCALA_VUELO FOREIGN KEY(idVuelo) REFERENCES Vuelo(idVuelo)
)

CREATE TABLE TipoEstatus(
	idTipoEstatus INT IDENTITY(1,1),
	Tipo VARCHAR(20) NOT NULL,

	CONSTRAINT PK_TIPOESTATUS PRIMARY KEY(idTipoEstatus)
)

CREATE TABLE VueloAsiento(
	idVueloAsiento INT IDENTITY(1,1),
	idVuelo INT,
	idAsiento INT,
	idTipoEstatus INT NOT NULL DEFAULT 1,

	CONSTRAINT PK_VUELOASIENTO PRIMARY KEY(idVueloAsiento),
	CONSTRAINT FK_VUELOASIENTO_VUELO FOREIGN KEY(idVuelo) REFERENCES Vuelo(idVuelo),
	CONSTRAINT FK_VUELOASIENTO_ASIENTO FOREIGN KEY(idAsiento) REFERENCES Asiento(idAsiento),
	CONSTRAINT FK_VUELOASIENTO_ESTATUS FOREIGN KEY(idTipoEstatus) REFERENCES TipoEstatus(idTipoEstatus)
)

CREATE TABLE VueloPasajero(
	idVueloPasajero INT IDENTITY(1,1),
	idVuelo INT,
	idPasajero INT,
	idVueloAsiento INT DEFAULT NULL,

	CONSTRAINT PK_VUELOPASAJERO PRIMARY KEY(idVueloPasajero),
	CONSTRAINT FK_VUELOPASAJERO_VUELO FOREIGN KEY(idVuelo) REFERENCES Vuelo(idVuelo),
	CONSTRAINT FK_VUELOPASAJERO_PASAJERO FOREIGN KEY(idPasajero) REFERENCES Pasajero(idPasajero),
	CONSTRAINT FK_VUELOPASAJERO_VUELOASIENTO FOREIGN KEY(idVueloAsiento) REFERENCES VueloAsiento(idVueloAsiento)
)

CREATE TABLE RESERVAR(
	idReservar INT IDENTITY(1,1),
	idVuelo INT,
	idPasajero INT,
	cancelada BIT default 0,
	CONSTRAINT FK_VUELO FOREIGN KEY(idVuelo) REFERENCES Vuelo(idVuelo),
	CONSTRAINT FK_PASAJERO FOREIGN KEY(idPasajero) REFERENCES Pasajero(idPasajero)
)
-- Trigger para cancelar un vuelo y para cancelar una reserva
GO
CREATE OR ALTER TRIGGER EliminarVuelo on Vuelo
AFTER UPDATE AS
	BEGIN
		--Declaracion de variables para determinar los datos de busqueda
		--Variable estatus del estado del vuelo
		DECLARE @estatus bit = (select estatus FROM inserted)
		--Variable idVuevo del id del vuelo
		DECLARE @idVuelo int = (select idVuelo FROM inserted)
		--Si el estatus que se actualizo es 0, se actualiza cancelada a 1 de todos los vuelos del idVuelo=@idVuelo
		IF @estatus=0
		BEGIN
			UPDATE r 
			SET cancelada=1
			FROM Reservar r 
				INNER JOIN Vuelo v on r.idVuelo = v.idVuelo
			where v.idVuelo=@idVuelo
		END
		--Caso contrario, se actualiza cancelada a 0 de todos los vuelos del idVuelo=@idVuelo
		ELSE
		BEGIN
			UPDATE r 
			SET cancelada=0
			FROM Reservar r 
				INNER JOIN Vuelo v on r.idVuelo = v.idVuelo
			where v.idVuelo=@idVuelo
		END
END

insert into Vuelo values (1,1,'QUITO','GUAYAQUIL','Q','G',1900-12-13,1900-12-14 ,'M');
insert into Vuelo values (1,1,'MANTA','GUAYAQUIL','M','G',1900-12-13,1900-12-14 ,'M');

insert into RESERVAR values (7,1,0);

insert into RESERVAR values (8,1,0);
select * from vuelo;
update Vuelo set Estatus =0 where Vuelo.idVuelo=7;
select * from Reservar;
delete from Vuelo;
delete from RESERVAR;
