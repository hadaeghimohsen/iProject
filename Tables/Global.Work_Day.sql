CREATE TABLE [Global].[Work_Day]
(
[REGN_PRVN_CNTY_CODE] [varchar] (3) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[REGN_PRVN_CODE] [varchar] (3) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[REGN_CODE] [varchar] (3) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[CODE] [varchar] (2) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
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
CREATE TRIGGER [Global].[CG$AINS_WDAY]
   ON  [Global].[Work_Day]
   AFTER INSERT
AS 
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for trigger here
   MERGE Global.Work_Day T
   USING(SELECT * FROM Inserted) S
   ON (t.REGN_PRVN_CNTY_CODE = s.REGN_PRVN_CNTY_CODE AND
       t.REGN_PRVN_CODE = s.REGN_PRVN_CODE AND
       t.REGN_CODE = s.REGN_CODE AND
       t.CODE = s.CODE)
  WHEN MATCHED THEN
   UPDATE SET
      T.CRET_BY = UPPER(SUSER_NAME())
     ,t.CRET_DATE = GETDATE()
     ,t.CODE = dbo.PADSTR(s.CODE, 2);
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
CREATE TRIGGER [Global].[CG$AUPD_WDAY]
   ON  [Global].[Work_Day]
   AFTER update
AS 
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for trigger here
   MERGE Global.Work_Day T
   USING(SELECT * FROM Inserted) S
   ON (t.REGN_PRVN_CNTY_CODE = s.REGN_PRVN_CNTY_CODE AND
       t.REGN_PRVN_CODE = s.REGN_PRVN_CODE AND
       t.REGN_CODE = s.REGN_CODE AND
       t.CODE = s.CODE)
  WHEN MATCHED THEN
   UPDATE SET
      T.MDFY_BY = UPPER(SUSER_NAME())
     ,t.MDFY_DATE = GETDATE();

END
GO
ALTER TABLE [Global].[Work_Day] ADD CONSTRAINT [PK_Work_Day] PRIMARY KEY CLUSTERED  ([REGN_PRVN_CNTY_CODE], [REGN_PRVN_CODE], [REGN_CODE], [CODE]) ON [BLOB]
GO
ALTER TABLE [Global].[Work_Day] ADD CONSTRAINT [FK_WDAY_REGN] FOREIGN KEY ([REGN_PRVN_CNTY_CODE], [REGN_PRVN_CODE], [REGN_CODE]) REFERENCES [Global].[Region] ([PRVN_CNTY_CODE], [PRVN_CODE], [CODE])
GO
