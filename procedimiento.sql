--===============EJERCICIO=========================================
--===========JULIO ANTHONY ENGELS RUIZ COTO - 1284719==============
--CREAR UNA FUNCION QUE RECIBA COMO PARAMETRO UN RANGO DE FECHAS (FECHA Y HORA ) Y REGRESE COMO RESULTADO EL NUMERO TOTAL
--DE HORAS LABORALES. X-DIAS LABORALES= LUNES-JUEVES. X-HORAS LABORALES: 8:00 A 17:00
go
CREATE OR ALTER FUNCTION dbo.calcular_horas_laborables
(@inicio datetime, @fin datetime)
RETURNS int
WITH EXECUTE AS CALLER
AS
BEGIN
    DECLARE 
	@horas int = 0,
	@temp date,
	@dia varchar(50),
	@hora_inicio int,
	@hora_fin int


	--Asignamos la fecha
	set @temp = convert(date, @inicio)
	
	--Si las fechas son el mismo día
	if(@temp = CONVERT(date,@fin))
	begin
		set @hora_inicio = datepart(hour, @inicio)
		set @hora_fin = datepart(hour, @fin)

		if @hora_inicio > @hora_fin or @hora_fin < 8 or @hora_inicio >=17
		begin
			set @horas = 0;
		end
		else
		begin
			if @hora_inicio < 8
			begin
				set @hora_inicio = 8;
			end

			if @hora_fin > 17
			begin
				set @hora_fin = 17
			end

			set @horas = @hora_fin - @hora_inicio;
		end
	end
	else
	begin
		--Si la fecha fin es mayor a la fecha inicial
		while(@temp <= @fin)
		begin
			/*
			1 - Domingo
			2 - Lunes
			3 - Martes
			4 - Miércoles
			5 - Jueves
			6 - Viernes
			7 - Sábado
			*/
			if datepart(dw,@temp) > 1 and datepart(dw,@temp) < 6 --dw = weekday devuelve un numero correspondiente al dia de la semana
			begin
				if @temp = CONVERT(date,@fin)
				begin
					if datepart(hour, @fin) > 8
						begin
							if datepart(hour, @fin) >= 17
							begin
								set @horas = @horas + 8
							end
							else
							begin
								set @horas = @horas + (datepart(hour, @fin) - 8) - 1
							end
						end
				end
				else
				begin
					if @temp = CONVERT(date,@inicio)
					begin
						set @hora_inicio = datepart(hour, @inicio)
						if @hora_inicio <= 8
						begin
							set @horas = @horas + 8
						end
						else
						begin
							if @hora_inicio < 17
							begin
								set @horas = @horas + (17 - @hora_inicio) - 1
							end
						end
					end
					else
					begin
						set @horas = @horas + 8
					end
				end
			end
			set @temp = dateadd(day,1,@temp) --dateadd añade un dia al temp
		end
	end
	

    RETURN @horas;
END;

go
SELECT dbo.calcular_horas_laborables('2022-09-05 9:00','2022-09-12 17:00') as horas;