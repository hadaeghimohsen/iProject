CREATE TABLE [DataGuard].[Sub_System]
(
[SUB_SYS] [int] NOT NULL,
[DESC] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SCHM_NAME] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[STAT] [varchar] (3) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[INST_STAT] [varchar] (3) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[INST_DATE] [datetime] NULL,
[DLL_NAME] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CAN_UN_INST] [varchar] (3) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DFLT_APP_STRT_STAT] [varchar] (3) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[LICN_TYPE] [varchar] (3) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[LICN_TRIL_DATE] [datetime] NULL,
[CLNT_LICN_DESC] [nvarchar] (4000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SRVR_LICN_DESC] [nvarchar] (4000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[INST_LICN_DESC] [nvarchar] (4000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[VERS_NO] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DB_NAME] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SUB_DESC] [nvarchar] (500) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SUPR_EMAL] [varchar] (250) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[JOBS_STAT] [varchar] (3) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[FREQ_INTR] [int] NULL,
[BACK_UP_STAT] [varchar] (3) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[BACK_UP_APP_EXIT] [varchar] (3) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[BACK_UP_PATH_ADRS] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[UPLD_FILE_PATH_ADRS] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SUPR_YEAR_PRIC] [bigint] NULL,
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
CREATE TRIGGER [DataGuard].[VG$AINS_SUBS]
   ON  [DataGuard].[Sub_System]
   AFTER INSERT
AS 
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for trigger here
   MERGE DataGuard.Sub_System T
   USING (SELECT * FROM inserted) S
   ON (T.SUB_SYS = S.SUB_SYS)
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
CREATE TRIGGER [DataGuard].[VG$AUPD_SUBS]
   ON  [DataGuard].[Sub_System]
   AFTER UPDATE 
AS 
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for trigger here
   MERGE DataGuard.Sub_System T
   USING (SELECT * FROM inserted) S
   ON (T.SUB_SYS = S.SUB_SYS)
   WHEN MATCHED THEN
      UPDATE SET
         T.MDFY_BY = UPPER(SUSER_NAME())
        ,T.MDFY_DATE = GETDATE();
   
   
END
GO
ALTER TABLE [DataGuard].[Sub_System] ADD CONSTRAINT [PK_SUBS] PRIMARY KEY CLUSTERED  ([SUB_SYS]) ON [PRIMARY]
GO
EXEC sp_addextendedproperty N'MS_Description', N'آیا قادر به حذف نرم افزار هستیم', 'SCHEMA', N'DataGuard', 'TABLE', N'Sub_System', 'COLUMN', N'CAN_UN_INST'
GO
EXEC sp_addextendedproperty N'MS_Description', N'نام پایگاه داده', 'SCHEMA', N'DataGuard', 'TABLE', N'Sub_System', 'COLUMN', N'DB_NAME'
GO
EXEC sp_addextendedproperty N'MS_Description', N'نرم افزار های کاربردی کاربران برای ورود پیش فرض', 'SCHEMA', N'DataGuard', 'TABLE', N'Sub_System', 'COLUMN', N'DFLT_APP_STRT_STAT'
GO
EXEC sp_addextendedproperty N'MS_Description', N'نام فایل برنامه', 'SCHEMA', N'DataGuard', 'TABLE', N'Sub_System', 'COLUMN', N'DLL_NAME'
GO
EXEC sp_addextendedproperty N'MS_Description', N'مدت زمان دوره اجرای زمان بندی شده', 'SCHEMA', N'DataGuard', 'TABLE', N'Sub_System', 'COLUMN', N'FREQ_INTR'
GO
EXEC sp_addextendedproperty N'MS_Description', N'زمان نصب', 'SCHEMA', N'DataGuard', 'TABLE', N'Sub_System', 'COLUMN', N'INST_DATE'
GO
EXEC sp_addextendedproperty N'MS_Description', N'آیا نرم افزار نصب شده', 'SCHEMA', N'DataGuard', 'TABLE', N'Sub_System', 'COLUMN', N'INST_STAT'
GO
EXEC sp_addextendedproperty N'MS_Description', N'وضعیت اجراهای زمان بندی', 'SCHEMA', N'DataGuard', 'TABLE', N'Sub_System', 'COLUMN', N'JOBS_STAT'
GO
EXEC sp_addextendedproperty N'MS_Description', N'تاریخ پایان لایسنس', 'SCHEMA', N'DataGuard', 'TABLE', N'Sub_System', 'COLUMN', N'LICN_TRIL_DATE'
GO
EXEC sp_addextendedproperty N'MS_Description', N'نوع لایسنس خریداری شده', 'SCHEMA', N'DataGuard', 'TABLE', N'Sub_System', 'COLUMN', N'LICN_TYPE'
GO
EXEC sp_addextendedproperty N'MS_Description', N'وضعیت قابل نمایش رکورد', 'SCHEMA', N'DataGuard', 'TABLE', N'Sub_System', 'COLUMN', N'STAT'
GO
EXEC sp_addextendedproperty N'MS_Description', N'متن اولیه فرم ورود به سیستم', 'SCHEMA', N'DataGuard', 'TABLE', N'Sub_System', 'COLUMN', N'SUB_DESC'
GO
EXEC sp_addextendedproperty N'MS_Description', N'مبلغ سالیانه پشتیبانی', 'SCHEMA', N'DataGuard', 'TABLE', N'Sub_System', 'COLUMN', N'SUPR_YEAR_PRIC'
GO
EXEC sp_addextendedproperty N'MS_Description', N'شماره نسخه نرم افزاری', 'SCHEMA', N'DataGuard', 'TABLE', N'Sub_System', 'COLUMN', N'VERS_NO'
GO
