SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [Report].[GetSchemas]
	@XML XML
AS
BEGIN
	DECLARE @RequestType VARCHAR(16);
	DECLARE @TableReturn VARCHAR(50);
	DECLARE @HasRelation BIT;
	
	SELECT @RequestType = @XML.query('Request').value('(Request/@type)[1]', 'VARCHAR(16)');
	
	IF( @RequestType = 'Normal' )
	BEGIN
	   SELECT 
	      ID, 
	      TitleEn As SEnName
	   FROM Report.Schemas
	   WHERE IsActive = 1
	   AND IsVisible = 1;
	   SET @TableReturn = 'Schema';
	   SET @HasRelation = 0;
	END
	
   SELECT
	 'SUCCESSFUL' AS RESULT
	,'0S' AS TIMERUN
	,@TableReturn AS TABLESNAME
	,'iProject' As TableSpaceName
	,@HasRelation AS [HasRelation];
END
GO
