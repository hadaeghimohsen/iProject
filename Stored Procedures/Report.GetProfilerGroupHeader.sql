SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [Report].[GetProfilerGroupHeader]
	-- Add the parameters for the stored procedure here
	@XML XML
AS
BEGIN
	DECLARE @TablesReturn VARCHAR(100);
	DECLARE @Role BIGINT, @Profiler BIGINT;
	DECLARE @AllRoles BIT;
	DECLARE @OrderBy SMALLINT;
	DECLARE @RequestType VARCHAR(15), @Limited BIT;
	SET @TablesReturn = 'RPG';
	SELECT @RequestType = @XML.query('/Request').value('(/Request/@type)[1]', 'VARCHAR(15)'),
	       @Limited     = @XML.query('/Request').value('(/Request/@limited)[1]', 'BIT'),
	       @Role        = @XML.query('//Role').value('.', 'BIGINT'),
	       @Profiler    = @XML.query('//Profiler').value('.', 'BIGINT');
	
	IF( @RequestType = 'Normal' ) -- تمامی اطلاعات سربرگ های پروفایل
	BEGIN
	   IF( @Limited = 1 ) -- فقط یک گروه دسترسی
         SELECT 
            GroupHeaderID AS Gid,
            GFaName,
            RoleID AS Rid,
            RFaName,
            RPGDsid AS Dsid,
            RPGDatasource AS DbFaName,
            RPGOrderIndex AS OrderIndex,
            RPGDatasourceFrom AS DsFrom,
            RPGDatasourceType AS DsType,
            RPGActive AS [State]
         FROM Report.APGR
         WHERE ProfilerID = @Profiler -- کدام پروفایل
           AND RoleID = @Role -- کدام گروه دسترسی
           AND GVisible = 1 -- سربرگ معتبر باشد
           AND GActive = 1 -- سربرگ فعال باشد
           AND RGVisible = 1 -- سربرگ درون گروه دسترسی معتبر باشد 
           AND RGActive = 1 -- سربرگ درون گروه دسترسی فعال باشد
           AND RVisible = 1 -- گروه دسترسی معتبر باشد
           AND RActive = 1 -- گروه دسترسی فعال باشد
           AND PVisible = 1 -- پروفایل معتبر باشد
           AND PActive = 1 -- پروفایل فعال باشد
           AND RPGVisible = 1 -- سربرگ درون گروه دسترسی متعلق به پروفایل معتبر باشد
         ORDER BY RPGOrderIndex;

	   ELSE -- تمامی گروه های دسترسی
	   SELECT 
            GroupHeaderID AS Gid,
            GFaName,
            RoleID AS Rid,
            RFaName,
            RPGDsid AS Dsid,
            RPGDatasource AS DbFaName,
            RPGOrderIndex AS OrderIndex,
            RPGDatasourceFrom AS DsFrom,
            RPGDatasourceType AS DsType,
            RPGActive AS [State]
         FROM Report.APGR
         WHERE ProfilerID = @Profiler -- کدام پروفایل
           --AND RoleID = @Role -- کدام گروه دسترسی
           AND GVisible = 1 -- سربرگ معتبر باشد
           AND GActive = 1 -- سربرگ فعال باشد
           AND RGVisible = 1 -- سربرگ درون گروه دسترسی معتبر باشد 
           AND RGActive = 1 -- سربرگ درون گروه دسترسی فعال باشد
           AND RVisible = 1 -- گروه دسترسی معتبر باشد
           AND RActive = 1 -- گروه دسترسی فعال باشد
           AND PVisible = 1 -- پروفایل معتبر باشد
           AND PActive = 1 -- پروفایل فعال باشد
           AND RPGVisible = 1 -- سربرگ درون گروه دسترسی متعلق به پروفایل معتبر باشد
         ORDER BY RPGOrderIndex;
	   
	END
	ELSE IF ( @RequestType = 'Leave' ) -- سربرگ های پاک شده از پروفایل
	BEGIN
	   IF( @Limited = 1 )	   
	      SELECT 
            GroupHeaderID AS Gid,
            GFaName,
            RoleID AS Rid,
            RFaName,
            RPGDsid AS Dsid,
            RPGDatasource AS DbFaName,
            RPGOrderIndex AS OrderIndex,
            RPGDatasourceFrom AS DsFrom,
            RPGDatasourceType AS DsType,
            RPGActive AS [State]
         FROM Report.APGR
         WHERE ProfilerID = @Profiler -- کدام پروفایل
           AND RoleID = @Role -- کدام گروه دسترسی
           AND GVisible = 1 -- سربرگ معتبر باشد
           AND GActive = 1 -- سربرگ فعال باشد
           AND RGVisible = 1 -- سربرگ درون گروه دسترسی معتبر باشد 
           AND RGActive = 1 -- سربرگ درون گروه دسترسی فعال باشد
           AND RVisible = 1 -- گروه دسترسی معتبر باشد
           AND RActive = 1 -- گروه دسترسی فعال باشد
           AND PVisible = 1 -- پروفایل معتبر باشد
           AND PActive = 1 -- پروفایل فعال باشد
           AND RPGVisible = 0 -- سربرگ درون گروه دسترسی متعلق به پروفایل معتبر نباشد
         ORDER BY RPGOrderIndex;
      ELSE
         SELECT 
            GroupHeaderID AS Gid,
            GFaName,
            RoleID AS Rid,
            RFaName,
            RPGDsid AS Dsid,
            RPGDatasource AS DbFaName,
            RPGOrderIndex AS OrderIndex,
            RPGDatasourceFrom AS DsFrom,
            RPGDatasourceType AS DsType,
            RPGActive AS [State]
         FROM Report.APGR
         WHERE ProfilerID = @Profiler -- کدام پروفایل
           --AND RoleID = @Role -- کدام گروه دسترسی
           AND GVisible = 1 -- سربرگ معتبر باشد
           AND GActive = 1 -- سربرگ فعال باشد
           AND RGVisible = 1 -- سربرگ درون گروه دسترسی معتبر باشد 
           AND RGActive = 1 -- سربرگ درون گروه دسترسی فعال باشد
           AND RVisible = 1 -- گروه دسترسی معتبر باشد
           AND RActive = 1 -- گروه دسترسی فعال باشد
           AND PVisible = 1 -- پروفایل معتبر باشد
           AND PActive = 1 -- پروفایل فعال باشد
           AND RPGVisible = 0 -- سربرگ درون گروه دسترسی متعلق به پروفایل معتبر نباشد
         ORDER BY RPGOrderIndex;
	END
	ELSE IF( @RequestType = 'Actived' ) -- سربرگ های فعال درون پروفایل
	BEGIN
	   IF( @Limited = 1 )
	      SELECT 
            GroupHeaderID AS Gid,
            GFaName,
            RoleID AS Rid,
            RFaName,
            RPGDsid AS Dsid,
            RPGDatasource AS DbFaName,
            RPGOrderIndex AS OrderIndex,
            RPGDatasourceFrom AS DsFrom,
            RPGDatasourceType AS DsType,
            RPGActive AS [State]
         FROM Report.APGR
         WHERE ProfilerID = @Profiler -- کدام پروفایل
           AND RoleID = @Role -- کدام گروه دسترسی
           AND GVisible = 1 -- سربرگ معتبر باشد
           AND GActive = 1 -- سربرگ فعال باشد
           AND RGVisible = 1 -- سربرگ درون گروه دسترسی معتبر باشد 
           AND RGActive = 1 -- سربرگ درون گروه دسترسی فعال باشد
           AND RVisible = 1 -- گروه دسترسی معتبر باشد
           AND RActive = 1 -- گروه دسترسی فعال باشد
           AND PVisible = 1 -- پروفایل معتبر باشد
           AND PActive = 1 -- پروفایل فعال باشد
           AND RPGVisible = 1 -- سربرگ درون گروه دسترسی متعلق به پروفایل معتبر باشد
           AND RPGActive = 1 -- سربرگ درون گروه دسترسی متعلق به پروفایل فعال باشد
         ORDER BY RPGOrderIndex;
      ELSE
          SELECT 
            GroupHeaderID AS Gid,
            GFaName,
            RoleID AS Rid,
            RFaName,
            RPGDsid AS Dsid,
            RPGDatasource AS DbFaName,
            RPGOrderIndex AS OrderIndex,
            RPGDatasourceFrom AS DsFrom,
            RPGDatasourceType AS DsType,
            RPGActive AS [State]
         FROM Report.APGR
         WHERE ProfilerID = @Profiler -- کدام پروفایل
           --AND RoleID = @Role -- کدام گروه دسترسی
           AND GVisible = 1 -- سربرگ معتبر باشد
           AND GActive = 1 -- سربرگ فعال باشد
           AND RGVisible = 1 -- سربرگ درون گروه دسترسی معتبر باشد 
           AND RGActive = 1 -- سربرگ درون گروه دسترسی فعال باشد
           AND RVisible = 1 -- گروه دسترسی معتبر باشد
           AND RActive = 1 -- گروه دسترسی فعال باشد
           AND PVisible = 1 -- پروفایل معتبر باشد
           AND PActive = 1 -- پروفایل فعال باشد
           AND RPGVisible = 1 -- سربرگ درون گروه دسترسی متعلق به پروفایل معتبر باشد
           AND RPGActive = 1 -- سربرگ درون گروه دسترسی متعلق به پروفایل فعال باشد
         ORDER BY RPGOrderIndex;
	END
	ELSE IF( @RequestType = 'Deactived' ) -- سربرگ های غیر فعال درون پروفایل
	BEGIN
	   IF( @Limited = 1 )
	      SELECT 
            GroupHeaderID AS Gid,
            GFaName,
            RoleID AS Rid,
            RFaName,
            RPGDsid AS Dsid,
            RPGDatasource AS DbFaName,
            RPGOrderIndex AS OrderIndex,
            RPGDatasourceFrom AS DsFrom,
            RPGDatasourceType AS DsType,
            RPGActive AS [State]
         FROM Report.APGR
         WHERE ProfilerID = @Profiler -- کدام پروفایل
           AND RoleID = @Role -- کدام گروه دسترسی
           AND GVisible = 1 -- سربرگ معتبر باشد
           AND GActive = 1 -- سربرگ فعال باشد
           AND RGVisible = 1 -- سربرگ درون گروه دسترسی معتبر باشد 
           AND RGActive = 1 -- سربرگ درون گروه دسترسی فعال باشد
           AND RVisible = 1 -- گروه دسترسی معتبر باشد
           AND RActive = 1 -- گروه دسترسی فعال باشد
           AND PVisible = 1 -- پروفایل معتبر باشد
           AND PActive = 1 -- پروفایل فعال باشد
           AND RPGVisible = 1 -- سربرگ درون گروه دسترسی متعلق به پروفایل معتبر باشد
           AND RPGActive = 0 -- سربرگ درون گروه دسترسی متعلق به پروفایل فعال باشد
         ORDER BY RPGOrderIndex;
	   ELSE
	      SELECT 
            GroupHeaderID AS Gid,
            GFaName,
            RoleID AS Rid,
            RFaName,
            RPGDsid AS Dsid,
            RPGDatasource AS DbFaName,
            RPGOrderIndex AS OrderIndex,
            RPGDatasourceFrom AS DsFrom,
            RPGDatasourceType AS DsType,
            RPGActive AS [State]
         FROM Report.APGR
         WHERE ProfilerID = @Profiler -- کدام پروفایل
           --AND RoleID = @Role -- کدام گروه دسترسی
           AND GVisible = 1 -- سربرگ معتبر باشد
           AND GActive = 1 -- سربرگ فعال باشد
           AND RGVisible = 1 -- سربرگ درون گروه دسترسی معتبر باشد 
           AND RGActive = 1 -- سربرگ درون گروه دسترسی فعال باشد
           AND RVisible = 1 -- گروه دسترسی معتبر باشد
           AND RActive = 1 -- گروه دسترسی فعال باشد
           AND PVisible = 1 -- پروفایل معتبر باشد
           AND PActive = 1 -- پروفایل فعال باشد
           AND RPGVisible = 1 -- سربرگ درون گروه دسترسی متعلق به پروفایل معتبر باشد
           AND RPGActive = 0 -- سربرگ درون گروه دسترسی متعلق به پروفایل فعال باشد
         ORDER BY RPGOrderIndex;
	END
	
	SELECT 
	   'SUCCESSFUL' AS Result,
	   '0s' AS TimeRun,
	   @TablesReturn as TablesName,
	   'iProject' as TableSpaceName,
	   'false' as [HasRelation];
END
GO
