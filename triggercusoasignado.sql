--Crear un trigger en la tabla CursoAsignado que no permita asignar a un estudiante al mismo curso (no importa la sección)
--, puede agregar una validación para que solo se pueda insertar una tupla a la vez.

create trigger tg_cursoasignado on cursoasignado after insert
as 
begin
	set nocount on;
	declare @contador int, @idcurso int, @idestudiante int




	select @contador = count(*), @idcurso = min(cp.idcurso),@idestudiante = min(i.idestudiante)
	from inserted i
	inner join cursoprogramado cp (holdlock) on cp.idcursoprogramado = i.idcursoprogramado

	if @contador > 1
	begin
		;
		throw 50000, 'No es posible insertar mas de una tupla ',1
	end

	select @contador = 0

	select @contador = count(*)
	from cursoasignado ca (xlock)
	inner join cursoprogramado cp (holdlock) on cp.idcursoprogramado = ca.idcursoprogramado
	where ca.idestudiante = @idestudiante and cp.idcurso = @idcurso

	if @contador > 1
	begin
		;
		throw 50000, 'El estudiante que inserto ya se encuentra en la tabla',1
	end


end
go
drop trigger tg_cursoprogramado
