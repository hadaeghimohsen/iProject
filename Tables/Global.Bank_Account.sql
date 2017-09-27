CREATE TABLE [Global].[Bank_Account]
(
[BNKB_BANK_CODE] [varchar] (2) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[BNKB_CODE] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[ACNT_NUMB] [varchar] (15) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[ACNT_NAME] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[ACNT_TYPE] [varchar] (2) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[OWNR_TYPE] [varchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[SHBA_ACNT] [varchar] (26) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CRET_BY] [varchar] (250) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[CRET_DATE] [datetime] NOT NULL,
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
CREATE TRIGGER [Global].[CG$AINS_BKAC]
   ON  [Global].[Bank_Account]
   AFTER INSERT   
AS 
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for trigger here
   MERGE Global.Bank_Account T
   USING (SELECT * FROM Inserted) S
   ON (t.BNKB_BANK_CODE = s.BNKB_BANK_CODE AND
       t.BNKB_CODE = s.BNKB_CODE AND
       t.ACNT_NUMB = s.ACNT_NUMB)
   WHEN MATCHED THEN
      UPDATE SET
         t.CRET_BY = UPPER(SUSER_NAME())
        ,t.CRET_DATE = GETDATE()
        ,t.ACNT_NUMB = dbo.PADSTR(s.ACNT_NUMB, 15);
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
CREATE TRIGGER [Global].[CG$AUPD_BKAC]
   ON  [Global].[Bank_Account]
   AFTER update
AS 
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for trigger here
   MERGE Global.Bank_Account T
   USING (SELECT * FROM Inserted) S
   ON (t.BNKB_BANK_CODE = s.BNKB_BANK_CODE AND
       t.BNKB_CODE = s.BNKB_CODE AND
       t.ACNT_NUMB = s.ACNT_NUMB)
   WHEN MATCHED THEN
      UPDATE SET
         t.mdfy_BY = UPPER(SUSER_NAME())
        ,t.mdfy_DATE = GETDATE();

END
GO
ALTER TABLE [Global].[Bank_Account] ADD CONSTRAINT [PK_BKAC] PRIMARY KEY CLUSTERED  ([BNKB_BANK_CODE], [BNKB_CODE], [ACNT_NUMB]) ON [BLOB]
GO
ALTER TABLE [Global].[Bank_Account] ADD CONSTRAINT [FK_BKAC_BNKB] FOREIGN KEY ([BNKB_BANK_CODE], [BNKB_CODE]) REFERENCES [Global].[Bank_Branch] ([BANK_CODE], [CODE]) ON DELETE CASCADE ON UPDATE CASCADE
GO
