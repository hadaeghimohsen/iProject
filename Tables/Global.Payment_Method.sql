CREATE TABLE [Global].[Payment_Method]
(
[CDBD_CODE] [bigint] NOT NULL,
[CDBT_CDID] [bigint] NOT NULL,
[PPLD_CODE] [bigint] NOT NULL,
[CODE] [bigint] NOT NULL,
[AMNT] [bigint] NULL,
[AMNT_DATE] [datetime] NULL,
[PAY_STAT] [varchar] (3) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[TRAN_TLID] [bigint] NULL,
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
CREATE TRIGGER [Global].[CG$AINS_PMMT]
   ON  [Global].[Payment_Method]
   AFTER INSERT
AS 
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

   -- Insert statements for trigger here
   MERGE Global.Payment_Method T
   USING (SELECT * FROM Inserted) S
   ON (T.CDBT_CDID = S.CDBT_CDID AND 
       T.PPLD_CODE = S.PPLD_CODE AND 
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
CREATE TRIGGER [Global].[CG$AUPD_PMMT]
   ON  [Global].[Payment_Method]
   AFTER UPDATE   
AS 
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

   -- Insert statements for trigger here
   MERGE Global.Payment_Method T
   USING (SELECT * FROM Inserted) S
   ON  (T.CODE = S.CODE)
   WHEN MATCHED THEN 
      UPDATE SET
         T.MDFY_BY = UPPER(SUSER_NAME()),
         T.MDFY_DATE = GETDATE(),
         T.MDFY_HOST_BY = dbo.GET_HOST_U();         
END
GO
ALTER TABLE [Global].[Payment_Method] ADD CONSTRAINT [PK_PMMT] PRIMARY KEY CLUSTERED  ([CODE]) ON [PRIMARY]
GO
CREATE UNIQUE NONCLUSTERED INDEX [Payment_Method_CODE] ON [Global].[Payment_Method] ([CODE]) ON [PRIMARY]
GO
ALTER TABLE [Global].[Payment_Method] ADD CONSTRAINT [FK_CDBD_PMMT] FOREIGN KEY ([CDBD_CODE]) REFERENCES [Global].[Current_Debt_Detail] ([CODE])
GO
ALTER TABLE [Global].[Payment_Method] ADD CONSTRAINT [FK_PMMT_CDBT] FOREIGN KEY ([CDBT_CDID]) REFERENCES [Global].[Current_Debt] ([CDID]) ON DELETE CASCADE
GO
ALTER TABLE [Global].[Payment_Method] ADD CONSTRAINT [FK_PMMT_PPLD] FOREIGN KEY ([PPLD_CODE]) REFERENCES [Global].[Payment_Plan_Detail] ([CODE]) ON DELETE CASCADE
GO
ALTER TABLE [Global].[Payment_Method] ADD CONSTRAINT [FK_PMMT_TRAN] FOREIGN KEY ([TRAN_TLID]) REFERENCES [Global].[Transaction_Log] ([TLID])
GO
