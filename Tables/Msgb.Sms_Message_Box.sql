CREATE TABLE [Msgb].[Sms_Message_Box]
(
[MBID] [bigint] NOT NULL IDENTITY(1, 1),
[SUB_SYS] [int] NULL,
[LINE_TYPE] [varchar] (3) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ACTN_DATE] [datetime] NULL,
[RFID] [bigint] NULL,
[KEY1_RFID] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[KEY2_RFID] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PHON_NUMB] [varchar] (11) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CHAT_ID] [bigint] NULL,
[MSGB_TEXT] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[MSGB_TYPE] [varchar] (3) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[STAT] [varchar] (3) COLLATE SQL_Latin1_General_CP1_CI_AS NULL CONSTRAINT [DF_Message_Box_STAT] DEFAULT ('001'),
[MESG_ID] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[EROR_CODE] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[EROR_MESG] [nvarchar] (500) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SRVR_SEND_DATE] [datetime] NULL,
[MESG_LENT] [int] NULL,
[SEND_TYPE] [varchar] (3) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[BULK_NUMB] [bigint] NULL,
[PAGE_NUMB_DNRM] [int] NULL,
[VIST_STAT] [varchar] (3) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[VIST_DATE] [datetime] NULL,
[VIST_SUB_SYS] [int] NULL,
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
            ,ACTN_DATE = CASE WHEN s.ACTN_DATE IS NULL THEN GETDATE() ELSE s.ACTN_DATE END
            ,SEND_TYPE = CASE WHEN s.SEND_TYPE IS NULL THEN '001' ELSE s.SEND_TYPE END;

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
            ,MDFY_DATE = GETDATE()
            ,T.MESG_LENT = LEN(S.MSGB_TEXT)
            ,T.PAGE_NUMB_DNRM = CASE (LEN(S.MSGB_TEXT) % 70) WHEN 0 THEN LEN(S.MSGB_TEXT) / 70 ELSE (LEN(S.MSGB_TEXT) / 70) + 1 END; 

   
   -- 1401/03/30 * اگر یکسری پیام ها که درون سیستم داریم نیاز به تکرار مجدد داشته باشند بعد از ارسال مجدد باید دوباره رکورد جدیدی ایجاد شود و دوباره اماده ارسال شوند
   --INSERT INTO Msgb.Sms_Message_Box 
   --( SUB_SYS ,LINE_TYPE ,RFID ,KEY1_RFID ,KEY2_RFID ,PHON_NUMB ,MSGB_TEXT ,MSGB_TYPE ,STAT )
   --SELECT i.SUB_SYS ,i.LINE_TYPE ,i.RFID ,i.KEY1_RFID ,i.KEY2_RFID ,i.PHON_NUMB ,i.MSGB_TEXT ,i.MSGB_TYPE ,'001' 
   --  FROM Inserted i, Deleted d
   -- WHERE (i.SUB_SYS = 5 AND i.MSGB_TYPE IN ('041'))
   --   AND i.STAT != '001'
   --   AND i.MBID = d.MBID
   --   AND d.STAT = '001';
     
END
GO
ALTER TABLE [Msgb].[Sms_Message_Box] ADD CONSTRAINT [PK_SMGB] PRIMARY KEY CLUSTERED  ([MBID]) ON [PRIMARY]
GO
ALTER TABLE [Msgb].[Sms_Message_Box] ADD CONSTRAINT [FK_SMGB_SUBS] FOREIGN KEY ([SUB_SYS]) REFERENCES [DataGuard].[Sub_System] ([SUB_SYS])
GO
EXEC sp_addextendedproperty N'MS_Description', N'تاریخ و زمان ارسال', 'SCHEMA', N'Msgb', 'TABLE', N'Sms_Message_Box', 'COLUMN', N'ACTN_DATE'
GO
EXEC sp_addextendedproperty N'MS_Description', N'شماره بلاک ارسالی', 'SCHEMA', N'Msgb', 'TABLE', N'Sms_Message_Box', 'COLUMN', N'BULK_NUMB'
GO
EXEC sp_addextendedproperty N'MS_Description', N'کلید ارجاعی 1', 'SCHEMA', N'Msgb', 'TABLE', N'Sms_Message_Box', 'COLUMN', N'KEY1_RFID'
GO
EXEC sp_addextendedproperty N'MS_Description', N'کلید ارجاعی 2', 'SCHEMA', N'Msgb', 'TABLE', N'Sms_Message_Box', 'COLUMN', N'KEY2_RFID'
GO
EXEC sp_addextendedproperty N'MS_Description', N'نوع خط ارسال کننده خط تبلیغاتی، خط معمولی', 'SCHEMA', N'Msgb', 'TABLE', N'Sms_Message_Box', 'COLUMN', N'LINE_TYPE'
GO
EXEC sp_addextendedproperty N'MS_Description', N'کد شناسه مربوط به ارسال پیام در وب سرویس -  برای پیگیری کردن وضعیت پیام ارسال شده', 'SCHEMA', N'Msgb', 'TABLE', N'Sms_Message_Box', 'COLUMN', N'MESG_ID'
GO
EXEC sp_addextendedproperty N'MS_Description', N'نوع پیام برای زیر سیستم', 'SCHEMA', N'Msgb', 'TABLE', N'Sms_Message_Box', 'COLUMN', N'MSGB_TYPE'
GO
EXEC sp_addextendedproperty N'MS_Description', N'تعداد صفحات پیامک', 'SCHEMA', N'Msgb', 'TABLE', N'Sms_Message_Box', 'COLUMN', N'PAGE_NUMB_DNRM'
GO
EXEC sp_addextendedproperty N'MS_Description', N'ایندکس مربوط به زیر سیستم ها که بتوانند اطلاعات خود را پیگیری کنند', 'SCHEMA', N'Msgb', 'TABLE', N'Sms_Message_Box', 'COLUMN', N'RFID'
GO
EXEC sp_addextendedproperty N'MS_Description', N'نوع ارسالی پیام', 'SCHEMA', N'Msgb', 'TABLE', N'Sms_Message_Box', 'COLUMN', N'SEND_TYPE'
GO
EXEC sp_addextendedproperty N'MS_Description', N'وضعیت پیام', 'SCHEMA', N'Msgb', 'TABLE', N'Sms_Message_Box', 'COLUMN', N'STAT'
GO
EXEC sp_addextendedproperty N'MS_Description', N'در چه تاریخی ویزیت شده', 'SCHEMA', N'Msgb', 'TABLE', N'Sms_Message_Box', 'COLUMN', N'VIST_DATE'
GO
EXEC sp_addextendedproperty N'MS_Description', N'وضعیت ویزیت رکورد', 'SCHEMA', N'Msgb', 'TABLE', N'Sms_Message_Box', 'COLUMN', N'VIST_STAT'
GO
EXEC sp_addextendedproperty N'MS_Description', N'توسط چه زیر سیستمی ویزیت شده', 'SCHEMA', N'Msgb', 'TABLE', N'Sms_Message_Box', 'COLUMN', N'VIST_SUB_SYS'
GO
