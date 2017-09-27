SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [DataGuard].[ChangeHostAuthorized]
	@X XML
AS
BEGIN
	DECLARE @ActnType     VARCHAR(3)
	       ,@MacAddress   VARCHAR(17)
	       ,@IPAddress    VARCHAR(15)
	       ,@ComputerName VARCHAR(50)
	       ,@CpuSrnoDnrm VARCHAR(30);
	
	SELECT @ActnType   = @X.query('Request').value('(Request/@actntype)[1]', 'VARCHAR(3)');
	
	IF @ActnType = '000'
	BEGIN
	   DECLARE @PLCY_MAC_ADDR_FLTR VARCHAR(3)
             ,@PLCY_COMP_BLOK VARCHAR(3)
             ,@LOGN_COMP_BLOK VARCHAR(3)
             ,@SHOW_ALRM_UNAT VARCHAR(3)
             ,@POST_PONE_UNAT INT
             ,@PLCY_FORC_SAFE_ENTR VARCHAR(3)
             ,@PLCY_SECR_PSWD VARCHAR(3)
             ,@PSWD_HIST_NUMB INT
             ,@MAX_PSWD_AGE INT
             ,@MIN_PSWD_LEN INT
             ,@PLCY_PSWD_CMPX VARCHAR(3)
             ,@USE_VPN VARCHAR(3);
      
      SELECT @PLCY_MAC_ADDR_FLTR  = @X.query('Request/SecurityManagment').value('(SecurityManagment/@plcymacaddrfltr)[1]', 'VARCHAR(3)')
            ,@PLCY_COMP_BLOK      = @X.query('Request/SecurityManagment').value('(SecurityManagment/@plcycompblok)[1]', 'VARCHAR(3)')
            ,@LOGN_COMP_BLOK      = @X.query('Request/SecurityManagment').value('(SecurityManagment/@logncompblok)[1]', 'VARCHAR(3)')
            ,@SHOW_ALRM_UNAT      = @X.query('Request/SecurityManagment').value('(SecurityManagment/@showalrmunat)[1]', 'VARCHAR(3)')
            ,@POST_PONE_UNAT      = @X.query('Request/SecurityManagment').value('(SecurityManagment/@postponeunat)[1]', 'INT')
            ,@PLCY_FORC_SAFE_ENTR = @X.query('Request/SecurityManagment').value('(SecurityManagment/@plcyforcsafeentr)[1]', 'VARCHAR(3)')
            ,@PLCY_SECR_PSWD      = @X.query('Request/SecurityManagment').value('(SecurityManagment/@plcysecrpswd)[1]', 'VARCHAR(3)')
            ,@PSWD_HIST_NUMB      = @X.query('Request/SecurityManagment').value('(SecurityManagment/@pswdhistnumb)[1]', 'INT')
            ,@MAX_PSWD_AGE        = @X.query('Request/SecurityManagment').value('(SecurityManagment/@maxpswdage)[1]', 'INT')
            ,@MIN_PSWD_LEN        = @X.query('Request/SecurityManagment').value('(SecurityManagment/@minpswdlen)[1]', 'INT')
            ,@PLCY_PSWD_CMPX      = @X.query('Request/SecurityManagment').value('(SecurityManagment/@plcypswdcmpx)[1]', 'VARCHAR(3)')
            ,@USE_VPN             = @X.query('Request/SecurityManagment').value('(SecurityManagment/@usevpn)[1]', 'VARCHAR(3)');
            
      UPDATE DataGuard.Security_Managment
         SET PLCY_MAC_ADDR_FLTR = @PLCY_MAC_ADDR_FLTR
            ,PLCY_COMP_BLOK     = @PLCY_COMP_BLOK
            ,LOGN_COMP_BLOK     = @LOGN_COMP_BLOK
            ,SHOW_ALRM_UNAT     = @SHOW_ALRM_UNAT
            ,POST_PONE_UNAT     = @POST_PONE_UNAT
            ,PLCY_FORC_SAFE_ENTR = @PLCY_FORC_SAFE_ENTR
            ,PLCY_SECR_PSWD     = @PLCY_SECR_PSWD
            ,PSWD_HIST_NUMB     = @PSWD_HIST_NUMB
            ,MAX_PSWD_AGE       = @MAX_PSWD_AGE
            ,MIN_PSWD_LEN       = @MIN_PSWD_LEN
            ,PLCY_PSWD_CMPX     = @PLCY_PSWD_CMPX
            ,USE_VPN            = @USE_VPN;
	END
	ELSE IF @ActnType = '001'
	BEGIN
	   DECLARE @Userid   BIGINT;

   	SELECT @MacAddress = @X.query('Request/User_Gateway').value('(User_Gateway/@mac)[1]', 'VARCHAR(17)')
            ,@Userid     = @X.query('Request/User_Gateway').value('(User_Gateway/@userid)[1]', 'VARCHAR(17)');

	   -- می خواهیم دسترسی اعتبار کاربرانی که با کامپیوتر مجاز کار میکنند تعیین تکلیف کنیم
	   IF EXISTS(SELECT * FROM DataGuard.User_Gateway WHERE GTWY_MAC_ADRS = @MacAddress AND USER_ID = @Userid AND VALD_TYPE = '002')
	      UPDATE DataGuard.User_Gateway
	         SET VALD_TYPE = '001'
	       WHERE GTWY_MAC_ADRS = @MacAddress
	         AND USER_ID = @Userid
	         AND VALD_TYPE = '002';
	   ELSE
	      INSERT INTO DataGuard.User_Gateway(GTWY_MAC_ADRS, USER_ID, RWNO, VALD_TYPE) 
	      VALUES(@MacAddress, @Userid, 0, '002');
	END
	ELSE IF @ActnType = '002'
	BEGIN
	   -- بلوکه کردن دستگاه
	   SELECT @MacAddress = @X.query('Request/Gateway').value('(Gateway/@mac)[1]', 'VARCHAR(17)');
	   
	   SELECT @IPAddress = IP_DNRM
	         ,@ComputerName = COMP_NAME_DNRM
	         ,@CpuSrnoDnrm = CPU_SRNO_DNRM
	     FROM DataGuard.Gateway
	    WHERE MAC_ADRS = @MacAddress;
	   
	   INSERT INTO DataGuard.Gateway_Public(GTWY_MAC_ADRS, RWNO, RECT_CODE, IP        , COMP_NAME    , CPU_SRNO    , DFLT_FACT, VALD_TYPE, NEW_RQST, AUTH_TYPE)
      VALUES                              (@MacAddress  , 0   , '004'    , @IPAddress, @ComputerName, @CpuSrnoDnrm, '001'    , '002'    , '001'   , '003');
	END
	ELSE IF @ActnType = '003'
	BEGIN
	   -- غیرمجاز بودن دستگاه
	   SELECT @MacAddress = @X.query('Request/Gateway').value('(Gateway/@mac)[1]', 'VARCHAR(17)');
	   
	   SELECT @IPAddress = IP_DNRM
	         ,@ComputerName = COMP_NAME_DNRM
	         ,@CpuSrnoDnrm = CPU_SRNO_DNRM
	     FROM DataGuard.Gateway
	    WHERE MAC_ADRS = @MacAddress;
	   
	   INSERT INTO DataGuard.Gateway_Public(GTWY_MAC_ADRS, RWNO, RECT_CODE, IP        , COMP_NAME    , CPU_SRNO    , DFLT_FACT, VALD_TYPE, NEW_RQST, AUTH_TYPE)
      VALUES                              (@MacAddress  , 0   , '004'    , @IPAddress, @ComputerName, @CpuSrnoDnrm, '001'    , '002'    , '001'   , '001');
	END
	ELSE IF @ActnType = '004'
	BEGIN
	   -- مجاز شدن دستگاه
	   SELECT @MacAddress = @X.query('Request/Gateway').value('(Gateway/@mac)[1]', 'VARCHAR(17)');
	   
	   SELECT @IPAddress = IP_DNRM
	         ,@ComputerName = COMP_NAME_DNRM
	         ,@CpuSrnoDnrm = CPU_SRNO_DNRM
	     FROM DataGuard.Gateway
	    WHERE MAC_ADRS = @MacAddress;
	   
	   INSERT INTO DataGuard.Gateway_Public(GTWY_MAC_ADRS, RWNO, RECT_CODE, IP        , COMP_NAME    , CPU_SRNO    , DFLT_FACT, VALD_TYPE, NEW_RQST, AUTH_TYPE)
      VALUES                              (@MacAddress  , 0   , '004'    , @IPAddress, @ComputerName, @CpuSrnoDnrm, '001'    , '002'    , '001'   , '002');
      UPDATE DataGuard.Gateway
         SET CONF_STAT = '002'
       WHERE MAC_ADRS = @MacAddress
         AND CONF_STAT = '001';
	END
END
GO
