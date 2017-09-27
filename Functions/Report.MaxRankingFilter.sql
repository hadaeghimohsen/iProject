SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date, ,>
-- Description:	<Description, ,>
-- =============================================
CREATE FUNCTION [Report].[MaxRankingFilter]
(
   @Filter BIGINT,
	@XML XML
)
RETURNS INT
AS
BEGIN
   RETURN (
      SELECT ISNULL(MAX(Report.RankingFilter(ID)) , -1000)
      FROM Report.Filter
      WHERE ID <> @Filter
        AND FilterState = 1
        AND GroupHeaderID = @XML.query('//Group').value('.', 'BIGINT')
        AND EXISTS ( SELECT * 
                      FROM @XML.nodes('//Role')t(r)
                     WHERE r.value('.','BIGINT') = RoleID
                   )
   );
END
GO
