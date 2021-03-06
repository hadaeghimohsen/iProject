SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [ServiceDef].[ActiveGroupHeaders]
	-- Add the parameters for the stored procedure here
	@Xml Xml
AS
BEGIN
	Update ServiceDef.GroupHeader
	Set IsActive = 1
	Where Exists (Select * from @Xml.nodes('/Active/ID')Gh(ghid) 
	               Where ghid.query('.').value('.','bigint') = ID);
END
GO
