CREATE OR ALTER PROCEDURE usp_crear_cuenta (@NombreCuenta varchar(100), @NoCuenta varchar(10)) 
AS
BEGIN
	
	BEGIN TRAN 

		-- Si existe la cuenta no insertar y salir
		IF EXISTS(
					Select 1
					From Cuenta (holdlock)
					Where NoCuenta = @NoCuenta
					)
			BEGIN

				Print 'Debug: La cuenta ya existe, esperamos 5 segundos'
				WaitFor Delay '00:00:05'

				ROLLBACK
				Print 'El número de la cuenta ya existe, no se realizó la operación.'
			END
		ELSE
			BEGIN

			Print 'Debug: No existe la cuenta esperamos 5 segundos'
			WaitFor Delay '00:00:05'
			
			Insert Into Cuenta (NombreCuenta, NoCuenta, Saldo, Vigente) 
			Values (@NombreCuenta, @NoCuenta, 0, 1)
				IF @@error <> 0 
					BEGIN
						Print 'Debug: Hubo error al insertar, esperamos 5 segundos'
						WaitFor Delay '00:00:05'

						ROLLBACK
						PRINT 'Error al insertar la cuenta.'
					END
				ELSE
					BEGIN
						Print 'Debug: todo bien, esperamos 5 segundos'
						WaitFor Delay '00:00:05'

						COMMIT
						PRINT 'Cuenta creada exitosamente.'
					END
			END
END
go

CREATE OR ALTER PROCEDURE usp_cheque (@NoCuenta varchar(10), @NoDocumento varchar(10), @Monto decimal(10,2), @Usuario varchar(50)) 
AS
BEGIN

	DECLARE @limite int
	DECLARE @idCuenta int
	DECLARE @saldo decimal(10,2)
	DECLARE @vigente bit
	DECLARE @existe int
	DECLARE @idTipoDocumento int = 1
	
	BEGIN TRAN 

	BEGIN TRY

		Select	@limite = LimiteOperaciones
		From	TipoDocumento (xlock) 
		Where	idTipoDocumento = @idTipoDocumento

		IF @limite <= 0
		Begin
			;
			THROW 50000, 'Se alcanzó el límite de transacciones para cobro de cheque.', 1;
		End

		Select	@idCuenta = idCuenta, @saldo = Saldo, @vigente = Vigente
		From	Cuenta (xlock) 
		Where	NoCuenta = @NoCuenta

		Select	@existe = COUNT(*) 
		From	CuentaDetalle (holdlock) 
		Where	NoDocumento = @NoDocumento and
				idTipoDocumento = @idTipoDocumento

		Print 'Debug: select de existe, esperamos 5 segundos'
		WaitFor Delay '00:00:05'
		
		IF @vigente = 0 
		Begin
			;
			THROW 50000, 'La cuenta no está vigente.', 1;
		End

		IF @saldo < @Monto
		Begin 
			;
			THROW 50000, 'El saldo de la cuenta es insuficiente.', 1;
		End

		IF @existe > 0
		Begin 
			;
			THROW 50000, 'El cheque ya fue cobrado.', 1;
		End

		Insert CuentaDetalle (idCuenta, idTipoDocumento, NoDocumento, Monto, FechaHora, Usuario)
		Values(@idCuenta, @idTipoDocumento, @NoDocumento, @Monto, GETDATE(), @Usuario)

		Update Cuenta 
		Set Saldo = Saldo - @Monto
		Where idCuenta = @idCuenta

		Update TipoDocumento
		Set LimiteOperaciones = LimiteOperaciones - 1
		Where idTipoDocumento = @idTipoDocumento

		Commit Tran
		Print 'Cheque cobrado exitosamente, el saldo de la cuenta es: ' + convert(varchar,	@saldo - @Monto)

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