SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [ServiceDef].[CreateUnitType]
	@Xml Xml
AS
BEGIN
	Declare @TitleFa NVarchar(Max);
	Declare @TitleEn NVarchar(Max);
	Declare @UnitType bit;
	
	Select 
	   @TitleFa = ut.query('TitleFa').value('.', 'nvarchar(max)'),
	   @TitleEn = ut.query('TitleEn').value('.', 'nvarchar(max)'),
	   @UnitType = ut.query('UnitType').value('.', 'bit')
	From @Xml.nodes('/Create') t(ut);
	
	Insert Into ServiceDef.UnitType (ShortCut, TitleFa, TitleEn, UnitType)
	Values(
	   (Select MAX(ShortCut) + 1 from ServiceDef.UnitType Where UnitType = @UnitType),
	   @TitleFa,
	   IsNull(@TitleEn, 'Default'),
	   @UnitType
	);
	
	Declare @UnitTypeID Bigint;
	Select @UnitTypeID = Max(ID) From ServiceDef.UnitType Where UnitType = @UnitType And TitleFa = @TitleFa;
	
	Insert Into ServiceDef.Role_UnitType (RoleID, UnitTypeID)
	Select 
	   rid.query('.').value('.', 'bigint'),
	   @UnitTypeID
	From @Xml.nodes('/Create/Roles/RoleID')t(rid);
	
END
GO
