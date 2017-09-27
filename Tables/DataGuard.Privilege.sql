CREATE TABLE [DataGuard].[Privilege]
(
[BOXP_BPID] [bigint] NULL,
[ID] [bigint] NOT NULL CONSTRAINT [DF_Privilege_ID] DEFAULT ([dbo].[GetNewIdentity]()),
[ShortCut] [bigint] NULL,
[TitleFa] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[TitleEn] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[IsVisible] [bit] NOT NULL CONSTRAINT [DF__Privilege__IsVis__014935CB] DEFAULT ('true')
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
ALTER TABLE [DataGuard].[Privilege] ADD CONSTRAINT [PK__Privileg__3214EC277F60ED59] PRIMARY KEY CLUSTERED  ([ID]) ON [PRIMARY]
GO
CREATE UNIQUE NONCLUSTERED INDEX [Privilege_ID] ON [DataGuard].[Privilege] ([ID]) ON [PRIMARY]
GO
ALTER TABLE [DataGuard].[Privilege] ADD CONSTRAINT [FK_Privilege_Box_Privilege] FOREIGN KEY ([BOXP_BPID]) REFERENCES [DataGuard].[Box_Privilege] ([BPID]) ON DELETE SET NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'نوع دسته بندی دسترسی های سیستم', 'SCHEMA', N'DataGuard', 'TABLE', N'Privilege', 'COLUMN', N'BOXP_BPID'
GO
