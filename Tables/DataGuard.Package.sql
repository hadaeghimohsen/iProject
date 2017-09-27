CREATE TABLE [DataGuard].[Package]
(
[SUB_SYS] [int] NOT NULL,
[CODE] [varchar] (3) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[NAME] [nvarchar] (250) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
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
CREATE TRIGGER [DataGuard].[CG$AINS_PAKG]
   ON  [DataGuard].[Package]
   AFTER INSERT
AS 
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

   -- Insert statements for trigger here
   MERGE [DataGuard].[Package] T
   USING (SELECT * FROM INSERTED) S
   ON (T.SUB_SYS = S.SUB_SYS AND
       T.CODE    = S.CODE)
   WHEN MATCHED THEN
      UPDATE
         SET CRET_BY   = UPPER(SUSER_NAME())
            ,CRET_DATE = GETDATE()
            ,T.CODE = dbo.PADSTR(s.CODE, 3);
END
;
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [DataGuard].[CG$AUPD_PAKG]
   ON  [DataGuard].[Package]
   AFTER UPDATE
AS 
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

   -- Insert statements for trigger here
   MERGE [DataGuard].[Package] T
   USING (SELECT * FROM INSERTED) S
   ON (T.SUB_SYS = S.SUB_SYS AND
       T.CODE    = S.CODE)
   WHEN MATCHED THEN
      UPDATE
         SET MDFY_BY   = UPPER(SUSER_NAME())
            ,MDFY_DATE = GETDATE();
END
;
GO
ALTER TABLE [DataGuard].[Package] ADD CONSTRAINT [PK_PAKG] PRIMARY KEY CLUSTERED  ([SUB_SYS], [CODE]) ON [PRIMARY]
GO
ALTER TABLE [DataGuard].[Package] ADD CONSTRAINT [FK_SUBS_PAKG] FOREIGN KEY ([SUB_SYS]) REFERENCES [DataGuard].[Sub_System] ([SUB_SYS])
GO
