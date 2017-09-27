SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [DataGuard].[CreateOrReplaceBoxPrivilege]
	-- Add the parameters for the stored procedure here
	@X XML
	/*
	   <Box_Privilege bpid="" subsys="" boxpdesc=""/>
	*/
AS
BEGIN
	DECLARE @Bpid BIGINT,
	        @SubSys INT,
	        @BoxpDesc NVARCHAR(250);
	
	SELECT @Bpid = @X.query('.').value('(Box_Privilege/@bpid)[1]', 'BIGINT'),
	       @SubSys = @X.query('.').value('(Box_Privilege/@subsys)[1]', 'INT'),
	       @BoxpDesc = @X.query('.').value('(Box_Privilege/@boxpdesc)[1]', 'NVARCHAR(250)');
   
   IF ISNULL(@Bpid , 0) = 0 
      INSERT INTO DataGuard.Box_Privilege
              ( SUB_SYS ,
                BOXP_DESC 
              )
      VALUES  ( @SubSys , -- SUB_SYS - int
                @BoxpDesc  -- BOXP_DESC - nvarchar(250)                
              );
   ELSE IF ISNULL(@Bpid, 0) <> 0
      UPDATE DataGuard.Box_Privilege
         SET BOXP_DESC = @BoxpDesc
       WHERE BPID = @Bpid
         AND SUB_SYS = @SubSys;
END
GO
