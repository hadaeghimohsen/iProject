CREATE TABLE [Global].[Service]
(
[BLOK_WDAY_REGN_PRVN_CNTY_CODE] [varchar] (3) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[BLOK_WDAY_REGN_PRVN_CODE] [varchar] (3) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[BLOK_WDAY_REGN_CODE] [varchar] (3) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[BLOK_WDAY_CODE] [varchar] (2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[BLOK_CODE] [varchar] (2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[FILE_NO] [bigint] NOT NULL,
[REF_FILE_NO_DNRM] [bigint] NULL,
[SRPB_RWNO_DNRM] [int] NULL,
[SUNT_BUNT_DEPT_ORGN_CODE_DNRM] [varchar] (2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SUNT_BUNT_DEPT_CODE_DNRM] [varchar] (2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SUNT_BUNT_CODE_DNRM] [varchar] (2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SUNT_CODE_DNRM] [varchar] (4) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ISCP_ISCA_ISCG_CODE_DNRM] [varchar] (2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ISCP_ISCA_CODE_DNRM] [varchar] (2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ISCP_CODE_DNRM] [varchar] (6) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CONF_STAT] [varchar] (3) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[NAME_DNRM] [nvarchar] (250) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SEX_TYPE_DNRM] [varchar] (3) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SERV_ADRS_DNRM] [nvarchar] (1000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CELL_PHON_DNRM] [varchar] (15) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[TELL_PHON_DNRM] [varchar] (15) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CORD_X_DNRM] [float] NULL,
[CORD_Y_DNRM] [float] NULL,
[SEQ_DNRM] [int] NULL,
[TARF_CODE_DNRM] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SERV_TYPE_DNRM] [varchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ZONE_CODE_DNRM] [varchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[FMLY_NUMB_DNRM] [int] NULL,
[ZIP_CODE_DNRM] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[EMIL_ADDR_DNRM] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[HSPL_CODE_DNRM] [varchar] (15) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[RISK_CODE_DNRM] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SHAD_CODE_DNRM] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CRET_BY] [varchar] (250) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CRET_DATE] [datetime] NULL,
[MDFY_BY] [varchar] (250) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[MDFY_DATE] [datetime] NULL
) ON [BLOB]
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
CREATE TRIGGER [Global].[CG$AINS_SERV]
   ON  [Global].[Service]
   AFTER insert
AS 
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
   
   L$SetFileNo:
   DECLARE @FileNo BIGINT = dbo.GetNewVerIdentity();
   IF EXISTS (SELECT * FROM Global.Service WHERE FILE_NO = @Fileno)
      GOTO L$SetFileNo;
      
    -- Insert statements for trigger here
   MERGE Global.Service T
   USING (SELECT * FROM Inserted) S
   ON (t.FILE_NO = s.FILE_NO AND 
       t.REF_FILE_NO_DNRM = s.REF_FILE_NO_DNRM AND 
       t.BLOK_WDAY_REGN_PRVN_CODE = s.BLOK_WDAY_REGN_PRVN_CODE)
   WHEN MATCHED THEN
      UPDATE SET
         t.CRET_BY = UPPER(SUSER_NAME())
        ,t.CRET_DATE = GETDATE()
        ,t.FILE_NO = @FileNo;
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
CREATE TRIGGER [Global].[CG$AUPD_SERV]
   ON  [Global].[Service]
   AFTER update
AS 
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
   
    -- Insert statements for trigger here
   MERGE Global.Service T
   USING (SELECT * FROM Inserted) S
   ON (t.FILE_NO = s.FILE_NO)
   WHEN MATCHED THEN
      UPDATE SET
         t.MDFY_BY = UPPER(SUSER_NAME())
        ,t.MDFY_DATE = GETDATE();

END
GO
ALTER TABLE [Global].[Service] ADD CONSTRAINT [PK_SERV] PRIMARY KEY CLUSTERED  ([FILE_NO]) ON [BLOB]
GO
ALTER TABLE [Global].[Service] ADD CONSTRAINT [FK_SERV_BLOK] FOREIGN KEY ([BLOK_WDAY_REGN_PRVN_CNTY_CODE], [BLOK_WDAY_REGN_PRVN_CODE], [BLOK_WDAY_REGN_CODE], [BLOK_WDAY_CODE], [BLOK_CODE]) REFERENCES [Global].[Block] ([WDAY_REGN_PRVN_CNTY_CODE], [WDAY_REGN_PRVN_CODE], [WDAY_REGN_CODE], [WDAY_CODE], [CODE])
GO
ALTER TABLE [Global].[Service] ADD CONSTRAINT [FK_SERV_ISCP] FOREIGN KEY ([ISCP_ISCA_ISCG_CODE_DNRM], [ISCP_ISCA_CODE_DNRM], [ISCP_CODE_DNRM]) REFERENCES [Global].[Isic_Product] ([ISCA_ISCG_CODE], [ISCA_CODE], [CODE])
GO
ALTER TABLE [Global].[Service] ADD CONSTRAINT [FK_SERV_SUNT] FOREIGN KEY ([SUNT_BUNT_DEPT_ORGN_CODE_DNRM], [SUNT_BUNT_DEPT_CODE_DNRM], [SUNT_BUNT_CODE_DNRM], [SUNT_CODE_DNRM]) REFERENCES [Global].[Sub_Unit] ([BUNT_DEPT_ORGN_CODE], [BUNT_DEPT_CODE], [BUNT_CODE], [CODE])
GO
