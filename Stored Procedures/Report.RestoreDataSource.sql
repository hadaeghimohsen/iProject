SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [Report].[RestoreDataSource]
	@XML XML
AS
BEGIN
   UPDATE Report.DataSource
   Set IsVisible = 1,
       IsActive = 1
   WHERE Exists (
      SELECT * FROM @XML.nodes('/Restore/DataSourceID')t(c)
      WHERE c.query('.').value('.', 'BIGINT') = ID
   );
END
GO
