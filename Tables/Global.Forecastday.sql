CREATE TABLE [Global].[Forecastday]
(
[CRNT_CRID] [bigint] NULL,
[FCID] [bigint] NOT NULL IDENTITY(1, 1),
[LAST_UPDT] [datetime] NULL,
[LAST_UPDT_EPCH] [int] NULL,
[MAX_TEMP_C] [float] NULL,
[MAX_TEMP_F] [float] NULL,
[MIN_TEMP_C] [float] NULL,
[MIN_TEMP_F] [float] NULL,
[AVG_TEMP_C] [float] NULL,
[AVG_TEMP_F] [float] NULL,
[MAX_WIND_MPH] [float] NULL,
[MAX_WIN_KPH] [float] NULL,
[TOTL_PCIP_MM] [float] NULL,
[TOTL_PCIP_IN] [float] NULL,
[COND_TEXT] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[COND_ICON] [varchar] (500) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[COND_CODE] [int] NULL,
[SUN_RISE] [time] (0) NULL,
[SUN_SET] [time] (0) NULL,
[MOON_RISE] [time] (0) NULL,
[MOON_SET] [time] (0) NULL,
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
CREATE TRIGGER [Global].[CG$AINS_FCDY]
   ON  [Global].[Forecastday]
   AFTER INSERT 
AS 
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for trigger here
   MERGE Global.[Forecastday] T
   USING (SELECT * FROM Inserted) S
   ON (T.FCID = S.FCID)
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
CREATE TRIGGER [Global].[CG$AUPD_FCDY]
   ON  [Global].[Forecastday]
   AFTER UPDATE
AS 
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for trigger here
   MERGE Global.[Forecastday] T
   USING (SELECT * FROM Inserted) S
   ON (T.FCID = S.FCID)
   WHEN MATCHED THEN
      UPDATE SET
         T.MDFY_BY = UPPER(SUSER_NAME())
        ,T.MDFY_DATE = GETDATE();   
END
GO
ALTER TABLE [Global].[Forecastday] ADD CONSTRAINT [PK_Forecastday] PRIMARY KEY CLUSTERED  ([FCID]) ON [BLOB]
GO
ALTER TABLE [Global].[Forecastday] ADD CONSTRAINT [FK_Forecastday_Current] FOREIGN KEY ([CRNT_CRID]) REFERENCES [Global].[Current] ([CRID])
GO
