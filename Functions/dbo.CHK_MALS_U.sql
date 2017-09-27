SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date, ,>
-- Description:	<Description, ,>
-- =============================================
CREATE FUNCTION [dbo].[CHK_MALS_U] ( @X XML )
RETURNS INT
AS
BEGIN
/*
   <MailServer type="001" username="artauser" typedesc="check profile name">
      <Profile name=""/>
      <Account name=""/>
   </MailServer>
*/
   DECLARE @type VARCHAR(50) ,
      @UserName VARCHAR(250) ,
      @ProfileName VARCHAR(250) ,
      @AccountName VARCHAR(250);

   SELECT  @type = @X.query('MailServer').value('(MailServer/@type)[1]','VARCHAR(50)') ,
          @UserName = @X.query('MailServer').value('(MailServer/@username)[1]','VARCHAR(250)');

   IF @type = '001'
   BEGIN
   -- Check Profile Name
        SELECT  @ProfileName = @X.query('Profile').value('(Profile/@name)[1]','VARCHAR(250)');
        IF EXISTS ( SELECT  *
                FROM    msdb.dbo.sysmail_profile
                WHERE   UPPER(name) = UPPER(@ProfileName)
                        AND UPPER([description]) <> UPPER(@UserName) )
        BEGIN
            RETURN -1;
        END;	   
   END;
   ELSE
   IF @type = '002'
   BEGIN
    -- Check Account Name
        SELECT  @AccountName = @X.query('Account').value('(Account/@name)[1]','VARCHAR(250)');
        IF EXISTS ( SELECT  *
                    FROM    msdb.dbo.sysmail_account
                    WHERE   UPPER(name) = UPPER(@AccountName)
                            AND UPPER([description]) <> UPPER(@UserName) )
            BEGIN
                RETURN -2;
            END;
   END;	

   RETURN 0;
END;


GO
