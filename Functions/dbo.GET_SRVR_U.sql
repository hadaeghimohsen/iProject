SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date, ,>
-- Description:	<Description, ,>
-- =============================================
CREATE FUNCTION [dbo].[GET_SRVR_U]
(
	@P_RqstXml XML
)
RETURNS VARCHAR(50)
AS
BEGIN
	DECLARE @RqtpCode VARCHAR(50)
	       ,@DatabaseName VARCHAR(50);
	SELECT @RqtpCode     = @P_RqstXml.query('/Request').value('(Request/@Rqtp_Code)[1]', 'VARCHAR(50)')
	      ,@DatabaseName = @P_RqstXml.query('/Request/Database').value('.', 'VARCHAR(50)');
	
   SET @RqtpCode = UPPER(@RqtpCode);
	
	IF @RqtpCode = 'SRVRADRS' 
	BEGIN
	   RETURN (SELECT IPADDRESS FROM Report.DataSource WHERE UPPER([Database]) = UPPER(@DatabaseName));
	END
	
	RETURN NULL;
END
GO
