CREATE TABLE [DataGuard].[Command]
(
[CODE] [bigint] NOT NULL,
[OPEN_CMND_TEXT] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[CLOS_CMND_TEXT] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[RUN_STAT] [varchar] (3) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CRET_BY] [varchar] (250) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CRET_DATE] [datetime] NULL,
[MDFY_BY] [varchar] (250) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[MDFY_DATE] [datetime] NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
ALTER TABLE [DataGuard].[Command] ADD CONSTRAINT [PK_Command] PRIMARY KEY CLUSTERED  ([CODE]) ON [PRIMARY]
GO
