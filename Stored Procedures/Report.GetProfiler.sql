SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [Report].[GetProfiler]
	@XML XML
AS
BEGIN
	DECLARE @RequestType VARCHAR(16);
	DECLARE @Profiler BIGINT;
	DECLARE @Role BIGINT;
	SELECT @RequestType = @XML.query('Request').value('(Request/@type)[1]', 'VARCHAR(16)'),
	       @Profiler    = @XML.query('//Profiler').value('(Profiler/@id)[1]', 'BIGINT'),
	       @Role        = @XML.query('//Role').value('(Role/@id)[1]', 'BIGINT');

	DECLARE @TableReturn VARCHAR(50);
	DECLARE @HasRelation BIT;
	
	SET @HasRelation = 'False';
		
	IF( @RequestType = 'GetGroups' )
	BEGIN
	   SELECT pg.GroupHeaderID AS [Group],
	          g.TitleFa As GFaName,
	          pg.DataSourceID AS DataSource
	   FROM Report.Profiler p , Report.Profiler_GroupHeader pg, Report.GroupHeader g
	   WHERE p.ID = @Profiler
	     AND p.ID = pg.ProfilerID
	     AND pg.IsVisible = 1 AND pg.IsActive = 1
	     AND pg.GroupHeaderID = g.ID
	     AND g.IsActive = 1 AND g.IsVisible = 1
	     AND EXISTS (SELECT * FROM @XML.nodes('//Role')t(r) WHERE r.value('.', 'BIGINT') = pg.RoleID)
	     ORDER BY pg.OrderIndex;
	   SET @TableReturn = 'Group';
	END
	ELSE IF( @RequestType = 'NGetGroups' )
	BEGIN
	   SELECT pg.GroupHeaderID AS [Group],
	          g.TitleFa As GFaName,
	          pg.DataSourceID AS DataSource
	   FROM Report.Profiler p , Report.Profiler_GroupHeader pg, Report.GroupHeader g
	   WHERE p.ID = @Profiler
	     AND p.ID = pg.ProfilerID
	     AND pg.IsVisible = 1 AND pg.IsActive = 1
	     AND pg.GroupHeaderID = g.ID
	     AND g.IsActive = 1 AND g.IsVisible = 1
	     AND EXISTS (SELECT * FROM @XML.nodes('//Profiler')t(r) WHERE r.value('@role_id', 'BIGINT') = pg.RoleID)
	     ORDER BY pg.OrderIndex;
	   SET @TableReturn = 'Group';
	END
	SELECT
	 'SUCCESSFUL' AS RESULT
	,'0S' AS TIMERUN
	,@TableReturn AS TABLESNAME
	,'iProject' As TableSpaceName
	,@HasRelation AS [HasRelation];
END
GO
