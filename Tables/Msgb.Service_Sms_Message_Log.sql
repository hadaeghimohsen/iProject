CREATE TABLE [Msgb].[Service_Sms_Message_Log]
(
[MBID] [bigint] NOT NULL IDENTITY(1, 1),
[SERV_FILE_NO] [bigint] NULL,
[SUB_SYS] [int] NULL,
[LINE_TYPE] [varchar] (3) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ACTN_DATE] [datetime] NULL,
[PHON_NUMB] [varchar] (11) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[MSGB_TEXT] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[MSGB_TYPE] [varchar] (3) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[STAT] [varchar] (3) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[MESG_ID] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[EROR_CODE] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[EROR_MESG] [nvarchar] (500) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CRET_BY] [varchar] (250) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CRET_DATE] [datetime] NULL,
[MDFY_BY] [varchar] (250) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[MDFY_DATE] [datetime] NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
ALTER TABLE [Msgb].[Service_Sms_Message_Log] ADD CONSTRAINT [PK_SSML] PRIMARY KEY CLUSTERED  ([MBID]) ON [PRIMARY]
GO
ALTER TABLE [Msgb].[Service_Sms_Message_Log] ADD CONSTRAINT [FK_SSML_SERV] FOREIGN KEY ([SERV_FILE_NO]) REFERENCES [Global].[Service] ([FILE_NO])
GO
ALTER TABLE [Msgb].[Service_Sms_Message_Log] ADD CONSTRAINT [FK_SSML_SUBS] FOREIGN KEY ([SUB_SYS]) REFERENCES [DataGuard].[Sub_System] ([SUB_SYS])
GO
