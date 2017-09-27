CREATE TABLE [Report].[ColumnUsage]
(
[TableUsageID] [bigint] NOT NULL,
[ID] [bigint] NULL,
[ShortCut] [bigint] NULL,
[CodeFaName] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[FormulaName] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CodeEnName] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ColumnType] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[IsActive] [bit] NULL CONSTRAINT [DF_ColumnUsage_IsActive] DEFAULT ('true'),
[IsVisible] [bit] NULL CONSTRAINT [DF_ColumnUsage_IsVisible] DEFAULT ('true')
) ON [PRIMARY]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [Report].[ColumnUsage_AfetrInsert]
ON [Report].[ColumnUsage]
FOR INSERT
AS    
   DECLARE @EnName NVARCHAR(50);
   DECLARE @TableUsageID BIGINT;
   
   DECLARE CINSERTED CURSOR 
   FOR SELECT CodeEnName, TableUsageID FROM inserted;
   
   OPEN CINSERTED;
   NEXTROW:
   FETCH NEXT FROM CINSERTED
   INTO @EnName, @TableUsageID;
   
   IF @@FETCH_STATUS <> 0
      GOTO EXITLOOP;
      
   WAITFOR DELAY '00:00:00:002';
   UPDATE Report.ColumnUsage
   SET ID = dbo.GetNewVerIdentity()
   WHERE TableUsageID = @TableUsageID AND CodeEnName = @EnName AND ID IS NULL;
   
   
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
CREATE TRIGGER [Report].[ColumnUsage_AfterDelete]
   ON  [Report].[ColumnUsage]
   AFTER DELETE
AS 
BEGIN
   RAISERROR(N'12', 16, 1);
   
	DELETE Report.ColumnValues
	WHERE ColumnUsageID in (SELECT ID FROM deleted);
	
	DELETE Report.Filter
	WHERE ColumnUsageID in (SELECT ID FROM deleted);
		
END
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
CREATE TRIGGER [Report].[ColumnUsage_AfterUpdate]
   ON  [Report].[ColumnUsage]
   AFTER UPDATE
AS 
BEGIN
	UPDATE Report.Filter
	SET 
	   ColumnEnName_Dnrm = i.CodeEnName 
	  ,ColumnFaName_Dnrm = i.CodeFaName 
	  ,ColumnType_Dnrm = i.ColumnType
	FROM inserted i
	WHERE Filter.ColumnUsageID = i.ID 
	  AND Filter.TableUsageID = i.TableUsageID;
	  
   UPDATE Report.Filter
	SET 
	   ColumnCode = i.CodeEnName
	FROM inserted i
	WHERE i.ID = CodeID;
	
	UPDATE Report.Filter 
	SET
	   ColumnValue = i.CodeEnName
   FROM inserted i
   WHERE i.ID = ValueID;
 
END;
GO
CREATE NONCLUSTERED INDEX [ColumnUsage_ID] ON [Report].[ColumnUsage] ([ID]) ON [PRIMARY]
GO
