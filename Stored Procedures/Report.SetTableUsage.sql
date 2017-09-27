SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [Report].[SetTableUsage]
	@XML XML
AS
BEGIN
	DECLARE @RequestType VARCHAR(16);
	DECLARE @idoc INT;
	
	SELECT @RequestType = @XML.query('/Request').value('(Request/@type)[1]', 'VARCHAR(16)');
	IF ( @RequestType = 'Transfer') 
	BEGIN	   
	   EXEC SP_XML_PREPAREDOCUMENT @idoc OUTPUT, @XMl;
	   MERGE Report.TableUsage TUT
	   USING(
	      SELECT
	         faName,
	         enName,
	         enRealName,
	         orderIndex
	      FROM OPENXML(@idoc, '//Table', 2)
	      WITH
	      (
	         faName NVARCHAR(50) '@faName',
	         enName NVARCHAR(50) '@enName',
	         enRealName VARCHAR(50) '@enRealName',
	         orderIndex INT      '@orderIndex'
	      ) 
	   ) TUS
	   ON (TUT.TitleEn = TUS.enName)
	   WHEN MATCHED THEN
	      UPDATE SET IsActive = 1, IsVisible = 1
	   WHEN NOT MATCHED THEN
	      INSERT (ShortCut, TitleFa, TitleEn, RealName)
	      VALUES (TUS.OrderIndex, TUS.faName, TUS.enName, TUS.enRealName);	   
	   EXEC SP_XML_REMOVEDOCUMENT @idoc;
	   
	   EXEC Report.SetColumnUsage @XML;
	END
END
GO
