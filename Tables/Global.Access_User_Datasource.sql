CREATE TABLE [Global].[Access_User_Datasource]
(
[ID] [bigint] NOT NULL IDENTITY(1, 1),
[USER_ID] [bigint] NULL,
[DSRC_ID] [bigint] NULL,
[STAT] [varchar] (3) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[STRT_DATE] [date] NULL,
[END_DATE] [date] NULL,
[ACES_TYPE] [varchar] (3) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[HOST_NAME] [varchar] (17) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
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
CREATE TRIGGER [Global].[CG$AINS_AUDS]
   ON  [Global].[Access_User_Datasource]
   AFTER INSERT   
AS 
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
   
   IF EXISTS(
      SELECT *
        FROM Global.Access_User_Datasource a, Inserted s
       WHERE a.USER_ID = s.USER_ID
         AND a.DSRC_ID = s.DSRC_ID
         AND a.HOST_NAME = s.HOST_NAME
         AND a.ID != s.ID
   )
   BEGIN
      RAISERROR(N'رکورد تکراری', 16, 1);
      RETURN;
   END 
   
   -- Insert statements for trigger here
   MERGE Global.Access_User_Datasource T
   USING (SELECT * FROM inserted ) S 
   ON (t.ID = s.ID 
   AND t.USER_ID = s.USER_ID
   AND t.DSRC_ID = s.DSRC_ID)
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
CREATE TRIGGER [Global].[CG$AUPD_AUDS]
   ON  [Global].[Access_User_Datasource]
   AFTER UPDATE
AS 
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

   -- Insert statements for trigger here
   MERGE Global.Access_User_Datasource T
   USING (SELECT * FROM inserted ) S 
   ON (t.ID = s.ID 
   AND t.USER_ID = s.USER_ID
   AND t.DSRC_ID = s.DSRC_ID)
   WHEN MATCHED THEN
      UPDATE SET
         T.MDFY_BY = UPPER(SUSER_NAME())
        ,T.MDFY_DATE = GETDATE();
   

END
GO
ALTER TABLE [Global].[Access_User_Datasource] ADD CONSTRAINT [PK_AUDS] PRIMARY KEY CLUSTERED  ([ID]) ON [PRIMARY]
GO
ALTER TABLE [Global].[Access_User_Datasource] ADD CONSTRAINT [FK_AUDS_DSRC] FOREIGN KEY ([DSRC_ID]) REFERENCES [Report].[DataSource] ([ID])
GO
ALTER TABLE [Global].[Access_User_Datasource] ADD CONSTRAINT [FK_AUDS_GTWY] FOREIGN KEY ([HOST_NAME]) REFERENCES [DataGuard].[Gateway] ([MAC_ADRS]) ON DELETE SET NULL
GO
ALTER TABLE [Global].[Access_User_Datasource] ADD CONSTRAINT [FK_AUDS_USER] FOREIGN KEY ([USER_ID]) REFERENCES [DataGuard].[User] ([ID]) ON DELETE CASCADE
GO
EXEC sp_addextendedproperty N'MS_Description', N'نوع دسترسی * نامحدود / محدود', 'SCHEMA', N'Global', 'TABLE', N'Access_User_Datasource', 'COLUMN', N'ACES_TYPE'
GO
EXEC sp_addextendedproperty N'MS_Description', N'تاریخ پایان همکاری', 'SCHEMA', N'Global', 'TABLE', N'Access_User_Datasource', 'COLUMN', N'END_DATE'
GO
EXEC sp_addextendedproperty N'MS_Description', N'کامپیوتری که می تواند با آن متصل شود و از این پل ارتباطی استفاده  کند', 'SCHEMA', N'Global', 'TABLE', N'Access_User_Datasource', 'COLUMN', N'HOST_NAME'
GO
EXEC sp_addextendedproperty N'MS_Description', N'تاریخ شروع همکاری', 'SCHEMA', N'Global', 'TABLE', N'Access_User_Datasource', 'COLUMN', N'STRT_DATE'
GO
