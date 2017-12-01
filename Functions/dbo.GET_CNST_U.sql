SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date, ,>
-- Description:	<Description, ,>
-- =============================================
CREATE FUNCTION [dbo].[GET_CNST_U]
(
	-- Add the parameters for the function here
	@P_RqstXml XML
)
RETURNS VARCHAR(MAX)
AS
BEGIN
	DECLARE @RqtpCode     VARCHAR(50)
	       ,@DatabaseName VARCHAR(50)
	       ,@UserName     VARCHAR(MAX)
	       ,@Dbms         VARCHAR(100)
	       ,@ValueID      VARCHAR(5)
	       ,@IPAddress    VARCHAR(50)
	       ,@Password     VARCHAR(255)
	       ,@HostName     VARCHAR(50)
	       ,@CpuSrno     VARCHAR(30)
	       ,@UserFactory VARCHAR(3);
	       
	SELECT @RqtpCode       = @P_RqstXml.query('/Request').value('(Request/@Rqtp_Code)[1]', 'VARCHAR(50)')
	      ,@DatabaseName   = @P_RqstXml.query('/Request/Database').value('.', 'VARCHAR(50)')
	      ,@ValueID        = @P_RqstXml.query('/Request/Database').value('(Database/@value)[1]', 'VARCHAR(5)')
	      ,@UserName       = @P_RqstXml.query('/Request/User').value('.', 'VARCHAR(MAX)')
	      ,@Dbms           = @P_RqstXml.query('/Request/Dbms').value('.', 'VARCHAR(100)');
	
	-- 1395/12/21 * بدست آوردن کلاینت متصل به سرور
	SELECT   
	    @HostName = s.host_name
     FROM sys.dm_exec_connections AS c  
     JOIN sys.dm_exec_sessions AS s  
       ON c.session_id = s.session_id  
    WHERE c.session_id = @@SPID; 
   
   SELECT @CpuSrno = CPU_SRNO_DNRM
     FROM DataGuard.Gateway
    WHERE UPPER(COMP_NAME_DNRM) = UPPER(@HostName);

   IF @CpuSrno IS NULL OR @CpuSrno = ''
      SELECT @CpuSrno = @P_RqstXml.query('//Computer').value('(Computer/@cpu)[1]', 'VARCHAR(17)');
   
   -- 1395/12/21 * بررسی اینکه آیا کاربر شرکتی می باشد یا خیر
   SELECT @UserFactory = ISNULL(DFLT_FACT, '001')
     FROM DataGuard.[User] 
    WHERE UPPER(USERDB) = UPPER(@UserName);
   
   
   SET @RqtpCode = UPPER(@RqtpCode);
   SET @Dbms     = UPPER(@Dbms);
	
	IF @RqtpCode = 'CONNECTIONSTRING' 
	BEGIN
	   IF @Dbms = 'SQLSERVER'
	   BEGIN
	      SELECT @IPAddress = Ds.IPAddress
               ,@DatabaseName = Ds.[Database]
               ,@UserName = U.USERDB
               ,@Password = U.PASSDB
           FROM DataGuard.[User] U ,
                Report.DataSource Ds ,
                Global.Access_User_Datasource AUDS 
           WHERE U.ID = AUDS.USER_ID
             AND AUDS.DSRC_ID = Ds.ID
             AND UPPER(U.TitleEn) = UPPER(@UserName)
             AND UPPER(Ds.Database_Alias) = UPPER(@DatabaseName)
             -- اضافه کردن کد مروبط به دسترسی کاربران برای اتصال
             -- کاربران سیستمی هیچ محدودیتی ندارند
             AND ( 
                ( @UserFactory = '002' ) OR
                ( @UserFactory = '001' AND (AUDS.HOST_NAME = @CpuSrno AND (ISNULL(AUDS.ACES_TYPE, '001') = '001' /*unlimited*/ OR CAST(GETDATE() AS DATE) BETWEEN ISNULL(AUDS.STRT_DATE, GETDATE()) AND ISNULL(AUDS.END_DATE, GETDATE()) )))
             )
             AND AUDS.STAT = '002';
         
         RETURN 'SERVER=' + @IPAddress + ';' +
	             'DATABASE=' + @DatabaseName + ';' + 
	             'USER ID=' + @UserName + ';'+ 
	             'PASSWORD=' + @Password + ';'+
	             'Connection Timeout=1800;';
           
	      --RETURN 'SERVER=' + (SELECT IPADDRESS FROM Report.DataSource WHERE UPPER([Database]) = UPPER(@DatabaseName)) + ';' +
	      --       'DATABASE=' + @DatabaseName + ';' + 
	      --       'USER ID=' + (SELECT USERDB FROM DataGuard.[User] WHERE UPPER(TitleEn) = UPPER(@UserName)) + ';'+ 
	      --       'PASSWORD=' + (SELECT PASSDB FROM DataGuard.[User] WHERE UPPER(TitleEn) = UPPER(@UserName)) + ';'+
	      --       'Connection Timeout=1800;';
	   END
	   ELSE IF @Dbms = 'SQLSERVERACTIVEDBNAME' -- Sql Server Active db Name
	   BEGIN
	      SELECT @DatabaseName = Ds.[Database]
           FROM DataGuard.[User] U ,
                Report.DataSource Ds ,
                Global.Access_User_Datasource AUDS 
           WHERE U.ID = AUDS.USER_ID
             AND AUDS.DSRC_ID = Ds.ID
             AND UPPER(U.TitleEn) = UPPER(@UserName)
             AND UPPER(Ds.Database_Alias) = UPPER(@DatabaseName)
             -- اضافه کردن کد مروبط به دسترسی کاربران برای اتصال
             -- کاربران سیستمی هیچ محدودیتی ندارند
             AND ( 
                ( @UserFactory = '002' ) OR
                ( @UserFactory = '001' AND (AUDS.HOST_NAME = @CpuSrno AND (ISNULL(AUDS.ACES_TYPE, '001') = '001' /*unlimited*/ OR CAST(GETDATE() AS DATE) BETWEEN ISNULL(AUDS.STRT_DATE, GETDATE()) AND ISNULL(AUDS.END_DATE, GETDATE()) )))
             )
             AND AUDS.STAT = '002';
         
         RETURN @DatabaseName;
           
	      --RETURN 'SERVER=' + (SELECT IPADDRESS FROM Report.DataSource WHERE UPPER([Database]) = UPPER(@DatabaseName)) + ';' +
	      --       'DATABASE=' + @DatabaseName + ';' + 
	      --       'USER ID=' + (SELECT USERDB FROM DataGuard.[User] WHERE UPPER(TitleEn) = UPPER(@UserName)) + ';'+ 
	      --       'PASSWORD=' + (SELECT PASSDB FROM DataGuard.[User] WHERE UPPER(TitleEn) = UPPER(@UserName)) + ';'+
	      --       'Connection Timeout=1800;';
	   END
      ELSE IF @Dbms = 'ORACLE' 
         IF @ValueID = 'id'	        
            RETURN 'DATA SOURCE=' + (SELECT IPADDRESS FROM Report.DataSource WHERE ID = CAST(@DatabaseName AS BIGINT)) + ':' + (SELECT CAST(Port AS VARCHAR(10)) FROM Report.DataSource WHERE ID = CAST(@DatabaseName AS BIGINT)) + '/' + (SELECT [Database] FROM Report.DataSource WHERE ID = CAST(@DatabaseName AS BIGINT)) + ';' +
                   'USER ID=' + (SELECT USERDB FROM DataGuard.[User] WHERE UPPER(TitleEn) = UPPER(@UserName)) + ';'+ 
	                'PASSWORD=' + (SELECT PASSDB FROM DataGuard.[User] WHERE UPPER(TitleEn) = UPPER(@UserName)) + ';';
         ELSE
            RETURN 'DATA SOURCE=' + (SELECT IPADDRESS FROM Report.DataSource WHERE UPPER([Database]) = UPPER(@DatabaseName)) + ':' + (SELECT CAST(Port AS VARCHAR(10)) FROM Report.DataSource WHERE UPPER([Database]) = UPPER(@DatabaseName)) + '/' + (SELECT [Database] FROM Report.DataSource WHERE UPPER([Database]) = UPPER(@DatabaseName)) + ';' +
                   'USER ID=' + (SELECT USERDB FROM DataGuard.[User] WHERE UPPER(TitleEn) = UPPER(@UserName)) + ';'+ 
	                'PASSWORD=' + (SELECT PASSDB FROM DataGuard.[User] WHERE UPPER(TitleEn) = UPPER(@UserName)) + ';';
	END
	
	RETURN NULL;

END
GO
