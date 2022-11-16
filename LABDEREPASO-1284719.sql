---JULIO ANTHONY ENGELS RUIZ COTO - 1284719------
----Accidentes geograficos-----
Create table AG_Accidentes_Geograficos
(
	Id_Tipo INT NOT NULL,
	NOMBRE VARCHAR(50),
	
	CONSTRAINT CHK_Id_Tipo PRIMARY KEY (Id_Tipo)
)
SELECT * FROM AG_Accidentes_Geograficos
-----------------------------------------------
INSERT AG_Accidentes_Geograficos
(Id_Tipo, NOMBRE)
VALUES
(1,'Playa')
-----------------------------------------------
INSERT AG_Accidentes_Geograficos
(Id_Tipo, NOMBRE)
VALUES
(2,'Desierto')
-----------------------------------------------
INSERT AG_Accidentes_Geograficos
(Id_Tipo, NOMBRE)
VALUES
(3,'Bosque')
-----------------------------------------------
INSERT AG_Accidentes_Geograficos
(Id_Tipo, NOMBRE)
VALUES
(4,'Cascada')
-----------------------------------------------
INSERT AG_Accidentes_Geograficos
(Id_Tipo, NOMBRE)
VALUES
(5,'Río')
-----------------------------------------------
INSERT AG_Accidentes_Geograficos
(Id_Tipo, NOMBRE)
VALUES
(6,'Lago')
-----------------------------------------------
INSERT AG_Accidentes_Geograficos
(Id_Tipo, NOMBRE)
VALUES
(7,'Acantilado')
-----------------------------------------------
INSERT AG_Accidentes_Geograficos
(Id_Tipo, NOMBRE)
VALUES
(8,'Montaña')
-----------------------------------------------
INSERT AG_Accidentes_Geograficos
(Id_Tipo, NOMBRE)
VALUES
(9,'Selva')
-----------------------------------------------
INSERT AG_Accidentes_Geograficos
(Id_Tipo, NOMBRE)
VALUES
(10,'Isla')
-----------------------------------------------
INSERT AG_Accidentes_Geograficos
(Id_Tipo, NOMBRE)
VALUES
(11,'Llanura')
-----------------------------------------------
INSERT AG_Accidentes_Geograficos
(Id_Tipo, NOMBRE)
VALUES
(12,'Glaciar')
-----------------------------------------------



----Datos accidente----
Create table DA_Datos_Accidente
(
	Id_Nombre_D INT NOT NULL,
	Nombre_D VARCHAR(50),
	Caracteristicas_D VARCHAR(50),
	Id_Tipo INT NOT NULL,

	CONSTRAINT CHK_Id_Nombre_D PRIMARY KEY (Id_Nombre_D)

)

SELECT * FROM DA_Datos_Accidente
-----------------------------------------------
INSERT DA_Datos_Accidente
(Id_Nombre_D, Nombre_D, Caracteristicas_D, Id_Tipo)
VALUES
(1,'Amazonas', 'Río mas largo del mundo', 5)
-----------------------------------------------
----Paises afectados----
Create table PA_Paises_Afectados
(
	Id_Pais INT NOT NULL,
	Id_Nombre_D INT NOT NULL,
	Nombre_Pais VARCHAR(50),
	Localidad VARCHAR(50),
)

SELECT * FROM PA_Paises_Afectados
-----------------------------------------------
INSERT PA_Paises_Afectados
(Id_Pais, Id_Nombre_D, Nombre_Pais, Localidad)
VALUES
(1,1, 'Brasil', 'Manaos')
INSERT PA_Paises_Afectados
(Id_Pais, Id_Nombre_D, Nombre_Pais, Localidad)
VALUES
(1,1, 'Brasil', 'Macapá')
INSERT PA_Paises_Afectados
(Id_Pais, Id_Nombre_D, Nombre_Pais, Localidad)
VALUES
(1,1, 'Brasil', 'Santarém')
INSERT PA_Paises_Afectados
(Id_Pais, Id_Nombre_D, Nombre_Pais, Localidad)
VALUES
(2,1, 'Perú', 'Iquitos')
INSERT PA_Paises_Afectados
(Id_Pais, Id_Nombre_D, Nombre_Pais, Localidad)
VALUES
(3,1, 'Colombia', 'Leticia')
-----------------------------------------------
----Dimensiones----
Create table Dimensiones
(
	Id_Dimensiones INT NOT NULL,
	Id_Nombre_D INT NOT NULL,
	Altura_NM FLOAT NOT NULL,
	Tipo_Dimension VARCHAR(50),
	Valor_Dimension VARCHAR(50),

	CONSTRAINT CHK_Id_Dimensiones PRIMARY KEY (Id_dimensiones)
)

----------CONSULTAS----------------------------------

SELECT*
FROM VWACCIDENTES

SELECT DA.Id_Nombre_D, COUNT(PA.Nombre_Pais) AS Total_Paises FROM DA_Datos_Accidente DA 
INNER JOIN PA_Paises_Afectados PA  ON DA.Id_Nombre_D = PA.Id_Nombre_D
GROUP BY DA.Id_Nombre_D

SELECT PA.Id_Nombre_D, PA.Nombre_Pais, DA.Nombre_D FROM PA_Paises_afectados PA
INNER JOIN DA_Datos_Accidente DA  ON PA.Id_Nombre_D = DA.Id_Nombre_D
GROUP BY PA.Nombre_Pais, PA.ID_Nombre_D, DA.NOMBRE_D

SELECT*
FROM VWCANT_ACCIDENTES

CREATE VIEW VWCANT_ACCIDENTES
SELECT  DA.Nombre_D, Count(1) AS Cantidad_Accidentes
FROM DA_Datos_Accidente DA
GROUP BY DA.Nombre_D

CREATE VIEW VWProfundidad
SELECT PA.Id_Nombre_D, PA.Localidad, D.Valor_Dimension FROM PA_Paises_afectados PA
INNER JOIN Dimensiones D  ON PA.Id_Nombre_D = D.Id_Nombre_D
WHERE (D.Tipo_Dimension = 'PROFUNDIDAD') AND (D.Valor_Dimension > 100)

SELECT*
FROM VWAMIGOS

CREATE VIEW VWAMIGOS AS
SELECT PA.Nombre_Pais, COUNT(1) AS Total_Localidades FROM PA_Paises_afectados PA
WHERE (Id_NOMBRE_D = 1)
GROUP BY PA.Nombre_Pais
ORDER BY Total_Localidades DESC
