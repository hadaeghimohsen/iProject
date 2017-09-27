CREATE TABLE [Msgb].[Sms_Message_Box]
(
[MBID] [bigint] NOT NULL IDENTITY(1, 1),
[SUB_SYS] [int] NULL,
[LINE_TYPE] [varchar] (3) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ACTN_DATE] [datetime] NULL,
[RFID] [bigint] NULL,
[PHON_NUMB] [varchar] (11) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[MSGB_TEXT] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[MSGB_TYPE] [varchar] (3) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[STAT] [varchar] (3) COLLATE SQL_Latin1_General_CP1_CI_AS NULL CONSTRAINT [DF_Message_Box_STAT] DEFAULT ('001'),
[MESG_ID] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[EROR_CODE] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[EROR_MESG] [nvarchar] (500) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SRVR_SEND_DATE] [datetime] NULL,
[MESG_LENT] [int] NULL,
[CRET_BY] [varchar] (250) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CRET_DATE] [datetime] NULL,
[MDFY_BY] [varchar] (250) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[MDFY_DATE] [datetime] NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
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
CREATE TRIGGER [Msgb].[CG$AINS_MSGB]
   ON [Msgb].[Sms_Message_Box]
   AFTER INSERT
AS 
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

   -- Insert statements for trigger here
   MERGE Msgb.Sms_Message_Box T
   USING(SELECT * FROM INSERTED)S
   ON (T.MBID = S.MBID)
   WHEN MATCHED THEN
      UPDATE
         SET CRET_BY = UPPER(SUSER_NAME())
            ,CRET_DATE = GETDATE()
            ,ACTN_DATE = GETDATE();

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
CREATE TRIGGER [Msgb].[CG$AUPD_MSGB]
   ON [Msgb].[Sms_Message_Box]
   AFTER UPDATE
AS 
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

   -- Insert statements for trigger here
   MERGE Msgb.Sms_Message_Box T
   USING(SELECT * FROM INSERTED)S
   ON (T.MBID = S.MBID)
   WHEN MATCHED THEN
      UPDATE
         SET MDFY_BY = UPPER(SUSER_NAME())
            ,MDFY_DATE = GETDATE();

END
GO
ALTER TABLE [Msgb].[Sms_Message_Box] ADD CONSTRAINT [PK_SMGB] PRIMARY KEY CLUSTERED  ([MBID]) ON [PRIMARY]
GO
ALTER TABLE [Msgb].[Sms_Message_Box] ADD CONSTRAINT [FK_SMGB_SUBS] FOREIGN KEY ([SUB_SYS]) REFERENCES [DataGuard].[Sub_System] ([SUB_SYS])
GO
EXEC sp_addextendedproperty N'MS_Description', N'کد شناسه مربوط به ارسال پیام در وب سرویس -  برای پیگیری کردن وضعیت پیام ارسال شده', 'SCHEMA', N'Msgb', 'TABLE', N'Sms_Message_Box', 'COLUMN', N'MESG_ID'
GO
EXEC sp_addextendedproperty N'MS_Description', N'ایندکس مربوط به زیر سیستم ها که بتوانند اطلاعات خود را پیگیری کنند', 'SCHEMA', N'Msgb', 'TABLE', N'Sms_Message_Box', 'COLUMN', N'RFID'
GO
