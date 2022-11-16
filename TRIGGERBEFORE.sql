ALTER TRIGGER HumanResources.tubEmployee --triggerupdatebefore
ON HumanResources.Employee --nombre del objeto que se le asocia ese procedimiento
instead of update as   --evento 
begin 

--deleted --objetos unicamente a nivel de triggers
--inserted--objetos unicamente a nivel de triggers

declare @id int
declare @nuevovalor varchar(2)
	select @id = BusinessEntityID,
			@nuevovalor = MaritalStatus
	from inserted
	--- 
	-- print 'actualizar data....'
	if update (gender)
	begin
		 print 'before actualizar data si..'
	end
	else
	begin
		print 'before actualizar data si..'
		update HumanResources.Employee
		set MaritalStatus = @nuevovalor
		where BusinessEntityID = @id
	end

end

--===================================================================================
-----------------------------BEFORE-------------------------------------------------------------
--CREA UN TRIGGER EN LA TABLA HumanResources con el nombre tubEmployee(TablaUpdateBeforeEmployee)
ALTER TRIGGER HumanResources.tubEmployee
--NOMBRE DEL OBJETO AL CUAL SE ASOCIA EL PROCEDIMIENTO 
ON HumanResources.Employee
--MOMENTO
INSTEAD OF UPDATE AS --ANTES DEL UPDATE
--EVENTO
BEGIN

    --DELETED -- EXISTEN UNICAMENTE EN LOS TRIGGERS; VALORES ACTUALES
    --INSERTED -- EXITEN UNICAMENTE EN LOS TRIGGERS; VALORES NUEVOS

    DECLARE @id INT
    SELECT @id = BusinessEntityID --SE GUARDA EN @id EL DATO DE BUSINESSENTITYID 
    FROM inserted --EL CUAL ES EL NUEVO QUE SE SELECCIONA

    DECLARE @VIEJOvalor varchar(2)
    SELECT @VIEJOvalor = MaritalStatus
    FROM inserted

    DECLARE @nuevo varchar(2)
    SELECT @nuevo = MaritalStatus
    FROM deleted
 
    IF UPDATE(Gender)
    BEGIN
        PRINT 'BEFORE ACTUALIZO DATA...si'
    END
    ELSE
    BEGIN
        PRINT 'ANTES '+@nuevo + ' ' + 'DESPUES '+@VIEJOVALOR + ' ' + 'EN ' + CONVERT(VARCHAR, @id)
        UPDATE HumanResources.Employee
        SET MaritalStatus = @VIEJOvalor
        WHERE BusinessEntityID = @id
    END
END


--==ACTUALIZAR EL PAGO DEL EMPLEADO SI SE ACTUALIZA LAS HORAS DE VACACIONES DEL MISMO
--EVENTO=UPDATE, TABLA EMPLOYEE, MOMENTO=AFTER 

-- SI NO SE QUIERE ACTUALIZAR LA TABLA ASOCIADA SE USA BEFORE


ALTER TRIGGER HumanResources.tubEmployee
--NOMBRE DEL OBJETO AL CUAL SE ASOCIA EL PROCEDIMIENTO 
ON HumanResources.Employee
--MOMENTO
INSTEAD OF UPDATE AS --ANTES DEL UPDATE
--EVENTO
BEGIN

    --DELETED -- EXISTEN UNICAMENTE EN LOS TRIGGERS; VALORES ACTUALES
    --INSERTED -- EXITEN UNICAMENTE EN LOS TRIGGERS; VALORES NUEVOS

    DECLARE @id INT
    SELECT @id = BusinessEntityID --SE GUARDA EN @id EL DATO DE BUSINESSENTITYID 
    FROM inserted --EL CUAL ES EL NUEVO QUE SE SELECCIONA

    DECLARE @VIEJOvalor varchar(2)
    SELECT @VIEJOvalor = MaritalStatus
    FROM inserted

    DECLARE @nuevo varchar(2)
    SELECT @nuevo = MaritalStatus
    FROM deleted
 
	DECLARE @NUEVOVALOR INT

    IF UPDATE(vacationhours)
    BEGIN
        SELECT @NUEVOVALOR = VacationHours, @id = BusinessEntityID
		FROM inserted

		if(@NUEVOVALOR > 100)
		begin 
			update HumanResources.EmployeePayHistory
			set rate = 10
			where BusinessEntityID = @id
		end
    END
    ELSE
    BEGIN
        PRINT 'ANTES '+@nuevo + ' ' + 'DESPUES '+@VIEJOVALOR + ' ' + 'EN ' + CONVERT(VARCHAR, @id)
        UPDATE HumanResources.Employee
        SET MaritalStatus = @VIEJOvalor
        WHERE BusinessEntityID = @id
    END
END



--===============
select*
from HumanResources.Employee
where BusinessEntityID = 10

update HumanResources.Employee
set Gender = 'S', Gender = 'F'
where BusinessEntityID = 3

update HumanResources.Employee
set MaritalStatus = 'S'
where BusinessEntityID = 10