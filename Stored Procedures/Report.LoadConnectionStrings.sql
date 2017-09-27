SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [Report].[LoadConnectionStrings]
   @Xml Xml
AS
BEGIN
	
	Select 
	   'Db_' + CAST(ID as Varchar(Max)) as [Dbid],
	   DatabaseServer,
	   IPAddress,
	   Port,
	   [Database]
	From Report.DataSource
	Where Exists (
	   Select * From @Xml.nodes('/ConnectionStrings/DataSourceID')t(ds)
	   Where ds.query('.').value('.', 'bigint') = ID
	);
	
	
	SELECT
	 'SUCCESSFUL' AS RESULT
	,'0S' AS TIMERUN
	,'DataSources' AS TABLESNAME
	,'Mojtama' As TableSpaceName
	,'false' AS [HasRelation];  
END
GO
