--JULIO ANTHONY ENGELS RUIZ COTO -1284719

--Realice un procedimiento que permita asignar a un estudiante a un curso, para esto debe:

--1. (10pts) Crear un trigger en la tabla CursoAsignado que no permita asignar a un estudiante al mismo curso 
--(no importa la sección),
--puede agregar una validación para que solo se pueda insertar una tupla a la vez.


create table cursoasignado(
idcurso int,
idcursoprogramado int,
idestudiante int,
fechahora datetime)
insert cursoasignado
(idcurso,idcursoprogramado,idestudiante,fechahora)
values(2,4,8,'12/09/2021')
insert cursoasignado
(idcurso,idcursoprogramado,idestudiante,fechahora)
values(3,5,9,'12/09/2021')

select*from cursoasignado
CREATE or alter TRIGGER elcurso
ON cursoasignado
AFTER INSERT
AS
begin
	SET NOCOUNT ON --para acceder a los datos que se estan ingresando
	declare @idcurso varchar(3)
	declare @idestudiante varchar(3)
	set @idcurso = (select i.idcurso from inserted as i) --inserted simula la fila que se esta ingresando
	set @idestudiante = (select i.idestudiante from inserted as i)
	if @idestudiante <> @idcurso
	begin
		begin try
			throw 60000,'Error, no se permite asignar a un estudiante al mismo curso',1;
		end try
		begin catch
			ROLLBACK TRANSACTION; --es para guardar informacion, por logica si hay un error esa info no debe de almacenarse
			SELECT ERROR_MESSAGE()
		end catch
		RETURN
	end
end


--. (40pts) Crear un procedimiento almacenado que reciba como
--parámetros el nombre del curso, carnet del estudiante y número de sección. Debe tomar en cuenta lo siguiente:
--a. Dado que se recibe el nombre del curso y carnet del estudiante, debe verificar que no exista más de un curso 
--con el mismo nombre ni estudiante con el mismo carnet, si fuera así, debe generar un error y terminar el proceso.
CREATE OR ALTER PROCEDURE verificar (@nombrecurso varchar(50),@carnet varchar(7),@numseccion varchar(3))
AS
BEGIN
	
	BEGIN TRAN 
	BEGIN TRY 
		declare @idcursoprogramado varchar(3)
		declare @idcurso varchar(3)
		declare @cupo int
		declare @idcursoasignado varchar(3)

			BEGIN TRY
				IF @nombrecurso != @nombrecurso AND @carnet != @carnet
				BEGIN
						IF EXISTS
						(
							SELECT * FROM cursoasignado
							WHERE nombrecurso= @nombrecurso and
							carnet = @carnet)				
						ELSE
						BEGIN
							THROW 50000,'Error exista más de un curso con el mismo nombre y estudiante con el mismo carnet,'
						END;
			   IF @idcursoprogramado <> 0 
			   BEGIN 
				IF @cupo <= 10
				 BEGIN
					IF EXISTS
						(
							SELECT * FROM cursoasignado
							WHERE idcursoprogramado= @idcursoprogramado and
							idcursoasignado = @idcursoasignado AND cupo = @cupo)	
					END
				ELSE
				BEGIN 
				  THROW 50000, 'El cupo esta lleno'
					END

			CCommit Tran
		
	END TRY

	BEGIN CATCH 
		rollback

		DECLARE @ErrorMessage NVARCHAR(4000);
		DECLARE @ErrorSeverity INT;
		DECLARE @ErrorState INT;

		SELECT
			@ErrorMessage = ERROR_MESSAGE(),
			@ErrorSeverity = ERROR_SEVERITY(),
			@ErrorState = ERROR_STATE();
		
		RAISERROR (@ErrorMessage, -- Message text.
				   @ErrorSeverity, -- Severity.
				   @ErrorState -- State.
				   );
	END CATCH
END
go

end;