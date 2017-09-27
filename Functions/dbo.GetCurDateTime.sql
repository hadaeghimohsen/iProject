SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE FUNCTION [dbo].[GetCurDateTime]()
RETURNS MyDate
AS
BEGIN
	Declare @DateTimeStr	MyDate
	Declare @Hour			smallint
	Declare @Minute			smallint

	Select @Hour=DATEPART(hh,getDate())
	Select @Minute=DATEPART(mi,GetDate())

	Declare @TimeStr	nvarchar(5)
	Select @TimeStr=''
	if(@Hour<10)
		Select @TimeStr=@TimeStr+'0'
	Select @TimeStr=@TimeStr+Cast(@Hour as nvarchar(2))
	if(@Minute<10)
		Select @TimeStr=@TimeStr+':0'+Cast(@minute as nvarchar(2))
	else 
		Select @TimeStr=@TimeStr+':'+Cast(@minute as nvarchar(2))
	Select @DateTimeStr=dbo.MiladiToShamsi(GetDate())+' '+@TimeStr
	return @DateTimeStr
END
GO
