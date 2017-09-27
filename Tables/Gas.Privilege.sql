CREATE TABLE [Gas].[Privilege]
(
[BOXP_BPID] [bigint] NULL,
[ID] [bigint] NOT NULL CONSTRAINT [DF_Privilege_ID] DEFAULT ([dbo].[GetNewIdentity]()),
[ShortCut] [bigint] NULL,
[TitleFa] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[TitleEn] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[IsVisible] [bit] NOT NULL CONSTRAINT [DF__Privilege__IsVis__4E298478] DEFAULT ('true')
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
ALTER TABLE [Gas].[Privilege] ADD CONSTRAINT [PK__Privileg__3214EC274B4D17CD] PRIMARY KEY CLUSTERED  ([ID]) ON [PRIMARY]
GO
ALTER TABLE [Gas].[Privilege] ADD CONSTRAINT [FK_Privilege_Box_Privilege] FOREIGN KEY ([BOXP_BPID]) REFERENCES [DataGuard].[Box_Privilege] ([BPID])
GO
