SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [Report].[GetTableUsage]
	@XML XML
AS
BEGIN
	DECLARE @RequestType VARCHAR(16);
	SELECT @RequestType = @XML.query('/Request').value('(Request/@type)[1]', 'VARCHAR(16)');
	
	DECLARE @TableReturn VARCHAR(50);
	
	IF(@RequestType = 'Normal')
	BEGIN
	   SELECT ID,
	          TitleFa As FaName,
	          TitleEn As EnName
	   FROM Report.TableUsage
	   WHERE IsVisible = 1
	     AND IsActive = 1
	     AND TableType = 1 /* Real Table */;
	   Set @TableReturn = 'TableUsage';
	END
	ELSE IF( @RequestType = 'Tables')
	BEGIN
	   SELECT ID,
	          COALESCE(RealName, TitleEn) /*+ ' - ['+ CASE TableType WHEN 1 THEN 'T' ELSE 'D' END +'] '*/ As [TEnName]
	   FROM Report.TableUsage
	   WHERE IsVisible = 1
	     AND IsActive = 1
	     AND TableType = 1;

	   Set @TableReturn = 'TableUsage';
	END
	ELSE IF( @RequestType = 'Domains')
	BEGIN
	   SELECT ID,
	          TitleEn /*+ ' - ['+ CASE TableType WHEN 1 THEN 'T' ELSE 'D' END +'] '*/ As [TEnName]
	   FROM Report.TableUsage
	   WHERE IsVisible = 1
	     AND IsActive = 1
	     AND TableType = 0;

	   Set @TableReturn = 'TableUsage';
	END
   SELECT
	 'SUCCESSFUL' AS RESULT
	,'0S' AS TIMERUN
	,@TableReturn AS TABLESNAME
	,'iProject' As TableSpaceName
	,'false' AS [HasRelation];  	
END
GO
