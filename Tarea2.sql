--HOJA DE TRABAJO FUNCIONES Y TRIGGERS
--JULIO ANTHONY ENGELS RUIZ COTO -1284719
--INTRUCCIONES UTILIZANDO LA BASE DE DATOS DE ACCIDENTES GEOGRAFICOS REALICE LO SIGUIENTE

--==============================================EJERCICIO 1=============================================
--FUNCION QUE DEVUELVA DATOS DE CONEXION DEL USUARIO
SELECT SUSER_NAME(),APP_NAME(),HOST_NAME(),GETDATE()
SELECT LOGINAME,PROGRAM_NAME,HOSTNAME,GETDATE() FROM SYSPROCESSES WHERE SPID = @@SPID

CREATE OR ALTER FUNCTION datosConexion()
RETURNS table
AS
RETURN(
	select 
		SUSER_NAME() as [login name],
		PROGRAM_NAME() AS PROGRAM_NAME,
		HOST_NAME() AS HOST_NAME,
		GETDATE() AS FECHA FROM SYSPROCESSES WHERE SPID = @@SPID
);
SELECT * from datosConexion()

----------------OTRA FORMA DE HACERLO-----------------------
--CREATE FUNCTION fn_datousuario()
--RETURNS TABLE AS
--RETURN(SELECT LOGINAME, PROGRAM_NAME,HOSTNAME,GETDATE() AS FECHA FROM SYSPROCESSES WHERE SPID = @@SPID)
--SELECT* FROM fn_datousuario()

--==============================================EJERCICIO 2=============================================
--TRIGGER QUE NO PERMITA INGRESAR UN ACCIDENTE CON NOMBRE MENOR A 3 CARACTERES
CREATE or alter TRIGGER validar_nombre
ON Accidente
AFTER INSERT
AS
begin
	SET NOCOUNT ON --para acceder a los datos que se estan ingresando
	declare @nombre varchar(500)
	set @nombre = (select i.Nombre from inserted as i) --inserted simula la fila que se esta ingresando
	if len(@nombre) < 3
	begin
		begin try
			throw 60000,'Error, el nombre debe tener al menos 3 caracteres',1;
		end try
		begin catch
			ROLLBACK TRANSACTION; --es para guardar informacion, por logica si hay un error esa info no debe de almacenarse
			SELECT ERROR_MESSAGE()
		end catch
		RETURN
	end
end

INSERT INTO Accidente (idAccidente, idTipoAccidente, Nombre, AlturaNivelMar)
VALUES (1264,4,'R233',1000);

SELECT* FROM dbo.Accidente

--==============================================EJERCICIO 3=============================================
--CREAR UN TRIGGER QUE GENERE UNA BITACORA DE MODIFICACIONES A LA TABLA ACCIDENTES, DICHA BITACORA DEBE GUARDAR:
--USUARIO,CLIENTE UTILIZANDO(PROGRAMA), HOST, FECHA Y HORA , VALORES INICIALES, VALORES FINALES
--ACCIDENTEBITACORA
	--COLUMNNAME     \DATA TYPE
	--USUARIO        \NVARCHAR(128)
	--PROGRAM_NAME   \NVARCHAR(128)
	--HOSTNAME       \NVARCHAR(128)
	--FECHA          \DATETIME
	--IDACCIDENTE    \INT
	--IDTIPOACCIDENTE\INT
	--NOMBRE         \VARCHAR(500)
	--ALTURANIVELMAR \BIGINT
	--IDACCIDENTE2    \INT
	--IDTIPOACCIDENTE2\INT
	--NOMBRE2        \VARCHAR(500)
	--ALTURANIVELMAR2 \BIGINT
CREATE or alter TRIGGER auditoria
ON Accidente
AFTER INSERT,UPDATE,DELETE
AS
begin
	SET NOCOUNT ON
	declare 
	@id int,
	@usuario nvarchar(128),
	@program_name nvarchar(128),
	@hostname nvarchar(128),
	@id_tipo int,
	@nombre varchar(500),
	@altura bigint

	set @id = (select i.idAccidente from inserted as i)  
	set @nombre = (select i.Nombre from Accidente as i where idAccidente = @id)
	set @id_tipo = (select i.idTipoAccidente from Accidente as i where idAccidente = @id)
	set @altura = (select i.AlturaNivelMar from Accidente as i where idAccidente = @id)

	insert into AccidenteBitacora 
	values(
		SUSER_NAME(),
		APP_NAME(),
		HOST_NAME(),
		GETDATE(),
		@id,
		@id_tipo,
		@nombre,
		@altura)
	
end

create table AccidenteBitacora(
	Usuario nvarchar(128),
	Program_name nvarchar(128),
	Hostname nvarchar(128),
	fecha datetime,
	idAccidente int,
	idTipoAccidente int,
	Nombre varchar(500),
	AlturaNivelMar bigint
);
