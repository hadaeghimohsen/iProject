CREATE TABLE [DataGuard].[Service]
(
[FILE_NO] [bigint] NOT NULL,
[FRST_NAME] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[LAST_NAME] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CELL_PHON] [varchar] (11) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[TELL_PHON] [varchar] (11) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[EMAL_ADRS] [varchar] (500) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[POST_ADRS] [nvarchar] (500) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[COMP_NAME] [nvarchar] (250) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CRET_BY] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CRET_DATE] [datetime] NULL,
[MDFY_BY] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
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
CREATE TRIGGER [DataGuard].[CG$AINS_SERV]
   ON  [DataGuard].[Service]
   AFTER INSERT
AS 
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for trigger here
   MERGE DataGuard.Service T
   USING(SELECT * FROM Inserted) S
   ON(T.FILE_NO = S.FILE_NO)
   WHEN MATCHED THEN
      UPDATE SET
         T.CRET_BY = UPPER(SUSER_NAME())
        ,T.CRET_DATE = GETDATE()
        ,t.FILE_NO = CASE WHEN t.FILE_NO = 0 THEN dbo.GNRT_NVID_U() ELSE t.FILE_NO END;
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
CREATE TRIGGER [DataGuard].[CG$AUPD_SERV]
   ON  [DataGuard].[Service]
   AFTER UPDATE
AS 
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for trigger here
   MERGE DataGuard.Service T
   USING(SELECT * FROM Inserted) S
   ON(T.FILE_NO = S.FILE_NO)
   WHEN MATCHED THEN
      UPDATE SET
         T.MDFY_BY = UPPER(SUSER_NAME())
        ,T.MDFY_DATE = GETDATE();

END
GO
ALTER TABLE [DataGuard].[Service] ADD CONSTRAINT [PK_Contact] PRIMARY KEY CLUSTERED  ([FILE_NO]) ON [PRIMARY]
GO
