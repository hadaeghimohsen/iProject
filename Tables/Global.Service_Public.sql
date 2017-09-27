CREATE TABLE [Global].[Service_Public]
(
[BLOK_WDAY_REGN_PRVN_CNTY_CODE] [varchar] (3) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[BLOK_WDAY_REGN_PRVN_CODE] [varchar] (3) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[BLOK_WDAY_REGN_CODE] [varchar] (3) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[BLOK_WDAY_CODE] [varchar] (2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[BLOK_CODE] [varchar] (2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SERV_FILE_NO] [bigint] NOT NULL,
[RWNO] [int] NOT NULL,
[RECT_CODE] [varchar] (3) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[REF_FILE_NO] [bigint] NULL,
[SUNT_BUNT_DEPT_ORGN_CODE] [varchar] (2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SUNT_BUNT_DEPT_CODE] [varchar] (2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SUNT_BUNT_CODE] [varchar] (2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SUNT_CODE] [varchar] (4) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ISCP_ISCA_ISCG_CODE] [varchar] (2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ISCP_ISCA_CODE] [varchar] (2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ISCP_CODE] [varchar] (6) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[NAME] [nvarchar] (250) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SEX_TYPE] [varchar] (3) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SERV_ADRS] [nvarchar] (1000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CELL_PHON] [varchar] (15) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[TELL_PHON] [varchar] (15) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CORD_X] [float] NULL,
[CORD_Y] [float] NULL,
[SEQ] [int] NULL,
[TARF_CODE] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SERV_TYPE] [varchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ZONE_CODE] [varchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[FMLY_NUMB] [int] NULL,
[ZIP_CODE] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[EMIL_ADDR] [varchar] (500) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[HSPL_CODE] [varchar] (15) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[RISK_CODE] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SHAD_CODE] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
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
CREATE TRIGGER [Global].[CG$AINS_SRPB]
   ON  [Global].[Service_Public]
   AFTER INSERT
AS 
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
   
   L$SetFileNo:
   DECLARE @FileNo BIGINT = dbo.GetNewVerIdentity();
   IF EXISTS (SELECT * FROM Global.Service_Public WHERE SERV_FILE_NO = @Fileno)
      GOTO L$SetFileNo;

   --PRINT @FileNo;
   
   -- Insert statements for trigger here
   MERGE Global.Service_Public T
   USING (SELECT * FROM INSERTED) S
   ON (T.SERV_FILE_NO   = S.SERV_FILE_NO   AND
       T.REF_FILE_NO    = S.REF_FILE_NO AND
       T.RECT_CODE      = S.RECT_CODE AND 
       t.BLOK_WDAY_REGN_PRVN_CODE = s.BLOK_WDAY_REGN_PRVN_CODE)
   WHEN MATCHED THEN
      UPDATE
         SET T.CRET_BY             = UPPER(SUSER_NAME())
            ,T.CRET_DATE           = GETDATE()
            ,T.SERV_FILE_NO        = @FileNo
            ,T.RWNO                = (SELECT ISNULL(MAX(RWNO), 0) + 1 FROM Global.Service_Public WHERE SERV_FILE_NO = S.SERV_FILE_NO AND RECT_CODE = S.RECT_CODE AND REF_FILE_NO = S.REF_FILE_NO AND BLOK_WDAY_REGN_PRVN_CODE = s.BLOK_WDAY_REGN_PRVN_CODE);
END
;
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CReate TRIGGER [Global].[CG$AUPD_SRPB]
   ON  [Global].[Service_Public]
   AFTER UPDATE
AS 
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
   
   -- Insert statements for trigger here
   MERGE Global.Service_Public T
   USING (SELECT * FROM INSERTED) S
   ON (T.SERV_FILE_NO   = S.SERV_FILE_NO   AND
       T.REF_FILE_NO    = S.REF_FILE_NO AND
       T.RECT_CODE      = S.RECT_CODE AND 
       T.RWNO = S.RWNO)
   WHEN MATCHED THEN
      UPDATE
         SET MDFY_BY             = UPPER(SUSER_NAME())
            ,MDFY_DATE           = GETDATE();
   
   -- UPDATE Service TABLE
   MERGE Global.Service T
   USING (SELECT * FROM INSERTED I 
           WHERE I.RWNO = (SELECT MAX(RWNO) FROM Global.Service_PUBLIC M 
                            WHERE M.SERV_FILE_NO = I.SERV_FILE_NO AND 
                                  M.RECT_CODE    = '004')) S
   ON (T.FILE_NO   = S.SERV_FILE_NO AND
       S.RECT_CODE = '004')
   WHEN MATCHED THEN
      UPDATE 
         SET T.BLOK_WDAY_REGN_PRVN_CNTY_CODE = s.BLOK_WDAY_REGN_PRVN_CNTY_CODE
            ,t.BLOK_WDAY_REGN_PRVN_CODE = s.BLOK_WDAY_REGN_PRVN_CODE
            ,t.BLOK_WDAY_REGN_CODE = s.BLOK_WDAY_REGN_CODE
            ,t.BLOK_WDAY_CODE = s.BLOK_WDAY_CODE
            ,t.BLOK_CODE = s.BLOK_CODE
            ,T.REF_FILE_NO_DNRM = s.REF_FILE_NO
            ,T.SRPB_RWNO_DNRM = s.RWNO
            ,t.SUNT_BUNT_DEPT_ORGN_CODE_DNRM = s.SUNT_BUNT_DEPT_ORGN_CODE
            ,t.SUNT_BUNT_DEPT_CODE_DNRM = s.SUNT_BUNT_DEPT_CODE
            ,t.SUNT_BUNT_CODE_DNRM = s.SUNT_BUNT_CODE
            ,t.SUNT_CODE_DNRM = s.SUNT_CODE
            ,t.ISCP_ISCA_ISCG_CODE_DNRM = s.ISCP_ISCA_ISCG_CODE
            ,t.ISCP_ISCA_CODE_DNRM = s.ISCP_ISCA_CODE
            ,t.ISCP_CODE_DNRM = s.ISCP_CODE
            ,t.NAME_DNRM = s.NAME
            ,T.SEX_TYPE_DNRM = s.SEX_TYPE
            ,t.SERV_ADRS_DNRM = s.SERV_ADRS
            ,t.CELL_PHON_DNRM = s.CELL_PHON
            ,t.TELL_PHON_DNRM = s.TELL_PHON
            ,t.CORD_X_DNRM = s.CORD_X
            ,t.CORD_Y_DNRM = s.CORD_Y
            ,T.SEQ_DNRM = s.SEQ
            ,t.TARF_CODE_DNRM = s.TARF_CODE
            ,t.SERV_TYPE_DNRM = s.SERV_TYPE
            ,T.ZONE_CODE_DNRM = s.ZONE_CODE
            ,t.FMLY_NUMB_DNRM = s.FMLY_NUMB
            ,t.ZIP_CODE_DNRM = s.ZIP_CODE
            ,t.EMIL_ADDR_DNRM = s.EMIL_ADDR
            ,t.HSPL_CODE_DNRM = s.HSPL_CODE
            ,t.RISK_CODE_DNRM = s.RISK_CODE
            ,t.SHAD_CODE_DNRM = s.SHAD_CODE;
END
;
GO
ALTER TABLE [Global].[Service_Public] ADD CONSTRAINT [PK_SRPB] PRIMARY KEY CLUSTERED  ([SERV_FILE_NO], [RWNO], [RECT_CODE]) ON [BLOB]
GO
ALTER TABLE [Global].[Service_Public] ADD CONSTRAINT [FK_SRPB_BLOK] FOREIGN KEY ([BLOK_WDAY_REGN_PRVN_CNTY_CODE], [BLOK_WDAY_REGN_PRVN_CODE], [BLOK_WDAY_REGN_CODE], [BLOK_WDAY_CODE], [BLOK_CODE]) REFERENCES [Global].[Block] ([WDAY_REGN_PRVN_CNTY_CODE], [WDAY_REGN_PRVN_CODE], [WDAY_REGN_CODE], [WDAY_CODE], [CODE])
GO
ALTER TABLE [Global].[Service_Public] ADD CONSTRAINT [FK_SRPB_ISCP] FOREIGN KEY ([ISCP_ISCA_ISCG_CODE], [ISCP_ISCA_CODE], [ISCP_CODE]) REFERENCES [Global].[Isic_Product] ([ISCA_ISCG_CODE], [ISCA_CODE], [CODE])
GO
ALTER TABLE [Global].[Service_Public] ADD CONSTRAINT [FK_SRPB_SUNT] FOREIGN KEY ([SUNT_BUNT_DEPT_ORGN_CODE], [SUNT_BUNT_DEPT_CODE], [SUNT_BUNT_CODE], [SUNT_CODE]) REFERENCES [Global].[Sub_Unit] ([BUNT_DEPT_ORGN_CODE], [BUNT_DEPT_CODE], [BUNT_CODE], [CODE])
GO
