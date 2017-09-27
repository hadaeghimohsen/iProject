CREATE TABLE [DataGuard].[Gateway]
(
[MAC_ADRS] [varchar] (17) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[CONF_DATE] [datetime] NULL,
[CONF_STAT] [varchar] (3) COLLATE SQL_Latin1_General_CP1_CI_AS NULL CONSTRAINT [DF_Gateway_CONF_STAT] DEFAULT ('001'),
[GWPB_RWNO_DNRM] [int] NULL,
[IP_DNRM] [varchar] (15) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[COMP_NAME_DNRM] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CPU_SRNO_DNRM] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[NAME_DNRM] [nvarchar] (1000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DFLT_FACT_DNRM] [varchar] (3) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[VALD_TYPE_DNRM] [varchar] (3) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AUTH_TYPE_DNRM] [varchar] (3) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PORT_DNRM] [int] NULL,
[RQST_JBQU_NUMB_DNRM] [int] NULL,
[RQST_SEND_DNRM] [varchar] (3) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[RQST_RCIV_DNRM] [varchar] (3) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[UPDT_NEW_SERV_PRVD_DNRM] [varchar] (3) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CYCL_GET_CACH_SERV_PRVD_DNRM] [int] NULL,
[UPDT_NEW_CLNT_PRVD_DNRM] [varchar] (3) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CYCL_SEND_INFO_PRVD_CLNT_DNRM] [int] NULL,
[CNTR_PART_DNRM] [int] NULL,
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
CREATE TRIGGER [DataGuard].[CG$AINS_GTWY]
   ON  [DataGuard].[Gateway]
   AFTER INSERT
AS 
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

   -- Insert statements for trigger here
   MERGE [DataGuard].[Gateway] T
   USING (SELECT * FROM INSERTED) S
   ON (T.MAC_ADRS = S.MAC_ADRS)
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
CREATE TRIGGER [DataGuard].[CG$AUPD_GTWY]
   ON  [DataGuard].[Gateway]
   AFTER UPDATE
AS 
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

   -- Insert statements for trigger here
   MERGE [DataGuard].[Gateway] T
   USING (SELECT * FROM INSERTED) S
   ON (T.MAC_ADRS = S.MAC_ADRS)
   WHEN MATCHED THEN
      UPDATE
         SET MDFY_BY        = UPPER(SUSER_NAME())
            ,MDFY_DATE      = GETDATE()
            ,CONF_DATE      = CASE WHEN T.CONF_STAT = '002' AND S.CONF_STAT = '002' THEN GETDATE() WHEN T.CONF_STAT = '001' AND S.CONF_STAT = '001' THEN NULL END;

END
;
GO
ALTER TABLE [DataGuard].[Gateway] ADD CONSTRAINT [PK_Gateway_1] PRIMARY KEY CLUSTERED  ([MAC_ADRS]) ON [PRIMARY]
GO
EXEC sp_addextendedproperty N'MS_Description', N'میزان حجم استفاده کردن از منابع سیستم', 'SCHEMA', N'DataGuard', 'TABLE', N'Gateway', 'COLUMN', N'CNTR_PART_DNRM'
GO
EXEC sp_addextendedproperty N'MS_Description', N'وضعیت کامپیوتر', 'SCHEMA', N'DataGuard', 'TABLE', N'Gateway', 'COLUMN', N'CONF_DATE'
GO
EXEC sp_addextendedproperty N'MS_Description', N'مدت زمان دوره چک کردن سرویس دهنده های جدید', 'SCHEMA', N'DataGuard', 'TABLE', N'Gateway', 'COLUMN', N'CYCL_GET_CACH_SERV_PRVD_DNRM'
GO
EXEC sp_addextendedproperty N'MS_Description', N'مدت زمان دوره ارسال پیام به عنوان سرویس دهنده به دیگر سیستم های مشتری', 'SCHEMA', N'DataGuard', 'TABLE', N'Gateway', 'COLUMN', N'CYCL_SEND_INFO_PRVD_CLNT_DNRM'
GO
EXEC sp_addextendedproperty N'MS_Description', N'کامپیوتر رزروی خود شرکت با بالاترین سطح دسترسی', 'SCHEMA', N'DataGuard', 'TABLE', N'Gateway', 'COLUMN', N'DFLT_FACT_DNRM'
GO
EXEC sp_addextendedproperty N'MS_Description', N'تعداد صف درخواست', 'SCHEMA', N'DataGuard', 'TABLE', N'Gateway', 'COLUMN', N'RQST_JBQU_NUMB_DNRM'
GO
EXEC sp_addextendedproperty N'MS_Description', N'اجازه دریافت پیام از خارج به داخل', 'SCHEMA', N'DataGuard', 'TABLE', N'Gateway', 'COLUMN', N'RQST_RCIV_DNRM'
GO
EXEC sp_addextendedproperty N'MS_Description', N'اجازه ارسال پیام به خارج', 'SCHEMA', N'DataGuard', 'TABLE', N'Gateway', 'COLUMN', N'RQST_SEND_DNRM'
GO
EXEC sp_addextendedproperty N'MS_Description', N'بروز کردن لیست سرویس دهنده های جدید', 'SCHEMA', N'DataGuard', 'TABLE', N'Gateway', 'COLUMN', N'UPDT_NEW_SERV_PRVD_DNRM'
GO
EXEC sp_addextendedproperty N'MS_Description', N'آیا معتبر می باشد', 'SCHEMA', N'DataGuard', 'TABLE', N'Gateway', 'COLUMN', N'VALD_TYPE_DNRM'
GO
