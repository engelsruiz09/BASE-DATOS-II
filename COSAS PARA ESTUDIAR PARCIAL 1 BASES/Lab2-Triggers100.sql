--LABORATORIO #2, BASES 2
-- Pablo Arreaga 1331818
-- Cristian Azurdia 1081718



select * from Sales.PersonCreditCard
select * from Sales.CreditCard

create trigger tu_Tarjeta on sales.creditcard after update as
begin
	declare @val_MesExp tinyint; -- 12
	declare @val_añoMod smallint; 
	declare @val_añoExp smallint;

	select @val_MesExp = ExpMonth, @val_añoExp = ExpYear, @val_añoMod = YEAR(ModifiedDate) -- 1-12, 1900-3000
	from Sales.CreditCard
	
	--select @val_año = ExpYear-- 1900 - 3000
	-- from inserted

	if ((month(GETDATE())+1) = @val_MesExp AND year(GETDATE()) > @val_añoMod )--si expira en 30 dias
	begin
		print 'Acceso denegado a su tarjeta'
	end
	else 
	begin
		print 'Tarjeta aceptada'
		update sales.CreditCard
		set CardNumber = '0000001'
		where CreditCardID = 1
	end
end;


select *from person.EmailAddress
create trigger person.tu_Correo on person.EmailAddress after update as
begin

declare @var_ant nvarchar(50);
declare @var_nuevo nvarchar(50);

	
		if (@var_ant = @var_nuevo)
		begin
			print 'El correo ingresado ya existe'
		end;
		else
		begin
		update person.EmailAddress
		set EmailAddress = @var_nuevo
		where @var_ant = null
		end
end;

--actualizar el inventario del producto al vender cada uno de ellos.al momento que se confirma y/o cancela
--la venta. (primero actualizar el status de las ventas) con un random entre 1 y 6
select * from Production.ProductInventory
create trigger production.tau_Inventario on production.ProductInventory after update as
begin

declare @var_invAnterior smallint;
declare @var_invNuevo smallint;
declare @var_IDproducto int;

select @var_invAnterior = Quantity, @var_IDproducto = ProductID
		from  inserted;

	if exists(select @var_IDproducto)
	begin
		print 'cambio realizado'
		update Production.ProductInventory
		set Quantity = 7
		where @var_IDproducto = ProductID
	end
	else
	begin
		print 'no se realizo el cambio, el id no existe'
	end
end;
