SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [DataGuard].[ShrinkLogFileDb]	
AS
BEGIN
   BEGIN TRY
      
	IF EXISTS (SELECT name FROM sys.databases WHERE name = N'iCRM')
	BEGIN
	   EXEC iCRM.dbo.ShrinkLogFileDb;
	END
	
	IF EXISTS (SELECT name FROM sys.databases WHERE name = N'iCRM001')
	BEGIN
	   EXEC iCRM001.dbo.ShrinkLogFileDb;
	END
	
	--IF EXISTS (SELECT name FROM sys.databases WHERE name = N'iDental')
	--BEGIN
	--   EXEC iDental.dbo.ShrinkLogFileDb;
	--END
	
	--IF EXISTS (SELECT name FROM sys.databases WHERE name = N'iDental001')
	--BEGIN
	--   EXEC iDental001.dbo.ShrinkLogFileDb;
	--END
	
	--IF EXISTS (SELECT name FROM sys.databases WHERE name = N'iISP')
	--BEGIN
	--   EXEC iISP.dbo.ShrinkLogFileDb;
	--END
	
	--IF EXISTS (SELECT name FROM sys.databases WHERE name = N'iISP001')
	--BEGIN
	--   EXEC iISP001.dbo.ShrinkLogFileDb;
	--END
	
	IF EXISTS (SELECT name FROM sys.databases WHERE name = N'iProject')
	BEGIN
	   ALTER DATABASE iProject SET RECOVERY SIMPLE;
	   DBCC SHRINKFILE('iProject_log', 1);
	   ALTER DATABASE iProject SET RECOVERY FULL;
	   PRINT 'iProject Log File Shrink 1 MB';
	END
	
	IF EXISTS (SELECT name FROM sys.databases WHERE name = N'iRoboTech')
	BEGIN
	   EXEC iRoboTech.dbo.ShrinkLogFileDb;
	END
	
	IF EXISTS (SELECT name FROM sys.databases WHERE name = N'iScsc')
	BEGIN
	   EXEC iScsc.dbo.ShrinkLogFileDb;
	END
	
	IF EXISTS (SELECT name FROM sys.databases WHERE name = N'iScsc001')
	BEGIN
	   EXEC iScsc001.dbo.ShrinkLogFileDb;
	END
	END TRY
	BEGIN CATCH
	   DECLARE @ErrorMessage NVARCHAR(MAX);
	   SET @ErrorMessage = ERROR_MESSAGE();
	   PRINT @ErrorMessage;
      /*RAISERROR ( @ErrorMessage, -- Message text.
               16, -- Severity.
               1 -- State.
               );*/
	END CATCH	
END
GO
