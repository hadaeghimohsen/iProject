CREATE TABLE [DataGuard].[Tiny_Lock]
(
[OPRT_OPID] [bigint] NULL,
[TNID] [bigint] NOT NULL,
[TINY_CODE_DNRM] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
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
CREATE TRIGGER [DataGuard].[CG$AINS_TINY]
   ON  [DataGuard].[Tiny_Lock]
   AFTER INSERT
AS 
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for trigger here
   MERGE DataGuard.Tiny_Lock T
   USING(SELECT * FROM Inserted) S
   ON(T.TNID = S.TNID)
   WHEN MATCHED THEN
      UPDATE SET
         T.CRET_BY = UPPER(SUSER_NAME())
        ,T.CRET_DATE = GETDATE()
        ,t.TNID = CASE WHEN t.TNID = 0 THEN dbo.GNRT_NVID_U() ELSE t.TNID END;
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
CREATE TRIGGER [DataGuard].[CG$AUPD_TINY]
   ON  [DataGuard].[Tiny_Lock]
   AFTER UPDATE   
AS 
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for trigger here
   MERGE DataGuard.Tiny_Lock T
   USING(SELECT * FROM Inserted) S
   ON(T.TNID = S.TNID)
   WHEN MATCHED THEN
      UPDATE SET
         T.MDFY_BY = UPPER(SUSER_NAME())
        ,T.MDFY_DATE = GETDATE();
END
GO
ALTER TABLE [DataGuard].[Tiny_Lock] ADD CONSTRAINT [PK_Tiny_Lock] PRIMARY KEY CLUSTERED  ([TNID]) ON [PRIMARY]
GO
ALTER TABLE [DataGuard].[Tiny_Lock] ADD CONSTRAINT [FK_TINY_OPRT] FOREIGN KEY ([OPRT_OPID]) REFERENCES [DataGuard].[Opportunity] ([OPID])
GO
