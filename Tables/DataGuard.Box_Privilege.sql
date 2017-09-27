CREATE TABLE [DataGuard].[Box_Privilege]
(
[SUB_SYS] [int] NULL,
[BPID] [bigint] NOT NULL IDENTITY(1, 1),
[BOXP_DESC] [nvarchar] (250) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
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
CREATE TRIGGER [DataGuard].[CG$AINS_BOXP]
   ON  [DataGuard].[Box_Privilege]
   AFTER INSERT
AS 
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for trigger here
   MERGE DataGuard.Box_Privilege T
   USING (SELECT * FROM Inserted) S
   ON (T.SUB_SYS = S.SUB_SYS AND 
       T.BPID = S.BPID)
   WHEN MATCHED THEN
      UPDATE SET 
         t.CRET_BY = UPPER(SUSER_NAME())
        ,t.CRET_DATE = GETDATE();
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
CREATE TRIGGER [DataGuard].[CG$AUPD_BOXP]
   ON  [DataGuard].[Box_Privilege]
   AFTER UPDATE
AS 
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for trigger here
   MERGE DataGuard.Box_Privilege T
   USING (SELECT * FROM Inserted) S
   ON (T.SUB_SYS = S.SUB_SYS AND 
       T.BPID = S.BPID)
   WHEN MATCHED THEN
      UPDATE SET 
         t.MDFY_BY = UPPER(SUSER_NAME())
        ,t.MDFY_DATE = GETDATE();
END
GO
ALTER TABLE [DataGuard].[Box_Privilege] ADD CONSTRAINT [PK_Box_Privilege] PRIMARY KEY CLUSTERED  ([BPID]) ON [PRIMARY]
GO
ALTER TABLE [DataGuard].[Box_Privilege] ADD CONSTRAINT [FK_Box_Privilege_Sub_System] FOREIGN KEY ([SUB_SYS]) REFERENCES [DataGuard].[Sub_System] ([SUB_SYS])
GO
