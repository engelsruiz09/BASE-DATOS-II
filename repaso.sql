
create table estudiante(
		idestudiante int identity(1,1),
		carnet varchar(10),
		nombre varchar(100)

		constraint PK_ESTUDIANTE PRIMARY KEY(idestudiante),
)
create table curso(
		idcurso int identity(1,1),
		nombre varchar(50)

		constraint pk_curso primary key(idcurso),

)
create table cursoprogramado(
		idcursoprogramado int identity(1,1),
		idcurso int,
		noseccion smallint,
		cupo int

		constraint pk_cursoprogramado primary key(idcursoprogramado),
		constraint fk_curso foreign key(idcurso) references curso(idcurso)

)

create table cursoasignado(
		idcursoasignado int identity(1,1),
		idcursoprogramado int,
		idestudiante int,
		fecha_hora datetime

		constraint pk_cursoasignado primary key(idcursoasignado),
		constraint fk_cursoprogramado foreign key(idcursoprogramado) references cursoprogramado(idcursoprogramado),
		constraint fk_estudiante foreign key(idestudiante) references estudiante(idestudiante),


)

drop table estudiante

insert into estudiante(carnet,nombre) values('1284719','julio romo')
insert into estudiante(carnet,nombre) values('1284718','chepe soto')
insert into estudiante(carnet,nombre) values('1284720','elediie ramirez')
insert into estudiante(carnet,nombre) values('1282721','el pato')
select* from estudiante

insert into curso(nombre) values('estadistica')
insert into curso(nombre) values('microprogramacion')
insert into curso(nombre) values('arquitectura del computador')
insert into curso(nombre) values('base de datos')
select* from curso

insert into cursoprogramado(idcurso,noseccion,cupo) values(2,3,45)
insert into cursoprogramado(idcurso,noseccion,cupo) values(3,3,45)
insert into cursoprogramado(idcurso,noseccion,cupo) values(1,3,45)
insert into cursoprogramado(idcurso,noseccion,cupo) values(4,3,45)
select* from cursoprogramado

insert into cursoasignado(idcursoprogramado,idestudiante,fecha_hora) values(1,2,getdate())
insert into cursoasignado(idcursoprogramado,idestudiante,fecha_hora) values(2,1,getdate())
insert into cursoasignado(idcursoprogramado,idestudiante,fecha_hora) values(3,3,getdate())
insert into cursoasignado(idcursoprogramado,idestudiante,fecha_hora) values(4,4,getdate())
select* from cursoasignado

--=====================================================================================================================
--Crear un SP que permita modificar la asignación de un estudiante (únicamente cambiar de sección de un curso), 
--para esto debe recibir como parámetro el Nombre del curso asignado, Carnet del estudiante y el número de sección 
--a la cual se desea trasladar.

create or alter procedure modificar_asignacion (@nombre_curso varchar(50),@carnet varchar(10),@noseccion smallint)
as begin
	declare @idestudiante int,@contar int,@idcurso int,@idcursoprogramado int,@cupo int
	select @contar = 0,@cupo = 0,@idcursoprogramado = 0

	begin try
		begin tran 
			---	No exista más de un estudiante con el mismo carnet 
			select @idestudiante = min(idestudiante),@contar = count(idestudiante)
			--debe evitar se inserte otro curso o carnet repetido mientras se ejecuta su transacción
			from estudiante (holdlocK) 
			where carnet = @carnet
			group by carnet

			if(@contar > 1)
			begin 
				;
				THROW 50000, 'Existe más de un estudiante con el mismo número de carnet.', 1;
			end
			set @contar = 0

			--y más de un curso con el mismo nombre
			select @idcurso = min(idcurso),@contar = count(idcurso)
			--debe evitar se inserte otro curso o carnet repetido mientras se ejecuta su transacción
			from curso (holdlocK) 
			where idcurso= @idcurso
			group by idcurso

			if(@contar > 1)
			begin 
				;
				THROW 50000, 'El nombre del curso ya existe', 1;
			end

			---	La sección a la que se desea trasladar al estudiante esté programada (exista en CursoProgramado)
			select @idcursoprogramado = idcursoprogramado,@cupo = cupo
			from cursoprogramado (xlock)
			where idcurso = @idcurso and noseccion = @noseccion

			if @idcursoprogramado = 0
			begin
				;
				THROW 50000, 'El curso no esta programado', 1;
			end

			---	La sección destino aún tenga cupo: para esto, en la tabla CursoProgramado existe un atributo
			--con la cantidad máxima de alumnos, debe contar cuántos están inscritos en esa sección y comparar
			--con este atributo.
			select @contar = 0

			select @contar = count(*)
			from cursoasignado(holdlock)
			where idcursoprogramado = @idcursoprogramado

			if @contar < @cupo
			begin 
				insert cursoasignado(idcursoprogramado,idestudiante,fecha_hora)
				values(@idcursoprogramado,@idestudiante,getdate())

				commit
					print 'curso asignado exitosamente'
			end
			else
			begin
				--si no hay cupo se busca otra seccion solo puede existir 2 seccions como maximo
				select @idcursoprogramado = idcursoprogramado, @cupo = cupo
				from cursoprogramado(xlock)
				where idcurso = @idcurso and noseccion <> @noseccion

				if @idcursoprogramado = 0
				begin
					;
					THROW 50000, 'El cupo esta lleno y no existe otra seccion programada', 1;
				end
			select @contar = 0

			select @contar = count(*)
			from cursoasignado (holdlock)
			where idcursoprogramado = @idcursoprogramado

			if @contar < @cupo
			begin 
				insert cursoasignado(idcursoprogramado,idestudiante,fecha_hora)
				values(@idcursoprogramado,@idestudiante,getdate())

				commit
				print 'curso asignado exitosamente en otra seccion cupo estaba lleno'
			end
			else
			begin
				;
				throw 50000, 'El cupo en las dos secciones esta lleno',1;
			end
			end
	end try
	begin catch
		rollback;
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
	end catch
end
go

drop procedure dbo.modificar_asignacion

exec modificar_asignacion 'microprogramacion','1284720','3'
