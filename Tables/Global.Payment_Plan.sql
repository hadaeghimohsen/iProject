CREATE TABLE [Global].[Payment_Plan]
(
[CDBT_CDID] [bigint] NOT NULL,
[CODE] [bigint] NOT NULL,
[RWNO] [int] NULL,
[CARD_NUMB] [varchar] (16) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SHBA_NUMB] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CARD_NUMB_DNRM] [varchar] (19) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SHBA_NUMB_DNRM] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[BANK_NAME] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ACNT_OWNR] [nvarchar] (250) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CMNT] [nvarchar] (1000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[REMN_AMNT_DNRM] [bigint] NULL,
[DFLT_STAT] [varchar] (3) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
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
CREATE TRIGGER [Global].[CG$AINS_PPLN]
   ON  [Global].[Payment_Plan]
   AFTER INSERT
AS 
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

   -- Insert statements for trigger here
   MERGE Global.Payment_Plan T
   USING (SELECT * FROM Inserted) S
   ON (T.CDBT_CDID = S.CDBT_CDID AND 
       T.CODE = S.CODE)
   WHEN MATCHED THEN 
      UPDATE SET
         T.CRET_BY = UPPER(SUSER_NAME()),
         T.CRET_DATE = GETDATE(),
         T.CRET_HOST_BY = dbo.GET_HOST_U(),
         T.CODE = CASE s.CODE WHEN 0 THEN dbo.GNRT_NVID_U() ELSE s.CODE END;
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
CREATE TRIGGER [Global].[CG$AUPD_PPLN]
   ON  [Global].[Payment_Plan]
   AFTER UPDATE
AS 
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

   -- Insert statements for trigger here
   MERGE Global.Payment_Plan T
   USING (SELECT * FROM Inserted) S
   ON (T.CODE = S.CODE)
   WHEN MATCHED THEN 
      UPDATE SET
         T.MDFY_BY = UPPER(SUSER_NAME()),
         T.MDFY_DATE = GETDATE(),
         T.MDFY_HOST_BY = dbo.GET_HOST_U();
END
GO
ALTER TABLE [Global].[Payment_Plan] ADD CONSTRAINT [PK_PPLN] PRIMARY KEY CLUSTERED  ([CODE]) ON [PRIMARY]
GO
CREATE UNIQUE NONCLUSTERED INDEX [Payment_Plan_CODE] ON [Global].[Payment_Plan] ([CODE]) ON [PRIMARY]
GO
ALTER TABLE [Global].[Payment_Plan] ADD CONSTRAINT [FK_CDBT_PPLN] FOREIGN KEY ([CDBT_CDID]) REFERENCES [Global].[Current_Debt] ([CDID]) ON DELETE CASCADE
GO
EXEC sp_addextendedproperty N'MS_Description', N'شماره حساب هایی که طلبکاران وارد میکنند و پول به حساب انها واریز میشود', 'SCHEMA', N'Global', 'TABLE', N'Payment_Plan', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'تعریف حساب پیش فرض', 'SCHEMA', N'Global', 'TABLE', N'Payment_Plan', 'COLUMN', N'DFLT_STAT'
GO
EXEC sp_addextendedproperty N'MS_Description', N'مانده مبلغ حساب بستانکاری', 'SCHEMA', N'Global', 'TABLE', N'Payment_Plan', 'COLUMN', N'REMN_AMNT_DNRM'
GO
EXEC sp_addextendedproperty N'MS_Description', N'ردیف و ترتیب قرار گیری حساب پرداخت بدهی مشتری', 'SCHEMA', N'Global', 'TABLE', N'Payment_Plan', 'COLUMN', N'RWNO'
GO
