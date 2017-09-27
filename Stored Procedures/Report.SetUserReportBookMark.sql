SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [Report].[SetUserReportBookMark]
	-- Add the parameters for the stored procedure here
	@XML XML
AS
BEGIN
	DECLARE @Request_Type VARCHAR(16);
	DECLARE @idoc INT;
	DECLARE @TableReturn VARCHAR(100);
	
	SELECT @Request_Type = @XML.query('/Request').value('(Request/@type)[1]', 'VARCHAR(16)');
	
	IF(@Request_Type = 'Create')
	BEGIN
		EXEC SP_XML_PREPAREDOCUMENT @idoc OUTPUT, @XML;
		MERGE Report.UserReportBookMark URBMT
		USING (
			SELECT
	         ServiceID,
	         RoleID,
	         UserName
	      FROM OPENXML(@idoc, '//Report', 2)
	      WITH
	      (
	         ServiceID BIGINT '@id',
	         RoleID    BIGINT '@roleId',
	         UserName  VARCHAR(250) '../../User/@name'
	      ) 
		) URBMS
		ON (URBMT.ServiceID = URBMS.ServiceID AND URBMT.RoleID = URBMS.RoleID AND UPPER(URBMT.UserName) = UPPER(URBMS.UserName))
		WHEN NOT MATCHED THEN
			INSERT (ServiceID, RoleID, UserName, Priority)
			VAlUES (URBMS.ServiceID, URBMS.RoleID, URBMS.UserName, 1)
		WHEN MATCHED THEN
			UPDATE 
			SET Priority = Priority + 1;
		
		EXEC SP_XML_REMOVEDOCUMENT @idoc;	
		SELECT 'Create BookMark Successfully! Done.';
		SET @TableReturn = 'CREATEBOOKMARK';	
	END
	ELSE IF(@Request_Type = 'Remove')
	BEGIN
		EXEC SP_XML_PREPAREDOCUMENT @idoc OUTPUT, @XML;
		MERGE Report.UserReportBookMark URBMT
		USING (
			SELECT
	         ServiceID,
	         RoleID,
	         UserName
	      FROM OPENXML(@idoc, '//Report', 2)
	      WITH
	      (
	         ServiceID BIGINT '@id',
	         RoleID    BIGINT '@roleId',
	         UserName  VARCHAR(250) '../../User/@name'
	      ) 
		) URBMS
		ON (URBMT.ServiceID = URBMS.ServiceID AND URBMT.RoleID = URBMS.RoleID AND UPPER(URBMT.UserName) = UPPER(URBMS.UserName))		
		WHEN MATCHED THEN
			DELETE ;
		
		EXEC SP_XML_REMOVEDOCUMENT @idoc;
		
		SELECT 'Remove BookMark Successfully! Done.';		
		SET @TableReturn = 'REMOVEBOOKMARK';	
	END
	ELSE IF(@Request_Type = 'RemoveAll')
	BEGIN
		DELETE FROM Report.UserReportBookMark
		WHERE UPPER(UserName) = @XML.query('//User').value('(User/@name)[1]', 'VARCHAR(250)');
		
		SELECT 'Remove All BookMark Successfully! Done.';
		SET @TableReturn = 'REMOVEALLBOOKMARK';	
	END
	
	SELECT
	 'SUCCESSFUL' AS RESULT
	,'0S' AS TIMERUN
	,@TableReturn AS TABLESNAME
	,'iProject' As TableSpaceName
	,'false' AS [HasRelation];
END
GO
