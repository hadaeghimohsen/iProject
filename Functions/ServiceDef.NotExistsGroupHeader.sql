SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date, ,>
-- Description:	<Description, ,>
-- =============================================
CREATE FUNCTION [ServiceDef].[NotExistsGroupHeader]
(
	@Xml Xml
)
RETURNS bit
AS
BEGIN
	Declare @STitleFa Nvarchar(Max);
	
	Select
	   @STitleFa = r.c.query('STitleFa').value('.', 'nvarchar(max)')
	From @Xml.nodes('/') r(c);
	
	IF(Not Exists (Select * from ServiceDef.GroupHeader Where STitleFa = @STitleFa))
	   Return 1;
	Return 0;

END
GO
