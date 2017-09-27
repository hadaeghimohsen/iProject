CREATE TABLE [Global].[Bank_Branch]
(
[BANK_CODE] [varchar] (2) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[CODE] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[NAME] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[STAT] [varchar] (3) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[ADDR] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[TEL] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[HEAD_CODE] [varchar] (6) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
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
CREATE TRIGGER [Global].[CG$AINS_BNKB]
   ON  [Global].[Bank_Branch]
   AFTER INSERT
AS 
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for trigger here
   MERGE Global.Bank_Branch T
   USING(SELECT * FROM Inserted) S
   ON(t.BANK_CODE = s.BANK_CODE AND
      t.CODE = s.CODE)
   WHEN MATCHED THEN
      UPDATE SET
         t.CRET_BY = UPPER(SUSER_NAME())
        ,t.CRET_DATE = GETDATE()
        ,t.CODE = dbo.PADSTR(s.CODE, 10);

   
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
CREATE TRIGGER [Global].[CG$AUPD_BNKB]
   ON  [Global].[Bank_Branch]
   AFTER update
AS 
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for trigger here
   MERGE Global.Bank_Branch T
   USING(SELECT * FROM Inserted) S
   ON(t.BANK_CODE = s.BANK_CODE AND
      t.CODE = s.CODE)
   WHEN MATCHED THEN
      UPDATE SET
         t.MDFY_BY = UPPER(SUSER_NAME())
        ,t.MDFY_DATE = GETDATE();
   
END
GO
ALTER TABLE [Global].[Bank_Branch] ADD CONSTRAINT [PK_BNKB] PRIMARY KEY CLUSTERED  ([BANK_CODE], [CODE]) ON [BLOB]
GO
ALTER TABLE [Global].[Bank_Branch] ADD CONSTRAINT [FK_BNKB_BANK] FOREIGN KEY ([BANK_CODE]) REFERENCES [Global].[Bank] ([CODE]) ON DELETE CASCADE ON UPDATE CASCADE
GO
