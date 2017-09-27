CREATE TABLE [Msgb].[Message_Broad_Settings]
(
[MBID] [bigint] NOT NULL CONSTRAINT [DF_Message_Broad_Settings_MBID] DEFAULT ((0)),
[TYPE] [varchar] (3) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[BGWK_STAT] [varchar] (3) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[BGWK_INTR] [int] NULL,
[CUST_BGWK_STAT] [varchar] (3) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CUST_BGWK_INTR] [int] NULL,
[USER_NAME] [varchar] (250) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PASS_WORD] [varchar] (250) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[WEB_SITE_LOGN] [varchar] (250) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[WEB_SITE_PSWD] [varchar] (250) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[LINE_NUMB] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[LINE_TYPE] [varchar] (3) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DFLT_STAT] [varchar] (3) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[LAST_ROW_FTCH] [bigint] NULL,
[FTCH_ROW] [int] NULL,
[CRET_BY] [varchar] (250) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CRET_DATE] [datetime] NULL,
[MDFY_BY] [varchar] (250) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[MDFY_DATE] [datetime] NULL
) ON [PRIMARY]
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
CREATE TRIGGER [Msgb].[CG$AINS_MGBS]
   ON  [Msgb].[Message_Broad_Settings]
   AFTER INSERT
AS 
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for trigger here
   MERGE Msgb.Message_Broad_Settings T
   USING (SELECT * FROM INSERTED) S
   ON (T.MBID = S.MBID)
   WHEN MATCHED THEN
      UPDATE 
         SET CRET_BY = UPPER(SUSER_NAME())
            ,CRET_DATE = GETDATE()
            ,MBID = dbo.GetNewIdentity();
END
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
CREATE TRIGGER [Msgb].[CG$AUPD_MGBS]
   ON  [Msgb].[Message_Broad_Settings]
   AFTER UPDATE
AS 
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for trigger here
   MERGE Msgb.Message_Broad_Settings T
   USING (SELECT * FROM INSERTED) S
   ON (T.MBID = S.MBID)
   WHEN MATCHED THEN
      UPDATE 
         SET MDFY_BY = UPPER(SUSER_NAME())
            ,MDFY_DATE = GETDATE();
END
GO
ALTER TABLE [Msgb].[Message_Broad_Settings] ADD CONSTRAINT [PK_Message_Broad_Settings] PRIMARY KEY CLUSTERED  ([MBID]) ON [PRIMARY]
GO
EXEC sp_addextendedproperty N'MS_Description', N'مدت زمان', 'SCHEMA', N'Msgb', 'TABLE', N'Message_Broad_Settings', 'COLUMN', N'BGWK_INTR'
GO
EXEC sp_addextendedproperty N'MS_Description', N'وضعیت', 'SCHEMA', N'Msgb', 'TABLE', N'Message_Broad_Settings', 'COLUMN', N'BGWK_STAT'
GO
EXEC sp_addextendedproperty N'MS_Description', N'شماره خط', 'SCHEMA', N'Msgb', 'TABLE', N'Message_Broad_Settings', 'COLUMN', N'LINE_NUMB'
GO
EXEC sp_addextendedproperty N'MS_Description', N'نوع خط', 'SCHEMA', N'Msgb', 'TABLE', N'Message_Broad_Settings', 'COLUMN', N'LINE_TYPE'
GO
EXEC sp_addextendedproperty N'MS_Description', N'SMS OR Telegram', 'SCHEMA', N'Msgb', 'TABLE', N'Message_Broad_Settings', 'COLUMN', N'TYPE'
GO
