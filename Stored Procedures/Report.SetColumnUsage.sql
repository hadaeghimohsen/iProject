SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [Report].[SetColumnUsage]
	@XML XML
AS
BEGIN
	DECLARE @RequestType VARCHAR(16);
	DECLARE @idoc INT;
	
	SELECT @RequestType = @XML.query('/Request').value('(Request/@type)[1]', 'VARCHAR(16)');
	IF ( @RequestType = 'Transfer') 
	BEGIN
	   EXEC SP_XML_PREPAREDOCUMENT @idoc OUTPUT, @XML;
	   MERGE Report.ColumnUsage CUT
	   USING
	   (
	      SELECT faName,
	             enName,
	             orderIndex,
	             [type],
	             formulaName,
	             tableName,
	             tu.id as tableID
	      FROM Report.TableUsage tu,
	      OPENXML(@idoc, '//Field')
	      WITH
	      (
	         faName NVARCHAR(50)      '@faName',
	         enName NVARCHAR(50)      '@enName',
	         orderIndex INT           '@orderIndex',
	         [type] VARCHAR(100)      '@type',
	         formulaName VARCHAR(100) '@formulaName',
	         tableName VARCHAR(50)    '../@enName'
	      )
	      WHERE tableName = tu.TitleEn
	        --AND tu.[Schemas] = 'NoSchema'
	   ) CUS
	   ON (CUT.TableUsageID = CUS.tableID AND CUT.CodeEnName = CUS.enName)
	   --WHEN MATCHED THEN
	   --   UPDATE SET IsActive = 1, IsVisible = 1
	   WHEN NOT MATCHED THEN
	      INSERT (TableUsageID ,ShortCut, CodeFaName, CodeEnName, ColumnType, FormulaName)
	      VALUES (CUS.tableID ,CUS.orderIndex, CUS.faName, CUS.enName, CUS.[type], CUS.formulaName);
	   
	   EXEC SP_XML_REMOVEDOCUMENT @idoc;
	END
END
GO
