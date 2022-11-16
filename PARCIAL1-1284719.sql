

--================================PRIMER EXAMEN PARCIAL BASES II ===================================

--=========================JULIO ANTHONY ENGELS RUIZ COTO 1284719 ==================================

--Por temas de manejo de costos, no debe permitir cambiar el precio de lista de un producto, 
--regla a : si existen ordenes de venta en proceso ( no finalizadas ) 
--regla b: y su �ltimo cambio de precio no haya pasado 1 a�o.

-- Creaci�n de M�TODO en el lugar correcto (30 pts)
-- Aplica regla A ( 35 pts)
--Aplica regla B ( 35 pts )

select* from Production.Product
select* from Production.ProductCostHistory
select* from sales.SalesOrderHeader --aqui esta el status


CREATE or alter TRIGGER manejo_costos_regla_ayb ON Production.Product AFTER UPDATE
AS
begin
	set nocount on
	declare @Finalizado datetime;
	declare @ProductID int;
	declare @NewCost money;
	declare @LastDateChange datetime;
	

	SELECT @ProductID = ProductID, @NewCost = ListPrice, @Finalizado = Status from inserted
	SELECT TOP 1 @LastDateChange = ModifiedDate
	FROM Production.Product
	WHERE ProductID = @ProductID 
	ORDER BY ModifiedDate DESC

	--en la tabla sales.salesorderheader hay un columna de estatus donde status = 6 es que fueron canceladas no finalizadas
	IF EXISTS (SELECT 1 FROM Sales.SalesOrderHeader WHERE @Finalizado = 6)--Si est� dentro del rango, permite la inserci�n
	begin
		if DATEDIFF(YEAR, @LastDateChange, GETDATE()) < 1--Si es menor a un a�o el �ltimo cambio, permite la inserci�n
		begin
			INSERT INTO Production.ProductCostHistory
			SELECT * FROM inserted;
		end;
		else--Si es mayor, no permite inserci�n
		begin
			PRINT 'No se logro actualizar el precio, el �ltimo cambio fue hace m�s de un a�o';
		end;
	end;
	else
	begin
		PRINT 'No se logro actualizar el precio, el nuevo precio no est� dentro del rango establecido  ;( ';
	end;
end;
