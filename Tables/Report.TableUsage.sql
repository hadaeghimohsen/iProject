CREATE TABLE [Report].[TableUsage]
(
[ID] [bigint] NULL,
[ShortCut] [bigint] NULL,
[TitleFa] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[TitleEn] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[RealName] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[IsVisible] [bit] NULL CONSTRAINT [DF_TableUsage_IsVisible] DEFAULT ('true'),
[IsActive] [bit] NULL CONSTRAINT [DF_TableUsage_IsActive] DEFAULT ('true'),
[TableType] [bit] NULL CONSTRAINT [DF_TableUsage_TableType] DEFAULT ('true')
) ON [PRIMARY]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [Report].[TableUsage_AfetrInsert]
ON [Report].[TableUsage]
FOR INSERT
AS    
   DECLARE @EnName NVARCHAR(50);
   
   DECLARE CINSERTED CURSOR 
   FOR SELECT TitleEn FROM inserted;
   
   OPEN CINSERTED;
   NEXTROW:
   FETCH NEXT FROM CINSERTED
   INTO @EnName;
   
   IF @@FETCH_STATUS <> 0
      GOTO EXITLOOP;
      
   WAITFOR DELAY '00:00:00:002';
   UPDATE Report.TableUsage
   SET ID = dbo.GetNewVerIdentity()
   WHERE TitleEn = @EnName AND ID IS NULL;
   
   
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
CREATE TRIGGER [Report].[TableUsage_AfterDelete]
   ON  [Report].[TableUsage]
   AFTER DELETE
AS 
BEGIN
	DELETE Report.ColumnUsage
	WHERE TableUsageID in (SELECT ID FROM deleted);
	
	DELETE Report.Filter
	WHERE TableUsageID in (SELECT ID FROM deleted);
		
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
CREATE TRIGGER [Report].[TableUsage_AfterUpdate]
   ON  [Report].[TableUsage]
   AFTER UPDATE
AS 
BEGIN
	UPDATE Report.Filter
	SET 
	   TableType_Dnrm = i.TableType
	  ,TableFaName_Dnrm = i.TitleFa
	  ,TableEnName_Dnrm = i.TitleEn
	FROM inserted i
	WHERE TableUsageID = i.ID;
	  
   UPDATE Report.Filter
	SET 
	   TableType = i.TableType
	  ,TableName = i.TitleEn
	FROM inserted i
	WHERE TableID = i.ID;
END
GO
CREATE NONCLUSTERED INDEX [TableUsage_ID] ON [Report].[TableUsage] ([ID]) ON [PRIMARY]
GO
EXEC sp_addextendedproperty N'MS_Description', N'نام واقعی شی درون پایگاه داده اطلاعاتی', 'SCHEMA', N'Report', 'TABLE', N'TableUsage', 'COLUMN', N'RealName'
GO
