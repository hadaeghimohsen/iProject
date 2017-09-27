CREATE TABLE [DataGuard].[Package_Instance_User_Gateway]
(
[PKIN_PAKG_SUB_SYS] [int] NOT NULL,
[PKIN_PAKG_CODE] [varchar] (3) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[PKIN_RWNO] [int] NOT NULL,
[USGW_GTWY_MAC_ADRS] [varchar] (17) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[USGW_USER_ID] [bigint] NOT NULL,
[USGW_RWNO] [int] NOT NULL,
[STAT] [varchar] (3) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SHOW_NOTF_STAT] [varchar] (3) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SHOW_NOTF_LOCK_SCRN] [varchar] (3) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SHOW_NOTF_WRMD_STAT] [varchar] (3) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SHOW_SYS_SUGT_STAT] [varchar] (3) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[BACK_GRND_TYPE] [varchar] (3) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[IMAG_PATH] [nvarchar] (1000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[IMAG_LYOT] [varchar] (3) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[BACK_GRND_COLR] [varchar] (7) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[THEM_COLR] [varchar] (7) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[LOCK_SCRN_BACK_GRND_COLR] [varchar] (7) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[LOCK_SCRN_NOTF_MESG_BUTN] [varchar] (3) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[LOCK_SCRN_DTIM_BUTN] [varchar] (3) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[LOCK_SCRN_WETR_BUTN] [varchar] (3) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SHOW_DESK_STAT] [varchar] (3) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SHOW_STRT_STAT] [varchar] (3) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SHOW_TASK_STAT] [varchar] (3) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[STRT_SHOW_MORE] [varchar] (3) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[STRT_SHOW_FAV] [varchar] (3) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[STRT_FULL_SCRN] [varchar] (3) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[STRT_EXIT_BUTN] [varchar] (3) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[STRT_STNG_BUTN] [varchar] (3) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[STRT_ACTV_USER_BUTN] [varchar] (3) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[STRT_CNTC_BUTN] [varchar] (3) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[STRT_NOTF_MESG_BUTN] [varchar] (3) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[STRT_PROF_USER_BUTN] [varchar] (3) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[STRT_WETR_BUTN] [varchar] (3) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[TASK_LOCT] [varchar] (3) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[TASK_SIZE] [varchar] (3) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[STRY_DTIM_BUTN] [varchar] (3) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[STRY_NOTF_MESG_BUTN] [varchar] (3) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[STRY_NETW_BUTN] [varchar] (3) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[STRY_BKRS_BUTN] [varchar] (3) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[REGN_PRVN_CNTY_CODE] [varchar] (3) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[REGN_PRVN_CODE] [varchar] (3) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[REGN_CODE] [varchar] (3) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[WETR_ACES_STAT] [varchar] (3) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SHOW_LOG_IN_DESC] [varchar] (3) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[LOG_IN_DESC] [nvarchar] (500) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
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
CREATE TRIGGER [DataGuard].[CG$AINS_PIUG]
   ON  [DataGuard].[Package_Instance_User_Gateway]
   AFTER INSERT
AS 
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

   -- Insert statements for trigger here
   MERGE [DataGuard].[Package_Instance_User_Gateway] T
   USING (SELECT * FROM INSERTED) S
   ON (T.PKIN_PAKG_SUB_SYS  = S.PKIN_PAKG_SUB_SYS  AND
       T.PKIN_PAKG_CODE     = S.PKIN_PAKG_CODE     AND
       T.PKIN_RWNO          = S.PKIN_RWNO          AND
       T.USGW_GTWY_MAC_ADRS = S.USGW_GTWY_MAC_ADRS AND
       T.USGW_USER_ID       = S.USGW_USER_ID       AND
       T.USGW_RWNO          = S.USGW_RWNO)
   WHEN MATCHED THEN
      UPDATE
         SET CRET_BY   = UPPER(SUSER_NAME())
            ,CRET_DATE = GETDATE();
END
;
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [DataGuard].[CG$AUPD_PIUG]
   ON  [DataGuard].[Package_Instance_User_Gateway]
   AFTER UPDATE
AS 
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

   -- Insert statements for trigger here
   MERGE [DataGuard].[Package_Instance_User_Gateway] T
   USING (SELECT * FROM INSERTED) S
   ON (T.PKIN_PAKG_SUB_SYS  = S.PKIN_PAKG_SUB_SYS  AND
       T.PKIN_PAKG_CODE     = S.PKIN_PAKG_CODE     AND
       T.PKIN_RWNO          = S.PKIN_RWNO          AND
       T.USGW_GTWY_MAC_ADRS = S.USGW_GTWY_MAC_ADRS AND
       T.USGW_USER_ID       = S.USGW_USER_ID       AND
       T.USGW_RWNO          = S.USGW_RWNO)
   WHEN MATCHED THEN
      UPDATE
         SET MDFY_BY   = UPPER(SUSER_NAME())
            ,MDFY_DATE = GETDATE();
END
;
GO
ALTER TABLE [DataGuard].[Package_Instance_User_Gateway] ADD CONSTRAINT [PK_PIUG] PRIMARY KEY CLUSTERED  ([PKIN_PAKG_SUB_SYS], [PKIN_PAKG_CODE], [PKIN_RWNO], [USGW_GTWY_MAC_ADRS], [USGW_USER_ID], [USGW_RWNO]) ON [PRIMARY]
GO
ALTER TABLE [DataGuard].[Package_Instance_User_Gateway] ADD CONSTRAINT [FK_PIUG_PKIN] FOREIGN KEY ([PKIN_PAKG_SUB_SYS], [PKIN_PAKG_CODE], [PKIN_RWNO]) REFERENCES [DataGuard].[Package_Instance] ([PAKG_SUB_SYS], [PAKG_CODE], [RWNO])
GO
ALTER TABLE [DataGuard].[Package_Instance_User_Gateway] ADD CONSTRAINT [FK_PIUG_REGN] FOREIGN KEY ([REGN_PRVN_CNTY_CODE], [REGN_PRVN_CODE], [REGN_CODE]) REFERENCES [Global].[Region] ([PRVN_CNTY_CODE], [PRVN_CODE], [CODE])
GO
ALTER TABLE [DataGuard].[Package_Instance_User_Gateway] ADD CONSTRAINT [FK_PIUG_USGW] FOREIGN KEY ([USGW_GTWY_MAC_ADRS], [USGW_USER_ID], [USGW_RWNO]) REFERENCES [DataGuard].[User_Gateway] ([GTWY_MAC_ADRS], [USER_ID], [RWNO]) ON DELETE CASCADE
GO
EXEC sp_addextendedproperty N'MS_Description', N'رنگ پس زمینه زیر سیستم', 'SCHEMA', N'DataGuard', 'TABLE', N'Package_Instance_User_Gateway', 'COLUMN', N'BACK_GRND_COLR'
GO
EXEC sp_addextendedproperty N'MS_Description', N'تنظمیات شخصی در قسمت پس زمینه گزینه نوع پس زمینه', 'SCHEMA', N'DataGuard', 'TABLE', N'Package_Instance_User_Gateway', 'COLUMN', N'BACK_GRND_TYPE'
GO
EXEC sp_addextendedproperty N'MS_Description', N'تنظمیات شخصی در قسمت پس زمینه گزینه نوع قرار گیری تصویر', 'SCHEMA', N'DataGuard', 'TABLE', N'Package_Instance_User_Gateway', 'COLUMN', N'IMAG_LYOT'
GO
EXEC sp_addextendedproperty N'MS_Description', N'تنظمیات شخصی در قسمت پس زمینه گزینه انتخاب مسیر عکس', 'SCHEMA', N'DataGuard', 'TABLE', N'Package_Instance_User_Gateway', 'COLUMN', N'IMAG_PATH'
GO
EXEC sp_addextendedproperty N'MS_Description', N'رنگ پس زمینه صفحه ورود', 'SCHEMA', N'DataGuard', 'TABLE', N'Package_Instance_User_Gateway', 'COLUMN', N'LOCK_SCRN_BACK_GRND_COLR'
GO
EXEC sp_addextendedproperty N'MS_Description', N'نمایش تاریخ و ساعت در صفحه ورود', 'SCHEMA', N'DataGuard', 'TABLE', N'Package_Instance_User_Gateway', 'COLUMN', N'LOCK_SCRN_DTIM_BUTN'
GO
EXEC sp_addextendedproperty N'MS_Description', N'نمایش پیام ها و ایمیل ها در صفحه ورود', 'SCHEMA', N'DataGuard', 'TABLE', N'Package_Instance_User_Gateway', 'COLUMN', N'LOCK_SCRN_NOTF_MESG_BUTN'
GO
EXEC sp_addextendedproperty N'MS_Description', N'نمایش اطلاعات آب و هوایی در صفحه ورود', 'SCHEMA', N'DataGuard', 'TABLE', N'Package_Instance_User_Gateway', 'COLUMN', N'LOCK_SCRN_WETR_BUTN'
GO
EXEC sp_addextendedproperty N'MS_Description', N'متن کاربر برای صفحه ورود به سیستم', 'SCHEMA', N'DataGuard', 'TABLE', N'Package_Instance_User_Gateway', 'COLUMN', N'LOG_IN_DESC'
GO
EXEC sp_addextendedproperty N'MS_Description', N'نمایش منوی زیر سیستم در میزکار', 'SCHEMA', N'DataGuard', 'TABLE', N'Package_Instance_User_Gateway', 'COLUMN', N'SHOW_DESK_STAT'
GO
EXEC sp_addextendedproperty N'MS_Description', N'متن کاربر برای صفحه ورود نمایش داده شود', 'SCHEMA', N'DataGuard', 'TABLE', N'Package_Instance_User_Gateway', 'COLUMN', N'SHOW_LOG_IN_DESC'
GO
EXEC sp_addextendedproperty N'MS_Description', N'آیا پیام ها در صفحه ورود نمایش داده شود', 'SCHEMA', N'DataGuard', 'TABLE', N'Package_Instance_User_Gateway', 'COLUMN', N'SHOW_NOTF_LOCK_SCRN'
GO
EXEC sp_addextendedproperty N'MS_Description', N'تنظیمات سیستم گزینه نمایش پیام', 'SCHEMA', N'DataGuard', 'TABLE', N'Package_Instance_User_Gateway', 'COLUMN', N'SHOW_NOTF_STAT'
GO
EXEC sp_addextendedproperty N'MS_Description', N'نمایش هشدار ها و یادآوری ها', 'SCHEMA', N'DataGuard', 'TABLE', N'Package_Instance_User_Gateway', 'COLUMN', N'SHOW_NOTF_WRMD_STAT'
GO
EXEC sp_addextendedproperty N'MS_Description', N'نمایش منوی زیر سیستم در منوی شروع', 'SCHEMA', N'DataGuard', 'TABLE', N'Package_Instance_User_Gateway', 'COLUMN', N'SHOW_STRT_STAT'
GO
EXEC sp_addextendedproperty N'MS_Description', N'نمایش پیام ها، خطا ها و هشدار های سیستم', 'SCHEMA', N'DataGuard', 'TABLE', N'Package_Instance_User_Gateway', 'COLUMN', N'SHOW_SYS_SUGT_STAT'
GO
EXEC sp_addextendedproperty N'MS_Description', N'نمایش منوی زیر سیستم در نوار وظیفه', 'SCHEMA', N'DataGuard', 'TABLE', N'Package_Instance_User_Gateway', 'COLUMN', N'SHOW_TASK_STAT'
GO
EXEC sp_addextendedproperty N'MS_Description', N'نمایش کاربران فعال در منوی شروع', 'SCHEMA', N'DataGuard', 'TABLE', N'Package_Instance_User_Gateway', 'COLUMN', N'STRT_ACTV_USER_BUTN'
GO
EXEC sp_addextendedproperty N'MS_Description', N'نمایش دکمه لیست دوستان در منوی شروع', 'SCHEMA', N'DataGuard', 'TABLE', N'Package_Instance_User_Gateway', 'COLUMN', N'STRT_CNTC_BUTN'
GO
EXEC sp_addextendedproperty N'MS_Description', N'نمایش دکمه خروج در منوی شروع', 'SCHEMA', N'DataGuard', 'TABLE', N'Package_Instance_User_Gateway', 'COLUMN', N'STRT_EXIT_BUTN'
GO
EXEC sp_addextendedproperty N'MS_Description', N'تمام صفحه کردن منوی شروع', 'SCHEMA', N'DataGuard', 'TABLE', N'Package_Instance_User_Gateway', 'COLUMN', N'STRT_FULL_SCRN'
GO
EXEC sp_addextendedproperty N'MS_Description', N'نمایش دکمه پیام و ایمیل ها در منوی شروع', 'SCHEMA', N'DataGuard', 'TABLE', N'Package_Instance_User_Gateway', 'COLUMN', N'STRT_NOTF_MESG_BUTN'
GO
EXEC sp_addextendedproperty N'MS_Description', N'نمایش اطلاعات پروفایل کاربری در منوی شروع', 'SCHEMA', N'DataGuard', 'TABLE', N'Package_Instance_User_Gateway', 'COLUMN', N'STRT_PROF_USER_BUTN'
GO
EXEC sp_addextendedproperty N'MS_Description', N'نمایش برنامه های پرکاربرد', 'SCHEMA', N'DataGuard', 'TABLE', N'Package_Instance_User_Gateway', 'COLUMN', N'STRT_SHOW_FAV'
GO
EXEC sp_addextendedproperty N'MS_Description', N'نمایش منوهای بیشتر', 'SCHEMA', N'DataGuard', 'TABLE', N'Package_Instance_User_Gateway', 'COLUMN', N'STRT_SHOW_MORE'
GO
EXEC sp_addextendedproperty N'MS_Description', N'نمایش دکمه تنظیمات در منوی شروع', 'SCHEMA', N'DataGuard', 'TABLE', N'Package_Instance_User_Gateway', 'COLUMN', N'STRT_STNG_BUTN'
GO
EXEC sp_addextendedproperty N'MS_Description', N'نمایش دکمه آب و هوا در منوی شروع', 'SCHEMA', N'DataGuard', 'TABLE', N'Package_Instance_User_Gateway', 'COLUMN', N'STRT_WETR_BUTN'
GO
EXEC sp_addextendedproperty N'MS_Description', N'نمایش وضعیت پشتیبان گیری و بازگردانی', 'SCHEMA', N'DataGuard', 'TABLE', N'Package_Instance_User_Gateway', 'COLUMN', N'STRY_BKRS_BUTN'
GO
EXEC sp_addextendedproperty N'MS_Description', N'نمایش ساعت در سیستم ترای', 'SCHEMA', N'DataGuard', 'TABLE', N'Package_Instance_User_Gateway', 'COLUMN', N'STRY_DTIM_BUTN'
GO
EXEC sp_addextendedproperty N'MS_Description', N'نمایش شبکه های موجود', 'SCHEMA', N'DataGuard', 'TABLE', N'Package_Instance_User_Gateway', 'COLUMN', N'STRY_NETW_BUTN'
GO
EXEC sp_addextendedproperty N'MS_Description', N'نمایش آخرین پیام ها و ایمیل ها در سیستم ترای', 'SCHEMA', N'DataGuard', 'TABLE', N'Package_Instance_User_Gateway', 'COLUMN', N'STRY_NOTF_MESG_BUTN'
GO
EXEC sp_addextendedproperty N'MS_Description', N'موقعیت نوار وظیفه', 'SCHEMA', N'DataGuard', 'TABLE', N'Package_Instance_User_Gateway', 'COLUMN', N'TASK_LOCT'
GO
EXEC sp_addextendedproperty N'MS_Description', N'اندازه نوار وظیفه', 'SCHEMA', N'DataGuard', 'TABLE', N'Package_Instance_User_Gateway', 'COLUMN', N'TASK_SIZE'
GO
EXEC sp_addextendedproperty N'MS_Description', N'رنگ بدنه کل نرم افزار', 'SCHEMA', N'DataGuard', 'TABLE', N'Package_Instance_User_Gateway', 'COLUMN', N'THEM_COLR'
GO
