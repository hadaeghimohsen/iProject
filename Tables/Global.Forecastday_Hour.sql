CREATE TABLE [Global].[Forecastday_Hour]
(
[FCDY_FCID] [bigint] NULL,
[HRID] [bigint] NOT NULL IDENTITY(1, 1),
[LAST_UPDT] [datetime] NULL,
[LAST_UPDT_EPCH] [int] NULL,
[TEMP_C] [float] NULL,
[TEMP_F] [float] NULL,
[COND_TEXT] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[COND_ICON] [varchar] (500) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[COND_CODE] [int] NULL,
[WIND_MPH] [float] NULL,
[WIND_KPH] [float] NULL,
[WIND_DEGR] [int] NULL,
[WIND_DIR] [varchar] (3) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PSUR_MB] [float] NULL,
[PSUR_IN] [float] NULL,
[PCIP_MM] [float] NULL,
[PCIP_IN] [float] NULL,
[HUMD] [int] NULL,
[CLUD] [int] NULL,
[FEEL_SLIK_C] [float] NULL,
[FEEL_SLIK_F] [float] NULL,
[WIND_CHIL_C] [float] NULL,
[WIND_CHIL_F] [float] NULL,
[HEAT_INDX_C] [float] NULL,
[HEAT_INDX_F] [float] NULL,
[DEW_PONT_C] [float] NULL,
[DEW_PONT_F] [float] NULL,
[WILL_IT_RAIN] [int] NULL,
[WILL_IT_SNOW] [int] NULL,
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
CREATE TRIGGER [Global].[CG$AINS_FCDH]
   ON  [Global].[Forecastday_Hour]
   AFTER INSERT 
AS 
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for trigger here
   MERGE Global.[Forecastday_Hour] T
   USING (SELECT * FROM Inserted) S
   ON (T.HRID = S.HRID)
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
CREATE TRIGGER [Global].[CG$AUPD_FCDH]
   ON  [Global].[Forecastday_Hour]
   AFTER UPDATE
AS 
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for trigger here
   MERGE Global.[Forecastday_Hour] T
   USING (SELECT * FROM Inserted) S
   ON (T.HRID = S.HRID)
   WHEN MATCHED THEN
      UPDATE SET
         T.MDFY_BY = UPPER(SUSER_NAME())
        ,T.MDFY_DATE = GETDATE();   
END
GO
ALTER TABLE [Global].[Forecastday_Hour] ADD CONSTRAINT [PK_Forecastday_Hour] PRIMARY KEY CLUSTERED  ([HRID]) ON [BLOB]
GO
ALTER TABLE [Global].[Forecastday_Hour] ADD CONSTRAINT [FK_Forecastday_Hour_Forecastday] FOREIGN KEY ([FCDY_FCID]) REFERENCES [Global].[Forecastday] ([FCID])
GO
