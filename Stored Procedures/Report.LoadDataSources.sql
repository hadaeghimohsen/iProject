SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [Report].[LoadDataSources]
AS
BEGIN
   SELECT 
      ID,
      CAST(ShortCut AS VARCHAR(3)) + '- ' + TitleFa AS [TitleFa],
      (CASE DatabaseServer 
         WHEN 0 THEN 'Oracle Database'
         WHEN 1 THEN 'SQL Server Database' 
       END) AS [DatabaseServer],
       IsActive
    FROM Report.Datasource
    WHERE IsVisible = 1;
    
	SELECT
	 'SUCCESSFUL' AS RESULT
	,'0S' AS TIMERUN
	,'Datasources' AS TABLESNAME
	,'Mojtama' As TableSpaceName
	,'false' AS [HasRelation];    
END
GO
