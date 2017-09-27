SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date, ,>
-- Description:	<Description, ,>
-- =============================================
Create FUNCTION [DataGuard].[NotExistsUser]
(
	-- Add the parameters for the function here
	@Xml Xml
)
RETURNS Bit
AS
BEGIN
	Declare @STitleEn Nvarchar(Max);
	
	Select
	   @STitleEn = r.c.query('STitleEn').value('.', 'nvarchar(max)')
	From @Xml.nodes('/') r(c);
	
	IF(Not Exists (Select * from DataGuard.[User] Where STitleEn = @STitleEn))
	   Return 1;
	Return 0;
END
GO
