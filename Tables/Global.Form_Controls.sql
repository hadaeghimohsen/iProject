CREATE TABLE [Global].[Form_Controls]
(
[FORM_ID] [bigint] NULL,
[ID] [bigint] NOT NULL CONSTRAINT [DF_Form_Controls_ID] DEFAULT ([Dbo].[GetNewVerIdentity]()),
[NAME] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[LABL_TEXT] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[TOOL_TIP_TEXT] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PLAC_HLDR_TEXT] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CNTL_TYPE] [varchar] (3) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[STAT] [varchar] (3) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [Global].[Form_Controls] ADD CONSTRAINT [PK_FMCL] PRIMARY KEY CLUSTERED  ([ID]) ON [PRIMARY]
GO
ALTER TABLE [Global].[Form_Controls] ADD CONSTRAINT [FK_FROM_FMCL] FOREIGN KEY ([FORM_ID]) REFERENCES [Global].[Form] ([ID]) ON DELETE CASCADE ON UPDATE CASCADE
GO
