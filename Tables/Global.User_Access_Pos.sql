CREATE TABLE [Global].[User_Access_Pos]
(
[USER_ID] [bigint] NULL,
[POSD_PSID] [bigint] NULL,
[UPID] [bigint] NOT NULL,
[STAT] [varchar] (3) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[BILL_NO] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
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
CREATE TRIGGER [Global].[CG$AINS_UACP]
   ON  [Global].[User_Access_Pos]
   AFTER INSERT
AS 
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

   -- Insert statements for trigger here
   MERGE Global.User_Access_Pos T
   USING (SELECT * FROM Inserted) S
   ON (T.USER_ID = S.USER_ID AND 
       T.POSD_PSID = S.POSD_PSID AND
       T.UPID = S.UPID)
   WHEN MATCHED THEN
      UPDATE SET
         T.CRET_BY = UPPER(SUSER_NAME())
        ,T.CRET_DATE = GETDATE()
        ,T.UPID = CASE s.UPID WHEN 0 THEN dbo.GNRT_NVID_U() ELSE s.UPID END;        
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
CREATE TRIGGER [Global].[CG$AUPD_UACP]
   ON  [Global].[User_Access_Pos]
   AFTER UPDATE
AS 
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

   -- Insert statements for trigger here
   MERGE Global.User_Access_Pos T
   USING (SELECT * FROM Inserted) S
   ON (T.UPID = S.UPID)
   WHEN MATCHED THEN
      UPDATE SET
         T.MDFY_BY = UPPER(SUSER_NAME())
        ,T.MDFY_DATE = GETDATE();
END
GO
ALTER TABLE [Global].[User_Access_Pos] ADD CONSTRAINT [PK_UACP] PRIMARY KEY CLUSTERED  ([UPID]) ON [PRIMARY]
GO
ALTER TABLE [Global].[User_Access_Pos] ADD CONSTRAINT [FK_UACP_POSD] FOREIGN KEY ([POSD_PSID]) REFERENCES [Global].[Pos_Device] ([PSID]) ON DELETE CASCADE
GO
ALTER TABLE [Global].[User_Access_Pos] ADD CONSTRAINT [FK_UACP_USER] FOREIGN KEY ([USER_ID]) REFERENCES [DataGuard].[User] ([ID]) ON DELETE CASCADE
GO
