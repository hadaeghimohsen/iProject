SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [Report].[WhatsFileType]
	@Xml XML
AS
BEGIN
	DECLARE @RoleID BIGINT, @AppDecision BIGINT;
	SELECT @RoleID = @Xml.query('//RoleID').value('.', 'BIGINT'),
	       @AppDecision = @Xml.query('//AppDecision').value('.', 'BIGINT') ;
	
   SELECT @AppDecision = ID
   FROM Report.AppDecision
   WHERE ShortCut = @AppDecision;	

	SELECT UnitTypeID As Uid
	FROM ServiceDef.Role_UnitType
	WHERE IsReporting = 1
	AND RoleID = @RoleID
	AND ADID = @AppDecision;
	
	SELECT
	 'SUCCESSFUL' AS RESULT
	,'0S' AS TIMERUN
	,'FileType' AS TABLESNAME
	,'Mojtama' As TableSpaceName
	,'false' AS [HasRelation]
END
GO
