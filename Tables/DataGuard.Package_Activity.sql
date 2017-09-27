CREATE TABLE [DataGuard].[Package_Activity]
(
[SSIT_SUB_SYS] [int] NOT NULL,
[SSIT_RWNO] [int] NOT NULL,
[PAKG_SUB_SYS] [int] NOT NULL,
[PAKG_CODE] [varchar] (3) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[STAT] [varchar] (3) COLLATE SQL_Latin1_General_CP1_CI_AS NULL CONSTRAINT [DF_Package_Activity_STAT] DEFAULT ('002'),
[STRT_DATE] [date] NULL,
[END_DATE] [date] NULL,
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
CREATE TRIGGER [DataGuard].[CG$AINS_PKAC]
   ON  [DataGuard].[Package_Activity]
   AFTER INSERT
AS 
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

   -- Insert statements for trigger here
   MERGE [DataGuard].[Package_Activity] T
   USING (SELECT * FROM INSERTED) S
   ON (T.SSIT_SUB_SYS      = S.SSIT_SUB_SYS AND
       T.SSIT_RWNO         = S.SSIT_RWNO    AND
       T.PAKG_SUB_SYS      = S.PAKG_SUB_SYS AND
       T.PAKG_CODE         = S.PAKG_CODE)
   WHEN MATCHED THEN
      UPDATE
         SET CRET_BY   = UPPER(SUSER_NAME())
            ,CRET_DATE = GETDATE();
END
;
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [DataGuard].[CG$AUPD_PKAC]
   ON  [DataGuard].[Package_Activity]
   AFTER UPDATE
AS 
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

   -- Insert statements for trigger here
   MERGE [DataGuard].[Package_Activity] T
   USING (SELECT * FROM INSERTED) S
   ON (T.SSIT_SUB_SYS      = S.SSIT_SUB_SYS AND
       T.SSIT_RWNO         = S.SSIT_RWNO    AND
       T.PAKG_SUB_SYS      = S.PAKG_SUB_SYS AND
       T.PAKG_CODE         = S.PAKG_CODE)
   WHEN MATCHED THEN
      UPDATE
         SET MDFY_BY   = UPPER(SUSER_NAME())
            ,MDFY_DATE = GETDATE();
END
;
GO
ALTER TABLE [DataGuard].[Package_Activity] ADD CONSTRAINT [PK_PKAC] PRIMARY KEY CLUSTERED  ([SSIT_SUB_SYS], [SSIT_RWNO], [PAKG_SUB_SYS], [PAKG_CODE]) ON [PRIMARY]
GO
ALTER TABLE [DataGuard].[Package_Activity] ADD CONSTRAINT [FK_PKAC_PAKG] FOREIGN KEY ([PAKG_SUB_SYS], [PAKG_CODE]) REFERENCES [DataGuard].[Package] ([SUB_SYS], [CODE])
GO
ALTER TABLE [DataGuard].[Package_Activity] ADD CONSTRAINT [FK_PKAC_SSIT] FOREIGN KEY ([SSIT_SUB_SYS], [SSIT_RWNO]) REFERENCES [DataGuard].[Sub_System_Item] ([SUB_SYS], [RWNO])
GO
EXEC sp_addextendedproperty N'MS_Description', N'تاریخ پایان استفاده از آیتم', 'SCHEMA', N'DataGuard', 'TABLE', N'Package_Activity', 'COLUMN', N'END_DATE'
GO
EXEC sp_addextendedproperty N'MS_Description', N'تاریخ شروه استفاده از آیتم', 'SCHEMA', N'DataGuard', 'TABLE', N'Package_Activity', 'COLUMN', N'STRT_DATE'
GO
