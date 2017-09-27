CREATE TABLE [Global].[Privilege]
(
[BOXP_BPID] [bigint] NULL,
[ID] [bigint] NOT NULL CONSTRAINT [DF_Privilege_ID] DEFAULT ([dbo].[GetNewIdentity]()),
[ShortCut] [bigint] NULL,
[TitleFa] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[TitleEn] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[IsVisible] [bit] NOT NULL CONSTRAINT [DF__Privilege__IsVis__7266E4EE] DEFAULT ('true')
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
ALTER TABLE [Global].[Privilege] ADD CONSTRAINT [PK__Privileg__3214EC276F8A7843] PRIMARY KEY CLUSTERED  ([ID]) ON [PRIMARY]
GO
ALTER TABLE [Global].[Privilege] ADD CONSTRAINT [FK_Privilege_Box_Privilege] FOREIGN KEY ([BOXP_BPID]) REFERENCES [DataGuard].[Box_Privilege] ([BPID]) ON DELETE SET NULL
GO
