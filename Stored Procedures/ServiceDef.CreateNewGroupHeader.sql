SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [ServiceDef].[CreateNewGroupHeader]
	-- Add the parameters for the stored procedure here
	@Xml Xml
AS
BEGIN
	Declare @FaName Nvarchar(Max), @EnName Nvarchar(Max);
	Declare @SFaName NVarchar(Max), @SEnName NVarchar(Max);
	
	Select 
	   @FaName = gh.c.query('FaName').value('.','nvarchar(max)'),
	   @EnName = gh.c.query('EnName').value('.','nvarchar(max)')
	From @Xml.nodes('/Create')gh(c);	
	
	Set @SFaName = REPLACE(@FaName, ' ', '');
	Set @SEnName = REPLACE(@EnName, ' ', '');
	
	IF(Exists (Select * From ServiceDef.GroupHeader Where STitleFa = @SFaName))
	   Return;
	
	Insert Into ServiceDef.GroupHeader (ShortCut, TitleFa, STitleFa, TitleEn, STitleEn)
	Values(
	   (Select IsNull(MAX(ShortCut),0) + 1 From ServiceDef.GroupHeader),
	   @FaName,
	   @SFaName,
	   @EnName,
	   @SEnName
	);
	
	Declare @GroupHeaderID Bigint;
	Select @GroupHeaderID = ID
	From ServiceDef.GroupHeader
	Where STitleFa = @SFaName;
	
	Insert Into ServiceDef.Role_GroupHeader (RoleID, GroupHeaderID)
	Select gh.[role].query('.').value('.', 'bigint'), @GroupHeaderID
	From @Xml.nodes('/Create/Roles/RoleID')gh([role]);
END
GO
