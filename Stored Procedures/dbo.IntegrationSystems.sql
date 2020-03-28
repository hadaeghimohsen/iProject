SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[IntegrationSystems]
AS
BEGIN
    EXEC DataGuard.ShrinkLogFileDb;
	
    DECLARE @HostName NVARCHAR(128) ,
        @Cpu VARCHAR(30) ,
        @ip VARCHAR(15);
    SELECT  @HostName = s.host_name
    FROM    sys.dm_exec_connections AS c
    JOIN    sys.dm_exec_sessions AS s ON c.session_id = s.session_id
    WHERE   c.session_id = @@SPID; 
      
    SELECT  @Cpu = CPU_SRNO_DNRM ,
            @ip = IP_DNRM ,
            @HostName = COMP_NAME_DNRM
    FROM    DataGuard.Gateway
    WHERE   UPPER(COMP_NAME_DNRM) LIKE UPPER(@HostName) + N'%';
	
    DECLARE C$UserNotGateway CURSOR
    FOR
    SELECT  USERDB
    FROM    iProject.DataGuard.[User]
    WHERE   ShortCut NOT IN ( 16, 21, 22 );
	
    DECLARE @UserDb NVARCHAR(255);
	
    OPEN [C$UserNotGateway];
    L$Loop_C$UserNotGateway:
    FETCH NEXT FROM [C$UserNotGateway] INTO @UserDb;
	
    IF @@FETCH_STATUS <> 0
        GOTO L$EndLoop_C$UserNotGateway;	   
	
    DECLARE @XT XML;
    SELECT  @XT = ( SELECT  'ManualSaveHostInfo' AS '@Rqtp_Code' ,
                            'installing' AS '@SystemStatus' ,
                            'iProject' AS 'Database' ,
                            'SqlServer' AS 'Dbms' ,
                            @UserDb AS 'User' ,
                            @HostName AS 'Computer/@name' ,
                            @Cpu AS 'Computer/@mac' ,
                            @ip AS 'Computer/@ip' ,
                            @Cpu AS 'Computer/@cpu'
                  FOR
                    XML PATH('Request')
                  );
      
    EXEC DataGuard.SaveHostInfo @X = @XT;
   
    GOTO L$Loop_C$UserNotGateway;
    L$EndLoop_C$UserNotGateway:
    CLOSE [C$UserNotGateway];
    DEALLOCATE [C$UserNotGateway];
   
    UPDATE  DataGuard.Sub_System
    SET     LICN_TRIL_DATE = ISNULL(LICN_TRIL_DATE, DATEADD(DAY, 365, GETDATE())) ,
            BACK_UP_STAT = '002' ,
            BACK_UP_APP_EXIT = '001';
   
    IF EXISTS ( SELECT  name
                FROM    sys.databases
                WHERE   name = N'iScsc' )
    BEGIN
        EXEC iScsc.dbo.IntegrationSystems;
    END;
	
    IF EXISTS ( SELECT  name
                FROM    sys.databases
                WHERE   name = N'iScsc001' )
    BEGIN
        EXEC iScsc001.dbo.IntegrationSystems;
    END;
	
    IF EXISTS ( SELECT  name
                FROM    sys.databases
                WHERE   name = 'iCRM' )
    BEGIN
        EXEC iCRM.dbo.IntegrationSystems;
    END;
	
	--IF EXISTS (select NAME FROM sys.databases WHERE name = 'iCRM001')
	--BEGIN
	--    EXEC iCRM001.dbo.IntegrationSystems
	--END
	
    IF EXISTS ( SELECT  name
                FROM    sys.databases
                WHERE   name = 'iRoboTech' )
    BEGIN
        EXEC iRoboTech.dbo.IntegrationSystems;
    END;
END;
GO
