USE [Proyecto]
GO
/****** Object:  StoredProcedure [dbo].[spReservarAsiento]    Script Date: 7/11/2022 22:18:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
ALTER  PROCEDURE [dbo].[spReservarAsiento](@idVuelo int, @NoAsiento int, @idPasajero int)  
AS
BEGIN
	begin tran
	--comprobar que el vuelo esté activo
	if (select Estatus from Vuelo where idVuelo = @idVuelo) = 1
	begin
		--asiento no reservado 
		if (select idTipoEstatus from VueloPasajero with (holdlock) where NoAsiento = @NoAsiento and @idVuelo = idVuelo) = 1
		begin
			declare @fechas smalldatetime, @fechal smalldatetime
			set @fechas = (select FechaSalida from Vuelo where idVuelo = @idVuelo) 
			set @fechal = (select FechaLlegada from Vuelo where idVuelo = @idVuelo)
			--reservación de asiento si no está en otro vuelo al mismo tiempo
			if not exists (select * from Vuelo inner join VueloPasajero on Vuelo.idVuelo = VueloPasajero.idVuelo where idPasajero = @idPasajero and (FechaSalida between @fechas and @fechal) and (FechaLlegada between @fechas and @fechal))
			begin
				update VueloPasajero
				set idTipoEstatus = 2, Fecha = GETDATE(), idPasajero = @idPasajero
				where NoAsiento = @NoAsiento and idVuelo = @idVuelo
				commit
			end;
			else
			begin
				RAISERROR ('Pasajero en otro vuelo distinto',16, 1)
				rollback
			end;
		end;
		else 
		begin
			--asiento reservado

			if (select idTipoEstatus from VueloPasajero with (holdlock) where NoAsiento = @NoAsiento and @idVuelo = idVuelo) = 2
			begin 
				--verificar tiempo de reserva
				if DATEDIFF(MINUTE,(select Fecha from VueloPasajero where NoAsiento = @NoAsiento and @idVuelo = idVuelo), GETDATE()) > 5 
				begin
					--si ya excedió el tiempo de reserva se cambia el pasajero
					update VueloPasajero
					set Fecha = GETDATE(), idPasajero = @idPasajero
					where NoAsiento = @NoAsiento and idVuelo = @idVuelo
					commit
				end;
				else 
				begin
					RAISERROR ('Asiento ya reservado', 16, 1)
					rollback
				end;
			end;
			else 
			begin
				RAISERROR ('Asiento Confirmado', 16, 1)
				rollback
			end;
		end;
	end;
	else
	begin
		RAISERROR ('Vuelo cancelado, no es posible reservar asientos',16, 1)
		rollback
	end;
	
END
