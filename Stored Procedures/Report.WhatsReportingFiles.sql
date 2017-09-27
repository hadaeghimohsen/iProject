SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [Report].[WhatsReportingFiles]
	@Xml XML
AS
BEGIN
	DECLARE @RoleID BIGINT;
	SELECT @RoleID = @Xml.query('/RoleID').value('.', 'BIGINT');
	
	SELECT GroupHeaderID as Cid
	FROM ServiceDef.Role_GroupHeader
	WHERE IsReporting = 1
	AND RoleID = @RoleID;
	
	SELECT UnitTypeID As Tid
	FROM ServiceDef.Role_UnitType
	WHERE IsReporting = 1
	AND RoleID = @RoleID;
	
	SELECT
	 'SUCCESSFUL' AS RESULT
	,'0S' AS TIMERUN
	,'Cabinets:Folders' AS TABLESNAME
	,'Mojtama' As TableSpaceName
	,'false' AS [HasRelation]
END
GO
