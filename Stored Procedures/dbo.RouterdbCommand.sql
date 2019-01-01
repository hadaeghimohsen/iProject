SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[RouterdbCommand]
	-- Add the parameters for the stored procedure here
	/*
	   <Router_Command subsys="5" cmndcode="1" cmnddesc="خواندن اطلاعات مشتریان با شماره کدملی و موبایل">
	      <Service fileno="13971010125456564" cellphon="09033927103"/>	      
	   </Router_Command>
	*/
	@X XML
AS
BEGIN
   BEGIN TRY
   BEGIN TRAN ROTR_DBCM_T
	DECLARE @SubSys INT
	       ,@CmndCode VARCHAR(10)
	       ,@CmndDesc NVARCHAR(100);
   
   SELECT @SubSys = @X.query('Router_Command').value('(Router_Command/@subsys)[1]', 'INT')
         ,@CmndCode = @X.query('Router_Command').value('(Router_Command/@cmndcode)[1]', 'VARCHAR(10)');
   
   IF @SubSys = '5' AND EXISTS (SELECT name FROM sys.databases WHERE name = N'iScsc')
   BEGIN   
      EXEC iScsc.dbo.RouterdbCommand @X = @X -- xml      
   END
   
   COMMIT TRAN ROTR_DBCM_T;
   RETURN 1;
   END TRY
   BEGIN CATCH
      DECLARE @ErrorMessage NVARCHAR(MAX);
      SET @ErrorMessage = ERROR_MESSAGE();
      RAISERROR ( @ErrorMessage, -- Message text.
               16, -- Severity.
               1 -- State.
               );
      ROLLBACK TRAN ROTR_DBCM_T;
   END CATCH
END
GO
