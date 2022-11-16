CREATE TRIGGER ti_CursoAsignado
   ON  CursoAsignado
   AFTER INSERT
AS 
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	Declare @contador int, @idCurso int, @idEstudiante int
	
	Select @contador = count(*), @idCurso = min(cp.idCurso), @idEstudiante = min(i.idEstudiante)
	From Inserted i 
	Inner Join CursoProgramado cp (Holdlock) on (cp.IdCursoProgramado = i.IdCursoProgramado)

	IF @contador > 1
	Begin
		;
		THROW 50000, 'tu_CursoAsignado: No es posible insertar más de una tupla en la tabla CursoAsignado.', 1;
	End

	Select @contador = 0

	Select @contador = count(*)
	From CursoAsignado ca (xlock)  
	Inner Join CursoProgramado cp (holdlock) on (cp.IdCursoProgramado = ca.IdCursoProgramado)
	Where ca.IdEstudiante = @idEstudiante and
			cp.IdCurso = @idCurso

	IF @contador > 1
	Begin
		;
		THROW 50000, 'tu_CursoAsignado: El estudiante no puede asignarse dos veces al mismo curso.', 1;
	End

END
GO

create procedure usp_modificaCurso (@NombreCurso varchar(50), @Carnet varchar(10), @NuevaSeccion smallint)
as
Begin
	Declare @idCurso int, @idEstudiante int, @contador int, @idCursoProgramado int, @cupo int, @cantidadInscritos int
	Select @idCursoProgramado = 0, @contador = 0, @cupo = 0
	
	Begin Try
		
		Begin Tran 
		Select @idEstudiante = Min(idEstudiante), @contador = count(idEstudiante)
		from Estudiante (holdlock) 
		where Carnet = @Carnet
		group by carnet

		IF @contador > 1
		Begin
			;
			THROW 50000, 'Existe más de un estudiante con el mismo número de carnet.', 1;
		End

		Select @contador = 0

		Select @idCurso = Min(idCurso), @contador = count(idCurso)
		From Curso (holdlock) 
		where Nombre = @NombreCurso
		group by Nombre

		IF @contador > 1
		Begin
			;
			THROW 50000, 'Existe más de un curso con el mismo nombre.', 1;
		End

		Select @idCursoProgramado = IdCursoProgramado, @cupo = Cupo
		From CursoProgramado (xlock)
		Where idCurso = @idCurso and
				NoSeccion = @NuevaSeccion

		IF @idCursoProgramado = 0 
		Begin 
			;
			THROW 50000, 'El curso no está programado.', 1;
		End 

		Select @contador = 0

		Select @contador = count(*)
		From CursoAsignado (holdlock)
		Where IdCursoProgramado = @idCursoProgramado 

		IF @contador < @cupo
		Begin
/*print 'antes de insertar 1'
WaitFor Delay '00:00:01'*/

			Update CursoAsignado 
			Set IdCursoProgramado = @idCursoProgramado, FechaHora = GetDate()
			From CursoAsignado ca (xlock)  
			Inner Join CursoProgramado cp (holdlock) on (cp.IdCursoProgramado = ca.IdCursoProgramado)
			Where ca.IdEstudiante = @idEstudiante and
					cp.IdCurso = @idCurso 

			Commit
			Print 'Curso modificado exitosamente.'
		End
		Else
		Begin
			;
			THROW 50000, 'El cupo está lleno en la sección destino.', 1;
		End

	End Try
	Begin Catch
		Rollback

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
	End Catch
End
go

create procedure usp_asignaCurso (@NombreCurso varchar(50), @Carnet varchar(10), @Seccion smallint)
as
Begin
	Declare @idCurso int, @idEstudiante int, @contador int, @idCursoProgramado int, @cupo int, @cantidadInscritos int
	Select @idCursoProgramado = 0, @contador = 0, @cupo = 0
	
	Begin Try
		
		Begin Tran Asignar

		Select @idEstudiante = Min(idEstudiante), @contador = count(idEstudiante)
		from Estudiante (holdlock) 
		where Carnet = @Carnet
		group by carnet

		IF @contador > 1
		Begin
			;
			THROW 50000, 'Existe más de un estudiante con el mismo número de carnet.', 1;
		End

		Select @contador = 0

		Select @idCurso = Min(idCurso), @contador = count(idCurso)
		From Curso (holdlock) 
		where Nombre = @NombreCurso
		group by Nombre

		IF @contador > 1
		Begin
			;
			THROW 50000, 'Existe más de un curso con el mismo nombre.', 1;
		End

		Select @idCursoProgramado = IdCursoProgramado, @cupo = Cupo
		From CursoProgramado (xlock)
		Where idCurso = @idCurso and
				NoSeccion = @Seccion

		IF @idCursoProgramado = 0 
		Begin 
			;
			THROW 50000, 'El curso no está programado.', 1;
		End 

		Select @contador = 0

		Select @contador = count(*)
		From CursoAsignado (holdlock)
		Where IdCursoProgramado = @idCursoProgramado 

		IF @contador < @cupo
		Begin
/*print 'antes de insertar 1'
WaitFor Delay '00:00:01'*/

			Insert CursoAsignado (IdCursoProgramado, IdEstudiante, FechaHora) 
			Values (@idCursoProgramado, @idEstudiante, GetDate())

			Commit
			Print 'Curso asignado exitosamente.'
		End
		Else
		Begin
		-- No hay cupo, se busca otra sección (asumiendo que solo pueden existir 2 secciones como máximo)
			Select @idCursoProgramado = IdCursoProgramado, @cupo = Cupo
			From CursoProgramado (xlock)
			Where idCurso = @idCurso and
					NoSeccion <> @Seccion

			IF @idCursoProgramado = 0 
			Begin 
				;
				THROW 50000, 'El cupo está lleno y no existe otra sección programada.', 1;
			End 

			Select @contador = 0

			Select @contador = count(*)
			From CursoAsignado (holdlock)
			Where IdCursoProgramado = @idCursoProgramado 

			IF @contador < @cupo
			Begin
/*print 'antes de insertar 2'
WaitFor Delay '00:00:01'*/
				Insert CursoAsignado (IdCursoProgramado, IdEstudiante, FechaHora) 
				Values (@idCursoProgramado, @idEstudiante, GetDate())

				Commit
				Print 'Curso asignado exitosamente en otra sección pues el cupo estaba lleno.'
			End
			Else
			Begin
				;
				THROW 50000, 'El cupo está lleno en las 2 secciones.', 1;
			End
			
		End

	End Try
	Begin Catch
		Rollback

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
	End Catch
End
go
