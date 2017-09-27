SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [Global].[SetFormReport]
	-- Add the parameters for the stored procedure here
	@XML XML
AS
BEGIN
	DECLARE @Rqtp_Desc VARCHAR(25);
	SELECT @Rqtp_Desc = @XML.query('Request').value('(Request/@type)[1]', 'VARCHAR(25)');
	
	DECLARE @Tbl_Ret VARCHAR(100);
	DECLARE @Has_Relt BIT;
	IF(@Rqtp_Desc = 'SetCurrentFormReports')
	BEGIN
	   DECLARE C$FormReports CURSOR FOR
	      SELECT r.query('ID').value('.', 'BIGINT') AS ID
	            ,@XML.query('//Guid').value('.', 'VARCHAR(38)') AS Guid
	            ,r.query('PROF_ROLE_ID').value('.', 'BIGINT') AS PROF_ROLE_ID
	            ,r.query('SERV_ROLE_ID').value('.', 'BIGINT') AS SERV_ROLE_ID
	            ,r.query('PROF_ID').value('.', 'BIGINT') AS PROF_ID
	            ,r.query('SERV_ID').value('.', 'BIGINT') AS SERV_ID
	            ,r.query('RWNO').value('.', 'BIGINT') AS RWNO
	            --,r.query('//RWNO').value('.', 'BIGINT') AS RWNO
	            ,r.query('RPRT_DESC').value('.', 'NVARCHAR(250)') AS RPRT_DESC
	            ,@XML.query('//Application').value('(Application/@subsys)[1]', 'CHAR(3)') AS Sub_Sys
	            ,@XML.query('//Application').value('(Application/@enname)[1]', 'NVARCHAR(250)') AS Apen_Name
	            ,@XML.query('//Form').value('(Form/@enname)[1]', 'NVARCHAR(250)') AS En_Name
	        FROM @Xml.nodes('//Form_Report') T(r);
	   
	   DECLARE @ID BIGINT
	          ,@GUID VARCHAR(38)  
	          ,@PROF_ROLE_ID BIGINT
	          ,@SERV_ROLE_ID BIGINT
	          ,@PROF_ID      BIGINT
	          ,@SERV_ID      BIGINT
	          ,@RWNO         BIGINT
	          ,@Rprt_Desc    NVARCHAR(250)
	          ,@Sub_Sys      VARCHAR(3)
	          ,@Apen_Name    NVARCHAR(250)
	          ,@En_Name      NVARCHAR(250);
	   
	   OPEN C$FormReports;
	   LFetch:
	   FETCH NEXT FROM C$FormReports INTO @ID, @Guid, @Prof_Role_ID, @Serv_Role_Id, @Prof_Id, @Serv_Id, @Rwno, @Rprt_Desc, @Sub_Sys, @Apen_Name, @En_Name
	   
	   IF @@FETCH_STATUS <> 0
	      GOTO LEnd;
	      IF EXISTS(
	         SELECT *
	           FROM v$FormReports
	          WHERE ID = @ID
	            AND GUID = @GUID-- @XML.query('//GUID').value('.', 'VARCHAR(38)')
	            AND SUB_SYS = @Sub_Sys --@XML.query('//Application').value('(Application/@subsys)[1]', 'CHAR(3)')
	            AND APEN_NAME = @Apen_Name --@XML.query('//Application').value('(Application/@enname)[1]', 'NVARCHAR(250)')
	            AND EN_NAME   = @En_Name --@XML.query('//Form').value('(Form/@enname)[1]', 'NVARCHAR(250)')
	            AND PROF_ROLE_ID = @PROF_ROLE_ID--@XML.query('//PROF_ROLE_ID').value('.', 'BIGINT')
	            AND PROF_ID = @PROF_ID --@XML.query('//PROF_ID').value('.', 'BIGINT')
	            AND SERV_ROLE_ID = @SERV_ROLE_ID-- @XML.query('//SERV_ROLE_ID').value('.', 'BIGINT')
	            AND SERV_ID = @SERV_ID --@XML.query('//SERV_ID').value('.', 'BIGINT')	        
	      )
	      UPDATE Global.v$FormReports
	         SET PROF_ROLE_ID = @PROF_ROLE_ID--@XML.query('//PROF_ROLE_ID').value('.', 'BIGINT'),
	            ,PROF_ID = @PROF_ID--@XML.query('//PROF_ID').value('.', 'BIGINT'),
	            ,SERV_ROLE_ID = @SERV_ROLE_ID--@XML.query('//SERV_ROLE_ID').value('.', 'BIGINT'),
	            ,SERV_ID = @SERV_ID--@XML.query('//SERV_ID').value('.', 'BIGINT'),
	            ,RPRT_DESC = @Rprt_Desc
          WHERE GUID = @GUID--@XML.query('//GUID').value('.', 'VARCHAR(38)')
            AND RWNO = @RWNO --@XML.query('//RWNO').value('.', 'BIGINT');
            AND ID   = @ID
         ELSE
         BEGIN
            IF NOT EXISTS(
               SELECT *
                 FROM Global.Form
                WHERE SUB_SYS = @Sub_Sys
                  AND APEN_NAME = @Apen_Name
                  AND EN_NAME = @En_Name
                  AND GUID = @GUID
            )
               INSERT INTO Global.Form (SUB_SYS, APEN_NAME, EN_NAME, GUID)
               VALUES (@Sub_Sys, @Apen_Name, @En_Name, @GUID);
            
            SELECT @ID = MAX(ID)
              FROM global.Form
             WHERE SUB_SYS = @Sub_Sys
               AND EN_NAME = @En_Name;
               
            IF NOT EXISTS(
               SELECT *
                 FROM Global.Form_Report
                WHERE FORM_ID = @ID
                  AND PROF_ID = @PROF_ID
                  AND PROF_ROLE_ID = @PROF_ROLE_ID
                  AND SERV_ID = @SERV_ID
                  AND SERV_ROLE_ID = @SERV_ROLE_ID
            )
               INSERT INTO GLobal.Form_Report (FORM_ID, RWNO, RPRT_DESC, PROF_ID, PROF_ROLE_ID, SERV_ID, SERV_ROLE_ID)
               VALUES (@ID, (SELECT ISNULL(MAX(RWNO), 1) + 1 FROM v$FormReports WHERE GUID = @GUID AND EN_NAME = @En_Name), 
               @Rprt_Desc, @PROF_ID, @PROF_ROLE_ID, @SERV_ID, @SERV_ROLE_ID);
               
	      END
	   GOTO LFetch;
	   LEnd:
	   CLOSE C$FormReports;
	   DEALLOCATE C$FormReports;   
	   
	END
	ELSE IF(@Rqtp_Desc = 'DelCurrentFormReport')
	BEGIN
	   DELETE Global.Form_Report
	    WHERE FORM_ID = @XML.query('//Form_Report/ID').value('.', 'BIGINT')
	      AND RWNO    = @XML.query('//Form_Report/RWNO').value('.', 'BIGINT')
	END
END
GO
