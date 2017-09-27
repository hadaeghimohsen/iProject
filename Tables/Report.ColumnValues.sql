CREATE TABLE [Report].[ColumnValues]
(
[ColumnUsageID] [bigint] NOT NULL,
[Code] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Value] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[IsVisible] [bit] NULL CONSTRAINT [DF_ColumnValues_IsVisible] DEFAULT ('True'),
[IsActive] [bit] NULL CONSTRAINT [DF_ColumnValues_IsActive] DEFAULT ('True')
) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [ColumnValues_Code] ON [Report].[ColumnValues] ([Code]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [ColumnValues_ColumnUsageID] ON [Report].[ColumnValues] ([ColumnUsageID]) ON [PRIMARY]
GO
