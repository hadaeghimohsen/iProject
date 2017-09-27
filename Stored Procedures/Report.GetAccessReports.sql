SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [Report].[GetAccessReports]
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
	         Role_ID AS '@id',
	         Role_Name AS '@faName'
	      FROM Report.v$AccessReports
	      WHERE User_Name = @USER_NAME
	      FOR XML PATH('Role'), ROOT('AccessReport')
	   );
	   
	   DECLARE AccessReports CURSOR FOR
	   SELECT
	      Role_ID, 
	      Serv_ID,
	      Serv_Name,
	      Serv_File_Path,
	      Report.GetIsLarge(ROW_NUMBER() OVER( ORDER BY Role_ID, Serv_ID )) AS Is_Larg
	   FROM Report.v$AccessReports
	   WHERE USER_NAME = @USER_NAME;
	   
	   DECLARE @Role_ID        BIGINT,
	           @Serv_ID        BIGINT,
	           @Serv_Name      NVARCHAR(255),
	           @Serv_File_Path VARCHAR(MAX),
	           @Rwno           INT,
	           @Is_Larg        BIT;
	           
      SET @Rwno = 0;	           
	   OPEN AccessReports;
	   GO_NEXTITEM_1st:
	   FETCH NEXT FROM AccessReports 
	   INTO @Role_ID,
	        @Serv_ID,
	        @Serv_Name,
	        @Serv_File_Path,
	        @Is_Larg;
	   	   
	   IF(@@FETCH_STATUS != 0)
	      GOTO GO_EXIT_1st;
      
	   IF(@TXML.exist('//Report[@id = sql:variable("@Serv_ID")]') = 1)
	      GOTO GO_NEXTITEM_1st;
	   
	   SET @Rwno += 1;
	   SET @TXML.modify(
	      'insert <Report rowNo="{sql:variable("@Rwno")}" isLarge="{sql:variable("@Is_Larg")}" id="{sql:variable("@Serv_ID")}" roleId="{sql:variable("@Role_ID")}">
	                 <LogicalName>{sql:variable("@Serv_Name")}</LogicalName>
	                 <PhysicalName>{sql:variable("@Serv_File_Path")}</PhysicalName>
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
   ELSE IF( @Rqtp = 'ROLES' )
	BEGIN
	   SELECT DISTINCT
	         ROLE_ID ,
	         ROLE_NAME
        FROM Report.v$AccessReports
       WHERE UPPER(User_Name) = UPPER(@XML.query('//User').value('.', 'VARCHAR(255)'));
       
       SET @Tabl_Ret = 'Roles';
       SET @Has_Relt = 'false';	   
   END
   ELSE IF(@Rqtp = 'USER-ROLES')
   BEGIN
      SELECT DISTINCT
	         SERV_ID ,
	         SERV_NAME
        FROM Report.v$AccessReports
       WHERE UPPER(User_Name) = UPPER(@XML.query('//User').value('.', 'VARCHAR(255)'))
         AND ROLE_ID = @XML.query('//Role').value('.', 'BIGINT');
       
       SET @Tabl_Ret = 'Reports';
       SET @Has_Relt = 'false';	   
   END

	
	SELECT
	 'SUCCESSFUL' AS RESULT
	,'0S' AS TIMERUN
	,@Tabl_Ret AS TABLESNAME
	,'iProject' As TableSpaceName
	,@Has_Relt AS [HasRelation];
END
GO
