-- ================================================
-- Template generated from Template Explorer using:
-- Create Procedure (New Menu).SQL
--
-- Use the Specify Values for Template Parameters 
-- command (Ctrl-Shift-M) to fill in the parameter 
-- values below.
--
-- This block of comments will not be included in
-- the definition of the procedure.
-- ================================================
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		CÉSAR SILVA
-- Create date: 05/11/2022
-- Description:	SP
-- =============================================
CREATE OR ALTER PROCEDURE USPMODIFICACION(@NOMBRECURSO VARCHAR(50), @CARNE VARCHAR(10), @NSECCION SMALLINT)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	DECLARE @CCU INT
	SET @CCU = 0

	--PRIMER 'IF' VERIFICA QUE SOLO EXISTA 1 CURSO CON DETERMINADO NOMBRE
	IF ((SELECT COUNT(nombre) FROM CURSO WHERE nombre = @NOMBRECURSO) > 1)
	BEGIN
		;
		THROW 50000, 'EL CURSO EXISTE 2 VECES', 1;
		ROLLBACK
	END
	ELSE
	BEGIN

		--SEGUNDO 'IF' VERIFICA QUE EL CURSO PROGRAMADO SI EXISTA EN LA TABLA CURSO
		IF EXISTS(SELECT * FROM CURSOPROGRAMADO CP 
					INNER JOIN CURSO C ON CP.IdCurso = C.IdCurso
					WHERE C.nombre = @NOMBRECURSO)
		BEGIN
			SET @CCU = (SELECT COUNT(cupo) FROM CURSOPROGRAMADO CP
							INNER JOIN CURSO C ON CP.IdCurso = C.IdCurso
							WHERE C.nombre = @NOMBRECURSO)

			--TERCER 'IF' VERIFICA QUE EL CUPO DEL CURSO REQUERIDO DE DETERMINADA SECCION SEA MENOR A LO QUE ESTÁ ASIGNADO ACUTALMENTE
			IF (@CCU < (SELECT cupo FROM CURSOPROGRAMADO CP
							INNER JOIN CURSO C ON CP.IdCurso = C.IdCurso
							WHERE C.nombre = @NOMBRECURSO AND CP.Noseccion = @NSECCION))
			BEGIN

				--CUARTO 'IF' VERIFICA QUE EL ESTUDIANTE NO ESTE ASIGNADO YA A DICHO CURSO EN DICHA SECCION
				IF EXISTS(SELECT * FROM CURSOASIGNADO(HOLDLOCK) CA
							INNER JOIN CURSOPROGRAMADO CP ON CA.IdCursoprogramado = CP.IdCursoprogramado
							INNER JOIN CURSO C ON C.IdCurso = CP.cupo
							INNER JOIN ESTUDIANTE E ON CA.IdEstudiante = E.IdEstudiante
							WHERE E.carnet = @CARNE)
				BEGIN
					;
					THROW 50000, 'EL ESTUDIANTE DEL CARNET INGRESADO YA ESTÁ EN ESTA SECCIÓN', 1;
					ROLLBACK
				END
				ELSE
				BEGIN
					PRINT('MODIFICACION EXITOSA')
					UPDATE CURSOASIGNADO SET FechaHora = GETDATE() WHERE (IdEstudiante = (SELECT IdEstudiante FROM ESTUDIANTE WHERE carnet = @CARNE)) AND (IdCursoprogramado = (SELECT IdCursoprogramado FROM CURSOPROGRAMADO CP
																																											INNER JOIN CURSO C ON CP.IdCurso = C.IdCurso
																																											WHERE C.nombre = @NOMBRECURSO AND CP.Noseccion = @NSECCION))
					UPDATE CURSOASIGNADO SET IdCursoprogramado = (SELECT IdCursoprogramado FROM CURSOPROGRAMADO CP
											INNER JOIN CURSO C ON CP.IdCurso = C.IdCurso
											WHERE C.nombre = @NOMBRECURSO AND CP.Noseccion = @NSECCION) WHERE (IdEstudiante = (SELECT IdEstudiante FROM ESTUDIANTE WHERE carnet = @CARNE))
					COMMIT
				END
			END
			ELSE
			BEGIN	
				;
				THROW 50000, 'LA SECCION QUE QUIERE YA ESTA LLENA', 1;
				ROLLBACK
			END

		END
		ELSE
		BEGIN
			;
			THROW 50000, 'EL CURSO NO ESTA PROGRAMADO', 1;
			ROLLBACK
		END
	END
END
GO

INSERT INTO CURSOPROGRAMADO(IdCursoprogramado,IdCurso, Noseccion, cupo)
VALUES
(2, 1, 5, 10)