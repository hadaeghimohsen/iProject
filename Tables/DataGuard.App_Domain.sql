CREATE TABLE [DataGuard].[App_Domain]
(
[CODE] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[NAME] [varchar] (250) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[VALU] [varchar] (3) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[DOMN_DESC] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [DataGuard].[App_Domain] ADD CONSTRAINT [PK_APDM] PRIMARY KEY CLUSTERED  ([CODE], [VALU]) ON [PRIMARY]
GO
