CREATE TABLE [Global].[Form]
(
[LCAL_LCID] [bigint] NULL,
[ID] [bigint] NOT NULL,
[SUB_SYS] [int] NOT NULL,
[APEN_NAME] [varchar] (250) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[FA_NAME] [nvarchar] (250) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[EN_NAME] [varchar] (250) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[GUID] [varchar] (38) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[FORM_PATH] [varchar] (250) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [BLOB]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE TRIGGER [Global].[CG$AINS_FORM]
   ON [Global].[Form]
   AFTER INSERT
AS 
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for trigger here
   MERGE Global.Form T
   USING (SELECT * FROM Inserted) S
   ON (T.LCAL_LCID = S.LCAL_LCID AND 
       T.ID = S.ID)
   WHEN MATCHED THEN
      UPDATE SET
         T.ID = CASE s.ID WHEN 0 THEN dbo.GetNewVerIdentity() ELSE s.ID END;
END
GO
ALTER TABLE [Global].[Form] ADD CONSTRAINT [PK_Form] PRIMARY KEY CLUSTERED  ([ID]) ON [BLOB]
GO
ALTER TABLE [Global].[Form] ADD CONSTRAINT [FK_FORM_SUBS] FOREIGN KEY ([SUB_SYS]) REFERENCES [DataGuard].[Sub_System] ([SUB_SYS])
GO
ALTER TABLE [Global].[Form] ADD CONSTRAINT [FK_FROM_LCAL] FOREIGN KEY ([LCAL_LCID]) REFERENCES [Global].[Localization] ([LCID]) ON DELETE CASCADE ON UPDATE CASCADE
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
