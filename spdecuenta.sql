
create or alter procedure creacion_cuenta_nueva(@nombrecuenta varchar(100),@nocuenta varchar(10))
AS
BEGIN
    SET NOCOUNT ON;

	declare @idcuenta int,@saldo decimal(10,2),@vigente bit,@contador int
	select @contador = 0
	select @saldo = 0.00
	select @vigente = 1

	begin try
	begin tran
		select @nocuenta = min(nocuenta),@contador = count(nocuenta)
		from cuenta (holdlock)
		where nocuenta = @nocuenta
		group by nocuenta

		if @contador > 1
			begin
				;
				throw 50000,'El numero de cuenta no puede ser repetido',1;
			end
		else
			begin
				insert cuenta(nombrecuenta,nocuenta,saldo,vigente)
				values (@nombrecuenta,@nocuenta,@saldo,@vigente)

				commit
				print 'La cuenta se creo en el sistema'
			end
		select @contador = 0

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

exec creacion_cuenta_nueva 'julio','1234'
exec creacion_cuenta_nueva 'maritza','0956'
exec creacion_cuenta_nueva 'elxoxas','8767'
drop procedure creacion_cuenta_nueva


create or alter procedure cobro_cheque(@nocuenta varchar(10),@nodocumento varchar(10),@monto decimal(10,2),@usuario varchar(50))
AS
BEGIN
    SET NOCOUNT ON;

	declare @idcuenta int,@nuevolimiteoperaciones int,@nuevomontorestante decimal(10,2),@contador int
	select @contador = 0

	begin try
	begin tran
		select @nodocumento = min(@nodocumento),@contador = count(@nodocumento)
		from cuentadetalle (holdlock)
		where nodocumento = @nodocumento and nodocumento = '1'
		group by nodocumento

		if @contador > 1
			begin
				;
				throw 50000,'El no.de cheque solo puede ser cobrado una vez',1;
			end
		
		select @contador = 0

		--la cuenta debe tener un saldo mayor o igual al monto del cheque y estar vigente
		--el límite de operaciones debe ser mayor o igual 1.
		if exists (select * from cuenta where nocuenta = @nocuenta)
		begin
			if exists (select* from cuenta where nocuenta = @nocuenta and vigente = 1 )
			begin
				if exists (select* from cuenta where nocuenta = @nocuenta and saldo >= @monto)
				begin 
					if exists(select* from cuentadetalle where nodocumento = @nodocumento )
					begin
						if exists(select * from tipodocumento where idtipodocumento = 1 and limiteoperacion >= 0)
						begin
							select @idcuenta = (select idcuenta from cuenta where nocuenta = @nocuenta)
							insert into cuentadetalle(idcuenta,idtipodocumento,nodocumento,monto ,fechahora,usuario)
							values(@idcuenta,1,@nodocumento,@monto,getdate(),@usuario)

							select @nuevolimiteoperaciones = (select limiteoperacion from tipodocumento where idtipodocumento = 1) - 1
							update tipodocumento set limiteoperacion = @nuevolimiteoperaciones where idtipodocumento = 1

							select @nuevomontorestante = (select saldo from cuenta where nocuenta = @nocuenta ) - @monto
							update cuenta set saldo = @nuevomontorestante where nocuenta = @nocuenta

							commit 
								PRINT('COBRO DE CHEQUE REALIZADO CON EXITO')
								PRINT('MONTO A COBRAR: ' + CAST(@monto AS VARCHAR))
								PRINT('NO. DE CUENTA: ' + @nocuenta)
								PRINT('EL USUARIO QUE REALIZÓ EL COBRO FUE ' + @usuario + ' CON EL NÚMERO DE DOCUMENTO: ' + @nodocumento)
								PRINT('MONTO RESTANTE: '+ CAST(@nuevomontorestante AS VARCHAR))
								PRINT('LIMITE DE OPERACIONES RESTANTES PARA EL TIPO DE DOCUMENTO: '+ CAST(@nuevolimiteoperaciones AS VARCHAR))
						end
					end
					else
					begin
						;
						throw 50000, 'El tipo de documento tiene que ser cheque',1
					end
				end
				else
				begin
				;
				throw 50000, 'La cuenta tiene un saldo menor al monto del cheque',1
				end
			end
			else
				begin
				;
				throw 50000, 'La cuenta no se encuentra vigente',1
				end
		end
		else
			begin
				;
				throw 50000, 'La cuenta no exite',1
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

exec cobro_cheque '1234','1',10.2,'eljulios'

drop procedure cobro_cheque


create or alter procedure deposito(@nocuenta varchar(10),@nodocumento varchar(10),@monto decimal(10,2),@usuario varchar(50))
AS
BEGIN
    SET NOCOUNT ON;

	declare @idcuenta int,@saldo decimal(10,2),@vigente bit,@contador int
	select @contador = 0
	select @saldo = 0.00
	select @vigente = 1

	begin try
	begin tran
		select @nocuenta = min(nocuenta),@contador = count(nocuenta)
		from cuenta (holdlock)
		where nocuenta = @nocuenta
		group by nocuenta

		if @contador > 1
			begin
				;
				throw 50000,'El numero de cuenta no puede ser repetido',1;
			end
		else
			begin
				insert cuenta(nombrecuenta,nocuenta,saldo,vigente)
				values (@nombrecuenta,@nocuenta,@saldo,@vigente)

				commit
				print 'La cuenta se creo en el sistema'
			end
		select @contador = 0

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
