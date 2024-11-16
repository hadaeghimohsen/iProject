CREATE TABLE [Global].[Current_Debt_Detail]
(
[CDBT_CDID] [bigint] NOT NULL,
[CODE] [bigint] NOT NULL,
[AMNT] [bigint] NULL,
[AMNT_DATE] [datetime] NULL,
[AMNT_TYPE_APBS_CODE] [bigint] NULL,
[CMNT] [nvarchar] (1000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
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
CREATE TRIGGER [Global].[CG$AINS_CDBD]
   ON  [Global].[Current_Debt_Detail]
   AFTER INSERT
AS 
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

   -- Insert statements for trigger here
   MERGE Global.Current_Debt_Detail T
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
CREATE TRIGGER [Global].[CG$AUPD_CDBD]
   ON  [Global].[Current_Debt_Detail]
   AFTER UPDATE
AS 
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

   -- Insert statements for trigger here
   MERGE Global.Current_Debt_Detail T
   USING (SELECT * FROM Inserted) S
   ON (T.CODE = S.CODE)
   WHEN MATCHED THEN 
      UPDATE SET
         T.MDFY_BY = UPPER(SUSER_NAME()),
         T.MDFY_DATE = GETDATE(),
         T.MDFY_HOST_BY = dbo.GET_HOST_U();
END
GO
ALTER TABLE [Global].[Current_Debt_Detail] ADD CONSTRAINT [PK_CDBD] PRIMARY KEY CLUSTERED  ([CODE]) ON [PRIMARY]
GO
CREATE UNIQUE NONCLUSTERED INDEX [Current_Debt_Detail_CODE] ON [Global].[Current_Debt_Detail] ([CODE]) ON [PRIMARY]
GO
ALTER TABLE [Global].[Current_Debt_Detail] ADD CONSTRAINT [FK_CDBT_CDBD] FOREIGN KEY ([CDBT_CDID]) REFERENCES [Global].[Current_Debt] ([CDID]) ON DELETE CASCADE
GO
EXEC sp_addextendedproperty N'MS_Description', N'این جدول میزان مبلغ های بدهی مختلف در زمان های مختلف هست که باید به طلبکار پرداخت شود', 'SCHEMA', N'Global', 'TABLE', N'Current_Debt_Detail', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'مبلغ بدهی', 'SCHEMA', N'Global', 'TABLE', N'Current_Debt_Detail', 'COLUMN', N'AMNT'
GO
EXEC sp_addextendedproperty N'MS_Description', N'تاریخ بدهی', 'SCHEMA', N'Global', 'TABLE', N'Current_Debt_Detail', 'COLUMN', N'AMNT_DATE'
GO
EXEC sp_addextendedproperty N'MS_Description', N'نوع مبلغ بدهی', 'SCHEMA', N'Global', 'TABLE', N'Current_Debt_Detail', 'COLUMN', N'AMNT_TYPE_APBS_CODE'
GO
EXEC sp_addextendedproperty N'MS_Description', N'توضیحات', 'SCHEMA', N'Global', 'TABLE', N'Current_Debt_Detail', 'COLUMN', N'CMNT'
GO
EXEC sp_addextendedproperty N'MS_Description', N'اگر مبلغ بستانکاری تسویه حساب شد باید از این فیلد مشخص شود', 'SCHEMA', N'Global', 'TABLE', N'Current_Debt_Detail', 'COLUMN', N'FILL_STAT'
GO
