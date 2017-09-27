SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [ServiceDef].[DeactiveUnitType]
	@Xml Xml
AS
BEGIN
	Update ServiceDef.UnitType
	Set IsActive = 0
	Where Exists (Select * 
	               From @Xml.nodes('/Deactive/UnitType/UnitTypeID') t(ut) 
	               Where ut.query('.').value('.', 'bigint') = ID);
END
GO
