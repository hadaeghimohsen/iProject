CREATE TABLE [Sas].[Privilege]
(
[BOXP_BPID] [bigint] NULL,
[ID] [bigint] NOT NULL CONSTRAINT [DF_Privilege_ID] DEFAULT ([dbo].[GetNewIdentity]()),
[ShortCut] [bigint] NULL,
[TitleFa] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[TitleEn] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[IsVisible] [bit] NULL CONSTRAINT [DF_Privilege_IsVisible] DEFAULT ((1))
) ON [PRIMARY]
GO
ALTER TABLE [Sas].[Privilege] ADD CONSTRAINT [PK_Privilege] PRIMARY KEY CLUSTERED  ([ID]) ON [PRIMARY]
GO
ALTER TABLE [Sas].[Privilege] ADD CONSTRAINT [FK_Privilege_Box_Privilege] FOREIGN KEY ([BOXP_BPID]) REFERENCES [DataGuard].[Box_Privilege] ([BPID]) ON DELETE SET NULL
GO
