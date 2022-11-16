--esquema principal dbo.

CREATE TRIGGER HumanResources.tuEmployee --triggerupdateafter
ON HumanResources.Employee --nombre del objeto que se le asocia ese procedimiento
after update as     --(momento y evento)despues de la actualizacion
begin 
	--- 
	-- print 'actualizar data....'
	if update (gender)
	begin
		 print 'actualizar data si..'
	end
	else
	begin
		print 'actualizar data si..'
	end

end