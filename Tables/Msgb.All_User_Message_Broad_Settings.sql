CREATE TABLE [Msgb].[All_User_Message_Broad_Settings]
(
[MBID] [bigint] NOT NULL CONSTRAINT [DF_All_User_Message_Broad_Settings_MBID] DEFAULT ((0)),
[TYPE] [varchar] (3) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[BGWK_STAT] [varchar] (3) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[BGWK_INTR] [int] NULL,
[CUST_BGWK_STAT] [varchar] (3) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CUST_BGWK_INTR] [int] NULL,
[USER_PNEL] [varchar] (250) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PASS_PNEL] [varchar] (250) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[USER_NAME] [varchar] (250) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PASS_WORD] [varchar] (250) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[LINE_NUMB] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[LINE_TYPE] [varchar] (3) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DFLT_STAT] [varchar] (3) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CRET_BY] [varchar] (250) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CRET_DATE] [datetime] NULL,
[MDFY_BY] [varchar] (250) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[MDFY_DATE] [datetime] NULL
) ON [PRIMARY]
GO
ALTER TABLE [Msgb].[All_User_Message_Broad_Settings] ADD CONSTRAINT [PK_All_User_Message_Broad_Settings] PRIMARY KEY CLUSTERED  ([MBID]) ON [PRIMARY]
GO
