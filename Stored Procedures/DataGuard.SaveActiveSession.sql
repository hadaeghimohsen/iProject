SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [DataGuard].[SaveActiveSession]
	-- Add the parameters for the stored procedure here
	@X XML
	/*
	   <ActiveSession userdb="artauser" cpusrno="BFEBFBFF000206A7" database="iProject" />
	*/
AS
BEGIN
	DECLARE @UserDb VARCHAR(250)
	       ,@CpuSrno VARCHAR(17)
	       ,@Database VARCHAR(50)
	       ,@HostName VARCHAR(128);
	
	SELECT --@UserDb = @X.value('(ActiveSession/@userdb)[1]', 'VARCHAR(50)')
	      --,@CpuSrno = @X.value('(ActiveSession/@cpusrno)[1]', 'VARCHAR(17)')
	      @Database = @X.value('(ActiveSession/@database)[1]', 'VARCHAR(50)');

   -- 1396/01/09 * بدست آوردن کلاینت متصل به سرور
	SELECT   
	    @HostName = s.host_name
     FROM sys.dm_exec_connections AS c  
     JOIN sys.dm_exec_sessions AS s  
       ON c.session_id = s.session_id  
    WHERE c.session_id = @@SPID; 
   
   SELECT @CpuSrno = CPU_SRNO_DNRM
     FROM DataGuard.Gateway
    WHERE UPPER(COMP_NAME_DNRM) LIKE UPPER(@HostName) + N'%';
   
   IF @CpuSrno IS NULL OR @CpuSrno = ''
      SELECT @CpuSrno = @X.value('(ActiveSession/@cpusrno)[1]', 'VARCHAR(17)');
   
	SELECT @UserDb = SUSER_NAME();
	
	DECLARE @UserId BIGINT
	       ,@GatewayRwno INT
	       ,@AccessUserDatasourceId BIGINT
	       ,@DatabaseServer SMALLINT
	       ,@AudsStat VARCHAR(3)
	       ,@AudsAcesType VARCHAR(3)
	       ,@AudsStrtDate DATE
	       ,@AudsEndDate DATE;
	
	IF NOT EXISTS(
	   SELECT *
	     FROM Global.Access_User_Datasource aud, DataGuard.[User] u, Report.DataSource d
	    WHERE aud.USER_ID = u.ID
	      AND aud.DSRC_ID = d.ID
	      AND UPPER(d.Database_Alias) = UPPER(@Database)
	      AND UPPER(u.USERDB) = UPPER(@UserDb)
	      AND aud.HOST_NAME = @CpuSrno
	)
	BEGIN
	   -- بدست آوردن اطلاعات کاربر
	   SELECT @UserId = ID
	     FROM DataGuard.[User]
	    WHERE UPPER(USERDB) = 'SCOTT';
	   
	   -- بدست آوردن اطلاعات سرور پایگاه داده کرنل
	   SELECT @AccessUserDatasourceId = ID
	     FROM Report.DataSource
	    WHERE UPPER(Database_Alias) = 'IPROJECT';
	    
	   INSERT INTO Global.Access_User_Datasource
	           ( USER_ID ,
	             DSRC_ID ,
	             STAT ,
	             STRT_DATE ,
	             END_DATE ,
	             ACES_TYPE ,
	             HOST_NAME 
	           )
	   VALUES  ( @UserId , -- USER_ID - bigint
	             @AccessUserDatasourceId , -- DSRC_ID - bigint
	             '002' , -- STAT - varchar(3)
	             NULL  , -- STRT_DATE - date
	             NULL , -- END_DATE - date
	             '001' , -- ACES_TYPE - varchar(3)
	             @CpuSrno  -- HOST_NAME - varchar(50)	             
	           );
	END 

	
	-- در این قسمت گزینه های کنترلی هم باید گرفته شود تا در ادامه متوجه شویم که به چه خاطر ممکن است این سیستم برای کاربر ورود غیرمجاز تلقی شود
	SELECT @UserId = u.ID
	      ,@GatewayRwno = ug.RWNO
	      ,@AccessUserDatasourceId = d.ID
	      ,@DatabaseServer = ds.DatabaseServer
	      ,@AudsStat = d.STAT
	      ,@AudsAcesType = d.ACES_TYPE
	      ,@AudsStrtDate = d.STRT_DATE
	      ,@AudsEndDate = d.END_DATE
	  FROM Report.DataSource ds, Global.Access_User_Datasource d, DataGuard.[User] u, DataGuard.User_Gateway ug
	 WHERE d.User_ID = u.ID
	   AND u.ID = ug.USER_ID
	   AND ds.ID = d.DSRC_ID
	   AND ds.Database_Alias = @Database
	   AND ug.GTWY_MAC_ADRS = @CpuSrno
	   AND ug.VALD_TYPE = '002'
	   AND UPPER(u.USERDB) = UPPER(@UserDb)
	   AND d.HOST_NAME = @CpuSrno;
	
	-- create xml for get connection string
	/*
	   <Request Rqtp_Code="ConnectionString">
	      <Database>iProject</Database>
	      <Dbms>SqlServer</Dbms>
	      <User>artauser</User>
	   </Request>
	*/
	
	DECLARE @xp XML;	
	
   IF @DatabaseServer = 0
   BEGIN
      SELECT @xp = (
         SELECT 'ConnectionString' AS '@Rqtp_Code'
               ,@Database AS 'Database'
               ,'Oracle' AS 'Dbms'
               ,@UserDb AS 'User'
            FOR XML PATH('Request')
      );
   END
   ELSE IF @DatabaseServer = 1
   BEGIN
      SELECT @xp = (
         SELECT 'ConnectionString' AS '@Rqtp_Code'
               ,@Database AS 'Database'
               ,'SqlServer' AS 'Dbms'
               ,@UserDb AS 'User'
            FOR XML PATH('Request')
      );
   END 
   
   DECLARE @ConnectionString VARCHAR(1000);
   SELECT @ConnectionString = dbo.GET_CNST_U(@xp);
   
   DECLARE @ActnType VARCHAR(3);
   
   IF @ConnectionString IS NULL 
   BEGIN
      SET @ActnType = '001'; -- عدم تایید سیستم و ورود غیرمجاز
   END 
   ELSE IF @AudsStat = '001' -- غیرفعال
   BEGIN
      SET @ActnType = '003'; -- دسترسی به داده از این سیستم برای کاربر جاری
   END   
   ELSE IF @AudsAcesType = '002' -- اگر ارتباط محدود باشد
       AND NOT CAST(GETDATE() AS DATE) BETWEEN @AudsStrtDate AND @AudsEndDate
   BEGIN
      SET @ActnType = '004'; -- دسترسی به داده از این سیستم برای کاربر جاری در زمان مقرر تمام شده
   END
   ELSE 
   BEGIN
      SET @ActnType = '002'; -- تایید سیستم و ورود مجاز
   END 
   
   -- 1397/05/28 * حذف رکورد های قدیمی
   DELETE DataGuard.Active_Session
    WHERE USGW_GTWY_MAC_ADRS = @CpuSrno
      AND USGW_USER_ID = @UserId
      AND USGW_RWNO = @GatewayRwno
      AND AUDS_ID = @AccessUserDatasourceId
      AND ACTN_TYPE = @ActnType;
      
   -- ذخیره کردن 
   --  Active Session
   INSERT INTO DataGuard.Active_Session
           ( USGW_GTWY_MAC_ADRS ,
             USGW_USER_ID ,
             USGW_RWNO ,
             AUDS_ID ,
             RWNO ,
             ACTN_DATE ,
             ACTN_TYPE 
           )
   VALUES  ( @CpuSrno, -- USGW_GTWY_MAC_ADRS - varchar(17)
             @UserId , -- USGW_USER_ID - bigint
             @GatewayRwno , -- USGW_RWNO - int
             @AccessUserDatasourceId , -- AUDS_ID - bigint
             0 , -- RWNO - bigint
             GETDATE() , -- ACTN_DATE - datetime
             @ActnType  -- ACTN_TYPE - varchar(3)
           );
END
GO
