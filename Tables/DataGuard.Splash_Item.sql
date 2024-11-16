CREATE TABLE [DataGuard].[Splash_Item]
(
[SPSC_CODE] [bigint] NULL,
[CODE] [bigint] NOT NULL,
[INDX] [int] NULL,
[STAT] [varchar] (3) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[TIME_WAIT] [int] NULL,
[TOP_TEXT] [nvarchar] (4000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[MIDL_TEXT] [nvarchar] (4000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[BOTM_TEXT] [nvarchar] (4000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[BACK_COLR] [varchar] (7) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[TOP_FORE_COLR] [varchar] (7) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[MIDL_FORE_COLR] [varchar] (7) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[BOTM_FORE_COLR] [varchar] (7) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CRET_BY] [varchar] (250) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CRET_DATE] [datetime] NULL,
[MDFY_BY] [varchar] (250) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[MDFY_DATE] [datetime] NULL
) ON [PRIMARY]
GO
ALTER TABLE [DataGuard].[Splash_Item] ADD CONSTRAINT [PK_Splash_Item] PRIMARY KEY CLUSTERED  ([CODE]) ON [PRIMARY]
GO
ALTER TABLE [DataGuard].[Splash_Item] ADD CONSTRAINT [FK_SPIT_SPSC] FOREIGN KEY ([SPSC_CODE]) REFERENCES [DataGuard].[Splash_Screen] ([CODE]) ON DELETE CASCADE
GO
