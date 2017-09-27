CREATE TABLE [Global].[Form_Report]
(
[FORM_ID] [bigint] NOT NULL,
[RWNO] [bigint] NOT NULL,
[RPRT_DESC] [nvarchar] (250) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[PROF_ID] [bigint] NULL,
[PROF_ROLE_ID] [bigint] NULL,
[SERV_ID] [bigint] NULL,
[SERV_ROLE_ID] [bigint] NULL
) ON [BLOB]
GO
ALTER TABLE [Global].[Form_Report] ADD CONSTRAINT [PK_Form_Report] PRIMARY KEY CLUSTERED  ([FORM_ID], [RWNO]) ON [BLOB]
GO
ALTER TABLE [Global].[Form_Report] ADD CONSTRAINT [FK_Fmrp_Form] FOREIGN KEY ([FORM_ID]) REFERENCES [Global].[Form] ([ID]) ON DELETE CASCADE
GO
EXEC sp_addextendedproperty N'MS_Description', N'شماره ردیف فرم', 'SCHEMA', N'Global', 'TABLE', N'Form_Report', 'COLUMN', N'FORM_ID'
GO
EXEC sp_addextendedproperty N'MS_Description', N'شماره ردیف پروفایل', 'SCHEMA', N'Global', 'TABLE', N'Form_Report', 'COLUMN', N'PROF_ID'
GO
EXEC sp_addextendedproperty N'MS_Description', N'گروه دسترسی فرم', 'SCHEMA', N'Global', 'TABLE', N'Form_Report', 'COLUMN', N'PROF_ROLE_ID'
GO
EXEC sp_addextendedproperty N'MS_Description', N'شماره ردیف گزارش فرم', 'SCHEMA', N'Global', 'TABLE', N'Form_Report', 'COLUMN', N'RWNO'
GO
EXEC sp_addextendedproperty N'MS_Description', N'شماره ردیف گزارش', 'SCHEMA', N'Global', 'TABLE', N'Form_Report', 'COLUMN', N'SERV_ID'
GO
EXEC sp_addextendedproperty N'MS_Description', N'گروه دسترسی گزارش', 'SCHEMA', N'Global', 'TABLE', N'Form_Report', 'COLUMN', N'SERV_ROLE_ID'
GO
