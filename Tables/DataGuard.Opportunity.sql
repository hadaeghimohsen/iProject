CREATE TABLE [DataGuard].[Opportunity]
(
[SERV_FILE_NO] [bigint] NULL,
[OPID] [bigint] NOT NULL,
[ISSU_DATE] [datetime] NULL,
[CNCL_DATE] [datetime] NULL,
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
CREATE TRIGGER [DataGuard].[CG$AINS_OPRT]
   ON  [DataGuard].[Opportunity]
   AFTER INSERT
AS 
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for trigger here
   MERGE DataGuard.Opportunity T
   USING(SELECT * FROM Inserted) S
   ON(T.OPID = S.OPID)
   WHEN MATCHED THEN
      UPDATE SET
         T.CRET_BY = UPPER(SUSER_NAME())
        ,T.CRET_DATE = GETDATE()
        ,t.OPID = CASE WHEN t.OPID = 0 THEN dbo.GNRT_NVID_U() ELSE t.OPID END;
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
CREATE TRIGGER [DataGuard].[CG$AUPD_OPRT]
   ON  [DataGuard].[Opportunity]
   AFTER UPDATE   
AS 
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for trigger here
   MERGE DataGuard.Opportunity T
   USING(SELECT * FROM Inserted) S
   ON(T.OPID = S.OPID)
   WHEN MATCHED THEN
      UPDATE SET
         T.MDFY_BY = UPPER(SUSER_NAME())
        ,T.MDFY_DATE = GETDATE();
END
GO
ALTER TABLE [DataGuard].[Opportunity] ADD CONSTRAINT [PK_Opportunity] PRIMARY KEY CLUSTERED  ([OPID]) ON [PRIMARY]
GO
ALTER TABLE [DataGuard].[Opportunity] ADD CONSTRAINT [FK_OPRT_SERV] FOREIGN KEY ([SERV_FILE_NO]) REFERENCES [DataGuard].[Service] ([FILE_NO])
GO
