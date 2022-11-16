--===========TAREA QUERYS == BASE DE DATOS Accidentes Geográficos============
--==============JULIO ANTHONY ENGELS RUIZ COTO - 1284719=====================

SELECT*
FROM Accidente --idaccidente, idtipoaccidente, nombre, alturanivelmar
SELECT*
FROM AccidenteLocalidad --id acclocalidad, idaccidente, idlocalidad
SELECT*
FROM Localidad--idlocalidad, id pais, nombre
SELECT*
FROM Pais --idpais, nombre
SELECT* 
FROM TipoAccidente --idtipoaccidente, nombre
SELECT*
FROM AccidenteCaracteristica --idacccar,idaccidente,idcaracteristica,valor
--===============================================================================================================

--listar todos los accidentes geograficos que pertenezcan a mas de 1 pais.
SELECT DISTINCT A.Nombre, AL.idAccidente, COUNT(P.idPais)
FROM dbo.Accidente A 
INNER JOIN dbo.AccidenteLocalidad AL on A.idAccidente = AL.idAccidente
INNER JOIN dbo.Localidad L on AL.idLocalidad = L.idLocalidad
INNER JOIN dbo.Pais P on L.idPais = P.idPais
GROUP BY A.Nombre,AL.idAccidente

--listar los tipos de accidentes y la cantidad de accidentes de cada uno
SELECT DISTINCT TA.idTipoAccidente,COUNT(A.idTipoAccidente) AS CANTIDAC 
FROM dbo.TipoAccidente TA 
INNER JOIN dbo.Accidente A on TA.idTipoAccidente = A.idTipoAccidente
GROUP BY TA.idTipoAccidente

--listar las localidades que tengan algun accidente geografico con una profundidad mayor a 100mts debe mostrar nombre del pais
--localidad y cantidad de accidentes ordenado de mayor a menor por la cantidad de accidentes.
SELECT AC.idAccidente, P.Nombre, al.idLocalidad, AC.idCaracteristica, AC.Valor From AccidenteCaracteristica AC
INNER JOIN AccidenteLocalidad AL ON AL.idAccidente = AC.idAccidente
INNER JOIN Localidad L ON L.idLocalidad = AL.idLocalidad
INNER JOIN Pais P ON P.idPais = L.idPais
WHERE Valor > 100

--dado un pais listar sus paises amigos se define un pais amigo a aquel que comparte al menos un accidente geografico con otro
--el listado debe estar ordenado por grado de amistad es decir la cantidad de accidentes geograficos que se comparten 
--empezando por el mayor 

SELECT P.Nombre,COUNT(P.idPais) as cantidadpais
FROM AccidenteLocalidad AL
INNER JOIN Localidad L on L.idLocalidad = AL.idLocalidad
INNER JOIN Pais P on P.idPais = L.idPais
GROUP BY P.Nombre
HAVING COUNT (P.idPais) > 1
