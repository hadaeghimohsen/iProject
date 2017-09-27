SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [ServiceDef].[DuplicateGroupHeader]
	-- Add the parameters for the stored procedure here
	@Xml Xml
AS
BEGIN
   Declare @GhID Bigint;
	Declare @FaName Nvarchar(Max), @EnName Nvarchar(Max);
	Declare @SFaName NVarchar(Max), @SEnName NVarchar(Max);
   Declare @Set bit;	
   Declare @SetObject smallint;
	Select 
	   @GhID = gh.c.query('GhID').value('.','bigint'),
	   @FaName = gh.c.query('FaName').value('.','nvarchar(max)'),
	   @EnName = gh.c.query('EnName').value('.','nvarchar(max)'),
	   @Set = gh.c.query('CascadeSettings/Set').value('.', 'bit'),
	   @SetObject = gh.c.query('CascadeSettings/SubObject').value('.','smallint')
	From @Xml.nodes('/Duplicate') gh(c);
	
	Select @GhID, @FaName, @EnName, @Set, @SetObject;
	
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
	
	IF(@Set = 0)
	   Return;
	
	IF(@SetObject = 0)
	Begin
	   Insert Into ServiceDef.Role_GroupHeader (RoleID, GroupHeaderID)
	   Select RoleID, @GroupHeaderID
	   From ServiceDef.Role_GroupHeader
	   Where GroupHeaderID = @GhID;
	End	
	Else IF(@SetObject = 1)
	Begin
	   INSERT INTO [ServiceDef].[Service]
           ([ShortCut] ,[TitleFa] ,[TitleEn] ,[ServiceUnitID] ,[ServiceTypeID] ,[StartDate]
           ,[ExpDate] ,[Level] ,[ParentCode] ,[Price] ,[GroupHeaderID])  
      Select 
            ShortCut ,TitleFa ,TitleEn ,ServiceUnitID ,ServiceTypeID ,StartDate
           ,ExpDate ,[Level] ,ParentCode ,Price ,@GroupHeaderID
     From ServiceDef.[Service]
     Where GroupHeaderID = @GhID;
	End
	Else IF(@SetObject = 2)
	Begin
	   Insert Into ServiceDef.Role_GroupHeader (RoleID, GroupHeaderID)
	   Select RoleID, @GroupHeaderID
	   From ServiceDef.Role_GroupHeader
	   Where GroupHeaderID = @GhID;
	   
	   INSERT INTO [ServiceDef].[Service]
           ([ShortCut] ,[TitleFa] ,[TitleEn] ,[ServiceUnitID] ,[ServiceTypeID] ,[StartDate]
           ,[ExpDate] ,[Level] ,[ParentCode] ,[Price] ,[GroupHeaderID])  
      Select 
            ShortCut ,TitleFa ,TitleEn ,ServiceUnitID ,ServiceTypeID ,StartDate
           ,ExpDate ,[Level] ,ParentCode ,Price ,@GroupHeaderID
      From ServiceDef.[Service]
      Where GroupHeaderID = @GhID;	   
	End
END
GO
