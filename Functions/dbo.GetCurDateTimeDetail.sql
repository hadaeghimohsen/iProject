SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE FUNCTION [dbo].[GetCurDateTimeDetail]()
RETURNS MyDateDetail
AS
BEGIN
	Declare @DateTimeStr	MyDateDetail
	Declare @Hour			smallint
	Declare @Minute			smallint
	Declare @Second			smallint		
	
	Select @Hour=DATEPART(hh,getDate())
	Select @Minute=DATEPART(mi,GetDate())
	Select @Second=DATEPART(ss,getDate())

	DECLARE @TimeStr		nvarchar(20)
	SELECT @TimeStr=dbo.PADSTR(@Hour,2)+':'+dbo.PADSTR(@Minute,2)+':'+dbo.PADSTR(@Second,2)

	Select @DateTimeStr=dbo.MiladiToShamsi(GetDate())+' '+@TimeStr
	return @DateTimeStr
END
GO
