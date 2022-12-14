USE [Proyecto]
GO
/****** Object:  StoredProcedure [dbo].[spConfirmarAsiento]    Script Date: 7/11/2022 22:45:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[spConfirmarAsiento](@idPasajero int, @idVuelo int, @NoAsiento int)
AS
BEGIN
	begin tran
	--primero comprobamos que el pasajero esté en el vuelo y que haya reservado el asiento 
	if (select idPasajero from VueloPasajero where idVuelo = @idVuelo and NoAsiento = @NoAsiento) = @idPasajero
	begin
		--comprobamos que la hora de reserva sea menor a 5 min
		DECLARE @FECHA smalldatetime
		SET @FECHA = (select Fecha from VueloPasajero where @NoAsiento = NoAsiento and idVuelo = @idVuelo)
		if DATEDIFF(MINUTE, @FECHA , GETDATE()) <= 5 
		BEGIN 
			--si está dentro del rango, se verifica que el asiento unicamente esté reservado
			if (select idTipoEstatus from VueloPasajero where  @NoAsiento = NoAsiento and idVuelo = @idVuelo) = 2
			begin
				--confirmamos asiento
				update VueloPasajero
				set idTipoEstatus = 3
				where  @NoAsiento = NoAsiento and idVuelo = @idVuelo
				commit tran
			end;
			else
			begin
				RAISERROR ('Asiento ya confirmado previamente', 16, 1)
				rollback
			end;
		END;
		else
		begin
			-- vaciamos asiento
			update VueloPasajero
			set idTipoEstatus = 0, Fecha = NULL, idPasajero = NULL
			commit tran	
		end;
	end;
	else
	begin
		RAISERROR ('Asiento ya confirmado', 16, 1)
		rollback
	end;
END