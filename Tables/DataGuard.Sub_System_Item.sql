CREATE TABLE [DataGuard].[Sub_System_Item]
(
[SUB_SYS] [int] NOT NULL,
[RWNO] [int] NOT NULL,
[NAME] [nvarchar] (250) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[EXPN_PRIC] [bigint] NULL,
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
CREATE TRIGGER [DataGuard].[CG$AINS_SSIT]
   ON  [DataGuard].[Sub_System_Item]
   AFTER INSERT
AS 
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

   -- Insert statements for trigger here
   MERGE [DataGuard].[Sub_System_Item] T
   USING (SELECT * FROM INSERTED) S
   ON (T.SUB_SYS      = S.SUB_SYS AND
       T.RWNO         = S.RWNO)
   WHEN MATCHED THEN
      UPDATE
         SET CRET_BY   = UPPER(SUSER_NAME())
            ,CRET_DATE = GETDATE()
            ,RWNO      = (SELECT ISNULL(MAX(RWNO), 0) + 1 FROM DataGuard.Sub_System_Item WHERE SUB_SYS = S.SUB_SYS);
END
;
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [DataGuard].[CG$AUPD_SSIT]
   ON  [DataGuard].[Sub_System_Item]
   AFTER UPDATE
AS 
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

   -- Insert statements for trigger here
   MERGE [DataGuard].[Sub_System_Item] T
   USING (SELECT * FROM INSERTED) S
   ON (T.SUB_SYS      = S.SUB_SYS AND
       T.RWNO         = S.RWNO)
   WHEN MATCHED THEN
      UPDATE
         SET MDFY_BY   = UPPER(SUSER_NAME())
            ,MDFY_DATE = GETDATE();
END
;
GO
ALTER TABLE [DataGuard].[Sub_System_Item] ADD CONSTRAINT [PK_SSIT] PRIMARY KEY CLUSTERED  ([SUB_SYS], [RWNO]) ON [PRIMARY]
GO
ALTER TABLE [DataGuard].[Sub_System_Item] ADD CONSTRAINT [FK_SSIT_SUBS] FOREIGN KEY ([SUB_SYS]) REFERENCES [DataGuard].[Sub_System] ([SUB_SYS])
GO
EXEC sp_addextendedproperty N'MS_Description', N'مبلغ آیتم زیر سیستم', 'SCHEMA', N'DataGuard', 'TABLE', N'Sub_System_Item', 'COLUMN', N'EXPN_PRIC'
GO
