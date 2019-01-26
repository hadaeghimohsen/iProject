SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [DataGuard].[TakedbBackup]
	@X XML
AS
BEGIN
   DECLARE @BackUpStat VARCHAR(3)
          ,@BackupAppExit BIT
          ,@BackupPathAdrs NVARCHAR(MAX)
          ,@BackupType VARCHAR(20) = 'Normal'
          ,@SubSys INT
          ,@DbName SYSNAME;

   
   DECLARE C$SubSys CURSOR FOR
      SELECT SUB_SYS
            ,SCHM_NAME 
            ,BACK_UP_STAT
            ,BACK_UP_APP_EXIT
            ,BACK_UP_PATH_ADRS
        FROM DataGuard.Sub_System
       WHERE INST_STAT = '002'
         AND STAT = '002'
         AND SUB_SYS IN (0, 5, 11 , 12);
   
   OPEN [C$SubSys];
   L$LOOP:
   FETCH [C$SubSys] INTO @SubSys, @DbName, @BackUpStat, @BackupAppExit, @BackupPathAdrs;
   
   IF @SubSys = 0
      SET @DbName = 'iProject';
   
   IF @@FETCH_STATUS <> 0
      GOTO L$EndLoop;
   
   ---------------------
   SET NOCOUNT ON

   -- 1 - Variable declaration
   --DECLARE @DBName sysname
   DECLARE @DataPath nvarchar(500)
   DECLARE @LogPath nvarchar(500)
   DECLARE @DirTree TABLE (subdirectory nvarchar(255), depth INT)

   SET @DBName = @DbName + '_' + @BackupType + '_' + UPPER(SUSER_NAME()) + '_' + REPLACE(dbo.MiladiTOShamsi(GETDATE()), '/', '') + '_' + REPLACE(SUBSTRING(dbo.GetCurDateTimeDetail(), LEN(dbo.GetCurDateTimeDetail()) - 7, 10 ), ':', '') + '.bak';
   -- 2 - Initialize variables
   SET @DataPath = @BackupPathAdrs + '\Backup'

   -- 3 - @DataPath values
   INSERT INTO @DirTree(subdirectory, depth)
   EXEC master.sys.xp_dirtree @DataPath

   -- 4 - Create the @DataPath directory
   IF NOT EXISTS (SELECT 1 FROM @DirTree)
   EXEC master.dbo.xp_create_subdir @DataPath
   
   SET @DataPath = @DataPath + '\' + @DBName;
   SET NOCOUNT OFF
   ---------------------
   IF @SubSys = 0
      BACKUP DATABASE [iProject] TO  DISK = @DataPath WITH NOFORMAT, INIT,  NAME = N'iProject-Full Database Backup', SKIP, NOREWIND, NOUNLOAD,  STATS = 10
   ELSE IF @SubSys = 5
	   BACKUP DATABASE [iScsc] TO  DISK = @DataPath WITH NOFORMAT, INIT,  NAME = N'iScsc-Full Database Backup', SKIP, NOREWIND, NOUNLOAD,  STATS = 10
   ELSE IF @SubSys = 11
      BACKUP DATABASE [iCRM] TO  DISK = @DataPath WITH NOFORMAT, INIT,  NAME = N'iCRM-Full Database Backup', SKIP, NOREWIND, NOUNLOAD,  STATS = 10
   ELSE IF @SubSys = 12
      BACKUP DATABASE [iRoboTech] TO  DISK = @DataPath WITH NOFORMAT, INIT,  NAME = N'iRoboTech-Full Database Backup', SKIP, NOREWIND, NOUNLOAD,  STATS = 10
   
   GOTO L$Loop;
   L$ENDLOOP:
   CLOSE [C$SubSys];
   DEALLOCATE [C$SubSys];
      
END
GO
