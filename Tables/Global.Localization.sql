CREATE TABLE [Global].[Localization]
(
[LCID] [bigint] NOT NULL,
[SUB_SYS] [int] NULL,
[REGN_LANG_CODE] [varchar] (3) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CRET_BY] [varchar] (250) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CRET_DATE] [datetime] NULL,
[MDFY_BY] [varchar] (250) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[MDFY_DATE] [date] NULL
) ON [PRIMARY]
GO
ALTER TABLE [Global].[Localization] ADD CONSTRAINT [PK_Localization] PRIMARY KEY CLUSTERED  ([LCID]) ON [PRIMARY]
GO
