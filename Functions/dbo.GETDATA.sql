SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date, ,>
-- Description:	<Description, ,>
-- =============================================
CREATE FUNCTION [dbo].[GETDATA]
(
	@X XML
)
RETURNS XML
AS
   /*
      <Request code=""/>
   */
BEGIN
	DECLARE @Code VARCHAR(3);	
	DECLARE @XRespons XML;
	
	SELECT @Code = @X.query('Request').value('(Request/@code)[1]', 'VARCHAR(3)');
	
	IF @Code = '001' -- بدست آوردن شماره سریال قفل
	BEGIN
	   SELECT @XRespons = 
	   (
	      SELECT X.query('//TinyLock')
	        FROM dbo.Settings
	   );	   
	END
	
	RETURN @XRespons;
END
GO
