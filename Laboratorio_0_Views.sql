
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


