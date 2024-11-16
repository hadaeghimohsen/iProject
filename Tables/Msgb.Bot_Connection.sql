CREATE TABLE [Msgb].[Bot_Connection]
(
[MSBS_MBID] [bigint] NULL,
[BCID] [bigint] NOT NULL,
[BOT_NAME] [varchar] (250) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[BOT_DESC] [nvarchar] (250) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[BOT_TOKN] [varchar] (250) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CRET_BY] [varchar] (250) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CRET_DATE] [datetime] NULL,
[MDFY_BY] [varchar] (250) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[MDFY_DATE] [datetime] NULL
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
CREATE TRIGGER [Msgb].[CG$AINS_BOTC]
   ON  [Msgb].[Bot_Connection]
   AFTER INSERT
AS 
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

   -- Insert statements for trigger here
   MERGE Msgb.Bot_Connection T
   USING (SELECT * FROM Inserted) S
   ON (T.MSBS_MBID = S.MSBS_MBID AND 
       T.BCID = S.BCID)
   WHEN MATCHED THEN 
      UPDATE SET 
         T.CRET_BY = UPPER(SUSER_NAME()),
         T.CRET_DATE = GETDATE(),
         T.BCID = CASE s.BCID WHEN 0 THEN dbo.GNRT_NVID_U() ELSE s.BCID END;
          
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
CREATE TRIGGER [Msgb].[CG$AUPD_BOTC]
   ON  [Msgb].[Bot_Connection]
   AFTER UPDATE
AS 
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

   -- Insert statements for trigger here
   MERGE Msgb.Bot_Connection T
   USING (SELECT * FROM Inserted) S
   ON (T.BCID = S.BCID)
   WHEN MATCHED THEN 
      UPDATE SET 
         T.MDFY_BY = UPPER(SUSER_NAME()),
         T.MDFY_DATE = GETDATE();
          
END
GO
ALTER TABLE [Msgb].[Bot_Connection] ADD CONSTRAINT [PK_BOTC] PRIMARY KEY CLUSTERED  ([BCID]) ON [PRIMARY]
GO
ALTER TABLE [Msgb].[Bot_Connection] ADD CONSTRAINT [FK_BOTC_MSBS] FOREIGN KEY ([MSBS_MBID]) REFERENCES [Msgb].[Message_Broad_Settings] ([MBID]) ON DELETE CASCADE
GO
