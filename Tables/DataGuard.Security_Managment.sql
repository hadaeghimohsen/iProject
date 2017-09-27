CREATE TABLE [DataGuard].[Security_Managment]
(
[SMID] [bigint] NOT NULL IDENTITY(1, 2),
[LAST_UPDT] [datetime] NULL,
[PLCY_MAC_ADDR_FLTR] [varchar] (3) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PLCY_FORC_SAFE_ENTR] [varchar] (3) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PLCY_COMP_BLOK] [varchar] (3) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[LOGN_COMP_BLOK] [varchar] (3) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SHOW_ALRM_UNAT] [varchar] (3) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[POST_PONE_UNAT] [int] NULL,
[USE_VPN] [varchar] (3) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PLCY_SECR_PSWD] [varchar] (3) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PSWD_HIST_NUMB] [int] NULL,
[MAX_PSWD_AGE] [int] NULL,
[MIN_PSWD_AGE] [int] NULL,
[MIN_PSWD_LEN] [int] NULL,
[PLCY_PSWD_CMPX] [varchar] (3) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[HASH_PASS] [varchar] (3) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
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
CREATE TRIGGER [DataGuard].[CG$AINS_SECM]
   ON  [DataGuard].[Security_Managment]
   AFTER INSERT
AS 
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for trigger here
   MERGE DataGuard.Security_Managment T
   USING (SELECT * FROM Inserted) S
   ON (t.SMID = s.SMID)
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
CREATE TRIGGER [DataGuard].[CG$AUPD_SECM]
   ON  [DataGuard].[Security_Managment]
   AFTER UPDATE 
AS 
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for trigger here
   MERGE DataGuard.Security_Managment T
   USING (SELECT * FROM Inserted) S
   ON (t.SMID = s.SMID)
   WHEN MATCHED THEN
      UPDATE SET
         T.MDFY_BY = UPPER(SUSER_NAME())
        ,T.MDFY_DATE = GETDATE();       
END
GO
ALTER TABLE [DataGuard].[Security_Managment] ADD CONSTRAINT [PK_Security_Managment] PRIMARY KEY CLUSTERED  ([SMID]) ON [PRIMARY]
GO
EXEC sp_addextendedproperty N'MS_Description', N'آخرین بروز رسانی نرم افزار', 'SCHEMA', N'DataGuard', 'TABLE', N'Security_Managment', 'COLUMN', N'LAST_UPDT'
GO
EXEC sp_addextendedproperty N'MS_Description', N'کامپیوتر های بلاک شده قادر به ورود هستن', 'SCHEMA', N'DataGuard', 'TABLE', N'Security_Managment', 'COLUMN', N'LOGN_COMP_BLOK'
GO
EXEC sp_addextendedproperty N'MS_Description', N'بیشتر روز استفاده از رمز عبور', 'SCHEMA', N'DataGuard', 'TABLE', N'Security_Managment', 'COLUMN', N'MAX_PSWD_AGE'
GO
EXEC sp_addextendedproperty N'MS_Description', N'کمترین طول رمز عبور', 'SCHEMA', N'DataGuard', 'TABLE', N'Security_Managment', 'COLUMN', N'MIN_PSWD_LEN'
GO
EXEC sp_addextendedproperty N'MS_Description', N'سیاست جلوگیری از ورود کامپیوتر های بلوک شده', 'SCHEMA', N'DataGuard', 'TABLE', N'Security_Managment', 'COLUMN', N'PLCY_COMP_BLOK'
GO
EXEC sp_addextendedproperty N'MS_Description', N'سیاست ورود امن از طریق سیستم های تعریف شده', 'SCHEMA', N'DataGuard', 'TABLE', N'Security_Managment', 'COLUMN', N'PLCY_FORC_SAFE_ENTR'
GO
EXEC sp_addextendedproperty N'MS_Description', N'سیاست فیلتر کردن آدرس فیزیکی کارت شبکه', 'SCHEMA', N'DataGuard', 'TABLE', N'Security_Managment', 'COLUMN', N'PLCY_MAC_ADDR_FLTR'
GO
EXEC sp_addextendedproperty N'MS_Description', N'سیاست استفاده از رمز های پیچیده', 'SCHEMA', N'DataGuard', 'TABLE', N'Security_Managment', 'COLUMN', N'PLCY_PSWD_CMPX'
GO
EXEC sp_addextendedproperty N'MS_Description', N'سیاست فعال کردن رمز عبور', 'SCHEMA', N'DataGuard', 'TABLE', N'Security_Managment', 'COLUMN', N'PLCY_SECR_PSWD'
GO
EXEC sp_addextendedproperty N'MS_Description', N'مدت زمان یادآوری برای رسیدگی به هشدار ورود غیرمجاز', 'SCHEMA', N'DataGuard', 'TABLE', N'Security_Managment', 'COLUMN', N'POST_PONE_UNAT'
GO
EXEC sp_addextendedproperty N'MS_Description', N'نگهداری تعداد رمز های عبور گذشته', 'SCHEMA', N'DataGuard', 'TABLE', N'Security_Managment', 'COLUMN', N'PSWD_HIST_NUMB'
GO
EXEC sp_addextendedproperty N'MS_Description', N'نمایش پیام هشدار برای ورود غیرمجاز', 'SCHEMA', N'DataGuard', 'TABLE', N'Security_Managment', 'COLUMN', N'SHOW_ALRM_UNAT'
GO
