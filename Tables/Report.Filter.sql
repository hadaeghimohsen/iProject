CREATE TABLE [Report].[Filter]
(
[ID] [bigint] NULL,
[GroupHeaderID] [bigint] NOT NULL,
[RoleID] [bigint] NOT NULL,
[TableUsageID] [bigint] NOT NULL,
[ColumnUsageID] [bigint] NOT NULL,
[DataSourceID] [bigint] NULL,
[TableOrderIndex] [int] NULL,
[TableType_Dnrm] [bit] NULL,
[TableFaName_Dnrm] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[TableEnName_Dnrm] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ColumnOrderIndex] [int] NULL,
[ColumnFaName_Dnrm] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ColumnEnName_Dnrm] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ColumnType_Dnrm] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[FilterState] [bit] NULL CONSTRAINT [DF_GroupHeader_TableUsage_FilterState] DEFAULT ('False'),
[HighAccessControl] [smallint] NULL CONSTRAINT [DF__GroupHead__HighA__39788055] DEFAULT ((0)),
[MultiSelected] [bit] NULL CONSTRAINT [DF_GroupHeader_TableUsage_MultiSelected] DEFAULT ('true'),
[Distincted] [bit] NULL CONSTRAINT [DF_GroupHeader_TableUsage_Distincted] DEFAULT ('true'),
[HasDefaultValue] [bit] NULL CONSTRAINT [DF_GroupHeader_TableUsage_HasDefaultValue] DEFAULT ('false'),
[AllFetchRows] [bit] NULL CONSTRAINT [DF_GroupHeader_TableUsage_AllFetchRows] DEFAULT ('true'),
[RowCount] [bigint] NULL CONSTRAINT [DF_GroupHeader_TableUsage_RowCount] DEFAULT ((0)),
[IsOrdered] [bit] NULL CONSTRAINT [DF_GroupHeader_TableUsage_IsOrdered] DEFAULT ('False'),
[OrderByColumns] [smallint] NULL CONSTRAINT [DF_GroupHeader_TableUsage_OrderByColumns] DEFAULT ((1)),
[AscOrDescOrder] [int] NULL CONSTRAINT [DF_GroupHeader_TableUsage_FirstOrLastRows] DEFAULT ((0)),
[NullFsLs] [smallint] NULL CONSTRAINT [DF_Filter_NullFsLs] DEFAULT ((0)),
[HasSchema] [bit] NULL CONSTRAINT [DF_Filter_HasSchema] DEFAULT ('false'),
[TableType] [bit] NULL CONSTRAINT [DF_GroupHeader_TableUsage_TableType] DEFAULT ('True'),
[TableID] [bigint] NULL,
[SchemaID] [bigint] NULL,
[Schemas] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[TableName] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CodeID] [bigint] NULL,
[ColumnCode] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ValueID] [bigint] NULL,
[ColumnValue] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ShowMeaning] [smallint] NULL,
[HasWhereClause] [bit] NULL CONSTRAINT [DF_Filter_HasWhereClause] DEFAULT ('false'),
[WhereClause] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[HasMaxLen] [bit] NULL CONSTRAINT [DF_Filter_HasMaxLen] DEFAULT ('false'),
[IsStringDate] [bit] NULL CONSTRAINT [DF_Filter_IsStringDate] DEFAULT ('False'),
[MaxLen] [int] NULL CONSTRAINT [DF_Filter_MaxLen] DEFAULT ((0)),
[DigitSep] [bit] NULL CONSTRAINT [DF_Filter_DigitSep] DEFAULT ('false'),
[HasNumberPoint] [bit] NULL CONSTRAINT [DF_Filter_HasNumberPoint] DEFAULT ('false'),
[MaxNumberPoint] [int] NULL CONSTRAINT [DF_Filter_MaxNumberPoint] DEFAULT ((0)),
[HasMinValue] [bit] NULL CONSTRAINT [DF_Filter_HasMinValue] DEFAULT ('false'),
[MinValue] [varchar] (26) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[HasMaxValue] [bit] NULL CONSTRAINT [DF_Filter_HasMaxValue] DEFAULT ('false'),
[MaxValue] [varchar] (26) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[HasNullValue] [bit] NULL CONSTRAINT [DF_Filter_IsNotNull] DEFAULT ('true'),
[NullValue] [int] NULL CONSTRAINT [DF_Filter_NullValue] DEFAULT ((0)),
[IsVisible] [bit] NULL CONSTRAINT [DF_GroupHeader_TableUsage_IsVisible] DEFAULT ('true'),
[IsActive] [bit] NULL CONSTRAINT [DF_GroupHeader_TableUsage_IsActive] DEFAULT ('true')
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [Report].[Filter_AfetrInsert]
ON [Report].[Filter]
FOR INSERT
AS 
   DECLARE @Group BIGINT, @Role BIGINT, @Table BIGINT, @Column BIGINT;
   
   DECLARE CINSERTED CURSOR 
   FOR SELECT GroupHeaderID, RoleID, TableUsageID, ColumnUsageID FROM inserted;

   OPEN CINSERTED;
   NEXTROW:
   FETCH NEXT FROM CINSERTED
   INTO @Group, @Role, @Table, @Column;
  
   IF @@FETCH_STATUS <> 0
      GOTO EXITLOOP;
      
   --WAITFOR DELAY '00:00:00:002';
   DECLARE @ID BIGINT;
   L_CRETID:
   SET @ID = dbo.GetNewVerIdentity();
   IF EXISTS(SELECT * FROM Filter WHERE ID = @ID)
      GOTO L_CRETID;
   
   PRINT @ID;
   
   UPDATE Report.Filter
   SET ID = @ID, --dbo.GetNewVerIdentity(),
       TableType = TableType_Dnrm,
       --[Schemas] = (SELECT [Schemas] FROM Report.TableUsage WHERE ID = @Table),
       TableID = TableUsageID,
       TableName = TableEnName_Dnrm,
       CodeID = ColumnUsageID,
       ColumnCode = ColumnEnName_Dnrm,
       ValueID = ColumnUsageID,
       ColumnValue = ColumnEnName_Dnrm,
       ShowMeaning = 1,
       DataSourceID = (SELECT DataSourceID FROM Report.GroupHeader WHERE ID = @Group)
   WHERE ID IS NULL 
     AND GroupHeaderID = @Group
     AND RoleID = @Role
     AND TableUsageID = @Table
     AND ColumnUsageID = @Column;
   
   
   GOTO NEXTROW;
   
   EXITLOOP:
   CLOSE CINSERTED;
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE TRIGGER [Report].[Filter_AfterUpdate]
   ON  [Report].[Filter]
   AFTER UPDATE
AS 
BEGIN
--SELECT * FROM inserted;
   BEGIN TRY
	   UPDATE Report.Filter 
	   SET 
	      TableType    = (SELECT tu.TableType FROM Report.TableUsage tu WHERE tu.ID = Filter.TableID),
	      TableName    = (SELECT tu.TitleEn FROM Report.TableUsage tu WHERE tu.ID = Filter.TableID),
	      ColumnCode   = (SELECT cu.CodeEnName FROM Report.ColumnUsage cu WHERE cu.ID = Filter.CodeID /*AND i.TableID = cu.TableUsageID*/ AND cu.IsVisible = 1 AND cu.IsActive = 1),
	      ColumnValue  = (SELECT cu.CodeEnName FROM Report.ColumnUsage cu WHERE cu.ID = Filter.ValueID /*AND i.TableID = cu.TableUsageID*/ AND cu.IsVisible = 1 AND cu.IsActive = 1),
	      DataSourceID = CASE WHEN (i.TableType) = 0 THEN (SELECT ds.ID FROM Report.DataSource ds WHERE ds.IsDefault = 1) ELSE (SELECT DataSourceID FROM Report.GroupHeader WHERE ID = Filter.GroupHeaderID) END,
	      SchemaID     = CASE WHEN (i.TableType) = 0 THEN (SELECT s.ID FROM Report.Schemas s WHERE UPPER(s.TitleEn) = 'REPORT') ELSE Filter.SchemaID END,
	      [Schemas]    = CASE WHEN (i.TableType) = 0 THEN 'REPORT' ELSE Filter.[Schemas] END
	   FROM inserted i
	   WHERE i.ID = Filter.ID;
	END TRY
	BEGIN CATCH
	   SELECT * FROM inserted
	   SELECT * FROM Report.ColumnUsage cu, inserted i WHERE cu.ID = i.CodeID;
	END CATCH
	  
END
GO
CREATE NONCLUSTERED INDEX [GroupHeader_TableUsage_ColumnUsageID] ON [Report].[Filter] ([ColumnUsageID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [GroupHeader_TableUsage_GroupHeaderID] ON [Report].[Filter] ([GroupHeaderID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [GroupHeader_TableUsage_ID] ON [Report].[Filter] ([ID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [GroupHeader_TableUsage_RoleID] ON [Report].[Filter] ([RoleID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [GroupHeader_TableUsage_TableUsageID] ON [Report].[Filter] ([TableUsageID]) ON [PRIMARY]
GO
ALTER TABLE [Report].[Filter] ADD CONSTRAINT [FK_GroupHeader_TableUsage__GroupHeader] FOREIGN KEY ([GroupHeaderID]) REFERENCES [Report].[GroupHeader] ([ID])
GO
ALTER TABLE [Report].[Filter] ADD CONSTRAINT [FK_GroupHeader_TableUsage__Role] FOREIGN KEY ([RoleID]) REFERENCES [DataGuard].[Role] ([ID]) ON DELETE CASCADE ON UPDATE CASCADE
GO
