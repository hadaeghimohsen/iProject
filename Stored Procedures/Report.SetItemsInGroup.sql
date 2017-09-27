SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [Report].[SetItemsInGroup]
	@XML XML
AS
BEGIN
	DECLARE @RequestType VARCHAR(16);
	DECLARE @idoc INT;
	DECLARE @GroupID BIGINT;
	DECLARE @RoleID BIGINT;
	
	SELECT @RequestType = @XML.query('/Request').value('(Request/@type)[1]', 'VARCHAR(16)'),
	       @GroupID = @XML.query('//Group').value('(Group/@id)[1]', 'BIGINT'),
	       @RoleID = @Xml.query('//Role').value('(Role/@id)[1]', 'BIGINT');
	       
	IF ( @RequestType = 'Transfer' ) 
	BEGIN
	   EXEC Report.SetTableUsage @XML;
	   
	   EXEC SP_XML_PREPAREDOCUMENT @idoc OUTPUT, @XML;
	   
	   MERGE Report.Filter GTT
	   USING(
	      SELECT
	         @Groupid as GroupHeaderID,
	         @Roleid as RoleID,
	         tc.TableID as TableUsageID,
	         tc.ColumnID as ColumnUsageID,
	         tx.TOrderIndex,
	         tc.TFaName,
	         tc.TEnName,
	         tx.COrderIndex,
	         tc.CFaName,
	         tc.CEnName,
	         tc.ColumnType
	      FROM Report.AllTablesColumns tc,
	      OPENXML(@idoc, '//Field', 2)
	      WITH
	      (
	         CFaName NVARCHAR(50) '@faName',
	         CEnName NVARCHAR(50) '@enName',
	         COrderIndex INT      '@orderIndex',
	         TFaName NVARCHAR(50) '../@faName',
	         TEnName NVARCHAR(50) '../@enName',
	         TOrderIndex INT      '../@orderIndex'
	      ) as tx
	      WHERE tc.TEnName = tx.TEnName 
	        AND tc.CEnName = tx.CEnName
	   ) GTS
	   ON (GTT.GroupHeaderID = GTS.GroupHeaderID AND GTT.RoleID = GTS.RoleID AND 
	       GTT.TableUsageID = GTS.TableUsageID AND GTT.ColumnUsageID = GTS.ColumnUsageID)
      WHEN NOT MATCHED THEN
         INSERT ( 
                  GroupHeaderID, 
                  RoleID, 
                  TableType_Dnrm,
                  TableUsageID, 
                  ColumnUsageID, 
                  TableOrderIndex,
                  TableFaName_Dnrm,
                  TableEnName_Dnrm,
                  ColumnOrderIndex,
                  ColumnFaName_Dnrm,
                  ColumnEnName_Dnrm,
                  ColumnType_Dnrm )
         VALUES (                  
                  GTS.GroupHeaderID,
                  GTS.RoleID,
                  1,
                  GTS.TableUsageID,
                  GTS.ColumnUsageID,
                  GTS.TOrderIndex,
                  GTS.TFaName,
                  GTS.TEnName,
                  GTS.COrderIndex,
                  GTS.CFaName,
                  GTS.CEnName,
                  GTS.ColumnType );
      
      EXEC SP_XML_REMOVEDOCUMENT @idoc;	       
	END
	ELSE IF( @RequestType = 'Update' )
	BEGIN
	   UPDATE Report.Filter
	   SET
	      FilterState       = f.query('.').value('(Filter/@state)[1]', 'BIT'),
	      MultiSelected     = f.query('.').value('(Filter/@multiSelected)[1]', 'BIT'),
	      Distincted        = f.query('.').value('(Filter/@distincted)[1]', 'BIT'),
	      HighAccessControl = f.query('RefTable').value('(RefTable/@hac)[1]', 'SMALLINT'),
	      HasMaxLen         = f.query('MaxLen').value('(MaxLen/@checked)[1]', 'BIT'),
	      MaxLen            = f.query('MaxLen').value('(MaxLen/@value)[1]', 'INT'),
	      IsStringDate      = f.query('StringDate').value('(StringDate/@checked)[1]', 'BIT'),
	      [DigitSep]        = f.query('DigitSep').value('(DigitSep/@checked)[1]', 'BIT'),
	      HasNumberPoint    = f.query('NumberPoint').value('(NumberPoint/@checked)[1]', 'BIT'),
	      MaxNumberPoint    = f.query('NumberPoint').value('(NumberPoint/@value)[1]', 'INT'),
	      HasMinValue       = f.query('MinValue').value('(MinValue/@checked)[1]', 'BIT'),
	      MinValue          = f.query('MinValue').value('(MinValue/@value)[1]', 'VARCHAR(26)'),
	      HasMaxValue       = f.query('MaxValue').value('(MaxValue/@checked)[1]', 'BIT'),
	      MaxValue          = f.query('MaxValue').value('(MaxValue/@value)[1]', 'VARCHAR(26)'),	      
	      TableType         = f.query('RefTable').value('(RefTable/@type)[1]', 'BIT'),
	      TableID           = f.query('RefTable').value('(RefTable/@tableID)[1]', 'BIGINT'),
	      CodeID            = f.query('RefTable').value('(RefTable/@codeID)[1]', 'BIGINT'),
	      ValueID           = f.query('RefTable').value('(RefTable/@valueID)[1]', 'BIGINT'),
	      ShowMeaning       = f.query('RefTable').value('(RefTable/@showmeaning)[1]', 'SMALLINT'),
	      AllFetchRows      = f.query('RefTable/NRowFetched').value('(NRowFetched/@checked)[1]', 'BIT'),
	      [RowCount]        = f.query('RefTable/NRowFetched').value('(NRowFetched/@value)[1]', 'BIGINT'),
	      IsOrdered         = f.query('RefTable/IsOrdered').value('(IsOrdered/@checked)[1]', 'BIT'),
	      OrderByColumns    = f.query('RefTable/IsOrdered').value('(IsOrdered/@columns)[1]', 'SMALLINT'),
	      AscOrDescOrder    = f.query('RefTable/IsOrdered').value('(IsOrdered/@sorted)[1]', 'INT'),
	      NullFsLs          = f.query('RefTable/IsOrdered').value('(IsOrdered/@nullsFsLs)[1]', 'INT'),
	      HasNullValue      = f.query('RefTable/NullValue').value('(NullValue/@checked)[1]', 'BIT'),
	      NullValue         = f.query('RefTable/NullValue').value('(NullValue/@value)[1]', 'VARCHAR(26)'),
	      HasSchema         = f.query('RefTable/Schema').value('(Schema/@checked)[1]', 'BIT'),	      
	      [Schemas]         = f.query('RefTable/Schema').value('(Schema/@value)[1]', 'VARCHAR(50)'),
	      HasWhereClause    = f.query('RefTable/Where').value('(Where/@checked)[1]', 'BIT'),
	      WhereClause       = f.query('RefTable/Where').value('.', 'NVARCHAR(MAX)'),	      
	      HasDefaultValue   = ISNULL(f.query('RefTable/DefaultValues').value('(DefaultValues/@checked)[1]', 'BIT'), 0)
	   FROM @XML.nodes('/Request/Filter')t(f)
	   WHERE ID = f.query('.').value('(Filter/@id)[1]', 'BIGINT');
	   
	   /*
	   UPDATE Report.DefaultValues
	   SET IsVisible = 0
	   WHERE FilterID = @XML.query('Request/Filter').value('(Filter/@id)[1]', 'BIGINT');
	   */
	   DELETE Report.DefaultValues
	   WHERE FilterID = @XML.query('Request/Filter').value('(Filter/@id)[1]', 'BIGINT');
	   
	   MERGE Report.DefaultValues DVT
	   USING(
	      SELECT
	         @XML.query('Request/Filter').value('(Filter/@id)[1]', 'BIGINT') AS FilterID,
	         d.query('.').value('.', 'NVARCHAR(50)') AS Code
	      FROM @XML.nodes('//DefaultValues/Value')t(d)
	   ) DVS
	   ON (DVT.FilterID = DVS.FilterID AND DVT.Code = DVS.Code)
	   /*
	   WHEN MATCHED THEN
	      UPDATE SET IsVisible = 1
	   */
	   WHEN NOT MATCHED THEN
	      INSERT (FilterID, Code)
	      VALUES (DVS.FilterID, DVS.Code);	   
	END
	ELSE IF( @RequestType = 'AddNewItem' )
	BEGIN
	   EXEC SP_XML_PREPAREDOCUMENT @idoc OUTPUT, @XML;
	   
	   MERGE Report.Filter GTT
	   USING(
	      SELECT
	         @Groupid as GroupHeaderID,
	         @Roleid as RoleID,
	         tc.TableID as TableUsageID,
	         tc.ColumnID as ColumnUsageID,
	         tx.TOrderIndex,
	         tc.TFaName,
	         tc.TEnName,
	         tx.COrderIndex,
	         tc.CFaName,
	         tc.CEnName,
	         tc.ColumnType
	      FROM Report.AllTablesColumns tc,
	      OPENXML(@idoc, '//Field', 2)
	      WITH
	      (
	         Cid BIGINT           '@id',
	         COrderIndex INT      '@orderIndex',
	         Tid BIGINT           '../@id',
	         TOrderIndex INT      '../@orderIndex'
	      ) as tx
	      WHERE tc.TableID = tx.Tid
	        AND tc.ColumnID = tx.Cid
	   ) GTS
	   ON (GTT.GroupHeaderID = GTS.GroupHeaderID AND GTT.RoleID = GTS.RoleID AND 
	       GTT.TableUsageID = GTS.TableUsageID AND GTT.ColumnUsageID = GTS.ColumnUsageID)
	   WHEN MATCHED THEN
	      UPDATE 
	      SET IsActive = 1, IsVisible = 1
      WHEN NOT MATCHED THEN
         INSERT ( 
                  GroupHeaderID, 
                  RoleID, 
                  TableType_Dnrm,
                  TableUsageID, 
                  ColumnUsageID, 
                  TableOrderIndex,
                  TableFaName_Dnrm,
                  TableEnName_Dnrm,
                  ColumnOrderIndex,
                  ColumnFaName_Dnrm,
                  ColumnEnName_Dnrm,
                  ColumnType_Dnrm )
         VALUES (                  
                  GTS.GroupHeaderID,
                  GTS.RoleID,
                  1,
                  GTS.TableUsageID,
                  GTS.ColumnUsageID,
                  GTS.TOrderIndex,
                  GTS.TFaName,
                  GTS.TEnName,
                  GTS.COrderIndex,
                  GTS.CFaName,
                  GTS.CEnName,
                  GTS.ColumnType );
      
      EXEC SP_XML_REMOVEDOCUMENT @idoc;	
	END
	ELSE IF( @RequestType = 'Leave' )
	BEGIN
	   EXEC SP_XML_PREPAREDOCUMENT @idoc OUTPUT, @XML;
	   
	   MERGE Report.Filter GTT
	   USING(
	      SELECT
	         tx.Filterid
	      FROM 
	      OPENXML(@idoc, '//Field', 2)
	      WITH
	      (
	         Filterid BIGINT   '@global'
	      ) as tx
	   ) GTS
	   ON (GTT.ID = GTS.Filterid)
	   WHEN MATCHED THEN
	      UPDATE 
	      SET IsVisible = 0;
      
      EXEC SP_XML_REMOVEDOCUMENT @idoc;
	END
	ELSE IF( @RequestType = 'Join' )
	BEGIN
	   EXEC SP_XML_PREPAREDOCUMENT @idoc OUTPUT, @XML;
	   
	   MERGE Report.Filter GTT
	   USING(
	      SELECT
	         tx.Filterid
	      FROM 
	      OPENXML(@idoc, '//Field', 2)
	      WITH
	      (
	         Filterid BIGINT   '@global'
	      ) as tx
	   ) GTS
	   ON (GTT.ID = GTS.Filterid)
	   WHEN MATCHED THEN
	      UPDATE 
	      SET IsVisible = 1;
      
      EXEC SP_XML_REMOVEDOCUMENT @idoc;
	END
	ELSE IF( @RequestType = 'Deactive' )
	BEGIN
	   EXEC SP_XML_PREPAREDOCUMENT @idoc OUTPUT, @XML;
	   
	   MERGE Report.Filter GTT
	   USING(
	      SELECT
	         tx.Filterid
	      FROM 
	      OPENXML(@idoc, '//Field', 2)
	      WITH
	      (
	         Filterid BIGINT   '@global'
	      ) as tx
	   ) GTS
	   ON (GTT.ID = GTS.Filterid)
	   WHEN MATCHED THEN
	      UPDATE 
	      SET IsActive = 0;
      
      EXEC SP_XML_REMOVEDOCUMENT @idoc;
	END
	ELSE IF( @RequestType = 'Active' )
	BEGIN
	   EXEC SP_XML_PREPAREDOCUMENT @idoc OUTPUT, @XML;
	   
	   MERGE Report.Filter GTT
	   USING(
	      SELECT
	         tx.Filterid
	      FROM 
	      OPENXML(@idoc, '//Field', 2)
	      WITH
	      (
	         Filterid BIGINT   '@global'
	      ) as tx
	   ) GTS
	   ON (GTT.ID = GTS.Filterid)
	   WHEN MATCHED THEN
	      UPDATE 
	      SET IsActive = 1;
      
      EXEC SP_XML_REMOVEDOCUMENT @idoc;
	END
END
GO
