SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- Configuration User Sql Server Mail Server
CREATE  PROCEDURE [Global].[ConfigurationUserMailServer] @X XML
AS
BEGIN
    BEGIN TRY
        BEGIN TRAN Cnfg_Umls_T;
    
   
-------------------------------------------------------------
--  Database Mail Simple Configuration Template.
--
--  This template creates a Database Mail profile, an SMTP account and 
--  associates the account to the profile.
--  The template does not grant access to the new profile for
--  any database principals.  Use msdb.dbo.sysmail_add_principalprofile
--  to grant access to the new profile for users who are not
--  members of sysadmin.
-------------------------------------------------------------
            
        /*
         <MailServer mailsrvr="002" emaladdr="hadaeghimohsen@yahoo.com" pswd="***" username="" userid="">
            <SqlServerMailServer type="001" stat="001" profname="hadaeghimohsen_yahoo_prof" acntname="hadaeghimohsen_yahoo_acnt" />
         </MailServer>
        */ 

        DECLARE @MailSrvr VARCHAR(3),
                @EmalAddr NVARCHAR(128) ,
                @PswdAddr VARCHAR(128),
                @UserID BIGINT,
                @UserName VARCHAR(250),
                @MailSrvrStat VARCHAR(3),
                @MailSrvrType VARCHAR(3),
                @ProfName sysname ,
                @AcntName sysname ,
                @SmtpSrvrName sysname ,                
                @SmtpPortNumb INT,
                @EnableSll BIT,
                @Display_name NVARCHAR(128);

        
        SELECT @MailSrvr = @X.query('MailServer').value('(MailServer/@mailsrvr)[1]', 'VARCHAR(3)')
              ,@EmalAddr = @X.query('MailServer').value('(MailServer/@emaladdr)[1]', 'VARCHAR(128)')
              ,@PswdAddr = @X.query('MailServer').value('(MailServer/@pswd)[1]', 'VARCHAR(128)')
              ,@UserID   = @X.query('MailServer').value('(MailServer/@userid)[1]', 'BIGINT')
              ,@UserName = @X.query('MailServer').value('(MailServer/@username)[1]', 'VARCHAR(250)');
         
        UPDATE DataGuard.[User]
           SET MAIL_SRVR = @MailSrvr
              ,EMAL_ADRS = @EmalAddr
              ,EMAL_PASS = @PswdAddr
         WHERE ID = @UserID;
        
        COMMIT TRANSACTION Cnfg_Umls_T;
        
        --BEGIN TRAN Cnfg_Umls_T;
        
        SELECT @MailSrvrStat = @X.query('//SqlServerMailServer').value('(SqlServerMailServer/@stat)[1]', 'VARCHAR(3)')
              ,@MailSrvrType = @X.query('//SqlServerMailServer').value('(SqlServerMailServer/@type)[1]', 'VARCHAR(3)')
              ,@ProfName = @X.query('//SqlServerMailServer').value('(SqlServerMailServer/@profname)[1]', 'VARCHAR(250)')
              ,@AcntName = @X.query('//SqlServerMailServer').value('(SqlServerMailServer/@acntname)[1]', 'VARCHAR(250)');
        
        -- بدست آوردن اطلاعات سرور اطلاعات
        SELECT @SmtpSrvrName = SMTP_ADRS
              ,@SmtpPortNumb = SMTP_PORT
              ,@EnableSll = CASE SMTP_SSL_MODE WHEN '001' THEN 0 WHEN '002' THEN 1 END
          FROM Global.Mail_Server
         WHERE EMAL_SRVR = @MailSrvr;
              
        -- Profile name. Replace with the name for your profile
        -- Account information. Replace with the information for your account.
        SET @display_name = @UserName;
        
        IF @MailSrvrType = '001' -- Insert
        BEGIN         
           IF EXISTS ( SELECT  *
                FROM    msdb.dbo.sysmail_profile
                WHERE   UPPER(name) = UPPER(@ProfName)
                        AND UPPER([description]) <> UPPER(@UserName) )        
           BEGIN
                RAISERROR(N'نام پروفایل وارد شده برای کاربر تکراری می باشد', 16, 1);
                RETURN -1;
           END;

           IF EXISTS ( SELECT  *
                       FROM    msdb.dbo.sysmail_account
                       WHERE   UPPER(name) = UPPER(@AcntName)
                               AND UPPER([description]) <> UPPER(@UserName) )
           BEGIN
                RAISERROR('نام حساب کاربری تکراری می باشد', 16, 1);
                RETURN -2;
           END;

           -- Start a transaction before adding the account and the profile
           DECLARE @rv INT;
           
           
           IF EXISTS ( SELECT  *
                FROM    msdb.dbo.sysmail_profile
                WHERE   UPPER(name) = UPPER(@ProfName)
                        AND UPPER([description]) = UPPER(@UserName) )        
           BEGIN
                RETURN 0;
           END;
           
           IF EXISTS ( SELECT  *
                       FROM    msdb.dbo.sysmail_account
                       WHERE   UPPER(name) = UPPER(@AcntName)
                               AND UPPER([description]) = UPPER(@UserName) )
           BEGIN
                RETURN 0;
           END;        

           -- Add the account
           EXECUTE @rv= msdb.dbo.sysmail_add_account_sp @account_name = @acntname,
               @email_address = @emaladdr, @description = @display_name,
               @mailserver_name = @smtpsrvrname, @port = @SmtpPortNumb, 
               @username = @EmalAddr , @password = @PswdAddr, @enable_ssl = @EnableSll;

           IF @rv <> 0
               BEGIN
                   RAISERROR('Failed to create the specified Database Mail account (<account_name,sysname,SampleAccount>).', 16, 1);
                   RETURN -3;
               END;

           -- Add the profile
           EXECUTE @rv= msdb.dbo.sysmail_add_profile_sp @profile_name = @profname, @description = @Display_name ;

           IF @rv <> 0
               BEGIN
                   RAISERROR('Failed to create the specified Database Mail profile (<profile_name,sysname,SampleProfile>).', 16, 1);
                   RETURN -4;
               END;
           
           EXECUTE msdb.dbo.sysmail_add_principalprofile_sp
             @principal_name = 'public',
             @profile_name = @ProfName,
             @is_default = 1 ;


           -- Associate the account with the profile.
           EXECUTE @rv= msdb.dbo.sysmail_add_profileaccount_sp @profile_name = @profname,
               @account_name = @acntname, @sequence_number = 1 ;

           IF @rv <> 0
               BEGIN
                   RAISERROR('Failed to associate the speficied profile with the specified account (<account_name,sysname,SampleAccount>).', 16, 1);
                   RETURN -5;
               END;
           
           UPDATE DataGuard.[User]
              SET MAIL_SRVR_STAT = @MailSrvrStat
                 ,MAIL_SRVR_PROF = @ProfName
                 ,MAIL_SRVR_ACNT = @AcntName
            WHERE ID = @UserID;
        END 
        ELSE IF @MailSrvrType = '002' -- delete
        BEGIN                              
            IF EXISTS ( SELECT  *
                          FROM    msdb.dbo.sysmail_account
                          WHERE   UPPER(name) = UPPER(@AcntName)
                                  AND UPPER([description]) = UPPER(@UserName) )
            BEGIN
               EXECUTE msdb.dbo.sysmail_delete_account_sp  @account_name = @AcntName ;                  
            END;               
            
            EXECUTE msdb.dbo.sysmail_delete_principalprofile_sp @principal_name = 'public', @profile_name = @ProfName ;
            
            IF EXISTS ( SELECT  *
                          FROM    msdb.dbo.sysmail_profile
                         WHERE   UPPER(name) = UPPER(@ProfName)
                                 AND UPPER([description]) = UPPER(@UserName) )        
            BEGIN
               EXECUTE msdb.dbo.sysmail_delete_profile_sp  @profile_name = @ProfName ;              
            END;
            
            UPDATE DataGuard.[User]
               SET MAIL_SRVR_STAT = '001'
                  ,MAIL_SRVR_PROF = NULL
                  ,MAIL_SRVR_ACNT = NULL
             WHERE id = @UserID;
        END
        --COMMIT TRANSACTION Cnfg_Umls_T;
        RETURN 0;

    END TRY
    BEGIN CATCH
        DECLARE @ErrorMessage NVARCHAR(4000);
        SET @ErrorMessage = ERROR_MESSAGE();
        RAISERROR ( @ErrorMessage, -- Message text.
               16, -- Severity.
               1 -- State.
               );
        ROLLBACK TRAN Cnfg_Umls_T;
        RETURN -1;
    END CATCH;
END;
GO
