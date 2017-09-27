CREATE TABLE [Global].[Block]
(
[WDAY_REGN_PRVN_CNTY_CODE] [varchar] (3) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[WDAY_REGN_PRVN_CODE] [varchar] (3) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[WDAY_REGN_CODE] [varchar] (3) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[WDAY_CODE] [varchar] (2) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
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
CREATE TRIGGER [Global].[CG$AINS_BLOK]
   ON  [Global].[Block]
   AFTER INSERT   
AS 
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for trigger here
   MERGE Global.Block T
   USING (SELECT * FROM Inserted) S
   ON (t.WDAY_REGN_PRVN_CNTY_CODE = s.WDAY_REGN_PRVN_CNTY_CODE AND
       t.WDAY_REGN_PRVN_CODE = s.WDAY_REGN_PRVN_CODE AND
       t.WDAY_REGN_CODE = s.WDAY_REGN_CODE AND
       t.WDAY_CODE = s.WDAY_CODE AND
       t.CODE = s.CODE)
   WHEN MATCHED THEN
      UPDATE SET
         t.CRET_BY = UPPER(SUSER_NAME())
        ,t.CRET_DATE = GETDATE(),
        t.CODE = dbo.PADSTR(s.CODE, 2);
         
   
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
CREATE TRIGGER [Global].[CG$AUPD_BLOK]
   ON  [Global].[Block]
   AFTER update   
AS 
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for trigger here
   MERGE Global.Block T
   USING (SELECT * FROM Inserted) S
   ON (t.WDAY_REGN_PRVN_CNTY_CODE = s.WDAY_REGN_PRVN_CNTY_CODE AND
       t.WDAY_REGN_PRVN_CODE = s.WDAY_REGN_PRVN_CODE AND
       t.WDAY_REGN_CODE = s.WDAY_REGN_CODE AND
       t.WDAY_CODE = s.WDAY_CODE AND
       t.CODE = s.CODE)
   WHEN MATCHED THEN
      UPDATE SET
         t.MDFY_BY = UPPER(SUSER_NAME())
        ,t.MDFy_DATE = GETDATE();

         
   
END
GO
ALTER TABLE [Global].[Block] ADD CONSTRAINT [PK_Block] PRIMARY KEY CLUSTERED  ([WDAY_REGN_PRVN_CNTY_CODE], [WDAY_REGN_PRVN_CODE], [WDAY_REGN_CODE], [WDAY_CODE], [CODE]) ON [BLOB]
GO
ALTER TABLE [Global].[Block] ADD CONSTRAINT [FK_BLOK_WDAY] FOREIGN KEY ([WDAY_REGN_PRVN_CNTY_CODE], [WDAY_REGN_PRVN_CODE], [WDAY_REGN_CODE], [WDAY_CODE]) REFERENCES [Global].[Work_Day] ([REGN_PRVN_CNTY_CODE], [REGN_PRVN_CODE], [REGN_CODE], [CODE])
GO
