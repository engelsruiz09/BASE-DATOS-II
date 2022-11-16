SELECT *
FROM SYSOBJECTS
WHERE NAME = 'upsObtieneContacto'

--===========================================================================================
ALTER PROCEDURE uspObtieneContacto AS  --alter procedure upsObtieneContacto AS
BEGIN 
	SELECT TOP 1 P.LastName, P.FirstName,P.BusinessEntityID
	FROM SALES.STORE S
	INNER JOIN PERSON.BusinessEntityContact BEC ON S.BusinessEntityID = BEC.BusinessEntityID
	INNER JOIN Person.Person P ON BEC.PersonID = P.BusinessEntityID

	ORDER BY P.LastName
END

	EXEC uspObtieneContacto 
	--la funcion por default regresa algo la funcion no puede actualizar datos , procedimiento si se puede
--=========================================================================================
ALTER PROCEDURE uspObtieneContacto (@pStore varchar(50), @idContacto int output) AS  --alter procedure upsObtieneContacto AS
BEGIN 
	SELECT TOP 1 @idContacto = p.BusinessEntityID
	FROM SALES.STORE S
	INNER JOIN PERSON.BusinessEntityContact BEC ON S.BusinessEntityID = BEC.BusinessEntityID
	INNER JOIN Person.Person P ON BEC.PersonID = P.BusinessEntityID
	WHERE S.Name = @pStore

	ORDER BY P.LastName
END

	EXEC uspObtieneContacto 'Riders Company'


--==============================================================================================================
--crear en otra ventana
DECLARE @NUMCONTACTO INT
SET @NUMCONTACTO = 0
EXEC uspObtieneContacto 'Riders Company', @NUMCONTACTO output
print @NUMCONTACTO

IF(@NUMCONTACTO <> 0)
BEGIN
	SELECT LastName, FirstName
	FROM Person.Person
	WHERE BusinessEntityID = @NUMCONTACTO
END
ELSE 
BEGIN 
	PRINT 'NO EXISTEN DATOS........'
END


SELECT* FROM Person.BusinessEntityContact
---=====================================================================================
--sp = actualizar datos

--SELECT avg(ListPrice) FROM Production.Product
EXEC uspCambioPrecio 28000

ALTER PROCEDURE uspCambioPrecio (@ValorMax decimal)
as 
begin 
WHILE((SELECT avg(ListPrice) FROM Production.Product) < @ValorMax)

BEGIN 
	UPDATE Production.Product
	SET ListPrice = CASE WHEN COLOR = 'Red' then ListPrice * 3 else ListPrice * 2 end

	end 
end

