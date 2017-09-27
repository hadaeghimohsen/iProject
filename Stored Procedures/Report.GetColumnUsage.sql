SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [Report].[GetColumnUsage]
	@XML XML
AS
BEGIN
	DECLARE @RequestType VARCHAR(16);
	DECLARE @Table BIGINT;
	
	SELECT @RequestType = @XML.query('/Request').value('(Request/@type)[1]', 'VARCHAR(16)'),
	       @Table = @XML.query('//Table').value('.', 'BIGINT');
	
	DECLARE @TableReturn VARCHAR(50);
	
	IF(@RequestType = 'Normal')
	BEGIN
	   SELECT ID,
	          CodeFaName As FaName,
	          CodeEnName As EnName
	   FROM Report.ColumnUsage
	   WHERE TableUsageID = @Table
	     AND IsVisible = 1
	     AND IsActive = 1;
	   Set @TableReturn = 'ColumnUsage';
	END
	ELSE IF( @RequestType = 'TableDetail' )
	BEGIN
	   SELECT 
	       [TableUsageID]
         ,[ID]
         ,[CodeEnName] AS [CEnName]
      FROM [Report].[ColumnUsage]
      WHERE
           TableUsageID = @Table 
       AND IsVisible = 1
       AND IsActive = 1;
   Set @TableReturn = 'ColumnUsage';
	END
	
   SELECT
	 'SUCCESSFUL' AS RESULT
	,'0S' AS TIMERUN
	,@TableReturn AS TABLESNAME
	,'iProject' As TableSpaceName
	,'false' AS [HasRelation];  	
END
GO
