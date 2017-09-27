CREATE TABLE [ServiceDef].[Service]
(
[ID] [bigint] NOT NULL CONSTRAINT [DF_Service_ID] DEFAULT ([dbo].[GetNewIdentity]()),
[ShortCut] [bigint] NULL,
[TitleFa] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[TitleEn] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ServiceUnitID] [bigint] NULL,
[ServiceTypeID] [bigint] NULL,
[StartDate] [dbo].[MyDate] NOT NULL CONSTRAINT [DF_Service_StartDate] DEFAULT ([dbo].[GetCurDateTime]()),
[ExpDate] [dbo].[MyDate] NULL,
[Level] [int] NULL,
[ParentID] [bigint] NULL,
[PriceType] [bit] NULL,
[Price] [bigint] NULL,
[RectCode] [smallint] NULL CONSTRAINT [DF_Service_RectCode] DEFAULT ((1)),
[IsActive] [bit] NULL CONSTRAINT [DF_Service_IsActive] DEFAULT ('true'),
[IsVisible] [bit] NULL CONSTRAINT [DF_Service_IsVisible] DEFAULT ('true')
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
ALTER TABLE [ServiceDef].[Service] ADD CONSTRAINT [PK__Service__3214EC270DAF0CB0] PRIMARY KEY NONCLUSTERED  ([ID]) ON [PRIMARY]
GO
CREATE UNIQUE NONCLUSTERED INDEX [Service_ID] ON [ServiceDef].[Service] ([ID]) ON [PRIMARY]
GO
CREATE CLUSTERED INDEX [ServiceID_RectCode] ON [ServiceDef].[Service] ([ID], [RectCode]) ON [PRIMARY]
GO
ALTER TABLE [ServiceDef].[Service] ADD CONSTRAINT [FK_Service_ServiceUnitType] FOREIGN KEY ([ServiceTypeID]) REFERENCES [ServiceDef].[UnitType] ([ID])
GO
ALTER TABLE [ServiceDef].[Service] ADD CONSTRAINT [FK_Service_ServiceUnitType1] FOREIGN KEY ([ServiceUnitID]) REFERENCES [ServiceDef].[UnitType] ([ID])
GO
EXEC sp_addextendedproperty N'MS_Description', N'1 = Normal
2 = Expire', 'SCHEMA', N'ServiceDef', 'TABLE', N'Service', 'COLUMN', N'RectCode'
GO
EXEC sp_addextendedproperty N'MS_Description', N'(dbo.GetCurDateTime())', 'SCHEMA', N'ServiceDef', 'TABLE', N'Service', 'COLUMN', N'StartDate'
GO
