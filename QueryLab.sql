CREATE or ALTER PROCEDURE MODIFICA_ASIGNACION(@NombreCurso varchar(50), @Carnet varchar(10), @NuevaSeccion int) AS
BEGIN
	DECLARE @CantSec int, @CantCurso int, @CupoCMP int, @ValidaCarnet int, @idEst int, @idCurs int, @idCursPro int
	BEGIN TRAN
		select @CantCurso = COUNT(*)
		from CursoProgramado CP(Holdlock)
		inner join Curso C on CP.idCurso = C.idCurso
		where @NombreCurso = C.Nombre

		select @idCurs = C.idCurso, @idCursPro = idCursoProgramado
		from CursoProgramado CP
		inner join Curso C on CP.idCurso = C.idCurso
		where @NombreCurso = C.Nombre

		if(@CantCurso > 1)
		begin
			select @CupoCMP = MIN(CP.Cupo)
			from CursoProgramado CP
			inner join Curso C on CP.idCurso = C.idCurso
			where @NombreCurso = C.Nombre and @NuevaSeccion = CP.NoSeccion

			if(@CupoCMP != 0)
			begin
				select @ValidaCarnet = COUNT(*)
				from CursoAsignado CA(xlock)
				inner join Estudiante E on CA.idEstudiante = E.idEstudiante
				where @Carnet = E.Carnet

				select @idEst = E.idEstudiante
				from CursoAsignado CA(xlock)
				inner join Estudiante E on CA.idEstudiante = E.idEstudiante
				where @Carnet = E.Carnet

				if(@ValidaCarnet = 1)
				begin
					update CursoProgramado
						set Cupo = Cupo - 1
						where idCurso = @idCurs and NoSeccion = @NuevaSeccion

					update CursoAsignado
						set idCursoProgramado = @idCursPro, FechaHora = GETDATE()
						where idEstudiante = @idEst
						
					commit
					;Throw 50000, 'Estudiante transferido de seccion con exito', 1
				end
				else
				begin
					rollback
					;Throw 50000,'Error, no existe, o existe mas de un estudiante con el número de carnet', 1
				end
			end
			else
			begin
				rollback
				;Throw 50000, 'No hay cupo', 1
			end
		end
		else
		begin
			rollback
			;Throw 50000,'Curso no existe o solamente existe una seccion', 1
		end

END
GO


exec MODIFICA_ASIGNACION 'Matematica', '1307419', 2

select *
from Curso

select *
from CursoProgramado

select *
from Estudiante

insert into Estudiante(Carnet, Nombre)
values('12345678', 'Oscar Rivera')

select *
from CursoAsignado

insert into Curso(Nombre)
values('Compu')

insert into CursoProgramado(idCurso, NoSeccion, Cupo)
values(1, 1, 10)

update CursoProgramado
	set NoSeccion = 2
	where idCursoProgramado = 1

update CursoProgramado
	set Cupo = 0
	where idCursoProgramado = 1

insert into CursoAsignado(idCursoProgramado, idEstudiante, FechaHora)
values(3, 2, GETDATE())

update CursoAsignado
	set idCursoAsignado = 1
	where idEstudiante = 1