--===============================================================================
--============================C�SAR SILVA // 1184519=============================
--===========================DIEGO MORALES // 1132119============================
--===============================================================================
--===============================================================================
--======================CREACION DE TABLAS A UTILIZAR============================
--===============================================================================
CREATE TABLE CUENTA(
IDCUENTA INT IDENTITY(1,1),
NOMBRE_CUENTA VARCHAR(100),
NOCUENTA VARCHAR(10),
SALDO DECIMAL(10,2),
VIGENTE BIT

CONSTRAINT PK_CUENTA PRIMARY KEY (IDCUENTA)
)

CREATE TABLE TIPODOCUMENTO(
IDTIPODOCUMENTO INT IDENTITY(1,1),
DESCRIPCION VARCHAR(21),
SUMA BIT,
LIMITEOPERACIONES INT

CONSTRAINT PK_TIPODOCUMENTO PRIMARY KEY (IDTIPODOCUMENTO)
)

CREATE TABLE CUENTADETALLE(
IDCUENTADETALLE INT IDENTITY(1,1),
IDCUENTA INT,
IDTIPODOCUMENTO INT,
NODOCUMENTO VARCHAR(10),
MONTO DECIMAL(10,2),
FECHAHORA DATETIME,
USUARIO VARCHAR(50)

CONSTRAINT PK_CUENTADETALLE PRIMARY KEY (IDCUENTADETALLE),
CONSTRAINT FK_CUENTA_CUENTADETALLE FOREIGN KEY(IDCUENTA) REFERENCES CUENTA(IDCUENTA),
CONSTRAINT FK_CUENTADETALLE_TIPODOCUMENTO FOREIGN KEY(IDTIPODOCUMENTO) REFERENCES TIPODOCUMENTO(IDTIPODOCUMENTO)
)

DROP TABLE CUENTA
DROP TABLE CUENTADETALLE
DROP TABLE TIPODOCUMENTO

--======================CUENTAS============================
INSERT INTO CUENTA VALUES('Diego Morales','1258469872',300000.00,1)
INSERT INTO CUENTA VALUES('Cesar Silva','0214783694',290000.50,1)
--======================TIPOS DE DOCUMENTO============================
INSERT INTO TIPODOCUMENTO VALUES('Cheque',0,1)
INSERT INTO TIPODOCUMENTO VALUES('Dep�sito',1,1)
INSERT INTO TIPODOCUMENTO VALUES('Transferencia d�bito',0,1)
INSERT INTO TIPODOCUMENTO VALUES('Transferencia cr�dito',1,1)
UPDATE TIPODOCUMENTO SET LIMITEOPERACIONES = 1 WHERE idTipoDocumento = 1
--===============================================================================
--==================CREACION DE PROCEDIMIENTO CREAR NUEVA CUENTA=================
--===============================================================================
CREATE OR ALTER PROCEDURE USPNUEVACUENTA (@UNIQUE VARCHAR(10), @NCUENTA VARCHAR(100))AS
BEGIN
	DECLARE @VERIFICAR VARCHAR(10)
	DECLARE @CONT INT
	SET @CONT = 1
	DECLARE @ADIOS INT
	SET @ADIOS = 0

	IF EXISTS(SELECT 1 FROM CUENTA WHERE NOCUENTA = @UNIQUE)
	BEGIN
		PRINT('NO. DE CUENTA YA EN USO')
	END
	ELSE
	BEGIN
		PRINT('CUENTA CREADA')
		INSERT CUENTA (NOMBRE_CUENTA,NOCUENTA,SALDO,VIGENTE)
		VALUES (@NCUENTA, @UNIQUE, 0, 1)
	END
END

--EXEC USPNUEVACUENTA '101010-3', 'DIEGO MARES'

--INSERT CUENTA (NOMBRE_CUENTA,NOCUENTA,SALDO,VIGENTE)
--VALUES ('DIEGO MORALES', '101010-4' , 0, 1)

--SELECT *
--FROM CUENTA

--===============================================================================
--================CREACION DE PROCEDIMIENTO COBRO DE CHEQUE======================
--===============================================================================
CREATE OR ALTER PROCEDURE USPCOBROCHEQUE (@NOC VARCHAR(10), @NOD VARCHAR(10), @MONT DECIMAL(10,2), @US VARCHAR(50)) AS
BEGIN
	DECLARE @IDCUENTA INT
	DECLARE @NUEVOMONTO DECIMAL(10,2)
	DECLARE @NUEVOLIMITE INT

	IF EXISTS(SELECT 1 FROM CUENTA WHERE NOCUENTA = @NOC)
	BEGIN
		IF EXISTS(SELECT 1 FROM CUENTA WHERE NOCUENTA = @NOC AND VIGENTE = 1)
		BEGIN
			IF EXISTS(SELECT 1 FROM CUENTA WHERE NOCUENTA = @NOC AND SALDO >= @MONT)
			BEGIN
				IF (NOT EXISTS(SELECT 1 FROM CUENTADETALLE WHERE NODOCUMENTO = @NOD))
				BEGIN
					IF EXISTS(SELECT 1 FROM TIPODOCUMENTO WHERE IDTIPODOCUMENTO = 1 AND LIMITEOPERACIONES > 0)
					BEGIN
						SET @IDCUENTA = (SELECT IDCUENTA FROM CUENTA WHERE NOCUENTA = @NOC)
						INSERT INTO CUENTADETALLE (IDCUENTA, IDTIPODOCUMENTO, NODOCUMENTO, MONTO, FECHAHORA, USUARIO)
						VALUES (@IDCUENTA,1,@NOD,@MONT,GETDATE(),@US)

						SET @NUEVOLIMITE = (SELECT LIMITEOPERACIONES FROM TIPODOCUMENTO WHERE IDTIPODOCUMENTO = 1) - 1
						UPDATE TIPODOCUMENTO SET LIMITEOPERACIONES = @NUEVOLIMITE WHERE IDTIPODOCUMENTO = 1

						SET @NUEVOMONTO = (SELECT SALDO FROM CUENTA WHERE NOCUENTA = @NOC) - @MONT
						UPDATE CUENTA SET SALDO = @NUEVOMONTO WHERE NOCUENTA = @NOC

						PRINT('COBRO DE CHEQUE REALIZADO CON EXITO')
						PRINT('MONTO A COBRAR: ' + CAST(@MONT AS VARCHAR))
						PRINT('NO. DE CUENTA: ' + @NOC)
						PRINT('EL USUARIO QUE REALIZ� EL COBRO FUE ' + @US + ' CON EL N�MERO DE DOCUMENTO: ' + @NOD)
						PRINT('MONTO RESTANTE: '+ CAST(@NUEVOMONTO AS VARCHAR))
						PRINT('LIMITE DE OPERACIONES RESTANTES PARA EL TIPO DE DOCUMENTO: '+ CAST(@NUEVOLIMITE AS VARCHAR))
					END
					ELSE
					BEGIN
						PRINT('LIMITE DE OPERACIONES YA PASADO')
					END
				END
				ELSE
				BEGIN 
					PRINT('CHEQUE NO VALIDO')
				END
			END
			ELSE
			BEGIN
				PRINT('SU SALDO DEBE SER MAYOR O IGUAL AL MONTO INGRESADO')
			END
		END
		ELSE
		BEGIN
			PRINT('CUENTA NO VIGENTE')
		END
	END
	ELSE
	BEGIN
		PRINT('CUENTA INEXISTENTE')
	END
END

--EXECUTE USPCOBROCHEQUE  '1258469872','1234567893',199700.00,'Diego Morales'
--===============================================================================
--================CREACION DE PROCEDIMIENTO DEPOSITO=============================
--===============================================================================
CREATE OR ALTER PROCEDURE USPDEPOSITO (@NUMC VARCHAR(10), @NUMD VARCHAR(10), @MONTO DECIMAL(10,2), @USU VARCHAR(50)) AS
BEGIN
	DECLARE @VGT INT
	DECLARE @NUEVOMONTO DECIMAL(10,2)
	DECLARE @NOMBRECUENTA VARCHAR(100)
	DECLARE @NUEVOLIMITE INT
	DECLARE @IDCUENTA INT

	IF EXISTS(SELECT 1 FROM CUENTA WHERE NOCUENTA = @NUMC)
	BEGIN
		SELECT @VGT = VIGENTE FROM CUENTA WHERE NOCUENTA = @NUMC
		IF(@VGT = 1)
		BEGIN
			IF EXISTS(SELECT 1 FROM TIPODOCUMENTO WHERE IDTIPODOCUMENTO = 2 AND LIMITEOPERACIONES > 0)
			BEGIN
				IF EXISTS(SELECT 1 FROM CUENTADETALLE WHERE IDTIPODOCUMENTO = 2 AND NODOCUMENTO = @NUMD)
				BEGIN
					PRINT('NO. DE DOCUMENTO YA EN USO')
				END
				ELSE
				BEGIN
					SET @IDCUENTA = (SELECT IDCUENTA FROM CUENTA WHERE NOCUENTA = @NUMC)
					INSERT INTO CUENTADETALLE (IDCUENTA, IDTIPODOCUMENTO, NODOCUMENTO, MONTO, FECHAHORA, USUARIO)
					VALUES (@IDCUENTA, 2, @NUMD, @MONTO, GETDATE(), @USU)

					SET @NUEVOMONTO = (SELECT SALDO FROM CUENTA WHERE NOCUENTA = @NUMC) + @MONTO
					UPDATE CUENTA SET SALDO = @NUEVOMONTO WHERE NOCUENTA = @NUMC

					SET @NUEVOLIMITE = (SELECT LIMITEOPERACIONES FROM TIPODOCUMENTO WHERE IDTIPODOCUMENTO = 1) - 1
					UPDATE TIPODOCUMENTO SET LIMITEOPERACIONES = @NUEVOLIMITE WHERE IDTIPODOCUMENTO = 1

					SELECT @NOMBRECUENTA = NOMBRE_CUENTA FROM CUENTA WHERE NOCUENTA = @NUMC
					PRINT('NUMERO DE LA CUENTA ' + @NUMC)
					PRINT('NOMBRE DE LA CUENTA ' + @NOMBRECUENTA)
					PRINT('NUMERO DE DOCUMENTO ' + @NUMD)
					PRINT('MONTO A DEPOSITAR ' + CAST(@MONTO AS VARCHAR))
					PRINT('USUARIO A DEBITAR ' + @USU)
					PRINT('FECHA Y HORA DE TRANSACCION ' + GETDATE())
					PRINT('NUEVO SALDO DE LA CUENTA ' + CAST(@NUEVOMONTO AS VARCHAR))
					PRINT('LIMITE DE OPERACIONES RESTANTES PARA EL TIPO DE DOCUMENTO: '+ CAST(@NUEVOLIMITE AS VARCHAR))
				END
			END
			ELSE
			BEGIN
				PRINT('LIMITE DE OPERACIONES NO VALIDO')
			END
		END
		ELSE
		BEGIN
			PRINT('CUENTA SOLICITADA NO VIGENTE')
		END
	END
	ELSE
	BEGIN
		PRINT('NO. DE CUENTA NO ENCONTRADO')
	END
END

--===============================================================================
--================CREACION DE PROCEDIMIENTO TRANSFERENCIAS=======================
--===============================================================================
CREATE OR ALTER PROCEDURE USPTRANSFERENCIA (@NOCOR VARCHAR(10), @NOCDES VARCHAR(10), @NODOC VARCHAR(10), @MONTO DECIMAL(10,2), @US VARCHAR(50)) AS
BEGIN
	DECLARE @VGT INT
	DECLARE @IDCUENTA INT
	DECLARE @NUEVOMONTO DECIMAL(10,2)
	DECLARE @NUEVOLIMITE INT
	DECLARE @NUEVOMONTO2 DECIMAL(10,2)
	DECLARE @QUITA DECIMAL(10,2)
	DECLARE @QUITA2 DECIMAL(10,2)

	IF EXISTS(SELECT 1 FROM CUENTADETALLE WHERE NODOCUMENTO = @NODOC AND IDTIPODOCUMENTO = 3)
	BEGIN
		PRINT('NO. DOCUMENTO YA EN USO')
	END
	IF EXISTS(SELECT 1 FROM CUENTADETALLE WHERE NODOCUMENTO = @NODOC AND IDTIPODOCUMENTO = 4)
	BEGIN
		PRINT('NO. DOCUMENTO YA EN USO')
	END
	ELSE
	BEGIN
		IF (EXISTS(SELECT 1 FROM CUENTA WHERE NOCUENTA = @NOCOR) AND EXISTS(SELECT 1 FROM CUENTA WHERE NOCUENTA = @NOCDES))
		BEGIN
			SELECT @VGT = VIGENTE FROM CUENTA WHERE NOCUENTA = @NOCDES
			IF(@VGT = 1)
			BEGIN
				SELECT @VGT = VIGENTE FROM CUENTA WHERE NOCUENTA = @NOCOR
				IF(@VGT = 1)
				BEGIN
					IF (SELECT SALDO FROM CUENTA WHERE NOCUENTA = @NOCOR) >= @MONTO
					BEGIN
						IF(@NODOC = 3)
						BEGIN
							IF(SELECT LIMITEOPERACIONES FROM TIPODOCUMENTO WHERE IDTIPODOCUMENTO = 3) > 0
							BEGIN
								SET @IDCUENTA = (SELECT IDCUENTA FROM CUENTA WHERE NOCUENTA = @NOCOR)
								INSERT INTO CUENTADETALLE (IDCUENTA, IDTIPODOCUMENTO, NODOCUMENTO, MONTO, FECHAHORA, USUARIO)
								VALUES (@IDCUENTA, 3, @NODOC, @MONTO, GETDATE(), @US)

								SET @NUEVOLIMITE = (SELECT LIMITEOPERACIONES FROM TIPODOCUMENTO WHERE IDTIPODOCUMENTO = 3) - 1
								UPDATE TIPODOCUMENTO SET LIMITEOPERACIONES = @NUEVOLIMITE WHERE IDTIPODOCUMENTO = 3

								SET @NUEVOMONTO = (SELECT SALDO FROM CUENTA WHERE NOCUENTA = @NOCOR) - @MONTO
								UPDATE CUENTA SET SALDO = @NUEVOMONTO WHERE NOCUENTA = @NOCOR

								SET @NUEVOMONTO2 = (SELECT SALDO FROM CUENTA WHERE NOCUENTA = @NOCDES) + @MONTO
								UPDATE CUENTA SET SALDO = @NUEVOMONTO2 WHERE NOCUENTA = @NOCDES

								PRINT('NUMERO DE CUENTA ORIGEN ' + @NOCOR)
								PRINT('NUMERO DE DOCUMENTO ' + @NODOC)
								PRINT('NUMERO DE CUENTA DESTINTO ' + @NOCDES)
								PRINT('MONTO TRANSFERIDO ' + CAST(@MONTO AS VARCHAR))
								PRINT('TRANSFERENCIA REALIZADA POR EL USUARIO ' + @US)
								PRINT('SALDO FINAL DE CUENTA ORIGEN ' + CAST(@NUEVOMONTO AS VARCHAR))
								PRINT('SALDO FINAL DE CUENTA DESTINO ' + CAST(@NUEVOMONTO2 AS VARCHAR))
								PRINT('LIMITE DE OPERACIONES RESTANTES PARA EL TIPO DE DOCUMENTO: '+ CAST(@NUEVOLIMITE AS VARCHAR))
							END
							ELSE
							BEGIN
								PRINT('LIMITE DE OPERACIONES TRASPASADO')
							END
						END
						IF(@NODOC = 4)
						BEGIN
							SET @QUITA = (SELECT SALDO FROM CUENTA WHERE NOCUENTA = @NOCOR) + @MONTO
							UPDATE CUENTA SET SALDO = @QUITA WHERE NOCUENTA = @NOCOR

							SET @QUITA2 = (SELECT SALDO FROM CUENTA WHERE NOCUENTA = @NOCDES) - @MONTO
							UPDATE CUENTA SET SALDO = @QUITA2 WHERE NOCUENTA = @NOCDES

							SET @NUEVOMONTO = (SELECT SALDO FROM CUENTA WHERE NOCUENTA = @NOCOR) - @MONTO
							UPDATE CUENTA SET SALDO = @NUEVOMONTO WHERE NOCUENTA = @NOCOR

							SET @NUEVOMONTO2 = (SELECT SALDO FROM CUENTA WHERE NOCUENTA = @NOCDES) + @MONTO
							UPDATE CUENTA SET SALDO = @NUEVOMONTO2 WHERE NOCUENTA = @NOCDES

							SET @IDCUENTA = (SELECT IDCUENTA FROM CUENTA WHERE NOCUENTA = @NOCDES)
							INSERT INTO CUENTADETALLE (IDCUENTA, IDTIPODOCUMENTO, NODOCUMENTO, MONTO, FECHAHORA, USUARIO)
							VALUES (@IDCUENTA, 4, @NODOC, @MONTO, GETDATE(), @US)

							PRINT('NUMERO DE CUENTA ORIGEN ' + @NOCOR)
							PRINT('NUMERO DE DOCUMENTO ' + @NODOC)
							PRINT('NUMERO DE CUENTA DESTINTO ' + @NOCDES)
							PRINT('MONTO TRANSFERIDO ' + CAST(@MONTO AS VARCHAR))
							PRINT('TRANSFERENCIA REALIZADA POR EL USUARIO ' + @US)
							PRINT('SALDO FINAL DE CUENTA ORIGEN ' + CAST(@NUEVOMONTO AS VARCHAR))
							PRINT('SALDO FINAL DE CUENTA DESTINO ' + CAST(@NUEVOMONTO2 AS VARCHAR))
						END
					END
					ELSE
					BEGIN
						PRINT('LA CUENTA ORIGEN NO TIENE FONDOS SUFICIENTES PARA DICHA TRANSACCI�N')
					END
				END
				ELSE
				BEGIN
					PRINT('CUENTA ORIGEN NO VIGENTE')
				END
			END
			ELSE
			BEGIN
				PRINT('CUENTA DESTINO NO VIGENTE')
			END
		END
		ELSE
		BEGIN
			PRINT('UNA CUENTA SOLICITADA NO EXISTE')
		END
	END
END