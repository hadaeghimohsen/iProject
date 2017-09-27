SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [Report].[LoadReminderDataSourceWithCondition]
	@Xml Xml
AS
BEGIN
   DECLARE @IsVisible Bit,
           @IsActive  BIT;
   SELECT @IsVisible = @Xml.query('/IsVisible').value('.', 'bit'),
          @IsActive  = @Xml.query('/IsActive').value('.', 'bit');
   
      
   IF(@IsVisible = 1)
      SELECT 
         ID,
         CAST(ShortCut as Varchar(3)) + '- ' + TitleFa as [TitleFa],
         (CASE DatabaseServer 
            WHEN 0 THEN 'Oracle Database'
            WHEN 1 THEN 'SQL Server Database' 
          END) AS [DatabaseServer],
          IsActive
       FROM Report.Datasource
       WHERE IsVisible = 1;
    ELSE
       SELECT 
         ID,
         CAST(ShortCut as Varchar(3)) + '- ' + TitleFa as [TitleFa],
         (CASE DatabaseServer 
            WHEN 0 THEN 'Oracle Database'
            WHEN 1 THEN 'SQL Server Database' 
          END) AS [DatabaseServer],
          IsActive
       FROM Report.Datasource
       WHERE IsActive = @IsActive
         AND IsVisible = 0;

    
   
	SELECT
	 'SUCCESSFUL' AS RESULT
	,'0S' AS TIMERUN
	,'Datasources' AS TABLESNAME
	,'Mojtama' As TableSpaceName
	,'false' AS [HasRelation];      
   
END
GO
