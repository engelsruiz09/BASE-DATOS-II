--resolucion de examen parcial 1 de base de datos II
--TEMARIO A PRACTICO A
--Por temas de manejo de costos, no debe permitir cambiar el precio de lista de un producto, si existen ordenes de venta en proceso ( no finalizadas ) y su último cambio de precio no haya pasado 1 año.

--         Creación de MÉTODO en el lugar correcto (30 pts)

--         Aplica regla A ( 35 pts)

--         CreaciónAplica regla B ( 35 pts )

create trigger tuproduct 
  on product.product
  after update
as
begin 

  set nocount on;
IF EXISTS(SELECT  1)

    from inserted p  
    inner join product.productlistPriceHistory plp:
      on (plp.productid = p.productid)
    inner join sales.salesorderdetail sod on (sod.productid = p.productid)
    inner join sales.salesorderheader soh on (sohsalesOrderID = sod.salesOrderID)
      
    where Datediff(dd,enddate,getdate()) < 365 and 
      soh.status in (1,2,3,4)

      IF UPDATE(LISTPRICE)
      BEGIN
        THROW 60000, 'NO SE PUEDE......' ,1;
      END
END
GO

BEGIN TRAN   
UPDATE PRODUCTION.PRODUCT
SET LISTPRICE = 1
ROLLBACK
