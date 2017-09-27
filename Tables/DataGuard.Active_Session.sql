CREATE TABLE [DataGuard].[Active_Session]
(
[USGW_GTWY_MAC_ADRS] [varchar] (17) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[USGW_USER_ID] [bigint] NOT NULL,
[USGW_RWNO] [int] NOT NULL,
[AUDS_ID] [bigint] NOT NULL,
[RWNO] [bigint] NOT NULL,
[ACTN_DATE] [datetime] NULL,
[ACTN_TYPE] [varchar] (3) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
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
CREATE TRIGGER [DataGuard].[CG$AINS_ACSN]
   ON  [DataGuard].[Active_Session]
   AFTER INSERT
AS 
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
   
    -- Insert statements for trigger here
   MERGE DataGuard.Active_Session T
   USING (SELECT * FROM Inserted) S
   ON (T.USGW_GTWY_MAC_ADRS = S.USGW_GTWY_MAC_ADRS AND
       T.USGW_USER_ID = S.USGW_USER_ID AND
       T.USGW_RWNO = S.USGW_RWNO AND
       T.AUDS_ID = S.AUDS_ID AND 
       T.RWNO = S.RWNO AND 
       CAST(T.ACTN_DATE AS DATE) = CAST(S.ACTN_DATE AS DATE))
   WHEN MATCHED THEN
      UPDATE SET
         T.CRET_BY = UPPER(SUSER_NAME())
        ,T.CRET_DATE = GETDATE()
        ,T.RWNO = (SELECT ISNULL(MAX(a.RWNO), 0) + 1 
                     FROM DataGuard.Active_Session a
                    WHERE a.USGW_GTWY_MAC_ADRS = s.USGW_GTWY_MAC_ADRS 
                      AND a.USGW_USER_ID = s.USGW_USER_ID 
                      AND a.USGW_RWNO = s.USGW_RWNO 
                      AND a.AUDS_ID = s.AUDS_ID);
   
   MERGE DataGuard.[User] T
   USING (SELECT * FROM Inserted)S 
   ON (T.ID = S.USGW_USER_ID)
   WHEN MATCHED THEN
      UPDATE SET T.LAST_LOGN_DATE_DNRM = GETDATE();
           
   
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
CREATE TRIGGER [DataGuard].[CG$AUPD_ACSN]
   ON  [DataGuard].[Active_Session]
   AFTER UPDATE
AS 
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for trigger here
   MERGE DataGuard.Active_Session T
   USING (SELECT * FROM Inserted) S
   ON (T.USGW_GTWY_MAC_ADRS = S.USGW_GTWY_MAC_ADRS AND
       T.USGW_USER_ID = S.USGW_USER_ID AND
       T.USGW_RWNO = S.USGW_RWNO AND
       T.AUDS_ID = S.AUDS_ID AND 
       T.RWNO = S.RWNO)
   WHEN MATCHED THEN
      UPDATE SET
         T.MDFY_BY = UPPER(SUSER_NAME())
        ,T.MDFY_DATE = GETDATE();
        
END
GO
ALTER TABLE [DataGuard].[Active_Session] ADD CONSTRAINT [PK_ACSN] PRIMARY KEY CLUSTERED  ([USGW_GTWY_MAC_ADRS], [USGW_USER_ID], [USGW_RWNO], [AUDS_ID], [RWNO]) ON [BLOB]
GO
ALTER TABLE [DataGuard].[Active_Session] ADD CONSTRAINT [FK_ACSN_AUDS] FOREIGN KEY ([AUDS_ID]) REFERENCES [Global].[Access_User_Datasource] ([ID]) ON DELETE CASCADE
GO
ALTER TABLE [DataGuard].[Active_Session] ADD CONSTRAINT [FK_ACSN_USGW] FOREIGN KEY ([USGW_GTWY_MAC_ADRS], [USGW_USER_ID], [USGW_RWNO]) REFERENCES [DataGuard].[User_Gateway] ([GTWY_MAC_ADRS], [USER_ID], [RWNO])
GO
