SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [DataGuard].[DeleteBoxPrivilege]
	-- Add the parameters for the stored procedure here
	@X XML
	/*
	   <Box_Privilege bpid="" subsys="" boxpdesc=""/>
	*/
AS
BEGIN
	DECLARE @Bpid BIGINT,
	        @SubSys INT;

	
	SELECT @Bpid = @X.query('.').value('(Box_Privilege/@bpid)[1]', 'BIGINT'),
	       @SubSys = @X.query('.').value('(Box_Privilege/@subsys)[1]', 'INT');

   DELETE DataGuard.Box_Privilege   
    WHERE BPID = @Bpid
      AND SUB_SYS = @SubSys;
END
GO
