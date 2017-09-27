SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [ServiceDef].[ActiveUnitType]
	@Xml Xml
AS
BEGIN
	Update ServiceDef.UnitType
	Set IsActive = 1
	Where Exists (Select * 
	               From @Xml.nodes('/Active/UnitType/UnitTypeID') t(ut) 
	               Where ut.query('.').value('.', 'bigint') = ID);
END
GO
