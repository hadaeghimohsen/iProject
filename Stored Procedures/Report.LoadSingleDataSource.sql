SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [Report].[LoadSingleDataSource]
	@Xml Xml
AS
BEGIN
	SELECT *
	FROM Report.DataSource
	WHERE ID = @Xml.query('/DataSourceID').value('.', 'bigint');
	
	SELECT
	 'SUCCESSFUL' AS Result
	,'0S' AS Timerun
	,'DataSource' AS Tablesname
	,'Mojtama' As TableSpaceName
	,'false' AS [HasRelation]; 	
END
GO
