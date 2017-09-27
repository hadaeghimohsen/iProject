SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date, ,>
-- Description:	<Description, ,>
-- =============================================
CREATE FUNCTION [dbo].[GET_UPWD_U]
(
	@P_RqstXml XML
)
RETURNS VARCHAR(MAX)
AS
BEGIN
	DECLARE @RqtpCode VARCHAR(50)
	       ,@UserName VARCHAR(MAX);
	
	SELECT  @RqtpCode     = @P_RqstXml.query('/Request').value('(Request/@Rqtp_Code)[1]', 'VARCHAR(50)')
	       ,@UserName     = @P_RqstXml.query('/Request/User').value('.', 'VARCHAR(MAX)');
	
	SET @RqtpCode = UPPER(@RqtpCode);
	
	IF @RqtpCode = 'DBPWD' 
	   RETURN (SELECT PASSDB FROM DataGuard.[User] WHERE UPPER(TitleEn) = UPPER(@UserName));
	ELSE IF @RqtpCode = 'DBUSER'
      RETURN (SELECT USERDB FROM DataGuard.[User] WHERE UPPER(TitleEn) = UPPER(@UserName));
	ELSE IF @RqtpCode = 'FACTORY'
	   RETURN (SELECT DFLT_FACT FROM DataGuard.[User] WHERE UPPER(USERDB) = UPPER(SUSER_NAME()))
	RETURN NULL;
END
GO
