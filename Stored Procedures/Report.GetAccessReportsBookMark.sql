SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [Report].[GetAccessReportsBookMark]
	-- Add the parameters for the stored procedure here
	@XML XML
AS
BEGIN
	DECLARE @Rqtp VARCHAR(15);
	SELECT @Rqtp = @XML.query('Request').value('(Request/@type)[1]', 'VARCHAR(15)');
	
	DECLARE @Tabl_Ret VARCHAR(100);
	DECLARE @Has_Relt BIT;
	IF (@Rqtp = 'USER')
	BEGIN
	   DECLARE @USER_NAME VARCHAR(255);
	   SELECT @USER_NAME = @XML.query('//User').value('.', 'VARCHAR(255)');
	   DECLARE @TXML XML;
	   SELECT @TXML = 
	   (
	      SELECT DISTINCT
	         RoleID AS '@id',
	         N'گزارشات پرکاربرد' AS '@faName'
	      FROM Report.v$UserReportsBookMark
	      WHERE UserName = @USER_NAME
	      FOR XML PATH('Role'), ROOT('AccessReport')
	   );
	   
	   DECLARE AccessReports CURSOR FOR
	   SELECT
	      RoleID, 
	      ServiceID,
	      LogicalName,
	      PhysicalName,
	      Report.GetIsLarge(ROW_NUMBER() OVER( ORDER BY RoleID, ServiceID )) AS Is_Larg
	   FROM Report.v$UserReportsBookMark
	   WHERE USERNAME = @USER_NAME;
	   
	   DECLARE @Role_ID        BIGINT,
	           @Serv_ID        BIGINT,
	           @LogicalName    NVARCHAR(255),
	           @PhysicalName   VARCHAR(MAX),
	           @Rwno           INT,
	           @Is_Larg        BIT;
	           
      SET @Rwno = 0;	           
	   OPEN AccessReports;
	   GO_NEXTITEM_1st:
	   FETCH NEXT FROM AccessReports 
	   INTO @Role_ID,
	        @Serv_ID,
	        @LogicalName,
	        @PhysicalName,
	        @Is_Larg;
	   	   
	   IF(@@FETCH_STATUS != 0)
	      GOTO GO_EXIT_1st;
      
	   IF(@TXML.exist('//Report[@id = sql:variable("@Serv_ID")]') = 1)
	      GOTO GO_NEXTITEM_1st;
	   
	   SET @Rwno += 1;
	   SET @TXML.modify(
	      'insert <Report rowNo="{sql:variable("@Rwno")}" isLarge="{sql:variable("@Is_Larg")}" id="{sql:variable("@Serv_ID")}" roleId="{sql:variable("@Role_ID")}">
	                 <LogicalName>{sql:variable("@LogicalName")}</LogicalName>
	                 <PhysicalName>{sql:variable("@PhysicalName")}</PhysicalName>
	              </Report>
	       into (/AccessReport/Role[@id = sql:variable("@Role_ID")])[1]'
	   );
	   
	   GOTO GO_NEXTITEM_1st;
	      
	   GO_EXIT_1st:
	   CLOSE AccessReports;
	   DEALLOCATE AccessReports;
	   
	   SELECT 'xAccessReport' = @TXML;
	   SET @Tabl_Ret = 'AccessReport';
	   SET @Has_Relt = 'False';
	   
	END
	
	SELECT
	 'SUCCESSFUL' AS RESULT
	,'0S' AS TIMERUN
	,@Tabl_Ret AS TABLESNAME
	,'iProject' As TableSpaceName
	,@Has_Relt AS [HasRelation];
END
GO
