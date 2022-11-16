SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
alter PROCEDURE ColaPorFecha (@año varchar(4), @mes varchar(2))
AS
BEGIN
	declare @completo char(10)
	set @completo = @año+'-'+@mes+'-01'
	declare @fechaI smalldatetime
	set @fechaI = CONVERT(smalldatetime, @completo)
	declare @fechaF smalldatetime
	set @fechaF = DATEADD(MONTH, 1, @fechaI)
	set @fechaF = DATEADD(Minute, -1, @fechaI)
	select COUNT(*) as Cola from Cola where Fecha between @fechaI and @fechaF 
	return;
END
GO
