--Crear un SP que permita modificar la asignación de un estudiante (únicamente cambiar de sección de un curso), 
--para esto debe recibir como parámetro el Nombre del curso asignado, Carnet del estudiante y el número de sección a la cual se desea trasladar.



--No exista más de un estudiante con el mismo carnet y más de un curso 
--con el mismo nombre, debe evitar se inserte otro curso o carnet repetido mientras se ejecuta su transacción

CREATE OR ALTER PROCEDURE MODIFICAR (@NOMBRECURSO VARCHAR(50), @CARNET VARCHAR(10), @NUM_SECCION VARCHAR (2))
AS
BEGIN
	BEGIN TRAN
			declare @NOMBRECURSO VARCHAR (50),
			declare @CARNET VARCHAR(10),
			declare @NUM_SECCION VARCHAR (2),
			declare @IDCURSO INT,
			declare @IDCURSOPROGRAMADO VARCHAR(2),
			declare @FECHAHORA SYSDATETIME()

			IF EXISTS(SELECT 1 FROM ESTUDIANTE WHERE CARNET = @CARNET)
				BEGIN
					PRINT('NO. DE CARNET YA EN USO')
				END
			IF EXISTS(SELECT 1 FROM CURSO WHERE IDCURSO = @IDCURSO
				BEGIN 
					PRINT('NOMBRE DE CURSO REPETIDO')
				END
			ELSE
			BEGIN 
				PRINT('NOMBRE CURSO CREADO')
				INSERT CURSO (ID_CURSO,NOMBRE)
				VALUES (@IDCURSO, @ 0, 1)
			ELSE
			BEGIN
				PRINT('NUM.CARNET CREADO')
				INSERT ESTUDIANTE (ID_ESTUDIANTE,CARNET,NOMBRE)
				VALUES (@CARNET, @NOMBRECURSO)
			END

			IF EXISTS(SELECT 1 FROM CURSO_ASIGNADO WHERE ID_CURSO_PROGRAMADO = @IDCURSOPROGRAMADO)
				BEGIN 
					PRINT('EL CURSO PROGRAMADO YA ESTA DUPLICADO')
				END
			ELSE
			BEGIN 
				PRINT('CURSO PROGRAMADO CREADO')
				INSERT CURSO_PROGRAMADO (ID_CURSO_ASIGNADO, ID_CURSO_PROGRAMADO, ID_ESTUDIANTE, FECHA_HORA)
				VALUES (@IDCURSOPROGRAMADO,@FECHAHORA,


