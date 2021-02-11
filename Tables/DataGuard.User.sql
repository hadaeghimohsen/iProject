CREATE TABLE [DataGuard].[User]
(
[ID] [bigint] NOT NULL CONSTRAINT [DF_User_ID] DEFAULT ([dbo].[GetNewIdentity]()),
[ShortCut] [bigint] NULL,
[TitleFa] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[TitleEn] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[STitleEn] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Password] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[USERDB] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PASSDB] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[IsLock] [bit] NOT NULL CONSTRAINT [DF__User__IsLock__276EDEB3] DEFAULT ('false'),
[IsVisible] [bit] NOT NULL CONSTRAINT [DF__User__IsVisible__286302EC] DEFAULT ('true'),
[AMIL_ADRS] [varchar] (250) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[MAIL_SRVR] [varchar] (3) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[EMAL_ADRS] [nvarchar] (250) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[EMAL_PASS] [nvarchar] (250) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[MUST_CHNG_PASS] [varchar] (3) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[FRST_LOGN] [varchar] (3) COLLATE SQL_Latin1_General_CP1_CI_AS NULL CONSTRAINT [DF_User_FRST_LOGN] DEFAULT ('002'),
[PLCY_FORC_SAFE_ENTR] [varchar] (3) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PASS_MDFY_DATE] [datetime] NULL,
[DFLT_FACT] [varchar] (3) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ADD_COMP_LIST] [varchar] (3) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DFLT_SUB_SYS] [int] NULL,
[REGN_PRVN_CNTY_CODE] [varchar] (3) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[REGN_PRVN_CODE] [varchar] (3) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[REGN_CODE] [varchar] (3) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[WETR_ACES_STAT] [varchar] (3) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CONT_PBLC_STAT] [varchar] (3) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[USER_IMAG] [image] NULL,
[PRVC_LOCK_SCRN_STAT] [varchar] (3) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[LAST_LOGN_DATE_DNRM] [datetime] NULL,
[CELL_PHON] [varchar] (15) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[TELL_PHON] [varchar] (15) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[VOIP_NUMB] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SHOW_LOGN_FORM] [varchar] (3) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[MAIL_SRVR_STAT] [varchar] (3) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[MAIL_SRVR_PROF] [varchar] (250) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[MAIL_SRVR_ACNT] [varchar] (250) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DFLT_USER_HELP_SRVR] [varchar] (3) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[REGN_LANG] [varchar] (3) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[RTL_STAT] [varchar] (3) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PIN_CODE] [int] NULL,
[CRET_BY] [varchar] (250) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CRET_DATE] [datetime] NULL,
[MDFY_BY] [varchar] (250) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[MDFY_DATE] [datetime] NULL
) ON [PRIMARY] TEXTIMAGE_ON [BLOB]
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
CREATE TRIGGER [DataGuard].[CG$AINS_USER]
   ON  [DataGuard].[User]
   AFTER INSERT   
AS 
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for trigger here
   MERGE DataGuard.[User] T
   USING (SELECT ID FROM Inserted) S
   ON (T.ID = S.ID)
   WHEN MATCHED THEN
      UPDATE SET
         T.CRET_BY = UPPER(SUSER_NAME())
        ,T.CRET_DATE = GETDATE();
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
CREATE TRIGGER [DataGuard].[CG$AUPD_USER]
   ON  [DataGuard].[User]
   AFTER UPDATE   
AS 
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

   IF EXISTS(
      SELECT *
        FROM Inserted u, DataGuard.Sub_System s
       WHERE u.DFLT_SUB_SYS = s.SUB_SYS
         AND s.DFLT_APP_STRT_STAT = '001'
   )
   BEGIN
      RAISERROR(N'نرم افزار های سیستمی نمی توانند  به عنوان برنامه پیش فرض قرار گیرند', 16, 1);
      RETURN;
   END;

    -- Insert statements for trigger here
   MERGE DataGuard.[User] T
   USING (SELECT ID FROM Inserted) S
   ON (T.ID = S.ID)
   WHEN MATCHED THEN
      UPDATE SET
         T.MDFY_BY = UPPER(SUSER_NAME())
        ,T.MDFY_DATE = GETDATE();
END
GO
ALTER TABLE [DataGuard].[User] ADD CONSTRAINT [PK__User__3214EC2725869641] PRIMARY KEY CLUSTERED  ([ID]) ON [PRIMARY]
GO
CREATE UNIQUE NONCLUSTERED INDEX [User_ID] ON [DataGuard].[User] ([ID]) ON [PRIMARY]
GO
ALTER TABLE [DataGuard].[User] ADD CONSTRAINT [FK_USER_REGN] FOREIGN KEY ([REGN_PRVN_CNTY_CODE], [REGN_PRVN_CODE], [REGN_CODE]) REFERENCES [Global].[Region] ([PRVN_CNTY_CODE], [PRVN_CODE], [CODE])
GO
EXEC sp_addextendedproperty N'MS_Description', N'ایمیل مخصوص نرم افزار انار', 'SCHEMA', N'DataGuard', 'TABLE', N'User', 'COLUMN', N'AMIL_ADRS'
GO
EXEC sp_addextendedproperty N'MS_Description', N'تلفن همراه', 'SCHEMA', N'DataGuard', 'TABLE', N'User', 'COLUMN', N'CELL_PHON'
GO
EXEC sp_addextendedproperty N'MS_Description', N'لیست دوستان به صورت عمومی در معرض دیگران قرار بگیرد', 'SCHEMA', N'DataGuard', 'TABLE', N'User', 'COLUMN', N'CONT_PBLC_STAT'
GO
EXEC sp_addextendedproperty N'MS_Description', N'نرم افزار پیش فرض کاربران', 'SCHEMA', N'DataGuard', 'TABLE', N'User', 'COLUMN', N'DFLT_SUB_SYS'
GO
EXEC sp_addextendedproperty N'MS_Description', N'برای استفاده از کاربر ارسال کننده ایمیل های سمت سرور', 'SCHEMA', N'DataGuard', 'TABLE', N'User', 'COLUMN', N'DFLT_USER_HELP_SRVR'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Account Name Mail Server', 'SCHEMA', N'DataGuard', 'TABLE', N'User', 'COLUMN', N'MAIL_SRVR_ACNT'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Profile Name Mail Server', 'SCHEMA', N'DataGuard', 'TABLE', N'User', 'COLUMN', N'MAIL_SRVR_PROF'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Sql Server Mail Server Use', 'SCHEMA', N'DataGuard', 'TABLE', N'User', 'COLUMN', N'MAIL_SRVR_STAT'
GO
EXEC sp_addextendedproperty N'MS_Description', N'برای وارد کردن شماره پین کد', 'SCHEMA', N'DataGuard', 'TABLE', N'User', 'COLUMN', N'PIN_CODE'
GO
EXEC sp_addextendedproperty N'MS_Description', N'اطلاعات خصوصی کاربران در صفحه ورود مجدد قابل رویت باشد', 'SCHEMA', N'DataGuard', 'TABLE', N'User', 'COLUMN', N'PRVC_LOCK_SCRN_STAT'
GO
EXEC sp_addextendedproperty N'MS_Description', N'زبان محلی برای کاربر (فارسی، عربی، انگلیسی، ...)', 'SCHEMA', N'DataGuard', 'TABLE', N'User', 'COLUMN', N'REGN_LANG'
GO
EXEC sp_addextendedproperty N'MS_Description', N'قابلیت راست به چپ مورد استفاده قرار بگیرد.', 'SCHEMA', N'DataGuard', 'TABLE', N'User', 'COLUMN', N'RTL_STAT'
GO
EXEC sp_addextendedproperty N'MS_Description', N'آیا نام کاربری در فرم ورود قابل نمایش باشد', 'SCHEMA', N'DataGuard', 'TABLE', N'User', 'COLUMN', N'SHOW_LOGN_FORM'
GO
EXEC sp_addextendedproperty N'MS_Description', N'تلفن ثابت', 'SCHEMA', N'DataGuard', 'TABLE', N'User', 'COLUMN', N'TELL_PHON'
GO
EXEC sp_addextendedproperty N'MS_Description', N'شماره داخلی', 'SCHEMA', N'DataGuard', 'TABLE', N'User', 'COLUMN', N'VOIP_NUMB'
GO
EXEC sp_addextendedproperty N'MS_Description', N'سرویس آب و هوا بتواند از این اطلاعات استفاده کند', 'SCHEMA', N'DataGuard', 'TABLE', N'User', 'COLUMN', N'WETR_ACES_STAT'
GO
