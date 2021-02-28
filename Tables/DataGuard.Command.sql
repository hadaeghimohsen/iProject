CREATE TABLE [DataGuard].[Command]
(
[SUB_SYS] [int] NULL,
[CODE] [bigint] NOT NULL,
[OPEN_CMND_TEXT] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[CLOS_CMND_TEXT] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[VALU] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CMND_DATE] [date] NULL,
[RUN_STAT] [varchar] (3) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CRET_BY] [varchar] (250) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CRET_DATE] [datetime] NULL,
[MDFY_BY] [varchar] (250) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[MDFY_DATE] [datetime] NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
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
CREATE TRIGGER [DataGuard].[CG$AINS_CMND]
   ON  [DataGuard].[Command]
   AFTER INSERT
AS 
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

   -- Insert statements for trigger here
   MERGE DataGuard.Command T
   USING (SELECT * FROM Inserted) S
   ON (t.SUB_SYS = s.SUB_SYS AND 
       t.CODE = s.CODE) 
   WHEN MATCHED THEN
      UPDATE SET
         T.CRET_BY = UPPER(SUSER_NAME()),
         T.CRET_DATE = GETDATE(),
         T.CODE = CASE s.CODE WHEN 0 THEN dbo.GNRT_NVID_U() ELSE S.CODE END;
   
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
CREATE TRIGGER [DataGuard].[CG$AUPD_CMND]
   ON  [DataGuard].[Command]
   AFTER UPDATE
AS 
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

   -- Insert statements for trigger here
   MERGE DataGuard.Command T
   USING (SELECT * FROM Inserted) S
   ON (t.SUB_SYS = s.SUB_SYS AND 
       t.CODE = s.CODE) 
   WHEN MATCHED THEN
      UPDATE SET
         T.MDFY_BY = UPPER(SUSER_NAME()),
         T.MDFY_DATE = GETDATE();
   
END
GO
ALTER TABLE [DataGuard].[Command] ADD CONSTRAINT [PK_CMND] PRIMARY KEY CLUSTERED  ([CODE]) ON [PRIMARY]
GO
