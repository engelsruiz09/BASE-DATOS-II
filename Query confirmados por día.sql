-- ================================================
-- Template generated from Template Explorer using:
-- Create Procedure (New Menu).SQL
--
-- Use the Specify Values for Template Parameters 
-- command (Ctrl-Shift-M) to fill in the parameter 
-- values below.
--
-- This block of comments will not be included in
-- the definition of the procedure.
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
alter PROCEDURE ConfirmadosPorDia (@fecha date)
AS
BEGIN
	declare @fechaf smalldatetime
	set @fechaf = DATEADD(hour,23,cast(@fecha as smalldatetime))
	set @fechaf = DATEADD(minute,59,@fechaf)
	print(@fechaf)
	print(cast(@fecha as smalldatetime))
	select COUNT(*) from VueloPasajero where Fecha between cast(@fecha as smalldatetime) and @fechaf and idTipoEstatus = 3
	return;
END
GO
