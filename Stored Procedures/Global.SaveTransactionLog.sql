SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [Global].[SaveTransactionLog]
	-- Add the parameters for the stored procedure here
	@X XML OUTPUT
AS
BEGIN
   BEGIN TRY
   BEGIN TRAN SaveTransactionLog_T
	   -- SET NOCOUNT ON added to prevent extra result sets from
	   -- interfering with SELECT statements.
	   SET NOCOUNT ON;
      
      DECLARE @Psid BIGINT             
             ,@SubSys INT
             ,@Rqid BIGINT
             ,@RqtpCode VARCHAR(3)
             ,@Tlid BIGINT
             ,@Amnt BIGINT
             ,@IssuDate DATETIME
             ,@RespCode VARCHAR(3)
             ,@RespDesc NVARCHAR(100)
             ,@CardNo VARCHAR(20)             
             ,@TermNo VARCHAR(20)
             ,@TranNo VARCHAR(20)
             ,@FlowNo VARCHAR(20)
             ,@RefNo VARCHAR(20)
             ,@SerlNo VARCHAR(20)
             ,@GtwyMacAdrs VARCHAR(17);
           
      SELECT @Psid = @X.query('PosRequest').value('(PosRequest/@psid)[1]', 'BIGINT')
            ,@SubSys = @X.query('PosRequest').value('(PosRequest/@subsys)[1]', 'INT')
            ,@GtwyMacAdrs = @X.query('PosRequest').value('(PosRequest/@gtwymacadrs)[1]', 'VARCHAR(17)')
            ,@Rqid = @X.query('PosRequest').value('(PosRequest/@rqid)[1]', 'BIGINT')
            ,@RqtpCode = @X.query('PosRequest').value('(PosRequest/@rqtpcode)[1]', 'VARCHAR(3)')
            ,@Tlid = @X.query('PosRequest').value('(PosRequest/@tlid)[1]', 'BIGINT')
            ,@Amnt = @X.query('PosRequest').value('(PosRequest/@amnt)[1]', 'BIGINT')
            ,@IssuDate = @X.query('PosRequest').value('(PosRequest/@issudate)[1]', 'DATETIME')
            ,@RespCode = @X.query('PosRequest').value('(PosRequest/@respcode)[1]', 'VARCHAR(3)')
            ,@RespDesc = @X.query('PosRequest').value('(PosRequest/@respdesc)[1]', 'NVARCHAR(100)')
            ,@CardNo = @X.query('PosRequest').value('(PosRequest/@cardno)[1]', 'VARCHAR(20)')
            ,@TermNo = @X.query('PosRequest').value('(PosRequest/@termno)[1]', 'VARCHAR(20)')
            ,@TranNo = @X.query('PosRequest').value('(PosRequest/@tranno)[1]', 'VARCHAR(20)')
            ,@FlowNo = @X.query('PosRequest').value('(PosRequest/@flowno)[1]', 'VARCHAR(20)')
            ,@RefNo = @X.query('PosRequest').value('(PosRequest/@refno)[1]', 'VARCHAR(20)')
            ,@SerlNo = @X.query('PosRequest').value('(PosRequest/@serlno)[1]', 'VARCHAR(20)');      
      
      IF @Psid = 0 RAISERROR(N'دستگاه پوز خود را مشخص نکرده اید', 16, 1);
      IF @Amnt = 0 RAISERROR(N'مبلغ تراکنش باید از 1000 ریال بزرگتر یا مساوی باشد', 16, 1);
      
      IF @Rqid = 0 SELECT @Rqid = NULL, @RqtpCode = NULL;
      
      IF @RespCode = '' SELECT @RespCode = NULL;
      IF @TermNo = '' SELECT @TermNo = NULL, @SerlNo = NULL, @CardNo = NULL, @TranNo = NULL, @FlowNo = NULL, @RefNo = NULL
      
      IF @Tlid = 0
      BEGIN      
         INSERT INTO Global.Transaction_Log( POSD_PSID , GTWY_MAC_ADRS,SUB_SYS ,RQID ,RQTP_CODE ,TLID ,TRAN_DATE ,AMNT ,PAY_STAT ,ISSU_DATE ,RESP_CODE ,TERM_NO ,TRAN_NO ,CARD_NO ,FLOW_NO ,REF_NO ,SERL_NO)
         VALUES  ( @Psid , @GtwyMacAdrs,@SubSys ,@Rqid ,@RqtpCode , 0 , GETDATE() ,@Amnt , '001' , NULL , NULL , @TermNo ,NULL , @CardNo , NULL , NULL , @SerlNo);   
         
         SELECT TOP 1 @Tlid = TLID
           FROM Global.Transaction_Log
          WHERE POSD_PSID = @Psid
            AND GTWY_MAC_ADRS = @GtwyMacAdrs
            AND SUB_SYS = @SubSys
            AND ISNULL(RQID, 0) = ISNULL(@Rqid, 0)
            AND AMNT = @Amnt
            AND CRET_BY = UPPER(SUSER_NAME())
            AND CAST(TRAN_DATE AS DATE) = CAST(GETDATE() AS DATE)
            AND PAY_STAT = '001'
       ORDER BY CRET_DATE DESC;
         
         IF @Tlid IS NULL RAISERROR(N'ثبت تراکنش در جدول سوابق پرداخت دستگاه های پوز با اشکال مواجه شد، لطفا دوباره تلاش کنید', 16, 1);         
      END
      ELSE IF @Tlid != 0
      BEGIN
         IF @Tlid IS NULL RAISERROR(N'شماره سابقه تراکنش مشخصی در سیستم ثبت نشده است، لطفا بررسی کنید', 16, 1);
         UPDATE Global.Transaction_Log
            SET PAY_STAT = CASE WHEN dbo.PADSTR(@RespCode, 3) IN ('000', '100') THEN '002' ELSE '001' END
               ,ISSU_DATE = CASE WHEN dbo.PADSTR(@RespCode, 3) IN ('000', '100') THEN GETDATE() ELSE NULL END
               ,RESP_CODE = dbo.PADSTR(@RespCode, 3)
               ,RESP_DESC = @RespDesc
               ,CARD_NO = @CardNo
               ,TERM_NO = @TermNo
               ,TRAN_NO = @TranNo               
               ,FLOW_NO = @FlowNo
               ,REF_NO = @RefNo
               ,SERL_NO = @SerlNo
          WHERE TLID = @Tlid;
      END
      
      SELECT @X = (
         SELECT @Tlid AS '@tlid'
            FOR XML PATH('PosResult')
      );
   COMMIT TRAN SaveTransactionLog_T;
   END TRY
   BEGIN CATCH
      DECLARE @ErrorMessage NVARCHAR(MAX);
	   SET @ErrorMessage = ERROR_MESSAGE();
      RAISERROR ( @ErrorMessage, -- Message text.
               16, -- Severity.
               1 -- State.
               );
      ROLLBACK TRAN SaveTransactionLog_T;
   END CATCH;
   
END
GO
