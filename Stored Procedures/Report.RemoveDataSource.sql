SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [Report].[RemoveDataSource]
	@XML XML
AS
BEGIN
   UPDATE Report.DataSource
   Set IsVisible = 0,
       IsActive = 0
   WHERE Exists (
      SELECT * FROM @XML.nodes('/Remove/DataSourceID')t(c)
      WHERE c.query('.').value('.', 'BIGINT') = ID
   );
END
GO
