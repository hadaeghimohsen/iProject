SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [Global].[GetFormReport]
	-- Add the parameters for the stored procedure here
	@XML XML
AS
BEGIN
	DECLARE @Rqtp_Desc VARCHAR(25);
	SELECT @Rqtp_Desc = @XML.query('Request').value('(Request/@type)[1]', 'VARCHAR(25)');
	
	DECLARE @Tbl_Ret VARCHAR(100);
	DECLARE @Has_Relt BIT;
	
	IF (@Rqtp_Desc = 'GetReportRwno')
	BEGIN	
	   SELECT
	      R.Serv_ID AS 'StepOne/Report/@id',
	      R.Serv_Name AS 'StepOne/Report/LogicalName',
	      R.Serv_File_Path AS 'StepOne/Report/PhysicalName',
	      P.PROF_ID AS 'StepTwo/Profiler/@id',
	      P.DSRC_ID AS 'StepTwo/Profiler/@dataSource',
	      P.ROLE_ID AS 'StepTwo/Profiler/@role_id'
	   FROM
	   (
	      SELECT DISTINCT
	             AR.Serv_ID,
	             AR.Serv_Name,
	             AR.Serv_File_Path 
	      FROM Report.v$AccessReports AR
	      WHERE UPPER(AR.User_Name) = UPPER(@XML.query('//User').value('.', 'VARCHAR(MAX)'))	      
	        AND EXISTS(
	            SELECT * FROM Global.v$FormReports FR
	            WHERE FR.SERV_ID = AR.Serv_ID
	              AND FR.GUID = @XML.query('//Guid').value('.', 'VARCHAR(38)')
	              AND FR.RWNO = @XML.query('//Report').value('(Report/@rwno)[1]', 'BIGINT')
	              AND FR.SERV_ROLE_ID = AR.Role_ID
	        )
	   ) R,
	   (
	      SELECT DISTINCT
	             AP.PROF_ID,
	             AP.DSRC_ID,
	             AP.ROLE_ID	         
	      FROM Report.v$AccessProfilers AP
	      WHERE UPPER(AP.USER_NAME) = UPPER(@XML.query('//User').value('.', 'VARCHAR(MAX)'))
	        AND EXISTS(
	            SELECT * FROM Global.v$FormReports FR
	            WHERE FR.PROF_ID = AP.PROF_ID
	              AND FR.GUID = @XML.query('//Guid').value('.', 'VARCHAR(38)')
	              AND FR.RWNO = @XML.query('//Report').value('(Report/@rwno)[1]', 'BIGINT')
	              AND FR.PROF_ROLE_ID = AP.ROLE_ID	              
	        )
	   ) P
	   FOR XML PATH('RunReport'), ROOT('RunReports');
	   
	   SET @Tbl_Ret = 'RunReport';
	   SET @Has_Relt = 'false'
	END
	ELSE IF(@Rqtp_Desc = 'GetCurrentFormReports' )
	BEGIN
	   SELECT 
	    FR.[ID]      
      ,FR.[FA_NAME]
      ,FR.[GUID]      
      ,FR.[RWNO]
      ,FR.[RPRT_DESC]
      ,FR.[PROF_ID]
      ,FR.[SERV_ID]
      ,FR.[PROF_ROLE_ID]
      ,FR.[SERV_ROLE_ID]
	   FROM Global.v$FormReports FR
	   WHERE FR.GUID = @XML.query('//Guid').value('.', 'VARCHAR(38)');
	   
	   SET @Tbl_Ret = 'Form_Report';	   
	   SET @Has_Relt = 'false';
	END
	SELECT
	 'SUCCESSFUL' AS RESULT
	,'0S' AS TIMERUN
	,@Tbl_Ret AS TABLESNAME
	,'iProject' As TableSpaceName
	,@Has_Relt AS [HasRelation];
END
GO
