SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [DataGuard].[SaveHostInfo]
	@X XML
AS
   /*
      <Computer name="Mohsen-LT" ip="192.168.1.209" mac="88:53:2e:35:14:11" cpu="5d5f5s6588e"/>
   */
BEGIN
   DECLARE @Retval INT;
   EXEC @Retval = DataGuard.ReCreateExistsUsers;
   
   DECLARE @RqtpCode VARCHAR(30)
          ,@ConfStat VARCHAR(3);
   
   DECLARE @ComputerName VARCHAR(50)
          ,@IPAddress    VARCHAR(15)
          ,@MacAddress   VARCHAR(17)
          ,@CpuSrno      VARCHAR(30)
          ,@UserId       BIGINT
          ,@SystemStatus VARCHAR(30);
   
   -- 1395/12/22 * برای ثبت دستی سیستم کاربری
   SELECT @RqtpCode = @x.query('Request').value('(Request/@Rqtp_Code)[1]', 'VARCHAR(30)')
         ,@SystemStatus = @x.query('Request').value('(Request/@SystemStatus)[1]', 'VARCHAR(30)');;
   
   IF @RqtpCode = 'ManualSaveHostInfo'
   BEGIN
      SELECT @UserId= ID FROM DataGuard.[User] WHERE UPPER(USERDB) = UPPER(@X.query('//User').value('.', 'VARCHAR(250)'));
      
      SELECT @MacAddress = @X.query('//Computer').value('(Computer/@mac)[1]', 'VARCHAR(17)')
            ,@IPAddress = @X.query('//Computer').value('(Computer/@ip)[1]', 'VARCHAR(15)')
            ,@ComputerName = @X.query('//Computer').value('(Computer/@name)[1]', 'VARCHAR(50)')
            ,@CpuSrno = @X.query('//Computer').value('(Computer/@cpu)[1]', 'VARCHAR(30)');   
   END 
   ELSE
   BEGIN   
      SELECT @UserId= ID FROM DataGuard.[User] WHERE UPPER(USERDB) = UPPER(SUSER_NAME());
      
      SELECT @MacAddress = @X.query('Computer').value('(Computer/@mac)[1]', 'VARCHAR(17)')
            ,@IPAddress = @X.query('Computer').value('(Computer/@ip)[1]', 'VARCHAR(15)')
            ,@ComputerName = @X.query('Computer').value('(Computer/@name)[1]', 'VARCHAR(50)')
            ,@CpuSrno = @X.query('Computer').value('(Computer/@cpu)[1]', 'VARCHAR(30)');   
   END
   -- اگر کاربر شرکتی باشد نیازی به ذخیره کردن سوابق ورود به سیستم نیست
   IF EXISTS(SELECT * FROM DataGuard.[User] WHERE ID = @UserId AND DFLT_FACT = '002')   
   BEGIN
      --RETURN;
      --PRINT 'Not Save Log Default Factory User';
      SET @ConfStat = '002';
   END;
   ELSE
   BEGIN
      SELECT @ConfStat = '001';
   END
   
   -- اگر کاربر مشخص کرده باشد که اجازه استفاده از 
   -- VPN 
   -- را ندارد
   
   DECLARE @OldComputerName VARCHAR(50);
   IF EXISTS(SELECT * FROM DataGuard.Gateway WHERE CPU_SRNO_DNRM = @CpuSrno)
      SELECT @MacAddress = g.MAC_ADRS
            --,@IPAddress = g.IP_DNRM
            ,@OldComputerName = g.COMP_NAME_DNRM
        FROM DataGuard.Gateway g
       WHERE g.CPU_SRNO_DNRM = @CpuSrno;
   
   -- 1395/12/22 * برای ایجاد کردن کلید اصلی برای جدول gateway
   SELECT @MacAddress = @CpuSrno;
   
   SELECT @IPAddress = c.client_net_address  
     FROM sys.dm_exec_connections AS c  
     JOIN sys.dm_exec_sessions AS s  
       ON c.session_id = s.session_id  
    WHERE c.session_id = @@SPID; 
       
   IF EXISTS(SELECT * FROM DataGuard.Security_Managment WHERE USE_VPN = '001')
   BEGIN
      IF LEN(@MacAddress) <> 16 BEGIN RAISERROR(N'آدرس فیزیکی دستگاه شما نامعتبر میباشد. اگر از "وی پی ان" استفاده میکنید لطفا آن را قطع کنید', 16, 1); RETURN; END;
      IF LEN(@IPAddress) = 0 BEGIN RAISERROR(N'IP دستگاه شما به درستی تنظیم نشده است', 16, 1); RETURN; END;
      IF LEN(@ComputerName) = 0 BEGIN RAISERROR(N'برای سیستم شما نام کامپیوتر تنظیم نشده', 16, 1); RETURN; END;
   END
   /* 1395/12/22 * ELSE IF LEN(REPLACE(REPLACE(@MacAddress, ' ', ''), ':', '')) != 12
   BEGIN
      SET @MacAddress = '00:00:00:00:00:00'
      SET @IPAddress  = '127.0.0.1'
      SET @ComputerName = 'VPN Active';
   END*/
   
   IF @IPAddress = '127.0.0.1'
      SET @IPAddress = '<local machine>';
   
   IF NOT EXISTS(
      SELECT *
        FROM DataGuard.Gateway
       WHERE MAC_ADRS = @MacAddress
   )
   BEGIN
      -- اگر کامپیوتر یا دستگاه جدید تعریف شده
      INSERT INTO DataGuard.Gateway(MAC_ADRS, CONF_STAT) VALUES (@MacAddress, /*'001'*/ @ConfStat);
      INSERT INTO DataGuard.Gateway_Public(GTWY_MAC_ADRS, RWNO, RECT_CODE, IP, COMP_NAME, DFLT_FACT, VALD_TYPE, NEW_RQST, AUTH_TYPE, CPU_SRNO)
      VALUES(@MacAddress, 0, '001', @IPAddress, @ComputerName, '001', '002', '002', '001', @CpuSrno);
      
      IF NOT EXISTS(
         SELECT *
           FROM DataGuard.Gateway
          WHERE CONF_STAT = '002'
            AND VALD_TYPE_DNRM = '002'
            AND AUTH_TYPE_DNRM = '002'
      )
      BEGIN
         -- ثبت اولین کامپیوتر برای استفاده از نرم افزار
         INSERT INTO DataGuard.Gateway_Public(GTWY_MAC_ADRS, RWNO, RECT_CODE, IP        , COMP_NAME    , DFLT_FACT, VALD_TYPE, NEW_RQST, AUTH_TYPE, CPU_SRNO)
         VALUES                              (@MacAddress  , 0   , '004'    , @IPAddress, @ComputerName, '001'    , '002'    , '002'   , '002', @CpuSrno);
         UPDATE DataGuard.Gateway
            SET CONF_STAT = '002'
          WHERE MAC_ADRS = @MacAddress;
          
         INSERT INTO DataGuard.User_Gateway (GTWY_MAC_ADRS, USER_ID, RWNO, VALD_TYPE)
         VALUES (@MacAddress, @UserId, 0, '002');
      END
      ELSE
      BEGIN
         -- این دستگاه اولین نفر واردشده درون سیستم نیست.
         IF EXISTS(SELECT * FROM DataGuard.Security_Managment WHERE PLCY_MAC_ADDR_FLTR = '002')
         BEGIN
            -- اگر سیاست فیلترینگ آدرس فیزیکی فعال باشد
            IF EXISTS(SELECT * FROM DataGuard.Security_Managment WHERE PLCY_FORC_SAFE_ENTR = '002')
            BEGIN
               -- اگر نخواهیم دستگاه جدید به شبکه اضافه گردد
               -- دستگاه را به صورت بلوکه شده در سیستم نمایش میدهیم
               INSERT INTO DataGuard.Gateway_Public(GTWY_MAC_ADRS, RWNO, RECT_CODE, IP, COMP_NAME, DFLT_FACT, VALD_TYPE, NEW_RQST, AUTH_TYPE, CPU_SRNO)
               VALUES(@MacAddress, 0, '004', @IPAddress, @ComputerName, '001', '002', '002', '003', @CpuSrno);
               
               -- اجازه ثبت به عنوان ورود غیرمجاز رو داریم تا مدیر اجازه ورود را صادر کند
               INSERT INTO DataGuard.User_Gateway (GTWY_MAC_ADRS, USER_ID, RWNO, VALD_TYPE)
               VALUES (@MacAddress, @UserId, 0, '001');
            END
            ELSE
            BEGIN
               -- اگر اجازه اضافه شدن دستگاه جدید به شبکه را داده باشیم               
               -- اجازه ثبت به عنوان ورود غیرمجاز رو داریم تا مدیر اجازه ورود را صادر کند
               INSERT INTO DataGuard.Gateway_Public(GTWY_MAC_ADRS, RWNO, RECT_CODE, IP        , COMP_NAME    , DFLT_FACT, VALD_TYPE, NEW_RQST, AUTH_TYPE, CPU_SRNO)
               VALUES                              (@MacAddress  , 0   , '004'    , @IPAddress, @ComputerName, '001'    , '002'    , '002'   , '001', @CpuSrno);
               
               INSERT INTO DataGuard.User_Gateway (GTWY_MAC_ADRS, USER_ID, RWNO, VALD_TYPE)
               VALUES (@MacAddress, @UserId, 0, '001');
            END
         END
         ELSE
         BEGIN
            -- اگر سیاست فیلترینگ آدرس فیزیکی فعال نباشد
            IF EXISTS(SELECT * FROM DataGuard.[User] WHERE UPPER(USERDB) = UPPER(SUSER_NAME()) AND PLCY_FORC_SAFE_ENTR = '002')
            BEGIN
               -- کاربر محدود بودن کامپیوتر را مشخص کرده
               IF EXISTS(SELECT * FROM DataGuard.[User] WHERE UPPER(USERDB) = UPPER(SUSER_NAME()) AND ADD_COMP_LIST = '002')
               BEGIN
                  -- کاربر اجازه اضافه کردن کامپیوتر جدید به لیست درگاه های خودش را صادر کرده               
                  INSERT INTO DataGuard.Gateway_Public(GTWY_MAC_ADRS, RWNO, RECT_CODE, IP        , COMP_NAME    , DFLT_FACT, VALD_TYPE, NEW_RQST, AUTH_TYPE, CPU_SRNO)
                  VALUES                              (@MacAddress  , 0   , '004'    , @IPAddress, @ComputerName, '001'    , '002'    , '002'   , '002', @CpuSrno);
                  UPDATE DataGuard.Gateway
                     SET CONF_STAT = '002'
                   WHERE MAC_ADRS = @MacAddress;
                  
                  
                  INSERT INTO DataGuard.User_Gateway (GTWY_MAC_ADRS, USER_ID, RWNO, VALD_TYPE)
                  VALUES (@MacAddress, @UserId, 0, '002');
               END
               ELSE
               BEGIN
                  -- کاربر اجازه اضافه کردن کامپیوتر جدید به لیست درگاه های خودش را صادر نکرده               
                  -- اجازه ثبت به عنوان ورود غیرمجاز رو داریم تا مدیر اجازه ورود را صادر کند
                  INSERT INTO DataGuard.Gateway_Public(GTWY_MAC_ADRS, RWNO, RECT_CODE, IP        , COMP_NAME    , DFLT_FACT, VALD_TYPE, NEW_RQST, AUTH_TYPE, CPU_SRNO)
                  VALUES                              (@MacAddress  , 0   , '004'    , @IPAddress, @ComputerName, '001'    , '002'    , '002'   , '003', @CpuSrno);
                  
                  INSERT INTO DataGuard.User_Gateway (GTWY_MAC_ADRS, USER_ID, RWNO, VALD_TYPE)
                  VALUES (@MacAddress, @UserId, 0, '001');
               END
            END
            ELSE
            BEGIN
               -- کاربر محدود بودن کامپیوتر را آزاد گذاشته است
               INSERT INTO DataGuard.Gateway_Public(GTWY_MAC_ADRS, RWNO, RECT_CODE, IP        , COMP_NAME    , DFLT_FACT, VALD_TYPE, NEW_RQST, AUTH_TYPE, CPU_SRNO)
               VALUES                              (@MacAddress  , 0   , '004'    , @IPAddress, @ComputerName, '001'    , '002'    , '002'   , '002', @CpuSrno);
               UPDATE DataGuard.Gateway
                  SET CONF_STAT = '002'
                WHERE MAC_ADRS = @MacAddress;
                  
                  
               INSERT INTO DataGuard.User_Gateway (GTWY_MAC_ADRS, USER_ID, RWNO, VALD_TYPE)
               VALUES (@MacAddress, @UserId, 0, '002');
            END
         END
      END
   END
   ELSE IF EXISTS(
      SELECT *
        FROM DataGuard.Gateway
       WHERE MAC_ADRS = @MacAddress
         AND CONF_STAT = '002' -- کامپیوتر تایید شده
         AND VALD_TYPE_DNRM = '002' -- معتبر است
         AND AUTH_TYPE_DNRM = '002' -- مجاز است
   )
   BEGIN
      -- اگر کامپیوتر قبلا تعریف شده است
      IF EXISTS(SELECT * FROM DataGuard.[User] WHERE UPPER(USERDB) = UPPER(SUSER_NAME()) AND PLCY_FORC_SAFE_ENTR = '002')
      BEGIN
         -- کاربر محدود بودن کامپیوتر را مشخص کرده
         IF EXISTS(SELECT * FROM DataGuard.[User] WHERE UPPER(USERDB) = UPPER(SUSER_NAME()) AND ADD_COMP_LIST = '002')
         BEGIN
            -- کاربر اجازه اضافه کردن کامپیوتر جدید به لیست درگاه های خودش را صادر کرده               
            IF NOT EXISTS(SELECT * FROM DataGuard.Gateway WHERE MAC_ADRS = @MacAddress /*AND IP_DNRM = @IPAddress AND COMP_NAME_DNRM = @ComputerName*/)
               OR UPPER(@ComputerName) != UPPER(@OldComputerName)
               INSERT INTO DataGuard.Gateway_Public(GTWY_MAC_ADRS, RWNO, RECT_CODE, IP        , COMP_NAME    , DFLT_FACT, VALD_TYPE, NEW_RQST, AUTH_TYPE, CPU_SRNO)
               VALUES                              (@MacAddress  , 0   , '004'    , @IPAddress, @ComputerName, '001'    , '002'    , '002'   , '002', @CpuSrno);
            
            -- اگر تا حالا کاربر با این سیستم قصد ورود را نداشته است باید کامپیوتر جدید را در لیست آن اضافه کرد
            -- در غیر این صورت باید کامپیوتر را به صورت دستی درون لیست کاربر فعال کرد
            IF NOT EXISTS(SELECT * FROM DataGuard.User_Gateway WHERE GTWY_MAC_ADRS = @MacAddress AND USER_ID = @UserId)
               INSERT INTO DataGuard.User_Gateway (GTWY_MAC_ADRS, USER_ID, RWNO, VALD_TYPE)
               VALUES (@MacAddress, @UserId, 0, '002');
         END
         ELSE
         BEGIN
            -- کاربر اجازه اضافه کردن کامپیوتر جدید به لیست درگاه های خودش را صادر نکرده               
            -- اجازه ثبت به عنوان ورود غیرمجاز رو داریم تا مدیر اجازه ورود را صادر کند
            INSERT INTO DataGuard.Gateway_Public(GTWY_MAC_ADRS, RWNO, RECT_CODE, IP        , COMP_NAME    , DFLT_FACT, VALD_TYPE, NEW_RQST, AUTH_TYPE, CPU_SRNO)
            VALUES                              (@MacAddress  , 0   , '004'    , @IPAddress, @ComputerName, '001'    , '002'    , '002'   , '003', @CpuSrno);
            
            -- اگر تا حالا کاربر با این سیستم قصد ورود را نداشته است باید کامپیوتر جدید را در لیست آن اضافه کرد
            -- در غیر این صورت باید کامپیوتر را به صورت دستی درون لیست کاربر فعال کرد
            IF NOT EXISTS(SELECT * FROM DataGuard.User_Gateway WHERE GTWY_MAC_ADRS = @MacAddress AND USER_ID = @UserId)
               INSERT INTO DataGuard.User_Gateway (GTWY_MAC_ADRS, USER_ID, RWNO, VALD_TYPE)
               VALUES (@MacAddress, @UserId, 0, '001');
         END
      END
      ELSE
      BEGIN
         -- کاربر محدود بودن کامپیوتر را آزاد گذاشته است
         IF NOT EXISTS(SELECT * FROM DataGuard.Gateway WHERE MAC_ADRS = @MacAddress /*AND IP_DNRM = @IPAddress AND COMP_NAME_DNRM = @ComputerName*/) 
            OR UPPER(@ComputerName) != UPPER(@OldComputerName)
            INSERT INTO DataGuard.Gateway_Public(GTWY_MAC_ADRS, RWNO, RECT_CODE, IP        , COMP_NAME    , DFLT_FACT, VALD_TYPE, NEW_RQST, AUTH_TYPE, CPU_SRNO)
            VALUES                              (@MacAddress  , 0   , '004'    , @IPAddress, @ComputerName, '001'    , '002'    , '002'   , '002', @CpuSrno);
            
            
         -- اگر تا حالا کاربر با این سیستم قصد ورود را نداشته است باید کامپیوتر جدید را در لیست آن اضافه کرد
         -- در غیر این صورت باید کامپیوتر را به صورت دستی درون لیست کاربر فعال کرد
         IF NOT EXISTS(SELECT * FROM DataGuard.User_Gateway WHERE GTWY_MAC_ADRS = @MacAddress AND USER_ID = @UserId)
            INSERT INTO DataGuard.User_Gateway (GTWY_MAC_ADRS, USER_ID, RWNO, VALD_TYPE)
            VALUES (@MacAddress, @UserId, 0, '002');
      END
   END
   ELSE
   BEGIN
      -- اگر سیستم هنوز تایید یا معتبر یا مجاز نباشد فقط باید بفهمیم چه کسی 
      -- قصد ورود به سیستم را داشته      
      -- اجازه ثبت به عنوان ورود غیرمجاز رو داریم تا مدیر بررسی ورود را صادر کند
      IF EXISTS(SELECT * FROM DataGuard.Gateway WHERE MAC_ADRS = @MacAddress AND GWPB_RWNO_DNRM IS NULL)
         INSERT INTO DataGuard.Gateway_Public(GTWY_MAC_ADRS, RWNO, RECT_CODE, IP        , COMP_NAME    , DFLT_FACT, VALD_TYPE, NEW_RQST, AUTH_TYPE, CPU_SRNO)
         VALUES                              (@MacAddress  , 0   , '004'    , @IPAddress, @ComputerName, '001'    , '002'    , '002'   , '001', @CpuSrno);
      ELSE
         INSERT INTO DataGuard.Gateway_Public(GTWY_MAC_ADRS, RWNO, RECT_CODE, IP        , COMP_NAME    , DFLT_FACT, VALD_TYPE, NEW_RQST, AUTH_TYPE, CPU_SRNO)
         VALUES                              (@MacAddress  , 0   , '002'    , @IPAddress, @ComputerName, '001'    , '002'    , '002'   , '001', @CpuSrno);
      
      -- اگر تا حالا کاربر با این سیستم قصد ورود را نداشته است باید کامپیوتر جدید را در لیست آن اضافه کرد
      -- در غیر این صورت باید کامپیوتر را به صورت دستی درون لیست کاربر فعال کرد
      IF NOT EXISTS(SELECT * FROM DataGuard.User_Gateway WHERE GTWY_MAC_ADRS = @MacAddress AND USER_ID = @UserId)
         INSERT INTO DataGuard.User_Gateway (GTWY_MAC_ADRS, USER_ID, RWNO, VALD_TYPE)
         VALUES (@MacAddress, @UserId, 0, '001');
   END
   
   -- 1396/01/09
   -- ذخیره کردن جلسه فعال در جدول های مدیریتی و نظارتی
   IF @SystemStatus != 'installing' AND
      EXISTS(
	   SELECT *
	     FROM DataGuard.Gateway
	    WHERE COMP_NAME_DNRM = @ComputerName
   )
   BEGIN   
      DECLARE @XSaveActiveSession XML;
      SELECT @XSaveActiveSession = (
         SELECT SUSER_NAME() AS '@userdb'
               ,@CpuSrno AS '@cpusrno'
               ,'iProject' AS '@database'
            FOR XML PATH('ActiveSession')
      );
      
      EXEC DataGuard.SaveActiveSession @X = @XSaveActiveSession -- xml      
   END 
END
GO
