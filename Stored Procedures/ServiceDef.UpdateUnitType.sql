SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [ServiceDef].[UpdateUnitType]
   @Xml Xml
AS
BEGIN
	Declare @UnitTypeID Bigint;
	Declare @TitleFa NVarchar(Max);
	Declare @TitleEn NVarchar(Max);
	Declare @UnitType bit;
	
	Select 
	   @UnitTypeID = ut.query('UnitTypeID').value('.','bigint'),
	   @TitleFa = ut.query('TitleFa').value('.', 'nvarchar(max)'),
	   @TitleEn = ut.query('TitleEn').value('.', 'nvarchar(max)'),
	   @UnitType = ut.query('UnitType').value('.', 'bit')
	From @Xml.nodes('/Update') t(ut);
	
   Update ServiceDef.UnitType
   Set 
      TitleFa = Case Len(@TitleFa) When 0 Then TitleFa Else @TitleFa End,
      TitleEn = Case Len(@TitleEn) When 0 Then TitleEn Else @TitleEn End,
      UnitType = @UnitType
   Where ID = @UnitTypeID;
   
   Update ServiceDef.Role_UnitType
   Set IsActive = 0
   Where UnitTypeID = @UnitTypeID;
   	
	Merge ServiceDef.Role_UnitType as utt
	Using (Select 
	            rid.query('.').value('.','bigint') as RoleID,
	            @UnitTypeID as [UnitTypeID]
	         from @Xml.nodes('/Update/Roles/RoleID') t(rid)) as uts
	On (utt.RoleID = uts.RoleID AND utt.UnitTypeID = uts.UnitTypeID)
	When Matched Then
	   Update set IsActive = 1
	When Not Matched Then
	   Insert (RoleID, UnitTypeID)
	   Values(uts.RoleID, @UnitTypeID);
END
GO
