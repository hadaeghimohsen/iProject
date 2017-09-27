CREATE TABLE [DataGuard].[Package_Instance_User_Qiuck_Action]
(
[PIUG_PKIN_PAKG_SUB_SYS] [int] NOT NULL,
[PIUG_PKIN_PAKG_CODE] [varchar] (3) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[PIUG_PKIN_RWNO] [int] NOT NULL,
[PIUG_USGW_GTWY_MAC_ADRS] [varchar] (17) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[PIUG_USER_ID] [bigint] NOT NULL,
[PIUG_USGW_RWNO] [int] NOT NULL,
[PKAC_SSIT_SUB_SYS] [int] NOT NULL,
[PKAC_SSIT_RWNO] [int] NOT NULL,
[PKAC_PKAG_SUB_SYS] [int] NOT NULL,
[PKAC_PAKG_CODE] [varchar] (3) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[ORDR] [int] NULL,
[STAT] [varchar] (3) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
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
CREATE TRIGGER [DataGuard].[CG$AINS_PIUQ]
   ON  [DataGuard].[Package_Instance_User_Qiuck_Action]
   AFTER INSERT
AS 
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for trigger here
   MERGE DataGuard.Package_Instance_User_Qiuck_Action T
   USING (SELECT * FROM Inserted) S
   ON (t.PIUG_PKIN_PAKG_SUB_SYS = s.PIUG_PKIN_PAKG_SUB_SYS AND 
       t.PIUG_PKIN_PAKG_CODE = s.PIUG_PKIN_PAKG_CODE AND 
       t.PIUG_PKIN_RWNO = s.PIUG_PKIN_RWNO AND
       t.PIUG_USGW_GTWY_MAC_ADRS = s.PIUG_USGW_GTWY_MAC_ADRS AND
       t.PIUG_USER_ID = s.PIUG_USER_ID AND 
       t.PIUG_USGW_RWNO = s.PIUG_USGW_RWNO AND 
       t.PKAC_SSIT_SUB_SYS = s.PKAC_SSIT_SUB_SYS AND
       t.PKAC_SSIT_RWNO = s.PKAC_SSIT_RWNO AND
       t.PKAC_PKAG_SUB_SYS = s.PKAC_PKAG_SUB_SYS AND
       t.PKAC_PAKG_CODE = s.PKAC_PAKG_CODE)
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
CREATE TRIGGER [DataGuard].[CG$AUPD_PIUQ]
   ON  [DataGuard].[Package_Instance_User_Qiuck_Action]
   AFTER UPDATE 
AS 
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for trigger here
   MERGE DataGuard.Package_Instance_User_Qiuck_Action T
   USING (SELECT * FROM Inserted) S
   ON (t.PIUG_PKIN_PAKG_SUB_SYS = s.PIUG_PKIN_PAKG_SUB_SYS AND 
       t.PIUG_PKIN_PAKG_CODE = s.PIUG_PKIN_PAKG_CODE AND 
       t.PIUG_PKIN_RWNO = s.PIUG_PKIN_RWNO AND
       t.PIUG_USGW_GTWY_MAC_ADRS = s.PIUG_USGW_GTWY_MAC_ADRS AND
       t.PIUG_USER_ID = s.PIUG_USER_ID AND 
       t.PIUG_USGW_RWNO = s.PIUG_USGW_RWNO AND 
       t.PKAC_SSIT_SUB_SYS = s.PKAC_SSIT_SUB_SYS AND
       t.PKAC_SSIT_RWNO = s.PKAC_SSIT_RWNO AND
       t.PKAC_PKAG_SUB_SYS = s.PKAC_PKAG_SUB_SYS AND
       t.PKAC_PAKG_CODE = s.PKAC_PAKG_CODE)
   WHEN MATCHED THEN
      UPDATE SET
         T.MDFY_BY = UPPER(SUSER_NAME())
        ,T.MDFY_DATE = GETDATE();
END
GO
ALTER TABLE [DataGuard].[Package_Instance_User_Qiuck_Action] ADD CONSTRAINT [PK_PIUQ] PRIMARY KEY CLUSTERED  ([PIUG_PKIN_PAKG_SUB_SYS], [PIUG_PKIN_PAKG_CODE], [PIUG_PKIN_RWNO], [PIUG_USGW_GTWY_MAC_ADRS], [PIUG_USER_ID], [PIUG_USGW_RWNO], [PKAC_SSIT_SUB_SYS], [PKAC_SSIT_RWNO], [PKAC_PKAG_SUB_SYS], [PKAC_PAKG_CODE]) ON [PRIMARY]
GO
ALTER TABLE [DataGuard].[Package_Instance_User_Qiuck_Action] ADD CONSTRAINT [FK_PIUQ_PIUG] FOREIGN KEY ([PIUG_PKIN_PAKG_SUB_SYS], [PIUG_PKIN_PAKG_CODE], [PIUG_PKIN_RWNO], [PIUG_USGW_GTWY_MAC_ADRS], [PIUG_USER_ID], [PIUG_USGW_RWNO]) REFERENCES [DataGuard].[Package_Instance_User_Gateway] ([PKIN_PAKG_SUB_SYS], [PKIN_PAKG_CODE], [PKIN_RWNO], [USGW_GTWY_MAC_ADRS], [USGW_USER_ID], [USGW_RWNO])
GO
ALTER TABLE [DataGuard].[Package_Instance_User_Qiuck_Action] ADD CONSTRAINT [FK_PIUQ_PKAC] FOREIGN KEY ([PKAC_SSIT_SUB_SYS], [PKAC_SSIT_RWNO], [PKAC_PKAG_SUB_SYS], [PKAC_PAKG_CODE]) REFERENCES [DataGuard].[Package_Activity] ([SSIT_SUB_SYS], [SSIT_RWNO], [PAKG_SUB_SYS], [PAKG_CODE])
GO
EXEC sp_addextendedproperty N'MS_Description', N'ترتیب قرار گیری دکمه ها', 'SCHEMA', N'DataGuard', 'TABLE', N'Package_Instance_User_Qiuck_Action', 'COLUMN', N'ORDR'
GO
