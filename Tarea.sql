
use AdventureWorks2019;
-- 1. Listar todos los clientes que no tienen direccion

select 
sc.CustomerID,
sc.AccountNumber
from
Sales.Customer sc 
left join Sales.SalesOrderHeader scoh on sc.CustomerID = scoh.CustomerID
inner join Person.Address pa on scoh.BillToAddressID = pa.AddressID
group by sc.CustomerID,sc.AccountNumber
having count(pa.AddressID)=0

-- 2. Listar todos los productos finales que no han sido vendidos
select  pp.ProductID,pp.Name,pp.ProductNumber
from Production.Product pp
left join Sales.SalesOrderDetail ss on pp.ProductID = ss.ProductID
group by pp.ProductID,pp.Name,pp.ProductNumber
having count(ss.ProductID)=0

-- 3.

select
case when (TotalDue between 0 and 100) then '0 - 99'
	 when (TotalDue between 100 and 999) then '100 - 999'
	 when (TotalDue between 1000 and 9999) then '1000 - 9999'
	 else '10000 - ' 
end as rango,
[cantidad de ordenes] = COUNT(*),
total = sum(TotalDue)
FROM sales.SalesOrderHeader
GROUP BY case when (TotalDue between 0 and 100) then '0 - 99'
	 when (TotalDue between 100 and 999) then '100 - 999'
	 when (TotalDue between 1000 and 9999) then '1000 - 9999'
	 else '10000 - ' 
	 end
order by rango

-- 4.Listar por cada proveedor, la cantidad de compras que se le han realizado, el 
--monto total,la compra minima y maxima, asi como tambien la primer y ultima fecha cuando se le compro

select 
pv.Name as Proveedor,
count(ppv.BusinessEntityID) as cantidad_compras,
ppod.LineTotal as monto_total,
ppv.MaxOrderQty as compra_maxima,
ppv.MinOrderQty as compra_minima,
ppv.LastReceiptDate as ultima_fecha_compra
from Purchasing.Vendor pv 
inner join Purchasing.ProductVendor ppv on pv.BusinessEntityID = ppv.BusinessEntityID 
inner join Purchasing.PurchaseOrderDetail ppod on ppv.ProductID=ppod.ProductID
group by pv.Name,ppod.LineTotal,
ppv.MaxOrderQty,
ppv.MinOrderQty,
ppv.LastReceiptDate,
pv.AccountNumber

 

-- 5.Cuanto ha recibido cada empleado (salario) al dia de hoy
select 
he.BusinessEntityID,
he.Gender,
he.JobTitle,
sum(hep.Rate) as salario
from HumanResources.Employee he
inner join HumanResources.EmployeePayHistory hep on he.BusinessEntityID=hep.BusinessEntityID
group by he.BusinessEntityID,he.Gender,he.JobTitle


-- 6.Mostrar todos los componentes que se necesitan para fabricar un producto en especifico

select
pp.ProductID,
pp.Name,
pp.ProductNumber,
pbom.ComponentID,
pbom.ProductAssemblyID,
pbom.BOMLevel,
pbom.PerAssemblyQty,
pbom.StartDate,
pbom.EndDate
from
Production.BillOfMaterials pbom
inner join Production.Product pp on pp.ProductID=pbom.BillOfMaterialsID
where pp.ProductID='893';

go
-- PARTE B

-- No permitir ingresar una tarjeta de crédito 
--	con diferencia de fecha de expiracion menor a 30 días

CREATE OR ALTER TRIGGER validar_tarjeta_credito
ON Sales.CreditCard
AFTER INSERT
AS
begin
	SET NOCOUNT ON
	declare @mes int, @anio int
	set @mes = (select i.ExpMonth from inserted as i)
	set @anio = (select i.ExpYear from inserted as i)
	if DATEDIFF(DAY,getdate(),CONCAT(CAST(@anio as varchar),'-',CAST(@mes as varchar),'-','1')) < 30
	begin
		raiserror('Error, la tarjeta expira en menos de 30 días',16,1);
		ROLLBACK TRANSACTION;  
		RETURN
	end
end


/*
Codigo para probar el trigger

insert into Sales.CreditCard(CardType,CardNumber,ExpMonth, ExpYear) 
values('Visa','111111111',10,2022);
*/
go
-- No permitir ingresar, actualizar un correo asociado a otra persona

CREATE or alter TRIGGER validar_email
ON Person.EmailAddress
AFTER INSERT,UPDATE
AS
begin
	SET NOCOUNT ON
	declare @email nvarchar(50)
	set @email = (select i.EmailAddress from inserted as i)  
	if (select count(*) from Person.EmailAddress where EmailAddress=@email) = 2
	begin
		raiserror('Error, el email ya esta registrado',16,1);
		ROLLBACK TRANSACTION;  
		RETURN
	end
end

go

/*
Validar email al ingresar
insert into Person.EmailAddress(BusinessEntityID,EmailAddress) values (1,'gigi0@adventure-works.com')
*/


-- Actualizar stock de productos al confirmar la venta
select * from Sales.SalesOrderHeader