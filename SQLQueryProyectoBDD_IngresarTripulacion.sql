CREATE OR ALTER PROCEDURE dbo.SP_INGRESAR_TRIPULACION(@PASAJERO INT, @VUELO INT)
AS BEGIN
BEGIN TRAN
BEGIN TRY
	DECLARE @FECHAS SMALLDATETIME,
			@FECHAL SMALLDATETIME

	SELECT @FECHAS = FechaSalida FROM Vuelo WHERE idVuelo = @VUELO
	SELECT @FECHAL = FechaLlegada FROM Vuelo WHERE idVuelo = @VUELO
	IF NOT EXISTS(SELECT * FROM VueloPasajero (XLOCK) WHERE idVuelo = @VUELO AND idPasajero = @PASAJERO)
	BEGIN
		IF NOT EXISTS(SELECT * FROM Vuelo INNER JOIN VueloPasajero ON Vuelo.idVuelo = VueloPasajero.idVuelo WHERE idPasajero = @PASAJERO AND (FechaSalida BETWEEN @FECHAS AND @FECHAL OR FechaLlegada BETWEEN @FECHAS AND @FECHAL))
		BEGIN
			INSERT INTO VueloPasajero(idVuelo, idPasajero)
			VALUES(@VUELO, @PASAJERO)
			COMMIT TRAN
		END
		ELSE
			THROW 51000, 'Un tripulante puede estar en un solo vuelo a la vez', 1;
	END
	ELSE
		THROW 50000, 'Tripulante ya est� asignado a este vuelo', 1;
END TRY
BEGIN CATCH
	THROW
	ROLLBACK TRAN
END CATCH;
END