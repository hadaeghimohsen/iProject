CREATE TABLE [Global].[Bank]
(
[CODE] [varchar] (2) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[BANK_DESC] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[TITL] [nvarchar] (3) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
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
CREATE TRIGGER [Global].[CG$AINS_BANK]
   ON  [Global].[Bank]
   AFTER INSERT
AS 
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for trigger here
   MERGE Global.Bank T
   USING (SELECT * FROM Inserted) S
   ON(T.CODE = S.CODE)
   WHEN MATCHED THEN
      UPDATE SET
         t.CRET_BY = UPPER(SUSER_NAME())
        ,t.CRET_DATE = GETDATE()
        ,t.CODE = dbo.PADSTR(s.code , 2);
   
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
CREATE TRIGGER [Global].[CG$AUPD_BANK]
   ON  [Global].[Bank]
   AFTER update
AS 
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for trigger here
   MERGE Global.Bank T
   USING (SELECT * FROM Inserted) S
   ON(T.CODE = S.CODE)
   WHEN MATCHED THEN
      UPDATE SET
         t.MDFY_BY = UPPER(SUSER_NAME())
        ,t.MDFY_DATE = GETDATE();
   
END
GO
ALTER TABLE [Global].[Bank] ADD CONSTRAINT [PK_Bank] PRIMARY KEY CLUSTERED  ([CODE]) ON [BLOB]
GO
