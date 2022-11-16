
--Cristian Azurdia 1081718
--Por temas de manejo de costos, no debe permitir cambiar el costo de un producto, si dicho costo no está dentro del rango +- 1 desviación estándar, tomando en cuenta los últimos 5 cambios de precio de dicho producto y su último cambio de costo sea mayor a 2 meses.
--          Creación de METODO en el lugar correcto (20 pts)
--          Aplica regla A ( 25 pts)
-- Aplica regla B ( 25 pts )

select * from Production.Product
select * from Production.ProductCostHistory


create trigger Production.tu_XCHGCost on Production.Product after update as
begin

declare @STcost float;
declare @var_nuevo int;
declare @var_ant int;
declare @DevestM float;
declare @ContadorCambios int;
declare @FechaCambio datetime;
declare @AnioCambio datetime;


	Select @ContadorCambios = COUNT(ProductID), @DevestM = STDEV(StandardCost), @STcost = StandardCost, @FechaCambio = MONTH(EndDate), @AnioCambio = YEAR(EndDate) from production.ProductCostHistory
	group by ProductID, StandardCost, EndDate

	if ( ( @STcost - 1.0 > @DevestM  OR  @STcost+ 1.0  < @DevestM ) AND ( @ContadorCambios >= 5 ) AND ( @FechaCambio > 2 AND @AnioCambio < Year(getdate()) ) )
	begin
		print 'Cambio realizado'

		select @var_ant = StandardCost
		from   deleted;

		select @var_nuevo = StandardCost
		from inserted

	end
	else
	begin
		print 'no cumple las reglas A y B'
	end
end;
