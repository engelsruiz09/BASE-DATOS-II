--para cada cliente con su direccion de casa en redmond, mostrar el campo linea1 de dicha 
--direccion y los campos linea1
--city de la direccion de entrega(dejar en blanco si no tiene)
SELECT*
FROM Person.Person
SELECT*
FROM Person.Address
SELECT*
FROM Person.BusinessEntityAddress
SELECT*
FROM Person.AddressType

SELECT p.BusinessEntityID, p.FirstName, p.LastName, a.AddressLine1, a.City, at.Name
FROM sales.Customer c
	inner join Person.Person p on p.BusinessEntityID = c.PersonID
	inner join Person.BusinessEntityAddress pbea on pbea.BusinessEntityID = p.BusinessEntityID
	inner join Person.Address a on a.AddressID = pbea.AddressID
	inner join Person.AddressType at on at.AddressTypeID = pbea.AddressTypeID
where pbea.AddressTypeID in (2,5) and a.City = 'Redmond'
order by 1 asc


--mostrar las 3 ciudades donde se han realizado la mayoria de ventar(entrega de producto)
SELECT SubTotal, a.City
FROM sales.SalesOrderHeader soh
	inner join person.Address a on soh.ShipToAddressID = a.AddressID

SELECT sum(Subtotal) as total, count(*) as cantidad, avg(SubTotal), --top 3 a.city, 
	min(Subtotal), max(SubTotal)
FROM Sales.SalesOrderHeader soh
	inner join Person.Address a on soh.ShipToAddressID = a.AddressID
group by a.City
order by 3 desc --columna dos del query/ columna tres del query


--muestre el procentaje de participacion por producto respecto a la ventas totales
--3.1 ordenes realizadas por TC

SELECT *
FROM sales.SalesOrderHeader
where CreditCardID is null

SELECT p.Name, (sum(sod.LineTotal) / dbo.uf_montototal()) as pct
FROM sales.SalesOrderHeader soh
	inner join sales.SalesOrderDetail sod on soh.SalesOrderID = sod.SalesOrderID
	inner join Production.Product p on p.ProductID = sod.ProductID
	where CreditCardID is not null
	group by p.Name

	--userfunction
create function uf_montototal()   
returns money
as
begin
declare @data money
	SELECT @data = sum(Subtotal)
	FROM sales.SalesOrderHeader 
	where CreditCardID is not null;

	return @data
end;

--listar los departamenteos que tengan por lo menos 7 empleados asignados

SELECT DepartmentID, count(distinct BusinessEntityID)
FROM HumanResources.EmployeeDepartmentHistory
group by DepartmentID
having count(distinct BusinessEntityID) > 6





