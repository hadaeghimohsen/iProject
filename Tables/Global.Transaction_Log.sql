CREATE TABLE [Global].[Transaction_Log]
(
[POSD_PSID] [bigint] NULL,
[SUB_SYS] [int] NULL,
[GTWY_MAC_ADRS] [varchar] (17) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[RQID] [bigint] NULL,
[RQTP_CODE] [varchar] (3) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[RWNO] [int] NULL,
[TLID] [bigint] NOT NULL,
[TRAN_DATE] [datetime] NULL,
[AMNT] [bigint] NULL,
[PAY_STAT] [varchar] (3) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ISSU_DATE] [datetime] NULL,
[RESP_CODE] [varchar] (3) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[RESP_DESC] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[TERM_NO] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[TRAN_NO] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CARD_NO] [varchar] (16) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[FLOW_NO] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[REF_NO] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SERL_NO] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CRET_BY] [varchar] (250) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CRET_DATE] [datetime] NULL,
[MDFY_BY] [varchar] (250) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[MDFY_DATE] [datetime] NULL
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
CREATE TRIGGER [Global].[CG$AINS_TRAN]
   ON  [Global].[Transaction_Log]
   AFTER INSERT   
AS 
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

   -- Insert statements for trigger here
   MERGE Global.Transaction_Log T
   USING (SELECT * FROM Inserted) S
   ON (T.POSD_PSID = S.POSD_PSID AND
       T.SUB_SYS = S.SUB_SYS AND
       T.TLID = S.TLID)
   WHEN MATCHED THEN
      UPDATE SET
         t.CRET_BY = UPPER(SUSER_NAME())
        ,t.CRET_DATE = GETDATE()
        ,t.RWNO = (SELECT ISNULL(MAX(RWNO), 0) + 1 FROM Global.Transaction_Log TL WHERE S.POSD_PSID = Tl.POSD_PSID AND CAST(S.TRAN_DATE AS DATE) = CAST(TL.TRAN_DATE AS DATE))
        ,t.TLID = dbo.GetNewIdentity();

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
CREATE TRIGGER [Global].[CG$AUPD_TRAN]
   ON  [Global].[Transaction_Log]
   AFTER UPDATE
AS 
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

   -- Insert statements for trigger here
   MERGE Global.Transaction_Log T
   USING (SELECT * FROM Inserted) S
   ON (T.POSD_PSID = S.POSD_PSID AND 
       T.TLID = S.TLID)
   WHEN MATCHED THEN
      UPDATE SET
         t.MDFY_BY = UPPER(SUSER_NAME())
        ,t.MDFY_DATE = GETDATE();
END
GO
ALTER TABLE [Global].[Transaction_Log] ADD CONSTRAINT [PK_TRAN] PRIMARY KEY CLUSTERED  ([TLID]) ON [BLOB]
GO
ALTER TABLE [Global].[Transaction_Log] ADD CONSTRAINT [FK_TRAN_GTWY] FOREIGN KEY ([GTWY_MAC_ADRS]) REFERENCES [DataGuard].[Gateway] ([MAC_ADRS])
GO
ALTER TABLE [Global].[Transaction_Log] ADD CONSTRAINT [FK_TRAN_POSD] FOREIGN KEY ([POSD_PSID]) REFERENCES [Global].[Pos_Device] ([PSID])
GO
ALTER TABLE [Global].[Transaction_Log] ADD CONSTRAINT [FK_TRAN_SUBS] FOREIGN KEY ([SUB_SYS]) REFERENCES [DataGuard].[Sub_System] ([SUB_SYS])
GO
EXEC sp_addextendedproperty N'MS_Description', N'مبلغ', 'SCHEMA', N'Global', 'TABLE', N'Transaction_Log', 'COLUMN', N'AMNT'
GO
EXEC sp_addextendedproperty N'MS_Description', N'شماره کارت', 'SCHEMA', N'Global', 'TABLE', N'Transaction_Log', 'COLUMN', N'CARD_NO'
GO
EXEC sp_addextendedproperty N'MS_Description', N'شماره پیگیری', 'SCHEMA', N'Global', 'TABLE', N'Transaction_Log', 'COLUMN', N'FLOW_NO'
GO
EXEC sp_addextendedproperty N'MS_Description', N'تاریخ پرداخت بانک', 'SCHEMA', N'Global', 'TABLE', N'Transaction_Log', 'COLUMN', N'ISSU_DATE'
GO
EXEC sp_addextendedproperty N'MS_Description', N'وضعیت پرداخت', 'SCHEMA', N'Global', 'TABLE', N'Transaction_Log', 'COLUMN', N'PAY_STAT'
GO
EXEC sp_addextendedproperty N'MS_Description', N'شماره ارجاع', 'SCHEMA', N'Global', 'TABLE', N'Transaction_Log', 'COLUMN', N'REF_NO'
GO
EXEC sp_addextendedproperty N'MS_Description', N'کد دستگاه پوز', 'SCHEMA', N'Global', 'TABLE', N'Transaction_Log', 'COLUMN', N'RESP_CODE'
GO
EXEC sp_addextendedproperty N'MS_Description', N'سریال دستگاه پوز', 'SCHEMA', N'Global', 'TABLE', N'Transaction_Log', 'COLUMN', N'SERL_NO'
GO
EXEC sp_addextendedproperty N'MS_Description', N'شماره ترمینال', 'SCHEMA', N'Global', 'TABLE', N'Transaction_Log', 'COLUMN', N'TERM_NO'
GO
EXEC sp_addextendedproperty N'MS_Description', N'تاریخ تراکنش', 'SCHEMA', N'Global', 'TABLE', N'Transaction_Log', 'COLUMN', N'TRAN_DATE'
GO
EXEC sp_addextendedproperty N'MS_Description', N'شماره تراکنش', 'SCHEMA', N'Global', 'TABLE', N'Transaction_Log', 'COLUMN', N'TRAN_NO'
GO
