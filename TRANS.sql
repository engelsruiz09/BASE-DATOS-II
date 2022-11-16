begin transaction

update [Person].[CountryRegion]
set name = name + ' ' + CountryRegionCode
where CHARINDEX (' ', name) > 0; --para buscar un caracter en un string

if((1+1) = 2)
begin 
	rollback transaction
	print 'rollack'
end
else
begin
	commit transaction
	end

--select*
--from [Person].[CountryRegion]
--where CHARINDEX(' ' ,name) > 0

select*
into tmp_vendedor
from [Purchasing].[Vendor]

select vendorid,count(1)
from Purchasing.PurchaseOrderHeader
group by VendorID
order by 2 desc

select* from tmp_vendedor

alter table tmp_vendedor
add Mayor int

begin transaction 
	update tmp_vendedor
	set Mayor =
		(
			select case when count(1) > 50 then 1 else 0 end 
			from Purchasing.PurchaseOrderHeader ph
			where BusinessEntityID = ph.VendorID)
	--print @@rowcount
if(@@ROWCOUNT > 100)
begin 
	commit
	print 'commit'
	end 
	else
	begin 
	rollback;
	print 'rollback'
	print @@rowcount
	end

-------------------------------------------------------------
begin trans
	update HumanResources.EmployeePayHistory
	set PayFrequency = 1555
	where BusinessEntityID = 1;

	if @@ERROR <> 0 --guardar el numero de error 
	begin
	rollback
	print 'rollback'
	end
	else
	begin
	print 'commit'


begin tran
begin try
	update HumanResources.EmployeePayHistory
	set PayFrequency = 155
	where BusinessEntityID = 1;

	print 'commit'
	commit;

end try
begin catch
	rollback;
	print 'rollback';
	select ERROR_NUMBER() as errornumber
	,ERROR_SEVERITY() as errorseverity
	,ERROR_STATE() as errorstate
	,ERROR_PROCEDURE() as errorprocedure
	,ERROR_LINE() as errorline
	,ERROR_MESSAGE() as errormessage
end catch

----------------------
begin tran
	update HumanResources.EmployeePayHistory
	set PayFrequency = 1
	where BusinessEntityID = 1;

-----------------------
sp_who2
select*
from HumanResources.EmployeePayHistory
where BusinessEntityID = 1;


---------------------------------------
begin transaction

rollback transaction

commit transaction 