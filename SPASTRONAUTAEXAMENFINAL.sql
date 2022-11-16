--julio anthony engels ruzi coto 

--ingreso a tripulante


--Crear un procedimiento de carga para los TRIPULANTES de un viaje.  
--Donde reciba de parámetro lo siguiente:

 --Nombre del astronauta
--Fecha de salida del viaje y el país
--(se asume que solamente exista un viaje por fecha/país: 
--agregue la regla respectiva en la base de datos).

create or alter procedure carga_para_tripulantes(@nombre varchar(50),@fecha_salida date,@pais varchar(50))
AS
BEGIN
    SET NOCOUNT ON;

	declare @contador int, @idviaje int,@fecha date,@nuevonumviajes int, @viajeestatus varchar(50)
	select @fecha = getdate()

	BULK INSERT astronauta
	FROM 'D:\Escritorio\astronautas.csv'
	WITH
	(
		FIRSTROW = 2, 
		FIELDTERMINATOR = ',',  
		ROWTERMINATOR = '\n',  
		TABLOCK
	)

	begin try
	begin tran
		--se asume que solamente exista un viaje por fecha/país
		select @pais = min(pais),@contador = count(pais)
		from astronauta (holdlock)
		where pais = @pais
		group by pais

		if @contador > 1
			begin
				;
				throw 50000,'El pais no se puede repetir',1;
			end

		select @fecha_salida = min(fechasalida),@contador = count(fechasalida)
		from viaje (xlock)
		where fechasalida = @fecha_salida
		group by fechasalida
		
		if @contador > 1
			begin
				;
				throw 50000,'La fecha no se puede repetir',1;
			end
		select @contador = 0

--Para poder aceptar al astronauta en el viaje, debe cumplir con:
--El astronauta no puede estar en un viaje en proceso (según su fecha salida y fecha llegada) (R3)
--Nombre astronauta válido (R1)
		select @nombre = min(nombre),@contador = count(nombre)
		from astronauta (holdlock)
		where nombre = @nombre
		group by nombre
		
		if @contador > 1
			begin
				;
				throw 50000,'El nombre del usuario no se puede repetir',1;
			end
		select @contador = 0

		-- Debe existir el viaje (combinación base y fecha). (R2)
		if exists (select * from astronauta where nombre = @nombre)
		begin
			if exists(select* from viaje where idviaje = @idviaje)
			begin 
				if exists(select* from viaje where viajestatus = @viajeestatus and viajestatus = 'en proceso')
				begin 

					select vj.idviaje,vj.idbase,vj.fechasalida,vj.fechallegada
					from viaje vj(xlock)
					inner join base b (xlock) on vj.idbase = b.idbase
					where vj.idviaje = @idviaje and vj.fechasalida != @fecha


					--Si el astronauta es aceptado en la misión, debe aumentar el número de viajes en la columna respectiva. (A1)
					SET @nuevonumviajes= (SELECT num_viajes FROM astronauta WHERE num_viajes > 0) + 1
					UPDATE astronauta SET num_viajes = @nuevonumviajes WHERE num_viajes > 0
				end
				else
				begin
					rollback
					;
					throw 50000,'El astronauta no es aceptado',1
				end
			end
			else
			begin 
				rollback
				;
				throw 50000,'El viaje no existe',1
			end
		end
		else
		begin 
			rollback
			;
			throw 50000,'El nombre del astronauta no existe',1
		end
		
		
	end try
	begin catch
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

END
GO

exec carga_para_tripulantes 'julio','2022/11/14','guatemala'

exec carga_para_tripulantes 'julio','2022/11/14','guatemala'

exec carga_para_tripulantes 'elias','2022/11/14','mexico'

drop procedure carga_para_tripulantes