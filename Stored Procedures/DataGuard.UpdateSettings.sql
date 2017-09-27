SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [DataGuard].[UpdateSettings]
   @X XML
AS
BEGIN
	DECLARE @ExpireType BIT
          ,@ExpireDate DATE
          ,@SessionType VARCHAR(20)
          ,@SessionMaxConnection INT
          ,@SessionOpenedConnection INT;
   
   IF NOT EXISTS(SELECT * FROM SETTINGS)
      RETURN 0;
   
   SELECT @ExpireType = x.query('//AppExpire').value('(AppExpire/@type)[1]','BIT')
         ,@ExpireDate = x.query('//AppExpire').value('(AppExpire/@value)[1]','DATE')
         ,@SessionType = x.query('//Session').value('(Session/@type)[1]','VARCHAR(20)')
         ,@SessionMaxConnection = x.query('//Session').value('(Session/@max)[1]','INT')
         ,@SessionOpenedConnection = x.query('//Session').value('(Session/@count)[1]','INT')
     FROM SETTINGS X;
   PRINT @SessionOpenedConnection;
   SET @SessionOpenedConnection = @SessionOpenedConnection + 1;
   PRINT @SessionOpenedConnection;
   UPDATE SETTINGS
      SET X.modify('replace value of (//Session/@count)[1] with sql:variable("@SessionOpenedConnection")');
END
GO
