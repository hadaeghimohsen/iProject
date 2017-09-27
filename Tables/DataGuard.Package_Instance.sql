CREATE TABLE [DataGuard].[Package_Instance]
(
[PAKG_SUB_SYS] [int] NOT NULL,
[PAKG_CODE] [varchar] (3) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[RWNO] [int] NOT NULL,
[INST_DESC] [nvarchar] (250) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[STAT] [varchar] (3) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[MAX_ROW] [bigint] NULL,
[ROW_COUNT] [bigint] NULL,
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
CREATE TRIGGER [DataGuard].[CG$AINS_PKIN]
   ON  [DataGuard].[Package_Instance]
   AFTER INSERT
AS 
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

   -- Insert statements for trigger here
   MERGE [DataGuard].[Package_Instance] T
   USING (SELECT * FROM INSERTED) S
   ON (T.PAKG_SUB_SYS = S.PAKG_SUB_SYS AND
       T.PAKG_CODE    = S.PAKG_CODE    AND
       T.RWNO         = S.RWNO)
   WHEN MATCHED THEN
      UPDATE
         SET CRET_BY   = UPPER(SUSER_NAME())
            ,CRET_DATE = GETDATE()
            ,RWNO      = (SELECT ISNULL(MAX(RWNO), 0) + 1 FROM DataGuard.Package_Instance WHERE PAKG_SUB_SYS = S.PAKG_SUB_SYS AND PAKG_CODE = S.PAKG_CODE);
END
;
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [DataGuard].[CG$AUPD_PKIN]
   ON  [DataGuard].[Package_Instance]
   AFTER UPDATE
AS 
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

   -- Insert statements for trigger here
   MERGE [DataGuard].[Package_Instance] T
   USING (SELECT * FROM INSERTED) S
   ON (T.PAKG_SUB_SYS = S.PAKG_SUB_SYS AND
       T.PAKG_CODE    = S.PAKG_CODE    AND
       T.RWNO         = S.RWNO)
   WHEN MATCHED THEN
      UPDATE
         SET MDFY_BY   = UPPER(SUSER_NAME())
            ,MDFY_DATE = GETDATE();
END
;
GO
ALTER TABLE [DataGuard].[Package_Instance] ADD CONSTRAINT [PK_PKIN] PRIMARY KEY CLUSTERED  ([PAKG_SUB_SYS], [PAKG_CODE], [RWNO]) ON [PRIMARY]
GO
ALTER TABLE [DataGuard].[Package_Instance] ADD CONSTRAINT [FK_PKIN_PAKG] FOREIGN KEY ([PAKG_SUB_SYS], [PAKG_CODE]) REFERENCES [DataGuard].[Package] ([SUB_SYS], [CODE])
GO
EXEC sp_addextendedproperty N'MS_Description', N'تعداد محدودیت رکورد برای نرم افزار', 'SCHEMA', N'DataGuard', 'TABLE', N'Package_Instance', 'COLUMN', N'MAX_ROW'
GO
EXEC sp_addextendedproperty N'MS_Description', N'تعداد ردیف های ثبت شده', 'SCHEMA', N'DataGuard', 'TABLE', N'Package_Instance', 'COLUMN', N'ROW_COUNT'
GO
