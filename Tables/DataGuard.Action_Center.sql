CREATE TABLE [DataGuard].[Action_Center]
(
[CODE] [bigint] NOT NULL,
[SUB_SYS] [int] NULL,
[USER_ID] [bigint] NULL,
[ACTN_DATE] [datetime] NULL,
[MESG_TEXT] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[MESG_TYPE] [varchar] (3) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[MESG_STAT] [varchar] (3) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
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
CREATE TRIGGER [DataGuard].[CG$AINS_ACCT]
   ON  [DataGuard].[Action_Center]
   AFTER INSERT
AS 
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for trigger here
   MERGE DataGuard.Action_Center T
   USING (SELECT * FROM INSERTED) S
   ON (T.CODE = S.Code AND 
       T.SUB_SYS = S.SUB_SYS AND
       T.USER_ID = S.USER_ID
   )
   WHEN MATCHED THEN
      UPDATE 
         SET CRET_BY = UPPER(SUSER_NAME())
            ,CRET_DATE = GETDATE()            
            ,CODE = dbo.GetNewVerIdentity()
            ,ACTN_DATE = GETDATE()
            ,MESG_STAT = '001';
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
CREATE TRIGGER [DataGuard].[CG$AUPD_ACCT]
   ON  [DataGuard].[Action_Center]
   AFTER UPDATE
AS 
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for trigger here
   MERGE DataGuard.Action_Center T
   USING (SELECT * FROM INSERTED) S
   ON (T.CODE = S.Code AND 
       T.SUB_SYS = S.SUB_SYS AND
       T.USER_ID = S.USER_ID
   )
   WHEN MATCHED THEN
      UPDATE 
         SET MDFY_BY = UPPER(SUSER_NAME())
            ,MDFY_DATE = GETDATE();
END
GO
ALTER TABLE [DataGuard].[Action_Center] ADD CONSTRAINT [PK_Action_Center] PRIMARY KEY CLUSTERED  ([CODE]) ON [PRIMARY]
GO
ALTER TABLE [DataGuard].[Action_Center] ADD CONSTRAINT [FK_ACCT_SUBS] FOREIGN KEY ([SUB_SYS]) REFERENCES [DataGuard].[Sub_System] ([SUB_SYS])
GO
ALTER TABLE [DataGuard].[Action_Center] ADD CONSTRAINT [FK_ACCT_USER] FOREIGN KEY ([USER_ID]) REFERENCES [DataGuard].[User] ([ID])
GO
