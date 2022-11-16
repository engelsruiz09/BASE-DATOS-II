
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