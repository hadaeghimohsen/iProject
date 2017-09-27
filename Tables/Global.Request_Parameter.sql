CREATE TABLE [Global].[Request_Parameter]
(
[REGN_PRVN_CNTY_CODE] [varchar] (3) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[REGN_PRVN_CODE] [varchar] (3) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[REGN_CODE] [varchar] (3) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[WENG_WEID] [bigint] NULL,
[RPID] [bigint] NOT NULL IDENTITY(1, 1),
[RQPM_DATE] [datetime] NULL,
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
CREATE TRIGGER [Global].[CG$AINS_RQPM]
   ON  [Global].[Request_Parameter]
   AFTER INSERT 
AS 
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for trigger here
   MERGE Global.Request_Parameter T
   USING (SELECT * FROM Inserted) S
   ON (T.RPID = S.RPID)
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
CREATE TRIGGER [Global].[CG$AUPD_RQPM]
   ON  [Global].[Request_Parameter]
   AFTER UPDATE   
AS 
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for trigger here
   MERGE Global.Request_Parameter T
   USING (SELECT * FROM Inserted) S
   ON (T.RPID = S.RPID)
   WHEN MATCHED THEN
      UPDATE SET
         T.MDFY_BY = UPPER(SUSER_NAME())
        ,T.MDFY_DATE = GETDATE();   
END
GO
ALTER TABLE [Global].[Request_Parameter] ADD CONSTRAINT [PK_Request_Parameter] PRIMARY KEY CLUSTERED  ([RPID]) ON [BLOB]
GO
ALTER TABLE [Global].[Request_Parameter] ADD CONSTRAINT [FK_Request_Parameter_Region] FOREIGN KEY ([REGN_PRVN_CNTY_CODE], [REGN_PRVN_CODE], [REGN_CODE]) REFERENCES [Global].[Region] ([PRVN_CNTY_CODE], [PRVN_CODE], [CODE])
GO
ALTER TABLE [Global].[Request_Parameter] ADD CONSTRAINT [FK_Request_Parameter_Wheater_Engine] FOREIGN KEY ([WENG_WEID]) REFERENCES [Global].[Wheater_Engine] ([WEID])
GO
