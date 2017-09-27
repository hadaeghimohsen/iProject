SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
Create PROCEDURE [ServiceDef].[DisabledUnitType]
	@Xml Xml
AS
BEGIN
	Update ServiceDef.UnitType
	Set IsVisible = 0
	Where Exists (Select * 
	               From @Xml.nodes('/Disabled/UnitType/UnitTypeID') t(ut) 
	               Where ut.query('.').value('.', 'bigint') = ID);
END
GO
