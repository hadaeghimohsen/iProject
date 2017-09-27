SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [Report].[UpdateProfiler]
	@XML XML
AS
BEGIN
	DECLARE @Profiler BIGINT;
	
	SELECT @Profiler = @XML.query('/UpdateProfiler/Profiler').value('.', 'BIGINT');
	UPDATE Report.Profiler
	SET ShortCut = ISNULL(@XML.query('//ShortCut').value('.','BIGINT'), ShortCut),
	    TitleFa  = ISNULL(@XML.query('//FaName').value('.','NVARCHAR(50)'), TitleFa),
	    TitleEn  = ISNULL(@XML.query('//EnName').value('.','NVARCHAR(50)'), TitleEn),
	    DataSourceID = ISNULL(@XML.query('//Datasource').value('.','BIGINT'), DataSourceID)	    
	WHERE ID = @Profiler;
	
	UPDATE Report.Role_Profiler
	SET IsActive  = 0,
	    IsVisible = @XML.query('//Roles').value('(//Roles/@RemoveType)[1]', 'BIT') 
	WHERE ProfilerID = @Profiler
	  AND NOT EXISTS (SELECT * FROM @XML.nodes('//Role')t(r) WHERE RoleID = r.query('.').value('.','BIGINT'));
	
	MERGE Report.Role_Profiler RPT
	USING (SELECT 
	         r.query('.').value('.', 'BIGINT') as [RoleID]
	       FROM @XML.nodes('//Role')t(r)) RPS
   ON (RPT.RoleID = RPS.RoleID AND RPT.ProfilerID = @Profiler)
   WHEN MATCHED THEN
      UPDATE SET IsActive = 1
   WHEN NOT MATCHED THEN
      INSERT (RoleID, ProfilerID)
      VALUES (RPS.RoleID, @Profiler);
   /*   
   UPDATE Report.Profiler_GroupHeader
   SET DataSourceID = @XML.query('//Datasource').value('.' , 'BIGINT')
   WHERE ProfilerID = @Profiler
     AND DatasourceFrom = 2
     AND DatasourceType = 0;
    */
END
GO
