CREATE TABLE [Global].[Form]
(
[ID] [bigint] NOT NULL CONSTRAINT [DF_FORM_ID] DEFAULT ([Dbo].[GetNewVerIdentity]()),
[SUB_SYS] [char] (3) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[APEN_NAME] [varchar] (250) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[FA_NAME] [nvarchar] (250) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[EN_NAME] [varchar] (250) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[GUID] [varchar] (38) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[FORM_PATH] [varchar] (250) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [BLOB]
GO
ALTER TABLE [Global].[Form] ADD CONSTRAINT [PK_Form] PRIMARY KEY CLUSTERED  ([ID]) ON [BLOB]
GO
EXEC sp_addextendedproperty N'MS_Description', N'نام لاتین زیر سیستم', 'SCHEMA', N'Global', 'TABLE', N'Form', 'COLUMN', N'APEN_NAME'
GO
EXEC sp_addextendedproperty N'MS_Description', N'نام لاتین فرم', 'SCHEMA', N'Global', 'TABLE', N'Form', 'COLUMN', N'EN_NAME'
GO
EXEC sp_addextendedproperty N'MS_Description', N'نام فارسی فرم', 'SCHEMA', N'Global', 'TABLE', N'Form', 'COLUMN', N'FA_NAME'
GO
EXEC sp_addextendedproperty N'MS_Description', N'مسیر اصلی فرم', 'SCHEMA', N'Global', 'TABLE', N'Form', 'COLUMN', N'FORM_PATH'
GO
EXEC sp_addextendedproperty N'MS_Description', N'کد انحصاری فرم', 'SCHEMA', N'Global', 'TABLE', N'Form', 'COLUMN', N'GUID'
GO
EXEC sp_addextendedproperty N'MS_Description', N'ردیف', 'SCHEMA', N'Global', 'TABLE', N'Form', 'COLUMN', N'ID'
GO
EXEC sp_addextendedproperty N'MS_Description', N'زیر سیستم', 'SCHEMA', N'Global', 'TABLE', N'Form', 'COLUMN', N'SUB_SYS'
GO
