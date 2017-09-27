CREATE TABLE [Report].[DataSource]
(
[ID] [bigint] NOT NULL CONSTRAINT [DF_DataSource_ID] DEFAULT ([dbo].[GetNewIdentity]()),
[ShortCut] [bigint] NOT NULL,
[DatabaseServer] [smallint] NOT NULL,
[IPAddress] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Port] [int] NULL,
[Database_Alias] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Database] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[UserID] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Password] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[TitleFa] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[IsDefault] [bit] NULL CONSTRAINT [DF_DataSource_IsDefault] DEFAULT ('false'),
[IsActive] [bit] NOT NULL CONSTRAINT [DF_DataSource_IsActive] DEFAULT ('true'),
[IsVisible] [bit] NOT NULL CONSTRAINT [DF_DataSource_IsVisible] DEFAULT ('true'),
[SUB_SYS] [int] NULL,
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
CREATE TRIGGER [Report].[CG$AINS_DSRC]
   ON  [Report].[DataSource]
   AFTER INSERT
AS 
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for trigger here
   MERGE Report.DataSource T
   USING (SELECT * FROM Inserted) S
   ON (t.ID = S.ID)
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
CREATE TRIGGER [Report].[CG$AUPD_DSRC]
   ON  [Report].[DataSource]
   AFTER UPDATE
AS 
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for trigger here
   MERGE Report.DataSource T
   USING (SELECT * FROM Inserted) S
   ON (t.ID = S.ID)
   WHEN MATCHED THEN
      UPDATE SET 
         T.MDFY_BY = UPPER(SUSER_NAME())
        ,T.MDFY_DATE = GETDATE();
END
GO
ALTER TABLE [Report].[DataSource] ADD CONSTRAINT [PK_DataSource] PRIMARY KEY CLUSTERED  ([ID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [DataSource_ID] ON [Report].[DataSource] ([ID]) ON [PRIMARY]
GO
ALTER TABLE [Report].[DataSource] ADD CONSTRAINT [FK_DataSource_Sub_System] FOREIGN KEY ([SUB_SYS]) REFERENCES [DataGuard].[Sub_System] ([SUB_SYS])
GO
