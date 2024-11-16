CREATE TABLE [Global].[Payment_Plan_Detail]
(
[CDBD_CODE] [bigint] NOT NULL,
[PPLN_CODE] [bigint] NOT NULL,
[CODE] [bigint] NOT NULL,
[ACTN_DATE] [datetime] NULL,
[AMNT] [bigint] NULL,
[FILL_AMNT_DNRM] [bigint] NULL,
[WAIT_AMNT_DNRM] [bigint] NULL,
[REMN_AMNT_DNRM] [bigint] NULL,
[FILL_STAT] [varchar] (3) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CRET_BY] [varchar] (250) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CRET_HOST_BY] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CRET_DATE] [datetime] NULL,
[MDFY_BY] [varchar] (250) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[MDFY_DATE] [datetime] NULL,
[MDFY_HOST_BY] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
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
CREATE TRIGGER [Global].[CG$AINS_PPLD]
   ON  [Global].[Payment_Plan_Detail]
   AFTER INSERT
AS 
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

   -- Insert statements for trigger here
   MERGE Global.Payment_Plan_Detail T
   USING (SELECT * FROM Inserted) S
   ON (T.PPLN_CODE = S.PPLN_CODE AND
       T.CDBD_CODE = S.CDBD_CODE AND
       T.CODE = S.CODE)
   WHEN MATCHED THEN 
      UPDATE SET
         T.MDFY_BY = UPPER(SUSER_NAME()),
         T.MDFY_DATE = GETDATE(),
         T.MDFY_HOST_BY = dbo.GET_HOST_U();
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
CREATE TRIGGER [Global].[CG$AUPD_PPLD]
   ON  [Global].[Payment_Plan_Detail]
   AFTER UPDATE
AS 
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

   -- Insert statements for trigger here
   MERGE Global.Payment_Plan_Detail T
   USING (SELECT * FROM Inserted) S
   ON (T.CODE = S.CODE)
   WHEN MATCHED THEN 
      UPDATE SET
         T.MDFY_BY = UPPER(SUSER_NAME()),
         T.MDFY_DATE = GETDATE(),
         T.MDFY_HOST_BY = dbo.GET_HOST_U();
END
GO
ALTER TABLE [Global].[Payment_Plan_Detail] ADD CONSTRAINT [PK_PPLD] PRIMARY KEY CLUSTERED  ([CODE]) ON [PRIMARY]
GO
CREATE UNIQUE NONCLUSTERED INDEX [Payment_Plan_Detail_CODE] ON [Global].[Payment_Plan_Detail] ([CODE]) ON [PRIMARY]
GO
ALTER TABLE [Global].[Payment_Plan_Detail] ADD CONSTRAINT [FK_PPLD_CDBD] FOREIGN KEY ([CDBD_CODE]) REFERENCES [Global].[Current_Debt_Detail] ([CODE])
GO
ALTER TABLE [Global].[Payment_Plan_Detail] ADD CONSTRAINT [FK_PPLD_PPLN] FOREIGN KEY ([PPLN_CODE]) REFERENCES [Global].[Payment_Plan] ([CODE])
GO
EXEC sp_addextendedproperty N'MS_Description', N'این جدول برای ذخیره کردن مبلغ های مختلف به حساب های مختلف میباشد
فرض کنید حقوق یه مربی 10 میلیون میشود و از صاحب خود این درخواست را میکند که مبلغ 5 میلیون به فلان حساب و
مبلغ مابقی به حساب دیگر واریز شود', 'SCHEMA', N'Global', 'TABLE', N'Payment_Plan_Detail', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'تاریخ پرداخت وصولی های مورد طلب مشتری به حساب تعریف شده', 'SCHEMA', N'Global', 'TABLE', N'Payment_Plan_Detail', 'COLUMN', N'ACTN_DATE'
GO
EXEC sp_addextendedproperty N'MS_Description', N'مبلغی که درخواست شده که واریز شود', 'SCHEMA', N'Global', 'TABLE', N'Payment_Plan_Detail', 'COLUMN', N'AMNT'
GO
EXEC sp_addextendedproperty N'MS_Description', N'چه میزان از مبلغ کل پر شده

IF AMNT == FILL_AMNT_DNRM THEN PYMT_STAT = ''002''
ELSE PYMT_STAT = ''001''', 'SCHEMA', N'Global', 'TABLE', N'Payment_Plan_Detail', 'COLUMN', N'FILL_AMNT_DNRM'
GO
EXEC sp_addextendedproperty N'MS_Description', N'وضعیت تسویه پرداخت حساب
که اگر حساب تسویه شده باشد فیلد مورد نظر تغییر وضعیت داده و دیگر به این رکورد کاری نداریم

IF AMNT == FILL_AMNT_DNRM THEN FILL_STAT = ''002''
ELSE FILL_STAT = ''001''', 'SCHEMA', N'Global', 'TABLE', N'Payment_Plan_Detail', 'COLUMN', N'FILL_STAT'
GO
EXEC sp_addextendedproperty N'MS_Description', N'میزان مبلغ مانده از طلب', 'SCHEMA', N'Global', 'TABLE', N'Payment_Plan_Detail', 'COLUMN', N'REMN_AMNT_DNRM'
GO
EXEC sp_addextendedproperty N'MS_Description', N'میزان مبلغ در حال انتظار برای پرداخت شن', 'SCHEMA', N'Global', 'TABLE', N'Payment_Plan_Detail', 'COLUMN', N'WAIT_AMNT_DNRM'
GO
