SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [Report].[SetProfilerGroupHeader]
	-- Add the parameters for the stored procedure here
	@XML XML
AS
BEGIN
	DECLARE @RequestType VARCHAR(16);
	DECLARE @Profiler BIGINT;
	DECLARE @Group BIGINT;
	DECLARE @Role BIGINT;
	DECLARE @idoc INT;
	
	SELECT @RequestType = @XML.query('//Request').value('(/Request/@type)[1]', 'VARCHAR(16)');
	
	IF( @RequestType = 'AddNewItem' )
	BEGIN	   
      EXEC SP_XML_PREPAREDOCUMENT @idoc OUTPUT, @XML;
      
      MERGE Report.Profiler_GroupHeader PGT
      USING (
         SELECT Profiler,
                Groupid,
                Roleid,
                (SELECT DataSourceID FROM Report.GroupHeader WHERE ID = Groupid) as DataSourceid, 
                OrderIndex,
                DsFrom,
                DsType      
         FROM OPENXML(@idoc, '//Request/Groups/Group')
         WITH
         (
            Profiler BIGINT '../../Profiler',
            Groupid BIGINT '@id',
            Roleid BIGINT 'Role',
            DsFrom SMALLINT 'Datasource/@from',
            DsType BIT 'Datasource/@type',
            OrderIndex INT 'OrderIndex'
         )
      ) PGS
      ON (PGT.ProfilerID = PGS.Profiler AND PGT.GroupHeaderID = PGS.Groupid AND PGT.RoleID = PGS.Roleid)
      WHEN MATCHED THEN
         UPDATE SET IsActive = 1, IsVisible = 1
      WHEN NOT MATCHED THEN               
	      INSERT 
	         ( ProfilerID,
	           GroupHeaderID,
	           RoleID,
	           DataSourceID,
	           OrderIndex,
	           DatasourceFrom,
	           DatasourceType )
	         VALUES
	         ( PGS.Profiler, 
	           PGS.Groupid, 
	           PGS.Roleid, 
	           PGS.Datasourceid, 
	           PGS.OrderIndex, 
	           PGS.DsFrom, 
	           PGS.DsType );
	         
      EXEC SP_XML_REMOVEDOCUMENT @idoc;   
	END
	ELSE IF( @RequestType = 'Update' )
	BEGIN
	   SELECT 1;
	END
	ELSE IF( @RequestType = 'Leave' )
	BEGIN
	   UPDATE Report.Profiler_GroupHeader
	   SET IsVisible = 0
	   WHERE ProfilerID = @XML.query('//Profiler').value('.','BIGINT')
	   AND EXISTS (SELECT * FROM @XML.nodes('//Groups/Group')t(g) WHERE g.query('.').value('(Group/@id)[1]', 'BIGINT') = GroupHeaderID);
	END
	ELSE IF( @RequestType = 'Join' )
	BEGIN
	   UPDATE Report.Profiler_GroupHeader
	   SET IsVisible = 1
	   WHERE ProfilerID = @XML.query('//Profiler').value('.','BIGINT')
	   AND EXISTS (SELECT * FROM @XML.nodes('//Groups/Group')t(g) WHERE g.query('.').value('(Group/@id)[1]', 'BIGINT') = GroupHeaderID);
	END
	ELSE IF( @RequestType = 'Active' )
	BEGIN
	   UPDATE Report.Profiler_GroupHeader
	   SET IsActive = 1
	   WHERE ProfilerID = @XML.query('//Profiler').value('.','BIGINT')
	   AND EXISTS (SELECT * FROM @XML.nodes('//Groups/Group')t(g) WHERE g.query('.').value('(Group/@id)[1]', 'BIGINT') = GroupHeaderID);
	END
	ELSE IF( @RequestType = 'Deactive' )
	BEGIN
	   UPDATE Report.Profiler_GroupHeader
	   SET IsActive = 0
	   WHERE ProfilerID = @XML.query('//Profiler').value('.','BIGINT')
	   AND EXISTS (SELECT * FROM @XML.nodes('//Groups/Group')t(g) WHERE g.query('.').value('(Group/@id)[1]', 'BIGINT') = GroupHeaderID);
	END
	ELSE IF ( @RequestType = 'ChangeOrder' )
	BEGIN
	   MERGE Report.Profiler_GroupHeader PGT
	   USING(
	      SELECT
	         @XML.query('//Profiler').value('.', 'BIGINT') as [Profiler],
	         g.query('.').value('(Group/@id)[1]', 'BIGINT') as [Group],
            g.query('Role').value('.', 'BIGINT') as [Role],
	         g.query('OrderIndex').value('.', 'INT') as [OrderIndex]
	      FROM @XML.nodes('//Group')t(g)
	   ) PGS
	   ON (PGT.ProfilerID = PGS.Profiler AND PGT.GroupHeaderID = PGS.[Group] AND PGT.RoleID = PGS.[Role])
	   WHEN MATCHED THEN
	      UPDATE SET OrderIndex = PGS.OrderIndex;
	END
	ELSE IF( @RequestType = 'ChangeDatasource' )
	BEGIN	   
	   DECLARE @from SMALLINT;
	   DECLARE @type BIT;
	   DECLARE @dslink BIGINT;
	   SELECT 
	      @from   = ds.query('.').value('(DatasourceTarget/@from)[1]', 'SMALLINT'),
	      @type   = ds.query('DsLink').value('(DsLink/@type)[1]', 'BIT'),
	      @dslink = ds.query('DirectDs').value('(DirectDs/@value)[1]', 'BIGINT')
	   FROM @XML.nodes('//DatasourceTarget')t(ds);
	   
	   	   
	   EXEC SP_XML_PREPAREDOCUMENT @idoc OUTPUT, @XML;
	   
	   MERGE Report.Profiler_GroupHeader PGT
	   USING (
	      SELECT Profilerid,
	             Groupid,
	             Roleid ,
	             CASE @from
	               WHEN 1 THEN -- GroupHeader
	                  (SELECT DataSourceID FROM Report.GroupHeader WHERE ID = Groupid)
	               WHEN 2 THEN -- Profiler
	                  (SELECT DataSourceID FROM Report.Profiler WHERE ID = Profilerid)
	               ELSE        -- Self Direct
	                  @dslink
	             END as DatasourceID	             
         FROM OPENXML(@idoc, '/Request/Groups/Group')
         WITH
         (
            Profilerid BIGINT '../../Profiler',
            Groupid BIGINT '@id',
            Roleid BIGINT 'Role',
            DsFrom SMALLINT 'Datasource/@from',
            DsType BIT 'Datasource/@type',
            OrderIndex INT 'OrderIndex'
         )
	   ) PGS
	   ON (PGT.ProfilerID = PGS.ProfilerID AND PGT.RoleID = PGS.Roleid AND PGT.GroupHeaderID = PGS.Groupid)
	   WHEN MATCHED THEN
	      UPDATE 
	      SET DatasourceID = PGS.DatasourceID,
	          DatasourceFrom = @from,
	          DatasourceType = @type;
	      
	   EXEC SP_XML_REMOVEDOCUMENT @idoc;   
	END
END
GO
