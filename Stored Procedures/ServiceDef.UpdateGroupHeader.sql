SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [ServiceDef].[UpdateGroupHeader]
	-- Add the parameters for the stored procedure here
	@Xml Xml
AS
BEGIN
	Declare @GhID Bigint;
	Declare @GhFaName NVarchar(Max);
	Declare @GhEnName NVarchar(Max);
	Declare @GhActive Bit;
	
	Select 
	   @GhID = gh.c.query('GroupHeaderID').value('.','bigint'),
	   @GhFaName = gh.c.query('FaName').value('.','nvarchar(max)'),
	   @GhEnName = gh.c.query('EnName').value('.','nvarchar(max)'),
	   @GhActive = gh.c.query('GhActive').value('.','bit')
	From @Xml.nodes('/Update') gh(c);

	Update ServiceDef.GroupHeader
	Set IsActive = @GhActive
	Where ID = @GhID;
END
GO
