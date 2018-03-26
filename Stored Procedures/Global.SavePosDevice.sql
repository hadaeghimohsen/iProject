SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [Global].[SavePosDevice]
	-- Add the parameters for the stored procedure here
	@X XML
AS
BEGIN   
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

   BEGIN TRY
   BEGIN TRAN SavePosDevice_Tran
      DECLARE @Psid BIGINT
             ,@BankType VARCHAR(3)
             ,@BnkbCode VARCHAR(10)
             ,@BnkaAcntNumb VARCHAR(15)
             ,@ShbaCode VARCHAR(50)
             ,@PosDesc NVARCHAR(250)
             ,@PosStat VARCHAR(3)
             ,@PosDflt VARCHAR(3)
             ,@PosCnctType VARCHAR(3)
             ,@IPAdrs VARCHAR(15)
             ,@CommPort VARCHAR(15)
             ,@BandRate INT
             ,@PrntSale NVARCHAR(250)
             ,@PrntCust NVARCHAR(250)
             ,@AutoComm VARCHAR(3);
      
      SELECT @Psid = @X.query('Pos').value('(Pos/@psid)[1]', 'BIGINT')
            ,@BankType = @X.query('Pos').value('(Pos/@banktype)[1]', 'VARCHAR(3)')
            ,@BnkbCode = @X.query('Pos').value('(Pos/@bnkbcode)[1]', 'VARCHAR(10)')
            ,@BnkaAcntNumb = @X.query('Pos').value('(Pos/@bnkaacntnumb)[1]', 'VARCHAR(15)')
            ,@ShbaCode = @X.query('Pos').value('(Pos/@shbacode)[1]', 'VARCHAR(50)')
            ,@PosDesc = @X.query('Pos').value('(Pos/@posdesc)[1]', 'NVARCHAR(250)')
            ,@PosStat = @X.query('Pos').value('(Pos/@posstat)[1]', 'VARCHAR(3)')
            ,@PosDflt = @X.query('Pos').value('(Pos/@posdflt)[1]', 'VARCHAR(3)')
            ,@PosCnctType = @X.query('Pos').value('(Pos/@poscncttype)[1]', 'VARCHAR(3)')
            ,@IPAdrs = @X.query('Pos').value('(Pos/@ipadrs)[1]', 'VARCHAR(15)')
            ,@CommPort = @X.query('Pos').value('(Pos/@commport)[1]', 'VARCHAR(15)')
            ,@BandRate = @X.query('Pos').value('(Pos/@bandrate)[1]', 'INT')
            ,@PrntSale = @X.query('Pos').value('(Pos/@prntsale)[1]', 'NVARCHAR(250)')
            ,@PrntCust = @X.query('Pos').value('(Pos/@prntcust)[1]', 'NVARCHAR(250)')
            ,@AutoComm = @X.query('Pos').value('(Pos/@autocomm)[1]', 'VARCHAR(3)');
      
      MERGE Global.Pos_Device T
      USING (SELECT @Psid AS PSID) S
      ON (T.PSID = S.PSID)
      WHEN NOT MATCHED THEN 
         INSERT (PSID, BANK_TYPE, BNKB_CODE, BNKA_ACNT_NUMB, SHBA_CODE, POS_DESC, POS_STAT, POS_DFLT, SEND_AMNT_EDIT, SEND_DATA_ON_DEVC, FILL_RSLT_DATA, POS_CNCT_TYPE, IP_ADRS, COMM_PORT, BAND_RATE, PRNT_SALE, PRNT_CUST, AUTO_COMM)
         VALUES (S.PSID, @BankType, @BnkbCode, @BnkaAcntNumb, @ShbaCode, @PosDesc, @PosStat, @PosDflt, '001', '002', '002', @PosCnctType, @IPAdrs, @CommPort, @BandRate, @PrntSale, @PrntCust, @AutoComm)
      WHEN MATCHED THEN
         UPDATE SET
            T.BANK_TYPE = @BankType
           ,T.BNKB_CODE = @BnkbCode
           ,T.BNKA_ACNT_NUMB = @BnkaAcntNumb
           ,T.SHBA_CODE = @ShbaCode
           ,T.POS_DESC = @PosDesc
           ,T.POS_STAT = @PosStat
           ,T.POS_DFLT = @PosDflt
           ,T.POS_CNCT_TYPE = @PosCnctType
           ,T.IP_ADRS = @IPAdrs
           ,T.COMM_PORT = @CommPort
           ,T.BAND_RATE = @BandRate
           ,T.PRNT_SALE = @PrntSale
           ,T.PRNT_CUST = @PrntCust
           ,T.AUTO_COMM = @AutoComm;
      
   COMMIT TRAN SavePosDevice_Tran;   
   END TRY
   BEGIN CATCH
      DECLARE @ErorMesg NVARCHAR(MAX);
      SET @ErorMesg = ERROR_MESSAGE();
      RAISERROR ( @ErorMesg, -- Message text.
               16, -- Severity.
               1 -- State.
               );
      ROLLBACK TRAN SavePosDevice_Tran;
   END CATCH   
END
GO
