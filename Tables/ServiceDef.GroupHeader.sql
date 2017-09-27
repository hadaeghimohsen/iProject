CREATE TABLE [ServiceDef].[GroupHeader]
(
[ID] [bigint] NOT NULL CONSTRAINT [DF_PayGroup_ID] DEFAULT ([dbo].[GetNewIdentity]()),
[ShortCut] [bigint] NULL,
[TitleFa] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[STitleFa] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[TitleEn] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[STitleEn] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[IsVisible] [bit] NOT NULL CONSTRAINT [DF__PayGroup__IsVisi__22AA2996] DEFAULT ('true'),
[IsActive] [bit] NOT NULL CONSTRAINT [DF_GroupHeader_IsActive] DEFAULT ('true')
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
ALTER TABLE [ServiceDef].[GroupHeader] ADD CONSTRAINT [PK__PayGroup__3214EC2720C1E124] PRIMARY KEY CLUSTERED  ([ID]) ON [PRIMARY]
GO
CREATE UNIQUE NONCLUSTERED INDEX [PayGroup_ID] ON [ServiceDef].[GroupHeader] ([ID]) ON [PRIMARY]
GO
