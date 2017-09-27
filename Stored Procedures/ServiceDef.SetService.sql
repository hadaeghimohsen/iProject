SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [ServiceDef].[SetService]
	-- Add the parameters for the stored procedure here
	@XML XML
AS
BEGIN
	DECLARE @Request_Type VARCHAR(16);
	SELECT @Request_Type = @XML.query('Request').value('(Request/@type)[1]', 'VARCHAR(16)');
	IF @Request_Type = 'Change_Title_En'
	BEGIN
		UPDATE ServiceDef.Service
		SET TitleEn = @XML.query('//Service').value('(Service/@newName)[1]', 'NVARCHAR(MAX)')
		WHERE 
			UPPER(TitleEn) = UPPER(@XML.query('//Service').value('(Service/@oldName)[1]', 'NVARCHAR(MAX)'));
	END;
END
GO
