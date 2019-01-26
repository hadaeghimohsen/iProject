CREATE TABLE [LogMan].[Excetion_Manager]
(
[ELID] [bigint] NOT NULL,
[SUB_SYS] [int] NULL,
[USER_NAME] [varchar] (250) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[EXCP_DATE] [datetime] NULL,
[FORM_NAME] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PROC_NAME] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[EXCP_MESG] [nvarchar] (4000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[EXCP_INER_MESG] [nvarchar] (4000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CRET_BY] [varchar] (250) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CRET_DATE] [datetime] NULL
) ON [BLOB]
GO
ALTER TABLE [LogMan].[Excetion_Manager] ADD CONSTRAINT [PK_Excetion_Manager] PRIMARY KEY CLUSTERED  ([ELID]) ON [BLOB]
GO
ALTER TABLE [LogMan].[Excetion_Manager] ADD CONSTRAINT [FK_EXCP_SUBS] FOREIGN KEY ([SUB_SYS]) REFERENCES [DataGuard].[Sub_System] ([SUB_SYS]) ON DELETE CASCADE
GO
