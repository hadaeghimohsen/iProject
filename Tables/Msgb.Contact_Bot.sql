CREATE TABLE [Msgb].[Contact_Bot]
(
[BOTC_BCID] [bigint] NULL,
[CONT_CODE] [bigint] NULL,
[CODE] [bigint] NOT NULL,
[CRET_BY] [varchar] (250) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CRET_DATE] [datetime] NULL
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
CREATE TRIGGER [Msgb].[CG$AINS_CBOT]
   ON  [Msgb].[Contact_Bot]
   AFTER INSERT
AS 
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

   -- Insert statements for trigger here
   MERGE Msgb.Contact_Bot T
   USING (SELECT * FROM Inserted) S
   ON (T.BOTC_BCID = T.BOTC_BCID AND 
       T.CONT_CODE = S.CONT_CODE AND 
       T.CODE = S.CODE)
   WHEN MATCHED THEN 
      UPDATE SET
         T.CRET_BY = UPPER(SUSER_ID()),
         T.CRET_DATE = GETDATE(),
         T.CODE = CASE s.CODE WHEN 0 THEN dbo.GNRT_NVID_U() ELSE s.CODE END;
END
GO
ALTER TABLE [Msgb].[Contact_Bot] ADD CONSTRAINT [PK_CBOT] PRIMARY KEY CLUSTERED  ([CODE]) ON [PRIMARY]
GO
ALTER TABLE [Msgb].[Contact_Bot] ADD CONSTRAINT [FK_CBOT_BOTC] FOREIGN KEY ([BOTC_BCID]) REFERENCES [Msgb].[Bot_Connection] ([BCID]) ON DELETE CASCADE
GO
ALTER TABLE [Msgb].[Contact_Bot] ADD CONSTRAINT [FK_CBOT_CONT] FOREIGN KEY ([CONT_CODE]) REFERENCES [Msgb].[Contact] ([CODE]) ON DELETE CASCADE
GO
