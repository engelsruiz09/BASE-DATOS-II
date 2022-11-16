-- ================================================
-- Template generated from Template Explorer using:
-- Create Multi-Statement Function (New Menu).SQL
--
-- Use the Specify Values for Template Parameters 
-- command (Ctrl-Shift-M) to fill in the parameter 
-- values below.
--
-- This block of comments will not be included in
-- the definition of the function.
-- ================================================
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE FUNCTION fn_regresarvalor
(
	-- Add the parameters for the function here
	@VALOR int
)
RETURNS int
AS
BEGIN
	-- Fill the table variable with the rows for your result set
	DECLARE @RESULTADO INT
	
	--ADD THE T-SQL STATEMENTS TO COMPUTE THE RETURN VALUE HERE
	SELECT @RESULTADO = @VALOR * 5

	--RETURN THE RESULT OF THE FUNCTION
	RETURN @RESULTADO
END
GO
SELECT * from sysobjects where name like 'fn%' --COMIENCE EN fn
SELECT dbo.fn_regresarvalor(idAccidente), *
	from Accidente

SELECT* FROM SYSOBJECTS
SELECT* FROM SYSCOMMENTS
WHERE id = 1205579333
sp_helptext fn_regresarvalor()



CREATE FUNCTION <Table_Function_Name, sysname, FunctionName> 
(
	-- Add the parameters for the function here
	<@param1, sysname, @p1> <data_type_for_param1, , int>, 
	<@param2, sysname, @p2> <data_type_for_param2, , char>
)
RETURNS 
<@Table_Variable_Name, sysname, @Table_Var> TABLE 
(
	-- Add the column definitions for the TABLE variable here
	<Column_1, sysname, c1> <Data_Type_For_Column1, , int>, 
	<Column_2, sysname, c2> <Data_Type_For_Column2, , int>
)
AS
BEGIN
	-- Fill the table variable with the rows for your result set
	
	RETURN 
END
GO