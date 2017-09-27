CREATE TABLE [Report].[AppDecision]
(
[ID] [bigint] NOT NULL CONSTRAINT [DF_AppDecision_ID] DEFAULT ([dbo].[GetNewIdentity]()),
[ShortCut] [bigint] NULL,
[TitleFa] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[TitleEN] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[IsVisible] [bit] NULL CONSTRAINT [DF_AppDecision_IsVisible] DEFAULT ('true'),
[IsActive] [bit] NULL CONSTRAINT [DF_AppDecision_IsActive] DEFAULT ('true')
) ON [PRIMARY]
GO
ALTER TABLE [Report].[AppDecision] ADD CONSTRAINT [PK_AppDecision] PRIMARY KEY CLUSTERED  ([ID]) ON [PRIMARY]
GO
