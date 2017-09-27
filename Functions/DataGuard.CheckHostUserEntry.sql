SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date, ,>
-- Description:	<Description, ,>
-- =============================================
CREATE FUNCTION [DataGuard].[CheckHostUserEntry]
(@X xml)
RETURNS varchar(3)
WITH EXEC AS CALLER
AS
BEGIN
DECLARE @MacAddress VARCHAR(17)
	    ,@UserId     BIGINT
	    ,@CpuSrno    VARCHAR(30);
	
	SELECT @UserId= ID FROM DataGuard.[User] WHERE UPPER(USERDB) = UPPER(SUSER_NAME());
	
	SELECT @MacAddress = @X.query('Computer').value('(Computer/@mac)[1]', 'VARCHAR(17)')
	      ,@CpuSrno    = @X.query('Computer').value('(Computer/@cpu)[1]', 'VARCHAR(30)');
	
	IF EXISTS(SELECT * FROM DataGuard.Gateway WHERE CPU_SRNO_DNRM = @CpuSrno)
      SELECT @MacAddress = g.MAC_ADRS
        FROM DataGuard.Gateway g
       WHERE g.CPU_SRNO_DNRM = @CpuSrno;
	
	RETURN 
	   CASE 
	      WHEN EXISTS(SELECT * FROM DataGuard.[User] WHERE ID = @UserId AND DFLT_FACT = '002') 
	        OR EXISTS(
                 SELECT *
                   FROM DataGuard.Gateway g, DataGuard.User_Gateway ug
                  WHERE g.MAC_ADRS = ug.GTWY_MAC_ADRS
                    AND g.MAC_ADRS = @MacAddress
                    AND g.CONF_STAT = '002' -- تایید شده باشد
                    AND g.VALD_TYPE_DNRM = '002' -- معتبر باشد
                    AND g.AUTH_TYPE_DNRM = '002' -- مجاز باشد
                    AND ug.USER_ID = @UserId
                    AND ug.VALD_TYPE = '002' -- معتبر باشد
                    AND ug.RWNO = (
                       SELECT MAX(RWNO)
                         FROM DataGuard.User_Gateway ugt
                        WHERE ugt.GTWY_MAC_ADRS = ug.GTWY_MAC_ADRS
                          AND ugt.USER_ID = ug.USER_ID
                    )
	      ) 
	      THEN '002' 
	      ELSE '001' 
	   END
END
GO
