CREATE TABLE [Msgb].[Default_Message]
(
[SUB_SYS] [int] NULL,
[CODE] [bigint] NOT NULL,
[MESG_NAME] [nvarchar] (250) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[MESG_TEXT] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
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
CREATE TRIGGER [Msgb].[CG$AINS_DMSG]
   ON  [Msgb].[Default_Message]
   AFTER INSERT
AS 
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for trigger here
   MERGE Msgb.Default_Message T
   USING (SELECT * FROM Inserted) S
   ON (T.SUB_SYS = S.SUB_SYS AND 
       T.CODE = S.CODE)
   WHEN MATCHED THEN
      UPDATE SET
         T.CRET_BY = UPPER(SUSER_NAME())
        ,T.CRET_DATE = GETDATE()
        ,T.CODE = CASE s.CODE WHEN 0 THEN dbo.GNRT_NVID_U() ELSE s.CODE END;
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
CREATE TRIGGER [Msgb].[CG$AUPD_DMSG]
   ON  [Msgb].[Default_Message]
   AFTER UPDATE 
AS 
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for trigger here
   MERGE Msgb.Default_Message T
   USING (SELECT * FROM Inserted) S
   ON (T.CODE = S.CODE)
   WHEN MATCHED THEN
      UPDATE SET
         T.MDFY_BY = UPPER(SUSER_NAME())
        ,T.MDFY_DATE = GETDATE();

END
GO
ALTER TABLE [Msgb].[Default_Message] ADD CONSTRAINT [PK_Default_Message] PRIMARY KEY CLUSTERED  ([CODE]) ON [PRIMARY]
GO
ALTER TABLE [Msgb].[Default_Message] ADD CONSTRAINT [FK_DMSG_SUBS] FOREIGN KEY ([SUB_SYS]) REFERENCES [DataGuard].[Sub_System] ([SUB_SYS]) ON DELETE CASCADE
GO
