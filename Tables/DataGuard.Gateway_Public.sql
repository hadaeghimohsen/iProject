CREATE TABLE [DataGuard].[Gateway_Public]
(
[GTWY_MAC_ADRS] [varchar] (17) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[RECT_CODE] [varchar] (3) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[RWNO] [int] NOT NULL,
[IP] [varchar] (15) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[COMP_NAME] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CPU_SRNO] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[NAME] [nvarchar] (250) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DFLT_FACT] [varchar] (3) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[VALD_TYPE] [varchar] (3) COLLATE SQL_Latin1_General_CP1_CI_AS NULL CONSTRAINT [DF_Authorized_Entry_VALD_TYPE] DEFAULT ((2)),
[NEW_RQST] [varchar] (3) COLLATE SQL_Latin1_General_CP1_CI_AS NULL CONSTRAINT [DF_Authorized_Entry_NEW_RQST] DEFAULT ((2)),
[ACTN_DATE] [datetime] NULL,
[AUTH_TYPE] [varchar] (3) COLLATE SQL_Latin1_General_CP1_CI_AS NULL CONSTRAINT [DF_Authorized_Entry_AUTH_TYPE] DEFAULT ('001'),
[PORT] [int] NULL,
[RQST_JBQU_NUMB] [int] NULL,
[RQST_SEND] [varchar] (3) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[RQST_RCIV] [varchar] (3) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[UPDT_NEW_SERV_PRVD] [varchar] (3) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CYCL_GET_CACH_SERV_PRVD] [int] NULL,
[UPDT_NEW_CLNT_PRVD] [varchar] (3) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CYCL_SEND_INFO_PRVD_CLNT] [int] NULL,
[CNTR_PART] [int] NULL,
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
CREATE TRIGGER [DataGuard].[CG$ADEL_GWPB]
   ON  [DataGuard].[Gateway_Public]
   AFTER DELETE
AS 
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
   
   -- Insert statements for trigger here
   
   DECLARE C$GWPB CURSOR FOR
      SELECT GTWY_MAC_ADRS, RWNO FROM DELETED D 
       WHERE D.Rect_Code = '004';

   DECLARE @GtwyMacAdrs      VARCHAR(17)
          ,@Rwno             INT;
   
   OPEN C$GWPB;
   NextFromFGPB:
   FETCH NEXT FROM C$GWPB INTO @GtwyMacAdrs, @Rwno;
   
   -- UPDATE FIGHTER TABLE
   MERGE [DataGuard].Gateway T
   USING (SELECT * FROM Gateway_Public I 
           WHERE I.GTWY_MAC_ADRS = @GtwyMacAdrs
             AND I.RWNO = (SELECT MAX(RWNO) FROM Gateway_Public M 
                            WHERE M.GTWY_MAC_ADRS = I.GTWY_MAC_ADRS AND 
                                  M.RECT_CODE    = '004')) S
   ON (T.MAC_ADRS   = S.GTWY_MAC_ADRS AND
       S.RECT_CODE = '004')
   WHEN MATCHED THEN
      UPDATE 
         SET GWPB_RWNO_DNRM                = S.RWNO
            ,NAME_DNRM                     = S.NAME
            ,IP_DNRM                       = S.IP
            ,COMP_NAME_DNRM                = S.COMP_NAME
            ,CPU_SRNO_DNRM                 = S.CPU_SRNO
            ,DFLT_FACT_DNRM                = S.DFLT_FACT
            ,VALD_TYPE_DNRM                = S.VALD_TYPE
            ,AUTH_TYPE_DNRM                = S.AUTH_TYPE
            ,PORT_DNRM                     = S.[PORT]
            ,RQST_JBQU_NUMB_DNRM           = S.RQST_JBQU_NUMB
            ,RQST_SEND_DNRM                = S.RQST_SEND
            ,RQST_RCIV_DNRM                = S.RQST_RCIV
            ,UPDT_NEW_SERV_PRVD_DNRM       = S.UPDT_NEW_SERV_PRVD
            ,CYCL_GET_CACH_SERV_PRVD_DNRM  = S.CYCL_GET_CACH_SERV_PRVD
            ,UPDT_NEW_CLNT_PRVD_DNRM       = S.UPDT_NEW_CLNT_PRVD
            ,CYCL_SEND_INFO_PRVD_CLNT_DNRM = S.CYCL_SEND_INFO_PRVD_CLNT
            ,CNTR_PART_DNRM                = S.CNTR_PART;
   
   IF NOT EXISTS(SELECT * FROM Gateway_Public I
                  WHERE I.GTWY_MAC_ADRS = @GtwyMacAdrs
                    AND RECT_CODE = '004')
   BEGIN
      UPDATE Gateway
         SET GWPB_RWNO_DNRM                = NULL
            ,NAME_DNRM                     = NULL
            ,IP_DNRM                       = NULL
            ,COMP_NAME_DNRM                = NULL
            ,CPU_SRNO_DNRM                 = NULL
            ,DFLT_FACT_DNRM                = NULL
            ,VALD_TYPE_DNRM                = NULL
            ,AUTH_TYPE_DNRM                = NULL
            ,PORT_DNRM                     = NULL
            ,RQST_JBQU_NUMB_DNRM           = NULL
            ,RQST_SEND_DNRM                = NULL
            ,RQST_RCIV_DNRM                = NULL
            ,UPDT_NEW_SERV_PRVD_DNRM       = NULL
            ,CYCL_GET_CACH_SERV_PRVD_DNRM  = NULL
            ,UPDT_NEW_CLNT_PRVD_DNRM       = NULL
            ,CYCL_SEND_INFO_PRVD_CLNT_DNRM = NULL
            ,CNTR_PART_DNRM                = NULL
       WHERE MAC_ADRS = @GtwyMacAdrs;
   END

   CLOSE C$GWPB;
   DEALLOCATE C$GWPB;         
END
;
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [DataGuard].[CG$AINS_GWPB]
   ON  [DataGuard].[Gateway_Public]
   AFTER INSERT
AS 
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
   
   -- Insert statements for trigger here
   MERGE DataGuard.Gateway_Public T
   USING (SELECT * FROM INSERTED) S
   ON (T.GTWY_MAC_ADRS  = S.GTWY_MAC_ADRS AND
       T.RECT_CODE      = S.RECT_CODE   AND
       T.RWNO           = S.RWNO)
   WHEN MATCHED THEN
      UPDATE
         SET CRET_BY             = UPPER(SUSER_NAME())
            ,CRET_DATE           = GETDATE()
            ,ACTN_DATE           = GETDATE()
            ,NAME                = S.COMP_NAME + ' - ' + S.IP
            ,RWNO                = (SELECT ISNULL(MAX(RWNO), 0) + 1 FROM DataGuard.Gateway_Public WHERE GTWY_MAC_ADRS = S.GTWY_MAC_ADRS AND RECT_CODE = S.RECT_CODE);
END
;
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [DataGuard].[CG$AUPD_GWPB]
   ON  [DataGuard].[Gateway_Public]
   AFTER UPDATE
AS 
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
   --BEGIN TRAN TCG$AUPD_FGPB;
   -- Insert statements for trigger here
   
   DECLARE	@GTWY_MAC_ADRS VARCHAR(17),	   @RECT_CODE VARCHAR(3),
	         @RWNO int,	@IP VARCHAR(15),	   @COMP_NAME VARCHAR(50),
	         @NAME NVARCHAR(250),        	   @DFLT_FACT VARCHAR(3),
	         @VALD_TYPE VARCHAR(3),	         @NEW_RQST VARCHAR(3),
	         @ACTN_DATE datetime,	            @AUTH_TYPE VARCHAR(3),
	         @PORT int,	                     @RQST_JBQU_NUMB int,
	         @RQST_SEND VARCHAR(3),	         @RQST_RCIV VARCHAR(3),
	         @UPDT_NEW_SERV_PRVD VARCHAR(3),	@CYCL_GET_CACH_SERV_PRVD int,
	         @UPDT_NEW_CLNT_PRVD VARCHAR(3),	@CYCL_SEND_INFO_PRVD_CLNT int,
	         @CNTR_PART int,                  @CPU_SRNO VARCHAR(30);
   
   -- FETCH LAST INFORMATION;
   SELECT TOP 1
     @GTWY_MAC_ADRS      = T.GTWY_MAC_ADRS     , @RECT_CODE = T.RECT_CODE,
     @RWNO               = T.RWNO              , @COMP_NAME = T.COMP_NAME,
     @NAME               = T.NAME              , @DFLT_FACT = T.DFLT_FACT,
     @VALD_TYPE          = T.VALD_TYPE         , @NEW_RQST  = T.NEW_RQST,
     @ACTN_DATE          = T.ACTN_DATE         , @AUTH_TYPE = T.AUTH_TYPE,
     @PORT               = T.PORT              , @RQST_JBQU_NUMB = T.RQST_JBQU_NUMB,
     @RQST_SEND          = T.RQST_SEND         , @RQST_RCIV = T.RQST_RCIV,
     @UPDT_NEW_SERV_PRVD = T.UPDT_NEW_SERV_PRVD, @CYCL_GET_CACH_SERV_PRVD = T.CYCL_GET_CACH_SERV_PRVD,
     @UPDT_NEW_CLNT_PRVD = T.UPDT_NEW_CLNT_PRVD, @CYCL_SEND_INFO_PRVD_CLNT = T.CYCL_SEND_INFO_PRVD_CLNT,
     @CNTR_PART          = T.CNTR_PART         , @IP = T.IP,
     @CPU_SRNO           = T.CPU_SRNO
     FROM [DataGuard].[Gateway_Public] T , INSERTED S
     WHERE T.GTWY_MAC_ADRS   = S.GTWY_MAC_ADRS
     ORDER BY T.RWNO DESC, T.CRET_DATE DESC;
   
   MERGE DataGuard.Gateway_Public T
   USING (SELECT * FROM INSERTED) S
   ON (T.GTWY_MAC_ADRS  = S.GTWY_MAC_ADRS AND
       T.RECT_CODE      = S.RECT_CODE)
   WHEN MATCHED THEN
      UPDATE
         SET MDFY_BY                  = UPPER(SUSER_NAME())
            ,MDFY_DATE                = GETDATE()
            ,GTWY_MAC_ADRS            = CASE S.GTWY_MAC_ADRS  WHEN NULL THEN @GTWY_MAC_ADRS                      ELSE S.GTWY_MAC_ADRS            END
	         ,IP  	                    = CASE S.IP             WHEN NULL THEN @IP                                 ELSE S.IP                       END
	         ,COMP_NAME                = CASE S.COMP_NAME      WHEN NULL THEN @COMP_NAME                          ELSE S.COMP_NAME                END
	         ,CPU_SRNO                 = CASE S.CPU_SRNO       WHEN NULL THEN @CPU_SRNO                           ELSE S.CPU_SRNO                 END
	         ,NAME                     = CASE S.NAME           WHEN NULL THEN @NAME                               ELSE S.NAME                     END
	         ,DFLT_FACT                = CASE S.DFLT_FACT      WHEN NULL THEN @DFLT_FACT                          ELSE S.DFLT_FACT                END
	         ,VALD_TYPE                = CASE S.VALD_TYPE      WHEN NULL THEN @VALD_TYPE                          ELSE S.VALD_TYPE                END
	         ,NEW_RQST                 = CASE S.NEW_RQST       WHEN NULL THEN @NEW_RQST                           ELSE S.NEW_RQST                 END
	         ,ACTN_DATE                = CASE S.ACTN_DATE      WHEN NULL THEN @ACTN_DATE                          ELSE S.ACTN_DATE                END
	         ,AUTH_TYPE                = CASE S.AUTH_TYPE      WHEN NULL THEN @AUTH_TYPE                          ELSE S.AUTH_TYPE                END
	         ,PORT                     = CASE S.PORT           WHEN NULL THEN @PORT                               ELSE S.PORT                     END
	         ,RQST_JBQU_NUMB           = CASE S.RQST_JBQU_NUMB WHEN NULL THEN @RQST_JBQU_NUMB                     ELSE S.RQST_JBQU_NUMB           END
	         ,RQST_SEND                = CASE S.RQST_SEND      WHEN NULL THEN @RQST_SEND                          ELSE S.RQST_SEND                END
	         ,RQST_RCIV                = CASE S.RQST_RCIV      WHEN NULL THEN @RQST_RCIV                          ELSE S.RQST_RCIV                END
	         ,UPDT_NEW_SERV_PRVD       = CASE S.UPDT_NEW_SERV_PRVD       WHEN NULL THEN @UPDT_NEW_SERV_PRVD       ELSE S.UPDT_NEW_SERV_PRVD       END
	         ,CYCL_GET_CACH_SERV_PRVD  = CASE S.CYCL_GET_CACH_SERV_PRVD  WHEN NULL THEN @CYCL_GET_CACH_SERV_PRVD  ELSE S.CYCL_GET_CACH_SERV_PRVD  END
	         ,UPDT_NEW_CLNT_PRVD       = CASE S.UPDT_NEW_CLNT_PRVD       WHEN NULL THEN @UPDT_NEW_CLNT_PRVD       ELSE S.UPDT_NEW_CLNT_PRVD       END
	         ,CYCL_SEND_INFO_PRVD_CLNT = CASE S.CYCL_SEND_INFO_PRVD_CLNT WHEN NULL THEN @CYCL_SEND_INFO_PRVD_CLNT ELSE S.CYCL_SEND_INFO_PRVD_CLNT END
	         ,CNTR_PART                = CASE S.CNTR_PART                WHEN NULL THEN @CNTR_PART                ELSE S.CNTR_PART                END;
            
   MERGE DataGuard.Gateway T
   USING (SELECT * FROM INSERTED I 
           WHERE I.RWNO = (SELECT MAX(RWNO) FROM Gateway_Public M 
                            WHERE M.GTWY_MAC_ADRS = I.GTWY_MAC_ADRS AND 
                                  M.RECT_CODE    = '004')) S
   ON (T.MAC_ADRS   = S.GTWY_MAC_ADRS AND
       S.RECT_CODE = '004')
   WHEN MATCHED THEN
      UPDATE 
         SET GWPB_RWNO_DNRM                = S.RWNO
            ,NAME_DNRM                     = S.NAME
            ,IP_DNRM                       = S.IP
            ,COMP_NAME_DNRM                = S.COMP_NAME
            ,CPU_SRNO_DNRM                 = S.CPU_SRNO
            ,DFLT_FACT_DNRM                = S.DFLT_FACT
            ,VALD_TYPE_DNRM                = S.VALD_TYPE
            ,AUTH_TYPE_DNRM                = S.AUTH_TYPE
            ,PORT_DNRM                     = S.[PORT]
            ,RQST_JBQU_NUMB_DNRM           = S.RQST_JBQU_NUMB
            ,RQST_SEND_DNRM                = S.RQST_SEND
            ,RQST_RCIV_DNRM                = S.RQST_RCIV
            ,UPDT_NEW_SERV_PRVD_DNRM       = S.UPDT_NEW_SERV_PRVD
            ,CYCL_GET_CACH_SERV_PRVD_DNRM  = S.CYCL_GET_CACH_SERV_PRVD
            ,UPDT_NEW_CLNT_PRVD_DNRM       = S.UPDT_NEW_CLNT_PRVD
            ,CYCL_SEND_INFO_PRVD_CLNT_DNRM = S.CYCL_SEND_INFO_PRVD_CLNT
            ,CNTR_PART_DNRM                = S.CNTR_PART;
END
;
GO
ALTER TABLE [DataGuard].[Gateway_Public] ADD CONSTRAINT [PK_GWPB] PRIMARY KEY CLUSTERED  ([GTWY_MAC_ADRS], [RECT_CODE], [RWNO]) ON [PRIMARY]
GO
ALTER TABLE [DataGuard].[Gateway_Public] ADD CONSTRAINT [FK_GWPB_GTWY] FOREIGN KEY ([GTWY_MAC_ADRS]) REFERENCES [DataGuard].[Gateway] ([MAC_ADRS])
GO
EXEC sp_addextendedproperty N'MS_Description', N'تاریخ اقدام', 'SCHEMA', N'DataGuard', 'TABLE', N'Gateway_Public', 'COLUMN', N'ACTN_DATE'
GO
EXEC sp_addextendedproperty N'MS_Description', N'درخواست جدید برای شروع فعالیت', 'SCHEMA', N'DataGuard', 'TABLE', N'Gateway_Public', 'COLUMN', N'NEW_RQST'
GO
EXEC sp_addextendedproperty N'MS_Description', N'آیا معتبر است؟', 'SCHEMA', N'DataGuard', 'TABLE', N'Gateway_Public', 'COLUMN', N'VALD_TYPE'
GO
