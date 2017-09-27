SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date, ,>
-- Description:	<Description, ,>
-- =============================================
CREATE FUNCTION [DataGuard].[NumberInstanceForUser]
(
	@X XML
)
RETURNS INT
AS
/*
   <Software subsys=""/>
*/
BEGIN
	DECLARE @SubSys INT;
	SELECT @SubSys = @X.query('Software').value('(Software/@subsys)[1]', 'INT');
	IF EXISTS(SELECT * FROM DataGuard.[User] WHERE UPPER(USERDB) = UPPER(SUSER_NAME()) AND DFLT_FACT = '002')
	   RETURN 99999999;
	   
	RETURN (
	   SELECT COUNT(DISTINCT PKIN_RWNO) 
        FROM DataGuard.Package_Instance_User_Gateway piug, DataGuard.Package_Instance pi
       WHERE piug.PKIN_PAKG_SUB_SYS = pi.PAKG_SUB_SYS
         AND piug.PKIN_PAKG_CODE = pi.PAKG_CODE
         AND piug.PKIN_RWNO = pi.RWNO
         AND pi.STAT = '002'
         AND piug.STAT = '002' 
         AND PKIN_PAKG_SUB_SYS = 5
         AND EXISTS(
            SELECT * 
              FROM DataGuard.[User] 
             WHERE ID = USGW_USER_ID 
               AND UPPER(USERDB) = UPPER(SUSER_NAME())
         ) 
         AND EXISTS(
            SELECT * 
              FROM DataGuard.Package_Activity 
             WHERE PAKG_SUB_SYS = 5 
               AND PAKG_CODE = PKIN_PAKG_CODE 
               AND SSIT_SUB_SYS = 5 
               AND SSIT_RWNO = 39
         )
   );
END
GO
