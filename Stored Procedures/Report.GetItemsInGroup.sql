SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [Report].[GetItemsInGroup]
	-- Add the parameters for the stored procedure here
	@XML XML
AS
BEGIN
	DECLARE @RequestType VARCHAR(16);
	DECLARE @TableReturn VARCHAR(100), @HasRelation BIT;
	DECLARE @Group BIGINT, @Role BIGINT, @Filter BIGINT;
   DECLARE @TXML XML;
   DECLARE @TFilter VARCHAR(20), @TCode NVARCHAR(50);
   DECLARE @CrntUser VARCHAR(250);
   
	SELECT @RequestType = @XML.query('/Request').value('(Request/@type)[1]', 'VARCHAR(16)'),
	       @CrntUser = @XML.query('/Request').value('(Request/@crntuser)[1]', 'VARCHAR(250)'),
	       @Group = @XML.query('//Group').value('.', 'BIGINT'),
	       @Role = @XML.query('//Role').value('.', 'BIGINT'),
	       @Filter = @XML.query('//Filter').value('.', 'BIGINT');
   	       
   SET @HasRelation = 0;
   	       
	IF( @RequestType = 'Normal' )
	BEGIN
	   SELECT Filter.ID,
	          Filter.TableUsageID,
	          Filter.TableOrderIndex TOrderIndex,
	          Filter.TableFaName_Dnrm TFaName,
	          Filter.TableEnName_Dnrm TEnName,
	          Filter.ColumnUsageID,
	          Filter.ColumnOrderIndex COrderIndex,
	          Filter.ColumnFaName_Dnrm CFaName,
	          Filter.ColumnEnName_Dnrm CEnName,
	          Filter.ColumnType_Dnrm CType,
	          CASE 
	            WHEN Filter.SchemaID IS NULL AND Filter.[Schemas] IS NULL THEN 0
	            --ELSE Filter.IsActive
	            ELSE Filter.FilterState
	          END AS IsActive 
	   FROM Report.Filter
	   WHERE Filter.GroupHeaderID = @Group
	     AND Filter.RoleID = @Role
	     AND IsVisible = 1
	   ORDER BY TOrderIndex, COrderIndex;
	   SET @TableReturn = 'Filter';
	END
	ELSE IF( @RequestType = 'Single' )
	BEGIN
      SELECT @TXML = (
      SELECT [ID] AS '@id'
			   ,'true' AS '@forConfig'
            ,(SELECT FormulaName FROM Report.ColumnUsage Cui WHERE Cui.TableUsageID = f.TableUsageID AND Cui.ID = ColumnUsageID) AS '@formulaName'
            ,[FilterState] As '@state'
            ,[MultiSelected] As '@multiSelected'
            ,[Distincted] As '@distincted'
/*
            ,DataSourceID AS 'DefConStr/@id'
            ,(SELECT DatabaseServer FROM Report.DataSource WHERE ID = DataSourceID) AS 'DefConStr/@dsType'
            ,(SELECT [UserID] FROM Report.DataSource WHERE ID = DataSourceID) AS 'DefConStr/@user'
            ,(SELECT [Password] FROM Report.DataSource WHERE ID = DataSourceID) AS 'DefConStr/@password'
*/
            ,DataSourceID AS 'UseConStr/@id'
            ,(SELECT DatabaseServer FROM Report.DataSource WHERE ID = DataSourceID) AS 'UseConStr/@dsType'
            --,(SELECT [UserID] FROM Report.user WHERE ID = DataSourceID) AS 'UseConStr/@user'
            --,(SELECT [Password] FROM Report.DataSource WHERE ID = DataSourceID) AS 'UseConStr/@password'
            ,UPPER(@CrntUser) AS 'UseConStr/@user'
            ,(SELECT PASSDB FROM DataGuard.[User] WHERE USERDB = @CrntUser) AS 'UseConStr/@password'
            --,'false' AS 'UseConStr/@retrieved'
            ,[ColumnFaName_Dnrm] AS 'Column/@faName'
            ,[ColumnEnName_Dnrm] As 'Column/@enName'
            ,[ColumnType_Dnrm] As 'Column/@type'
            ,[TableEnName_Dnrm] AS 'Table/@enName'   
            ,[TableFaName_Dnrm] AS 'Table/@faName'
            ,[HasMaxLen] As 'MaxLen/@checked'
            ,[MaxLen] As 'MaxLen/@value'
            ,[IsStringDate] As 'StringDate/@checked'  
            ,[DigitSep] AS 'DigitSep/@checked'
            ,[HasNumberPoint] As 'NumberPoint/@checked'
            ,[MaxNumberPoint] As 'NumberPoint/@value'
            ,[HasMinValue] As 'MinValue/@checked'
            ,ISNULL([MinValue], '') As 'MinValue/@value'
            ,[HasMaxValue] As 'MaxValue/@checked'
            ,ISNULL([MaxValue], '') As 'MaxValue/@value'
            ,[HighAccessControl] As 'RefTable/@hac'
            ,[TableType] As 'RefTable/@type'
            ,[TableID] AS 'RefTable/@tableID'
            ,[TableName] As 'RefTable/@enName'
            ,[CodeID] AS 'RefTable/@codeID'
            ,[ColumnCode] As 'RefTable/@code'
            ,[ValueID] AS 'RefTable/@valueID'
            ,[ColumnValue] As 'RefTable/@value'
            ,[ShowMeaning] As 'RefTable/@showmeaning'
            ,Report.GetRealNameTable(DataSourceID, TableID) AS 'RefTable/@tabRealName'
            ,Report.GetRealNameColumn(DataSourceID, CodeID) AS 'RefTable/@codeRealName'
            ,Report.GetRealNameColumn(DataSourceID, ValueID) AS 'RefTable/@valueRealName'
            ,[AllFetchRows] As 'RefTable/NRowFetched/@checked'
            ,[RowCount] As 'RefTable/NRowFetched/@value'
            ,[IsOrdered] As 'RefTable/IsOrdered/@checked'
            ,[OrderByColumns] As 'RefTable/IsOrdered/@columns'
            ,[AscOrDescOrder] As 'RefTable/IsOrdered/@sorted'
            ,[NullFsLs] AS 'RefTable/IsOrdered/@nullsFsLs'
            ,[HasNullValue] AS 'RefTable/NullValue/@checked'
            ,[NullValue] AS 'RefTable/NullValue/@value'
            ,[HasSchema] As 'RefTable/Schema/@checked'
            ,ISNULL([Schemas], 'NoSchema') As 'RefTable/Schema/@value'
            ,[HasWhereClause] As 'RefTable/Where/@checked'
            ,ISNULL([WhereClause], '') As 'RefTable/Where'
            ,[HasDefaultValue] As 'RefTable/DefaultValues/@checked'
        FROM [Report].[Filter] f 
        WHERE 
              f.ID = @Filter
        FOR XML PATH('Filter'), ROOT('Filters')
      )
      DECLARE DefVals CURSOR FOR 
      SELECT
         FilterID, Code
      FROM Report.DefaultValues
      WHERE IsVisible = 1
        AND FilterID = @Filter;

      OPEN DefVals;
      GO_NEXTITEM_0:
      FETCH NEXT FROM DefVals INTO @TFilter, @TCode;      

      IF(@@FETCH_STATUS != 0)
         GOTO GO_EXIT_0;
         
      PRINT @TFilter;
      
      SET @TXML.modify(
         'insert <Value>{sql:variable("@TCode")}</Value>
            into (/Filters/Filter[@id = sql:variable("@TFilter")]/RefTable/DefaultValues)[1]'); 
           
      GOTO GO_NEXTITEM_0;
      
      GO_EXIT_0:
      CLOSE DefVals;
      DEALLOCATE DefVals;

      SELECT 'XmlData' = @TXML;
      SET @TableReturn = 'Filter';
      SET @HasRelation = 'False';   	
	END
	ELSE IF( @RequestType = 'Leave' )
	BEGIN
	   SELECT Filter.ID,
	          Filter.TableUsageID,
	          Filter.TableOrderIndex TOrderIndex,
	          Filter.TableFaName_Dnrm TFaName,
	          Filter.TableEnName_Dnrm TEnName,
	          Filter.ColumnUsageID,
	          Filter.ColumnOrderIndex COrderIndex,
	          Filter.ColumnFaName_Dnrm CFaName,
	          Filter.ColumnEnName_Dnrm CEnName,
	          Filter.ColumnType_Dnrm CType,
	          Filter.IsActive 
	   FROM Report.Filter
	   WHERE Filter.GroupHeaderID = @Group
	     AND Filter.RoleID = @Role
	     AND IsVisible = 0
	   ORDER BY TOrderIndex, COrderIndex;
	   SET @TableReturn = 'Filter';
	END
	ELSE IF( @RequestType = 'Deactive' )
	BEGIN
	   SELECT Filter.ID,
	          Filter.TableUsageID,
	          Filter.TableOrderIndex TOrderIndex,
	          Filter.TableFaName_Dnrm TFaName,
	          Filter.TableEnName_Dnrm TEnName,
	          Filter.ColumnUsageID,
	          Filter.ColumnOrderIndex COrderIndex,
	          Filter.ColumnFaName_Dnrm CFaName,
	          Filter.ColumnEnName_Dnrm CEnName,
	          Filter.ColumnType_Dnrm CType,
	          Filter.IsActive 
	   FROM Report.Filter
	   WHERE Filter.GroupHeaderID = @Group
	     AND Filter.RoleID = @Role
	     AND IsVisible = 1
	     AND IsActive = 0
	   ORDER BY TOrderIndex, COrderIndex;
	   SET @TableReturn = 'Filter';
	END
	ELSE IF( @RequestType = 'Filters' )
	BEGIN
	   PRINT @Role;
	   IF @Role IS NULL OR @Role = 0
	      SELECT @Role = @XML.query('//Profiler').value('(Profiler/@role_id)[1]', 'BIGINT');
	     
      SELECT @TXML = (
      SELECT [ID] AS '@id'
			   ,'false' AS '@forConfig'
            ,(SELECT FormulaName FROM Report.ColumnUsage Cui WHERE Cui.TableUsageID = f.TableUsageID AND Cui.ID = ColumnUsageID) AS '@formulaName'
            ,[FilterState] As '@state'
            ,[MultiSelected] As '@multiSelected'
            ,[Distincted] As '@distincted'
            ,DataSourceID AS 'DefConStr/@id'
            ,(SELECT DatabaseServer FROM Report.DataSource WHERE ID = DataSourceID) AS 'DefConStr/@dsType'
            ,(SELECT [UserID] FROM Report.DataSource WHERE ID = DataSourceID) AS 'DefConStr/@user'
            ,(SELECT [Password] FROM Report.DataSource WHERE ID = DataSourceID) AS 'DefConStr/@password'
            ,DataSourceID AS 'UseConStr/@id'
            ,(SELECT DatabaseServer FROM Report.DataSource WHERE ID = DataSourceID) AS 'UseConStr/@dsType'
            --,(SELECT [UserID] FROM Report.DataSource WHERE ID = DataSourceID) AS 'UseConStr/@user'
            --,(SELECT [Password] FROM Report.DataSource WHERE ID = DataSourceID) AS 'UseConStr/@password'
            ,UPPER(@CrntUser) AS 'UseConStr/@user'
            ,(SELECT PASSDB FROM DataGuard.[User] WHERE USERDB = @CrntUser) AS 'UseConStr/@password'
            ,'false' AS 'UseConStr/@retrieved'
            ,[ColumnFaName_Dnrm] AS 'Column/@faName'
            ,[ColumnEnName_Dnrm] As 'Column/@enName'
            ,[ColumnType_Dnrm] As 'Column/@type'
            ,[TableEnName_Dnrm] AS 'Table/@enName'            
            ,[HasMaxLen] As 'MaxLen/@checked'
            ,[MaxLen] As 'MaxLen/@value'
            ,[IsStringDate] As 'StringDate/@checked'  
            ,[DigitSep] AS 'DigitSep/@checked'
            ,[HasNumberPoint] As 'NumberPoint/@checked'
            ,[MaxNumberPoint] As 'NumberPoint/@value'
            ,[HasMinValue] As 'MinValue/@checked'
            ,ISNULL([MinValue], '') As 'MinValue/@value'
            ,[HasMaxValue] As 'MaxValue/@checked'
            ,ISNULL([MaxValue], '') As 'MaxValue/@value'
            ,[HighAccessControl] As 'RefTable/@hac'
            ,[TableType] As 'RefTable/@type'
            ,[TableName] As 'RefTable/@enName'
            ,[ColumnCode] As 'RefTable/@code'
            ,[ColumnValue] As 'RefTable/@value'
            ,[ShowMeaning] As 'RefTable/@showmeaning'
            ,Report.GetRealNameTable(DataSourceID, TableID) AS 'RefTable/@tabRealName'
            ,Report.GetRealNameColumn(DataSourceID, CodeID) AS 'RefTable/@codeRealName'
            ,Report.GetRealNameColumn(DataSourceID, ValueID) AS 'RefTable/@valueRealName'
            ,[AllFetchRows] As 'RefTable/NRowFetched/@checked'
            ,[RowCount] As 'RefTable/NRowFetched/@value'
            ,[IsOrdered] As 'RefTable/IsOrdered/@checked'
            ,[OrderByColumns] As 'RefTable/IsOrdered/@columns'
            ,[AscOrDescOrder] As 'RefTable/IsOrdered/@sorted'
            ,[NullFsLs] AS 'RefTable/IsOrdered/@nullsFsLs'
            ,[HasNullValue]  AS 'RefTable/NullValue/@checked'
            ,[NullValue] AS 'RefTable/NullValue/@value'
            ,[HasSchema] As 'RefTable/Schema/@checked'
            ,ISNULL([Schemas], 'NoSchema') As 'RefTable/Schema/@value'
            ,[HasWhereClause] As 'RefTable/Where/@checked'
            ,ISNULL([WhereClause], '') As 'RefTable/Where'
            ,[HasDefaultValue] As 'RefTable/DefaultValues/@checked'
        FROM [Report].[Filter] f 
        WHERE f.GroupHeaderID = @Group
          AND f.RoleID = @Role 
          AND f.IsActive = 1
          AND f.IsVisible = 1
          AND f.FilterState = 1
        ORDER BY TableOrderIndex, ColumnOrderIndex
        FOR XML PATH('Filter'), ROOT('Filters')
      )
      DECLARE DefVals CURSOR FOR 
      SELECT
         FilterID, Code
      FROM Report.DefaultValues
      WHERE IsVisible = 1;
      
      OPEN DefVals;
      GO_NEXTITEM_1:
      FETCH NEXT FROM DefVals INTO @TFilter, @TCode;      

      IF(@@FETCH_STATUS != 0)
         GOTO GO_EXIT_1;
         
      PRINT @TFilter;
      
      SET @TXML.modify(
         'insert <Value>{sql:variable("@TCode")}</Value>
            into (/Filters/Filter[@id = sql:variable("@TFilter")]/RefTable/DefaultValues)[1]'); 
           
      GOTO GO_NEXTITEM_1;
      
      GO_EXIT_1:
      CLOSE DefVals;
      DEALLOCATE DefVals;

      SELECT 'XmlData' = @TXML;
      SET @TableReturn = 'Filter';
      SET @HasRelation = 'False';
	END
	
	SELECT
	 'SUCCESSFUL' AS RESULT
	,'0S' AS TIMERUN
	,@TableReturn AS TABLESNAME
	,'iProject' As TableSpaceName
	,@HasRelation AS [HasRelation];
END
GO
