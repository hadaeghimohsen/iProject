CREATE TABLE [Global].[Wheater_Engine]
(
[WEID] [bigint] NOT NULL IDENTITY(1, 1),
[WEB_SITE] [varchar] (1000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[FULL_NAME] [varchar] (250) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[USER_NAME] [varchar] (250) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PASS_WORD] [nvarchar] (250) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[EMIL_ADDR] [varchar] (250) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[API_KEY] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PRTC_TYPE] [varchar] (3) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[FRMT_TYPE] [varchar] (3) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[STAT] [varchar] (3) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
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
CREATE TRIGGER [Global].[CG$AINS_WENG]
   ON  [Global].[Wheater_Engine]
   AFTER INSERT
AS 
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for trigger here
   MERGE Global.Wheater_Engine T
   USING (SELECT * FROM Inserted) S
   ON (T.WEID = S.WEID)
   WHEN MATCHED THEN
      UPDATE SET
         T.CRET_BY = UPPER(SUSER_NAME())
        ,T.CRET_DATE = GETDATE();   
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
CREATE TRIGGER [Global].[CG$AUPD_WENG]
   ON  [Global].[Wheater_Engine]
   AFTER UPDATE   
AS 
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for trigger here
   MERGE Global.Wheater_Engine T
   USING (SELECT * FROM Inserted) S
   ON (T.WEID = S.WEID)
   WHEN MATCHED THEN
      UPDATE SET
         T.MDFY_BY = UPPER(SUSER_NAME())
        ,T.MDFY_DATE = GETDATE();   
END
GO
ALTER TABLE [Global].[Wheater_Engine] ADD CONSTRAINT [PK_Wheater_Engine] PRIMARY KEY CLUSTERED  ([WEID]) ON [BLOB]
GO
EXEC sp_addextendedproperty N'MS_Description', N'Format Type (JSON, XML)', 'SCHEMA', N'Global', 'TABLE', N'Wheater_Engine', 'COLUMN', N'FRMT_TYPE'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Portocol Type (Http, Https)', 'SCHEMA', N'Global', 'TABLE', N'Wheater_Engine', 'COLUMN', N'PRTC_TYPE'
GO
