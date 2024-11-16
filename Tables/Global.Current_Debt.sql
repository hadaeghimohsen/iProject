CREATE TABLE [Global].[Current_Debt]
(
[SUB_SYS] [int] NULL,
[FILE_NO] [int] NULL,
[CDID] [bigint] NOT NULL,
[RWNO] [int] NULL,
[NAME_DNRM] [nvarchar] (250) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CMNT] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[STAT] [varchar] (3) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[IN_CRED_DNRM] [bigint] NULL,
[OUT_CRED_DNRM] [bigint] NULL,
[REMN_CRED_DNRM] [bigint] NULL,
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
CREATE TRIGGER [Global].[CG$AINS_CDBT]
   ON  [Global].[Current_Debt]
   AFTER INSERT   
AS 
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

   -- Insert statements for trigger here
   MERGE Global.Current_Debt T
   USING (SELECT * FROM Inserted) S
   ON (T.SUB_SYS = S.SUB_SYS AND
       T.FILE_NO = S.FILE_NO AND 
       T.CDID = S.CDID)
   WHEN MATCHED THEN 
      UPDATE SET
         T.CRET_BY = UPPER(SUSER_NAME()),
         T.CRET_DATE = GETDATE(),
         T.CRET_HOST_BY = dbo.GET_HOST_U(),
         T.CDID = CASE S.CDID WHEN 0 THEN dbo.GNRT_NVID_U() ELSE s.CDID END;
   
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
CREATE TRIGGER [Global].[CG$AUPD_CDBT]
   ON  [Global].[Current_Debt]
   AFTER UPDATE   
AS 
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

   -- Insert statements for trigger here
   MERGE Global.Current_Debt T
   USING (SELECT * FROM Inserted) S
   ON (T.CDID = S.CDID)
   WHEN MATCHED THEN 
      UPDATE SET
         T.MDFY_BY = UPPER(SUSER_NAME()),
         T.MDFY_DATE = GETDATE(),
         T.MDFY_HOST_BY = dbo.GET_HOST_U();   
END
GO
ALTER TABLE [Global].[Current_Debt] ADD CONSTRAINT [PK__CDBT] PRIMARY KEY CLUSTERED  ([CDID]) ON [PRIMARY]
GO
CREATE UNIQUE NONCLUSTERED INDEX [Current_Debt_CDID] ON [Global].[Current_Debt] ([CDID]) ON [PRIMARY]
GO
ALTER TABLE [Global].[Current_Debt] ADD CONSTRAINT [FK_CDBT_SUBS] FOREIGN KEY ([SUB_SYS]) REFERENCES [DataGuard].[Sub_System] ([SUB_SYS])
GO
EXEC sp_addextendedproperty N'MS_Description', N'این جدول برای مشخص کردن لیست بدهکاران سازمان و میزان کل مبلغ بدهی انها می باشد
که توسط جدول های متفاوتی مشخص میکنیم که چه میزان بدهی و چه میزان از بدهی به چه حسابهایی واریز شده است', 'SCHEMA', N'Global', 'TABLE', N'Current_Debt', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'توضیحات', 'SCHEMA', N'Global', 'TABLE', N'Current_Debt', 'COLUMN', N'CMNT'
GO
EXEC sp_addextendedproperty N'MS_Description', N'شماره پرونده مشتری که نام ان درون سیستم ثبت شده', 'SCHEMA', N'Global', 'TABLE', N'Current_Debt', 'COLUMN', N'FILE_NO'
GO
EXEC sp_addextendedproperty N'MS_Description', N'بستانکاری ورودی کل حساب', 'SCHEMA', N'Global', 'TABLE', N'Current_Debt', 'COLUMN', N'IN_CRED_DNRM'
GO
EXEC sp_addextendedproperty N'MS_Description', N'نام صاحب بدهی و طلبکار مجموعه', 'SCHEMA', N'Global', 'TABLE', N'Current_Debt', 'COLUMN', N'NAME_DNRM'
GO
EXEC sp_addextendedproperty N'MS_Description', N'بستانکاری خروجی کل حساب', 'SCHEMA', N'Global', 'TABLE', N'Current_Debt', 'COLUMN', N'OUT_CRED_DNRM'
GO
EXEC sp_addextendedproperty N'MS_Description', N'ردیف و ترتیب قرار گیری پرداخت بدهی', 'SCHEMA', N'Global', 'TABLE', N'Current_Debt', 'COLUMN', N'RWNO'
GO
EXEC sp_addextendedproperty N'MS_Description', N'ایا حساب بستانکاری فعال / غیر فعال میباشد که بتوانیم تراکنش ها رو به حساب بستانکار هدایت کنیم', 'SCHEMA', N'Global', 'TABLE', N'Current_Debt', 'COLUMN', N'STAT'
GO
EXEC sp_addextendedproperty N'MS_Description', N'زیر سیستم به ما کمک میکند که این مبلغ بدهی و پرداختی ها به کدام زیر سیستم نرم افزار تعلق دارد', 'SCHEMA', N'Global', 'TABLE', N'Current_Debt', 'COLUMN', N'SUB_SYS'
GO
