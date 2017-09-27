SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [Report].[GetDataSource]
	@XML XML	
AS
BEGIN
	DECLARE @RequestType VARCHAR(16);
	DECLARE @TableReturn VARCHAR(100);	
	DECLARE @HasRelation VARCHAR(5);
	DECLARE @CrntUser VARCHAR(250);
	SELECT @RequestType = @XML.query('/Request').value('(Request/@type)[1]', 'VARCHAR(16)')
	      ,@CrntUser = @XML.query('/Request').value('(Request/@crntuser)[1]', 'VARCHAR(250)');
	
	IF( @RequestType = 'Single' )
	BEGIN
	   DECLARE @DataSource BIGINT;
	   SELECT @DataSource = @XML.query('//DataSource').value('(DataSource/@id)[1]', 'BIGINT');
	   
	   DECLARE @TXML XML;
	   SELECT @TXML = 
	   (
	      SELECT
	         DatabaseServer AS '@dsType',
	         IPAddress AS '@server',
	         [Port] AS '@port',
	         [Database] AS '@database',
--	         UserID AS '@user',
	         --[Password] AS '@password'
	         @CrntUser AS '@user',
	         (SELECT PASSDB FROM DataGuard.[User] WHERE UPPER(USERDB) = UPPER(@CrntUser)) AS '@password'
	      FROM Report.DataSource
	      WHERE ID = @DataSource
	      FOR XML PATH('DataSource'), ROOT('DataSources')
	   );
	   
	   SELECT 'XmlData' = @TXML;
	   SET @TableReturn = 'DataSource';
	   SET @HasRelation = 'false';
	END
	
	SELECT
	 'SUCCESSFUL' AS RESULT
	,'0S' AS TIMERUN
	,@TableReturn AS TABLESNAME
	,'iProject' As TableSpaceName
	,@HasRelation AS [HasRelation];	
END
GO
