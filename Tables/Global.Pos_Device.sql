CREATE TABLE [Global].[Pos_Device]
(
[PSID] [bigint] NOT NULL,
[BANK_TYPE] [varchar] (3) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[BNKB_CODE] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[BNKA_ACNT_NUMB] [varchar] (15) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[SHBA_CODE] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[POS_DESC] [nvarchar] (250) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[POS_STAT] [varchar] (3) COLLATE SQL_Latin1_General_CP1_CI_AS NULL CONSTRAINT [DF_Pos_Subsystem_POS_STAT] DEFAULT ('002'),
[POS_DFLT] [varchar] (3) COLLATE SQL_Latin1_General_CP1_CI_AS NULL CONSTRAINT [DF_Pos_Subsystem_POS_DFLT] DEFAULT ('001'),
[SEND_AMNT_EDIT] [varchar] (3) COLLATE SQL_Latin1_General_CP1_CI_AS NULL CONSTRAINT [DF_Pos_Subsystem_SEND_AMNT_EDIT] DEFAULT ('002'),
[SEND_DATA_ON_DEVC] [varchar] (3) COLLATE SQL_Latin1_General_CP1_CI_AS NULL CONSTRAINT [DF_Pos_Subsystem_SEND_DATA_ON_DEVC] DEFAULT ('001'),
[FILL_RSLT_DATA] [varchar] (3) COLLATE SQL_Latin1_General_CP1_CI_AS NULL CONSTRAINT [DF_Pos_Subsystem_FILL_RSLT_DATA] DEFAULT ('001'),
[POS_CNCT_TYPE] [varchar] (3) COLLATE SQL_Latin1_General_CP1_CI_AS NULL CONSTRAINT [DF_Pos_Subsystem_POS_CNCT_TYPE] DEFAULT ('000'),
[IP_ADRS] [varchar] (15) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[COMM_PORT] [varchar] (15) COLLATE SQL_Latin1_General_CP1_CI_AS NULL CONSTRAINT [DF_Pos_Subsystem_COMM_PORT] DEFAULT ('COM1'),
[BAND_RATE] [int] NULL CONSTRAINT [DF_Pos_Subsystem_BAND_RATE] DEFAULT ((9600)),
[PRNT_SALE] [nvarchar] (250) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PRNT_CUST] [nvarchar] (250) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AUTO_COMM] [varchar] (3) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[GTWY_MAC_ADRS] [varchar] (17) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CRET_BY] [varchar] (250) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CRET_DATE] [date] NULL,
[MDFY_BY] [varchar] (250) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[MDFY_DATE] [date] NULL
) ON [BLOB]
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
CREATE TRIGGER [Global].[CG$AINS_POS]
   ON  [Global].[Pos_Device]
   AFTER INSERT
AS 
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

   MERGE Global.Pos_Device T
   USING (SELECT * FROM Inserted) S
   ON (T.PSID = S.PSID)
   WHEN MATCHED THEN
      UPDATE SET
         T.CRET_BY = UPPER(SUSER_NAME())
        ,T.CRET_DATE = GETDATE()
        ,T.PSID = dbo.GetNewIdentity();

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
CREATE TRIGGER [Global].[CG$AUPD_POS]
   ON  [Global].[Pos_Device]
   AFTER UPDATE
AS 
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

   MERGE Global.Pos_Device T
   USING (SELECT * FROM Inserted) S
   ON (T.PSID = S.PSID)
   WHEN MATCHED THEN
      UPDATE SET
         T.MDFY_BY = UPPER(SUSER_NAME())
        ,T.MDFY_DATE = GETDATE();
END
GO
ALTER TABLE [Global].[Pos_Device] ADD CONSTRAINT [PK_POS] PRIMARY KEY CLUSTERED  ([PSID]) ON [BLOB]
GO
EXEC sp_addextendedproperty N'MS_Description', N'اجرای اتوماتیک', 'SCHEMA', N'Global', 'TABLE', N'Pos_Device', 'COLUMN', N'AUTO_COMM'
GO
EXEC sp_addextendedproperty N'MS_Description', N'میزان باند ', 'SCHEMA', N'Global', 'TABLE', N'Pos_Device', 'COLUMN', N'BAND_RATE'
GO
EXEC sp_addextendedproperty N'MS_Description', N'پورت سریال', 'SCHEMA', N'Global', 'TABLE', N'Pos_Device', 'COLUMN', N'COMM_PORT'
GO
EXEC sp_addextendedproperty N'MS_Description', N'اطلاعات دریافتی در مورد پرداخت هزینه از دستگاه ذخیره گردد', 'SCHEMA', N'Global', 'TABLE', N'Pos_Device', 'COLUMN', N'FILL_RSLT_DATA'
GO
EXEC sp_addextendedproperty N'MS_Description', N'سیستم متصل به دستگاه POS', 'SCHEMA', N'Global', 'TABLE', N'Pos_Device', 'COLUMN', N'GTWY_MAC_ADRS'
GO
EXEC sp_addextendedproperty N'MS_Description', N'IP', 'SCHEMA', N'Global', 'TABLE', N'Pos_Device', 'COLUMN', N'IP_ADRS'
GO
EXEC sp_addextendedproperty N'MS_Description', N'روش اتصال به دستگاه', 'SCHEMA', N'Global', 'TABLE', N'Pos_Device', 'COLUMN', N'POS_CNCT_TYPE'
GO
EXEC sp_addextendedproperty N'MS_Description', N'دستگاه پیش فرض', 'SCHEMA', N'Global', 'TABLE', N'Pos_Device', 'COLUMN', N'POS_DFLT'
GO
EXEC sp_addextendedproperty N'MS_Description', N'وضعیت فعال بودن دستگاه', 'SCHEMA', N'Global', 'TABLE', N'Pos_Device', 'COLUMN', N'POS_STAT'
GO
EXEC sp_addextendedproperty N'MS_Description', N'آیا مبلغ ارسالی قابل ویرایش می باشد', 'SCHEMA', N'Global', 'TABLE', N'Pos_Device', 'COLUMN', N'SEND_AMNT_EDIT'
GO
EXEC sp_addextendedproperty N'MS_Description', N'داده ها به روی دستگاه ارسال شود', 'SCHEMA', N'Global', 'TABLE', N'Pos_Device', 'COLUMN', N'SEND_DATA_ON_DEVC'
GO
