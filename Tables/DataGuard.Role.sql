CREATE TABLE [DataGuard].[Role]
(
[SUB_SYS] [int] NULL,
[ID] [bigint] NOT NULL CONSTRAINT [DF_Role_ID] DEFAULT ([dbo].[GetNewIdentity]()),
[ShortCut] [bigint] NOT NULL IDENTITY(1, 1),
[STitleFa] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[TitleFa] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[TitleEn] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[IsDefualt] [bit] NOT NULL CONSTRAINT [DF__Role__IsDefualt__060DEAE8] DEFAULT ('false'),
[IsVisible] [bit] NOT NULL CONSTRAINT [DF__Role__IsVisible__07020F21] DEFAULT ('true'),
[IsActive] [bit] NULL CONSTRAINT [DF_Role_IsActive] DEFAULT ('true')
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
ALTER TABLE [DataGuard].[Role] ADD CONSTRAINT [PK__Role__3214EC270425A276] PRIMARY KEY CLUSTERED  ([ID]) ON [PRIMARY]
GO
CREATE UNIQUE NONCLUSTERED INDEX [Role_ID] ON [DataGuard].[Role] ([ID]) ON [PRIMARY]
GO
ALTER TABLE [DataGuard].[Role] ADD CONSTRAINT [FK_Role_Sub_System] FOREIGN KEY ([SUB_SYS]) REFERENCES [DataGuard].[Sub_System] ([SUB_SYS])
GO
