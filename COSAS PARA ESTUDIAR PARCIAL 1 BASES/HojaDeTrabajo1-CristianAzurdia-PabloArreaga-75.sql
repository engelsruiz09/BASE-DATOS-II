
----- HOJA DE TRABAJO #1 ------
---CRISTIAN AZURDIA 1081718
---PABLO ARREAGA 1331818

---QUERY 1
select count (PWO.WorkOrderID) as [Cant de ordenes de trabajo], pp.Name as [Nombre producto], YEAR(PWO.EndDate) as Año from Production.WorkOrder as PWO
inner join Production.Product as pp ON PWO.ProductID = pp.ProductID
Group by pp.Name, YEAR(PWO.EndDate)


--QUERY 2
select DISTINCT pp.Name as Nombre_Producto, pp.StandardCost as Costo, pp.ListPrice as Precio, (pp.ListPrice - pp.StandardCost) as Ganancia from Production.Product as PP
inner join Sales.SalesOrderDetail as SOD on PP.ProductID = SOD.ProductID
where pp.ListPrice > 1000 and SOD.OrderQty > 0


--PROCEDIMIENTO 1
create PROCEDURE [Sales].[usp_GetSales] @pYEAR datetime, @pMonth integer, @pProduct nvarchar(50) OUTPUT AS
BEGIN
	
	select * from SalesOrderHeader
END;

alter PROCEDURE [Sales].[usp_GetSales] @pYEAR datetime, @pMonth datetime, @pProduct nvarchar(50) OUTPUT AS
BEGIN

declare 
select @pYEAR = YEAR(OrderDate), @pMonth = MONTH(OrderDate), @pProduct = pp.Name
FROM Sales.SalesOrderHeader as SOH
inner join Sales.SalesOrderDetail as sod on SOH.SalesOrderID =sod.SalesOrderID
inner join Production.Product as PP on sod.ProductID = PP.ProductID
WHERE YEAR(OrderDate) = YEAR(@pYEAR) AND MONTH(OrderDate) = MONTH(@pMonth);

IF (PP.ProductID == sod.)
	BEGIN
---- alter table shipmetodid = 3
	END
END;


