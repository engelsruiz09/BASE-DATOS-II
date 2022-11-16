--RAFAEL ANDRÉS ALVAREZ MAZARIEGOS----1018419---
--JULIO ANTHONY ENGELS RUIZ COTO ----1284719---
--DATOS CUENTA
INSERT CUENTA 
(IdCuenta, NombreCuenta, NoCuenta, Saldo, Vigente)
VALUES 
(1, 'ALVAREZ MAZARIEGOS RAFAEL ANDRÉS', '1018419111', 0.00, 1)
INSERT CUENTA 
(IdCuenta, NombreCuenta, NoCuenta, Saldo, Vigente)
VALUES 
(2, 'ARAGÓN LÓPEZ DIANA ALEJANDRA', '2530019111', 0.00, 1)
INSERT CUENTA 
(IdCuenta, NombreCuenta, NoCuenta, Saldo, Vigente)
VALUES 
(3, 'BARRIOS PÉREZ JULIO FERNANDO', '1005011111', 0.00, 1)
INSERT CUENTA 
(IdCuenta, NombreCuenta, NoCuenta, Saldo, Vigente)
VALUES 
(4, 'BECH FURLÁN KARL MARTIN', '1015920111', 0.00, 1)
INSERT CUENTA 
(IdCuenta, NombreCuenta, NoCuenta, Saldo, Vigente)
VALUES 
(5, 'BUSTAMANTE FREDY ALEXANDER', '0683811111', 0.00, 1)
INSERT CUENTA 
(IdCuenta, NombreCuenta, NoCuenta, Saldo, Vigente)
VALUES 
(6, 'DE LEÓN CHANG JOSÉ DANIEL', '1170419111', 0.00, 1)
INSERT CUENTA 
(IdCuenta, NombreCuenta, NoCuenta, Saldo, Vigente)
VALUES 
(7, 'ELÍAS COBAR DANIEL ALEJANDRO', '1247020111', 0.00, 1)
INSERT CUENTA 
(IdCuenta, NombreCuenta, NoCuenta, Saldo, Vigente)
VALUES 
(8, 'ELIZARDI GOBERN XIMENA STEPHANIA', '110172011', 0.00, 1)
INSERT CUENTA 
(IdCuenta, NombreCuenta, NoCuenta, Saldo, Vigente)
VALUES 
(9, 'FUENTES LOAIZA LEONEL ANTONIO', '121922011', 0.00, 1)
INSERT CUENTA 
(IdCuenta, NombreCuenta, NoCuenta, Saldo, Vigente)
VALUES 
(10, 'GIRÓN CARRANZA EDDIE ALEJANDRO', '1307419', 0.00, 1)

SELECT *FROM CUENTA
--DATOS TIPODOCUMENTO
INSERT TipoDocumento 
(IdTipoDocumento, Descripcion, Suma, LimiteOperacion)
VALUES 
(1, 'CHEQUE',0, 10)
INSERT TipoDocumento 
(IdTipoDocumento, Descripcion, Suma, LimiteOperacion)
VALUES 
(2, 'DEPOSITO',1, 10)
INSERT TipoDocumento 
(IdTipoDocumento, Descripcion, Suma, LimiteOperacion)
VALUES 
(3, 'TRANSFERENCIA DEBITO',0, 10)
INSERT TipoDocumento 
(IdTipoDocumento, Descripcion, Suma, LimiteOperacion)
VALUES 
(4, 'TRANSFERENCIACREDITO',1, 10)
SELECT *FROM TipoDocumento

--CUENTA DETALLE
INSERT CuentaDetalle 
(IdCuentaDetalle, IdCuenta, IdTipoDocumento, NoDocumento, Monto, FechaHora, Usuario)
VALUES 
(1, 1, 1, '12345', 0.00, GETDATE(), 'RANDRES')
INSERT CuentaDetalle 
(IdCuentaDetalle, IdCuenta, IdTipoDocumento, NoDocumento, Monto, FechaHora, Usuario)
VALUES 
(2, 2, 2, '23456', 0.00, GETDATE(), 'DIANAAR')
INSERT CuentaDetalle 
(IdCuentaDetalle, IdCuenta, IdTipoDocumento, NoDocumento, Monto, FechaHora, Usuario)
VALUES 
(3, 3, 3, '34567', 0.00, GETDATE(), 'JULIOBA')
INSERT CuentaDetalle 
(IdCuentaDetalle, IdCuenta, IdTipoDocumento, NoDocumento, Monto, FechaHora, Usuario)
VALUES 
(4, 4, 4, '45678', 0.00, GETDATE(), 'MARTINBE')
INSERT CuentaDetalle 
(IdCuentaDetalle, IdCuenta, IdTipoDocumento, NoDocumento, Monto, FechaHora, Usuario)
VALUES 
(5, 5, 2, '56789', 0.00, GETDATE(), 'FREDYBU')
INSERT CuentaDetalle 
(IdCuentaDetalle, IdCuenta, IdTipoDocumento, NoDocumento, Monto, FechaHora, Usuario)
VALUES 
(6, 6, 3, '67890', 0.00, GETDATE(), 'DANIELDE')
INSERT CuentaDetalle 
(IdCuentaDetalle, IdCuenta, IdTipoDocumento, NoDocumento, Monto, FechaHora, Usuario)
VALUES 
(7, 7, 4, '78901', 0.00, GETDATE(), 'DANIELED')
INSERT CuentaDetalle 
(IdCuentaDetalle, IdCuenta, IdTipoDocumento, NoDocumento, Monto, FechaHora, Usuario)
VALUES 
(8, 8, 1, '89012', 0.00, GETDATE(), 'XIMENAEL')
INSERT CuentaDetalle 
(IdCuentaDetalle, IdCuenta, IdTipoDocumento, NoDocumento, Monto, FechaHora, Usuario)
VALUES 
(9, 9, 2, '90123', 0.00, GETDATE(), 'LEONELFU')
INSERT CuentaDetalle 
(IdCuentaDetalle, IdCuenta, IdTipoDocumento, NoDocumento, Monto, FechaHora, Usuario)
VALUES 
(10, 10, 3, '01234', 0.00, GETDATE(), 'EDDIEGI')

SELECT * FROM CuentaDetalle CU
INNER JOIN TipoDocumento TI ON TI.IdTipoDocumento=CU.IdTipoDocumento
INNER JOIN Cuenta CUE ON CUE.IdCuenta=CU.IdCuenta


-------------------------------SP CREACION DE CUENTA-------------------------------
ALTER PROCEDURE CuentaCreacionNuevaCuenta(@id int, @NombreCuenta varchar (100), @NoCuenta varchar(10) ) AS
BEGIN
BEGIN TRAN
IF EXISTS (SELECT * FROM Cuenta WHERE NoCuenta=@NoCuenta)
BEGIN
IF EXISTS(SELECT * FROM Cuenta WHERE NombreCuenta=@NombreCuenta AND NoCuenta=@NoCuenta)
BEGIN 
rollback tran 
print'Si se encuentra en la db'
END
rollback tran 
END
ELSE 
BEGIN 
rollback tran 
print'No se encuentra en la base de datos'
INSERT INTO Cuenta (IdCuenta, NombreCuenta, NoCuenta, Saldo, Vigente)
VALUES (@id, @NombreCuenta, @NoCuenta, 0.00, 1)
COMMIT TRAN
END
END

exec CuentaCreacionNuevaCuenta 13,'ALVAREZ MAZARIEGOS RSSAA ANDÉS', '101841921'

SELECT *FROM CUENTA

DELETE FROM Cuenta 
WHERE IdCuenta = 11
------------------------SP COBRO DE CHEQUE-----------------------
CREATE OR ALTER PROCEDURE CobroDeCheque (@idCuentaDeta int, @NoCuenta varchar(10), @NoDocumento varchar(10), @MMonto decimal(10,2), @Usuario varchar(50)) AS
BEGIN
BEGIN TRAN
DECLARE @Idcuenta INT
DECLARE @NMonto DECIMAL(10,2)
DECLARE @limiteOpera INT

IF EXISTS(SELECT 1 FROM Cuenta WHERE NoCuenta = @NoCuenta)
BEGIN
IF EXISTS(SELECT 1 FROM Cuenta WHERE NoCuenta = @NoCuenta AND Vigente = 1 AND Saldo >= @MMonto)
BEGIN
IF (NOT EXISTS(SELECT 1 FROM CuentaDetalle WHERE NoDocumento = @NoDocumento))
BEGIN
IF EXISTS(SELECT 1 FROM TipoDocumento WHERE IdTipoDocumento = 1 AND LimiteOperacion > 0)
BEGIN
SET @Idcuenta = (SELECT IdCuenta FROM Cuenta WHERE NoCuenta = @NoCuenta)
INSERT INTO CuentaDetalle(IdCuentaDetalle, IdTipoDocumento, NoDocumento, Monto, FechaHora, Usuario)
VALUES (@idCuentaDeta,@Idcuenta,1,@NoDocumento,@MMonto,GETDATE(),@Usuario)
COMMIT TRAN
SET @limiteOpera = (SELECT LimiteOperacion FROM TipoDocumento WHERE IdTipoDocumento = 1) - 1
UPDATE TIPODOCUMENTO SET LimiteOperacion = @limiteOpera WHERE IdTipoDocumento = 1
SET @NMonto = (SELECT Saldo FROM Cuenta WHERE NoCuenta = @NoCuenta) - @MMonto
UPDATE Cuenta SET Saldo = @NMonto WHERE NoCuenta = @NoCuenta
rollback tran 
PRINT('COBRO DE CHEQUE')
PRINT('MONTO:' + CAST(@MMonto AS VARCHAR))
PRINT('NUMERO DE CUENTA: ' + @NoCuenta)
PRINT('LIMITE DE OPERACIONES RESTANTES PARA EL TIPO DE DOCUMENTO: '+ CAST(@limiteOpera AS VARCHAR))
END
ELSE
BEGIN
rollback tran 
PRINT('LIMITE DE OPERACIONES YA PASADO')
END
END
ELSE
BEGIN 
rollback tran 
PRINT('NO ESNTRA AL CHEUQE')
END
END
ELSE
BEGIN
rollback tran	
PRINT('EL SALDO DEBE DE SER MAYOR O IGUAL')
END
END
ELSE
BEGIN
rollback tran 
PRINT('LA CUENTA ESTA INVALIDA')
END
END
END

----------------------------------------------------DEPOSITO-----------------------------------------------
CREATE OR ALTER PROCEDURE NuevoDeposito (@NoCuenta VARCHAR(10), @NoDocumento VARCHAR(10), @Monto DECIMAL(10,2), @Usuario VARCHAR(50)) AS
BEGIN
BEGIN TRAN
DECLARE @vigente INT
DECLARE @NUEVOMonto DECIMAL(10,2)
DECLARE @NOMBRECUENTA VARCHAR(100)
DECLARE @Ellimite INT
DECLARE @IDCUENTA INT

IF EXISTS(SELECT 1 FROM CUENTA WHERE NOCUENTA = @NoCuenta)
BEGIN
SELECT @vigente = Vigente FROM Cuenta WHERE NoCuenta = @NoCuenta
IF(@vigente = 1)
BEGIN
IF EXISTS(SELECT 1 FROM TipoDocumento WHERE IdTipoDocumento = 2 AND LimiteOperacion > 0)
BEGIN
IF EXISTS(SELECT 1 FROM CuentaDetalle WHERE IdTipoDocumento = 2 AND NoDocumento = @NoDocumento)
BEGIN
PRINT('NUMERO DE DOCUMENTO YA EN USO')
END
ELSE
BEGIN
SET @IDCUENTA = (SELECT IDCUENTA FROM Cuenta WHERE NoCuenta = @NoCuenta)
INSERT INTO CuentaDetalle(IdCuenta, IdTipoDocumento, NoDocumento, Monto, FechaHora, Usuario)
VALUES (@IDCUENTA, 2, @NoDocumento, @Monto, GETDATE(), @Usuario)

SET @NUEVOMonto = (SELECT Saldo FROM Cuenta WHERE NoCuenta = @NoCuenta) + @Monto
UPDATE Cuenta SET Saldo = @NUEVOMonto WHERE NoCuenta = @NoCuenta

SET @Ellimite = (SELECT LimiteOperacion FROM TipoDocumento WHERE IdTipoDocumento = 1) - 1
UPDATE TIPODOCUMENTO SET LimiteOperacion = @Ellimite WHERE IdTipoDocumento = 1

SELECT @NOMBRECUENTA = NombreCuenta FROM CUENTA WHERE NoCuenta = @NoCuenta
PRINT('NUMERO DE LA CUENTA ' + @NoCuenta)
PRINT('NOMBRE DE LA CUENTA ' + @NOMBRECUENTA)
PRINT('NUMERO DE DOCUMENTO ' + @NoDocumento)
PRINT('MDEPOSITO ' + CAST(@Monto AS VARCHAR))
PRINT('USUARIO ' + @Usuario)
PRINT('FECHA Y HORA ' + GETDATE())
PRINT('NUEVO SALDO DE LA CUENTA ' + CAST(@NUEVOMonto AS VARCHAR))
PRINT('LIMITE DE OPERACIONES: '+ CAST(@Ellimite AS VARCHAR))
END
END
ELSE
BEGIN
PRINT('LIMITE DE OPERACIONES NO VALIDO')
END
END
ELSE
BEGIN
PRINT('CUENTA NO VIGENTE')
END
END
ELSE
BEGIN
PRINT('NUMERO DE CUENTA NO EXISTE')
END
END

-----------------------------------------TRANSACCCION------------------------------------------------------
CREATE or alter procedure NuevaTransferencia(@NoCuenta varchar(10) ,@NuevaCuenta varchar(10),@NoDocumennto varchar(10), @Monto decimal(10,2), @Usuario varchar(50) )AS
BEGIN
BEGIN TRAN
IF ((SELECT Nocuenta FROM Cuenta  WHERE NoCuenta =@NoCuenta )IS NULL)
BEGIN 
PRINT 'NO EXISTE CUENTA DE ORIGEN'
ROLLBACK TRAN
END 
ELSE BEGIN
DECLARE @nombrecuenta  varchar(100)
SELECT @nombrecuenta = NombreCuenta FROM Cuenta WHERE @NoCuenta = NoCuenta
PRINT 'NUMERO DE CUENTA ' + CAST(@NoCuenta as varchar)+ Cast(@NombreCuenta as varchar)

END
IF ((SELECT Nocuenta FROM Cuenta  WHERE NoCuenta =@NuevaCuenta )IS NULL)
BEGIN 
PRINT 'NO EXISTE LA CUENTA DESTINO'
ROLLBACK TRAN
END 
ELSE BEGIN 
DECLARE @NuevoNombreCuenta  varchar(100)
SELECT @NuevoNombreCuenta = NombreCuenta FROM Cuenta WHERE @NuevaCuenta = NoCuenta
PRINT 'CUENTA DESTINO ' + CAST(@NuevaCuenta as varchar)+' ' + Cast(@NuevoNombreCuenta as varchar)

END
IF ((SELECT NoDocumento FROM CuentaDetalle WHERE NoDocumento= @NoDocumennto)IS NULL) BEGIN
IF((SELECT Saldo FROM Cuenta WHERE NoCuenta= @NoCuenta)>= @monto) BEGIN
IF((SELECT Vigente FROM Cuenta WHERE NoCuenta = @NoCuenta ) =1)BEGIN
IF ((SELECT Vigente FROM Cuenta WHERE NoCuenta = @NuevaCuenta)=1)BEGIN
IF ((SELECT LimiteOperacion FROM TipoDocumento WHERE idTipoDocumento= 3)>= 1)BEGIN
UPDATE Cuenta
SET Saldo = Saldo + @monto
WHERE NoCuenta = @NuevaCuenta
UPDATE Cuenta
SET Saldo = Saldo-@monto
WHERE NoCuenta = @NoCuenta
DECLARE @iddetalle int 
SET @iddetalle = (SELECT COUNT(1) FROM CuentaDetalle) +1
DECLARE @idcuenta int
SET @idcuenta = (SELECT idCuenta FROM Cuenta WHERE NoCuenta=@NoCuenta)
INSERT INTO CuentaDetalle VALUES (@iddetalle,@idcuenta,3,@NoDocumennto,@monto,GETDATE(),@usuario)
DECLARE @idcuenta2 int
SET @idcuenta2 = (SELECT idCuenta FROM Cuenta WHERE NoCuenta=@NuevaCuenta)
INSERT INTO CuentaDetalle VALUES (@iddetalle+1,@idcuenta2,4,@NoDocumennto,@monto,GETDATE(),@usuario)
UPDATE TipoDocumento 
SET LimiteOperacion = LimiteOperacion-1
WHERE idTipoDocumento =3
DECLARE @saldos decimal(10,2)
DECLARE @saldo1 decimal(10,2)
SELECT @saldos = Saldo FROM Cuenta WHERE @NoCuenta = NoCuenta
SELECT @saldo1 = Saldo FROM Cuenta WHERE @NuevaCuenta = NoCuenta
PRINT 'SALDO ORIGEN ' + CAST(@saldos as varchar)
PRINT 'SALDO DESTINO ' + Cast(@saldo1 as varchar)
COMMIT TRAN
					
END
ELSE BEGIN
PRINT 'SE EXCEDIERON LAS TRANS'
ROLLBACK TRAN
END
					
END
ELSE BEGIN 
PRINT 'LA CUENTA NO ESTA VIGENTE'
ROLLBACK TRAN
END
END
ELSE BEGIN 
PRINT 'LA CUENTA NO ESTA VIGENTE'
ROLLBACK TRAN
END
END
ELSE BEGIN
PRINT 'NO TIENE SUFICIENTE SALDO'
ROLLBACK TRAN
END

END
ELSE BEGIN 
PRINT 'YA EXISTE'
ROLLBACK TRAN
END
END
