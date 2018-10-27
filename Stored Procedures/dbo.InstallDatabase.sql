SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[InstallDatabase]
	-- Add the parameters for the stored procedure here
	@X XML
AS
BEGIN
   BEGIN TRY   
   -- Delete Record From Database
   DELETE DataGuard.Gateway_Public;
   DELETE DataGuard.Package_Instance_User_Qiuck_Action;
   DELETE DataGuard.Package_Instance_User_Gateway;
   DELETE DataGuard.Active_Session;
   DELETE DataGuard.User_Gateway;
   DELETE Global.Transaction_Log;
   DELETE Global.Pos_Device;
   DELETE Global.Script_Parameter;
   DELETE Global.Script;
   DELETE DataGuard.Gateway;   
   DELETE DataGuard.[User] WHERE ShortCut NOT IN (16, 21, 22);
   DELETE Report.Profiler;
   DELETE Report.GroupHeader;
   DELETE Global.Access_User_Datasource;
   DELETE Report.DataSource;
   DELETE Msgb.Sms_Message_Box;
   UPDATE DataGuard.Sub_System SET STAT = '001', INST_STAT = '001', CLNT_LICN_DESC = NULL, SRVR_LICN_DESC = NULL, LICN_TYPE = NULL, LICN_TRIL_DATE = NULL;

   BEGIN TRAN T_INSTALLDB   
   -- Insert Default Value
   DECLARE @TinySN VARCHAR(100);
   SELECT @TinySN = @X.query('Params').value('(Params/@tinyserialno)[1]','VARCHAR(100)');
   
   UPDATE dbo.Settings
      SET x.modify('replace value of (/Settings/TinyLock/@serialno)[1] with sql:variable("@TinySN")')
   
   -- Save Host Info
   /*
   '<Request Rqtp_Code="ManualSaveHostInfo">
      <Database>iProject</Database>
      <Dbms>SqlServer</Dbms>
      <User>scott</User>
      <Computer name="DESKTOP-LB0GKTR" 
                ip="192.168.158.1" 
                mac="00:50:56:C0:00:01" 
                cpu="BFEBFBFF000206A7" />
    </Request>'
   */
   DECLARE  @RqtpCode      VARCHAR(30)
           ,@ComputerName VARCHAR(50)
           ,@IPAddress    VARCHAR(15)
           ,@MacAddress   VARCHAR(17)
           ,@Cpu      VARCHAR(30)
           ,@UserName     VARCHAR(250)
           ,@UserId       BIGINT
           ,@InstallLicenseKey NVARCHAR(4000);
   
   SELECT @ComputerName = @X.query('//Computer').value('(Computer/@name)[1]', 'VARCHAR(50)')
         ,@Cpu = @X.query('//Computer').value('(Computer/@cpu)[1]', 'VARCHAR(30)')
         ,@InstallLicenseKey = @X.query('//Params').value('(Params/@licensekey)[1]', 'NVARCHAR(4000)');;
   
   -- Save Datasource and Connection
   INSERT INTO Report.DataSource
   ( ID ,ShortCut ,DatabaseServer ,IPAddress ,Port ,
     Database_Alias ,[Database] ,UserID ,Password ,TitleFa ,
     IsDefault ,IsActive ,IsVisible ,SUB_SYS 
   )
   VALUES  
   ( 0 ,0 ,1 ,@ComputerName,0 , 
     'iProject' ,'iProject' ,'' , '' , N'هسته نرم افزار انار' , 
     1 , 1 , 1 , 0  );
   
   INSERT INTO Report.DataSource
   ( ID ,ShortCut ,DatabaseServer ,IPAddress ,Port ,
     Database_Alias ,[Database] ,UserID ,Password ,TitleFa ,
     IsDefault ,IsActive ,IsVisible ,SUB_SYS 
   )
   VALUES  
   ( 1 ,1 ,1 ,@ComputerName,0 , 
     NULL ,'master' ,'scott' , 'abcABC123!@#' , N'SQLSERVER' , 
     1 , 1 , 1 , NULL );
        
   DECLARE @XT XML;
   SELECT @XT = (
      SELECT 'ManualSaveHostInfo' AS '@Rqtp_Code'
            ,'installing' AS '@SystemStatus'
            ,'iProject' AS 'Database'
            ,'SqlServer' AS 'Dbms'
            ,'scott' AS 'User'            
            ,@X.query('//Computer').value('(Computer/@name)[1]', 'VARCHAR(50)') AS 'Computer/@name'
            ,@X.query('//Computer').value('(Computer/@mac)[1]', 'VARCHAR(17)') AS 'Computer/@mac'
            ,@X.query('//Computer').value('(Computer/@ip)[1]', 'VARCHAR(15)') AS 'Computer/@ip'
            ,@X.query('//Computer').value('(Computer/@cpu)[1]', 'VARCHAR(30)') AS 'Computer/@cpu'
        FOR XML PATH('Request')
   );
   
   EXEC DataGuard.SaveHostInfo @X = @XT;
   
   SELECT @XT = (
      SELECT 'ManualSaveHostInfo' AS '@Rqtp_Code'
            ,'installing' AS '@SystemStatus'
            ,'iProject' AS 'Database'
            ,'SqlServer' AS 'Dbms'
            ,'artauser' AS 'User'            
            ,@X.query('//Computer').value('(Computer/@name)[1]', 'VARCHAR(50)') AS 'Computer/@name'
            ,@X.query('//Computer').value('(Computer/@mac)[1]', 'VARCHAR(17)') AS 'Computer/@mac'
            ,@X.query('//Computer').value('(Computer/@ip)[1]', 'VARCHAR(15)') AS 'Computer/@ip'
            ,@X.query('//Computer').value('(Computer/@cpu)[1]', 'VARCHAR(30)') AS 'Computer/@cpu'
        FOR XML PATH('Request')
   );
   
   EXEC DataGuard.SaveHostInfo @X = @XT;

   SELECT @XT = (
      SELECT 'ManualSaveHostInfo' AS '@Rqtp_Code'
            ,'installing' AS '@SystemStatus'
            ,'iProject' AS 'Database'
            ,'SqlServer' AS 'Dbms'
            ,'demo' AS 'User'            
            ,@X.query('//Computer').value('(Computer/@name)[1]', 'VARCHAR(50)') AS 'Computer/@name'
            ,@X.query('//Computer').value('(Computer/@mac)[1]', 'VARCHAR(17)') AS 'Computer/@mac'
            ,@X.query('//Computer').value('(Computer/@ip)[1]', 'VARCHAR(15)') AS 'Computer/@ip'
            ,@X.query('//Computer').value('(Computer/@cpu)[1]', 'VARCHAR(30)') AS 'Computer/@cpu'
        FOR XML PATH('Request')
   );
   
   EXEC DataGuard.SaveHostInfo @X = @XT;   
   
   UPDATE DataGuard.Sub_System SET STAT = '002', INST_STAT = '002', CLNT_LICN_DESC = NULL, SRVR_LICN_DESC = NULL, LICN_TYPE = NULL, LICN_TRIL_DATE = NULL, INST_LICN_DESC = @InstallLicenseKey WHERE SUB_SYS IN (0,1,2);   
   
   INSERT INTO Global.Access_User_Datasource
   ( USER_ID ,DSRC_ID ,STAT ,ACES_TYPE ,
     HOST_NAME )
   SELECT id, 0, '002', '001', @Cpu
     FROM DataGuard.[User]
    WHERE ShortCut IN (16, 21, 22);
   
   COMMIT TRAN T_INSTALLDB;
   END TRY
   BEGIN CATCH
      DECLARE @ErrorMessage NVARCHAR(MAX);
      SET @ErrorMessage = ERROR_MESSAGE();
      RAISERROR ( @ErrorMessage, -- Message text.
               16, -- Severity.
               1 -- State.
               );
      ROLLBACK TRAN T_INSTALLDB;
   END CATCH;   
END
GO
