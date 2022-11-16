
--Cuantas horas-vuelo lleva acumulado los pilotos en: 
--Sus últimos 10 vuelos
--Los últimos 6 meses

alter PROCEDURE HorasVuelo
AS
BEGIN
	select 
		(select Top 10 SUM(DATEDIFF(hour, FechaSalida, FechaLlegada))from Vuelo group by FechaSalida order by FechaSalida DESC) as Ultimos10Vuelos,
		(select SUM(DATEDIFF(hour, FechaSalida, FechaLlegada))from Vuelo where DATEDIFF(MONTH, GETDATE(), FechaSalida) <= 6 ) as Ultimos6Meses, 
		Pasajero.idPasajero as Pasajero
	from Vuelo	inner join VueloPasajero on VueloPasajero.idVuelo = Vuelo.idVuelo 
				inner join Pasajero on Pasajero.idPasajero = VueloPasajero.idPasajero
	where (Pasajero.idTipoPasajero = 1)
END
GO


--Vuelos comerciales con 2 o más escalas, indicando la ruta completa y horas de 
--salida y llegada.

alter procedure vuelos_comerciales
as 
begin

	select A.idAvion,A.idTipoAvion,V.idVuelo, V.CiudadOrigen,V.CiudadDestino,V.AeropuertoOrigen,V.AeropuertoDestino, V.FechaSalida, V.FechaLlegada,E.idEscala,E.FechaHora as Fecha_Escala from Vuelo V
	inner join Escala E on V.idVuelo = E.idVuelo
	inner join Avion A on V.idAvion = A.idAvion
	where  A.idTipoAvion = 1 and  A.idAvion = 1
	group by  A.idAvion

	

	return;
end
go

select count(*) from Escala E  where E.idVuelo = 1




insert into escala values(1,'Merida','2021/11/10 10AM')
insert into escala values(1,'Oaxaca','2021/11/10 11AM')
insert into escala values(1,'Puebla','2021/11/10 12AM')
insert into escala values(2,'Usa','2021/11/10 9AM')
select* from escala


insert into VueloPasajero(idVuelo,idPasajero,idAsiento,NoAsiento,Fecha)
values(1,1,1,20,'2021/11/08')
insert into VueloPasajero(idVuelo,idPasajero,idAsiento,NoAsiento,Fecha)
values(2,2,2,21,'2021/11/08')
insert into VueloPasajero(idVuelo,idPasajero,idAsiento,NoAsiento,Fecha)
values(3,3,3,30,'2021/11/08')
insert into VueloPasajero(idVuelo,idPasajero,idAsiento,NoAsiento,Fecha)
values(4,4,4,23,'2021/11/08')
insert into VueloPasajero(idVuelo,idPasajero,idAsiento,NoAsiento,Fecha)
values(5,5,1,45,'2021/11/08')
insert into VueloPasajero(idVuelo,idPasajero,idAsiento,NoAsiento,Fecha)
values(6,6,2,12,'2021/11/08')
select * from VueloPasajero

insert into TipoEstatus values('Disponible')
insert into TipoEstatus values('Reservado')
insert into TipoEstatus values('Confirmado')
select* from TipoEstatus

insert into Asiento(idAvion,idTipoAsiento,Cantidad)
values(1,1,12)
insert into Asiento(idAvion,idTipoAsiento,Cantidad)
values(2,2,12)
insert into Asiento(idAvion,idTipoAsiento,Cantidad)
values(3,3,12)
insert into Asiento(idAvion,idTipoAsiento,Cantidad)
values(4,3,12)
select* from Asiento

insert into TipoAsiento(Tipo)
values('Primera Clase')
insert into TipoAsiento(Tipo)
values('Economica Premium')
insert into TipoAsiento(Tipo)
values('Economica')
select* from TipoAsiento

INSERT INTO TipoAvion (Tipo) VALUES ('Comercial') 
INSERT INTO TipoAvion (Tipo) VALUES ('Primera') 
SELECT * FROM TipoAvion

INSERT INTO Avion(idTipoAvion, Compañia, Carga, Alcance) VALUES (1,'Delta Air Lines', 10.2, 123) 
INSERT INTO Avion(idTipoAvion, Compañia, Carga, Alcance) VALUES (1,'Spirit Airlines', 13.5, 100) 
INSERT INTO Avion(idTipoAvion, Compañia, Carga, Alcance) VALUES (2,'Volaris', 32.1, 523) 
INSERT INTO Avion(idTipoAvion, Compañia, Carga, Alcance) VALUES (1,'Iberia', 20.7, 324)
INSERT INTO Avion(idTipoAvion, Compañia, Carga, Alcance) VALUES (2,'Taca', 19.3, 70) 
INSERT INTO Avion(idTipoAvion, Compañia, Carga, Alcance) VALUES (2,'Taca', 19.3, 70)
INSERT INTO Avion(idTipoAvion, Compañia, Carga, Alcance) VALUES (1,'Interjet', 39.2, 120)
select* from Avion

INSERT INTO Vuelo(idAvion ,CiudadOrigen ,CiudadDestino ,AeropuertoOrigen,AeropuertoDestino ,FechaSalida ,FechaLlegada,Jornada ) 
VALUES (1,'GMT', 'MX', 'Aur', 'Ben', '2021/11/08 8AM', '2021/11/18 8AM', 'M') 
INSERT INTO Vuelo(idAvion ,CiudadOrigen ,CiudadDestino ,AeropuertoOrigen,AeropuertoDestino ,FechaSalida ,FechaLlegada,Jornada ) 
VALUES (2,'MX', 'IN', 'Ben', 'Aer', '2021/11/09 8AM', '2021/11/23 8AM', 'M') 
INSERT INTO Vuelo(idAvion ,CiudadOrigen ,CiudadDestino ,AeropuertoOrigen,AeropuertoDestino ,FechaSalida ,FechaLlegada,Jornada ) 
VALUES (3,'JP', 'EU', 'Oli', 'Ben', '2021/11/01 8AM', '2021/11/12 8AM', 'M') 
INSERT INTO Vuelo(idAvion ,CiudadOrigen ,CiudadDestino ,AeropuertoOrigen,AeropuertoDestino ,FechaSalida ,FechaLlegada,Jornada ) 
VALUES (4,'GMT', 'HN', 'Aur', 'Jua', '2021/11/02 8AM', '2021/11/10 8AM', 'M') 
INSERT INTO Vuelo(idAvion ,CiudadOrigen ,CiudadDestino ,AeropuertoOrigen,AeropuertoDestino ,FechaSalida ,FechaLlegada,Jornada ) 
VALUES (5,'AU', 'BE', 'Leo', 'Nit', '2021/11/08 8AM', '2021/11/13 8AM', 'M') 
INSERT INTO Vuelo(idAvion ,CiudadOrigen ,CiudadDestino ,AeropuertoOrigen,AeropuertoDestino ,FechaSalida ,FechaLlegada,Jornada ) 
VALUES (6,'CL', 'CN', 'Key', 'Ale', '2021/11/12 8AM', '2021/11/08 8AM', 'M') 
INSERT INTO Vuelo(idAvion ,CiudadOrigen ,CiudadDestino ,AeropuertoOrigen,AeropuertoDestino ,FechaSalida ,FechaLlegada,Jornada ) 
VALUES (7,'AG', 'AE', 'Key', 'Iri', '2021/01/01 8AM', '2021/06/01 9AM', 'M') 
SELECT * FROM Vuelo

insert into Pasajero(idTipoPasajero,Nombres ,Apellidos ,Pasaporte ,FechaNacimiento)
values(1,'julio','remenez','12345678','2001/09/06')
insert into Pasajero(idTipoPasajero,Nombres ,Apellidos ,Pasaporte ,FechaNacimiento)
values(2,'anderson','aliva','21345678','2001/08/12')
insert into Pasajero(idTipoPasajero,Nombres ,Apellidos ,Pasaporte ,FechaNacimiento)
values(1,'son','soto','21345679','2002/08/13')
insert into Pasajero(idTipoPasajero,Nombres ,Apellidos ,Pasaporte ,FechaNacimiento)
values(2,'claudia','oliva','21346578','2004/08/12')
insert into Pasajero(idTipoPasajero,Nombres ,Apellidos ,Pasaporte ,FechaNacimiento)
values(1,'moreno','pineda','21435678','2001/07/22')
insert into Pasajero(idTipoPasajero,Nombres ,Apellidos ,Pasaporte ,FechaNacimiento)
values(3,'jeremy','ochoa','21345768','2003/04/11')
insert into Pasajero(idTipoPasajero,Nombres ,Apellidos ,Pasaporte ,FechaNacimiento)
values(1,'jose','miguel','21354678','2000/10/23')
select* from Pasajero

insert into TipoPasajero(Tipo)
values('Piloto')
insert into TipoPasajero(Tipo)
values('Aeromozas')
insert into TipoPasajero(Tipo)
values('Pasajero')
select* from TipoPasajero