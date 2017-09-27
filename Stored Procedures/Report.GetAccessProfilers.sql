SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [Report].[GetAccessProfilers]
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
	      FROM Report.v$AccessProfilers
	      WHERE User_Name = @USER_NAME
	      FOR XML PATH('Role'), ROOT('AccessProfiler')
	   );
	   
	   DECLARE AccessProfilers CURSOR FOR
	   SELECT
	      Role_ID, 
	      Prof_ID,
	      Prof_Name,
	      DSrc_ID,
	      Report.GetIsLarge(ROW_NUMBER() OVER( ORDER BY Role_ID, Prof_ID )) AS Is_Larg
	   FROM Report.v$AccessProfilers
	   WHERE USER_NAME = @USER_NAME;
	   
	   DECLARE @Role_ID        BIGINT,
	           @Prof_ID        BIGINT,
	           @Prof_Name      NVARCHAR(255),
	           @DSrc_ID        VARCHAR(MAX),
	           @Rwno           INT,
	           @Is_Larg        BIT;
	           
      SET @Rwno = 0;	           
	   OPEN AccessProfilers;
	   GO_NEXTITEM_1st:
	   FETCH NEXT FROM AccessProfilers 
	   INTO @Role_ID,
	        @Prof_ID,
	        @Prof_Name,
	        @DSrc_ID,
	        @Is_Larg;
	        
      PRINT @Role_ID;
	   	   
	   IF(@@FETCH_STATUS != 0)
	      GOTO GO_EXIT_1st;
      
/*
	   IF(@TXML.exist('//Profiler[@id = sql:variable("@Prof_ID")]') = 1)
	      GOTO GO_NEXTITEM_1st;
*/
	   
	   SET @Rwno += 1;
	   SET @TXML.modify(
	      'insert <Profiler rowNo="{sql:variable("@Rwno")}" isLarge="{sql:variable("@Is_Larg")}" id="{sql:variable("@Prof_ID")}" faName="{sql:variable("@Prof_Name")}" dataSource="{sql:variable("@DSrc_ID")}" role_id="{sql:variable("@Role_ID")}"/>
	       into (/AccessProfiler/Role[@id = sql:variable("@Role_ID")])[1]'
	   );
	   
	   GOTO GO_NEXTITEM_1st;
	      
	   GO_EXIT_1st:
	   CLOSE AccessProfilers;
	   DEALLOCATE AccessProfilers;
	   
	   SELECT 'xAccessProfiler' = @TXML;
	   SET @Tabl_Ret = 'AccessProfiler';
	   SET @Has_Relt = 'False';	   
	END
	ELSE IF( @Rqtp = 'ROLES' )
	BEGIN
	   SELECT DISTINCT
	         ROLE_ID ,
	         ROLE_NAME
        FROM Report.v$AccessProfilers
       WHERE UPPER(User_Name) = UPPER(@XML.query('//User').value('.', 'VARCHAR(255)'));
       
       SET @Tabl_Ret = 'Roles';
       SET @Has_Relt = 'false';	   
   END
   ELSE IF(@Rqtp = 'USER-ROLES')
   BEGIN
      SELECT DISTINCT
	         PROF_ID ,
	         PROF_NAME
        FROM Report.v$AccessProfilers
       WHERE UPPER(User_Name) = UPPER(@XML.query('//User').value('.', 'VARCHAR(255)'))
         AND ROLE_ID = @XML.query('//Role').value('.', 'BIGINT');
       
       SET @Tabl_Ret = 'Profilers';
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
