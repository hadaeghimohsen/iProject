SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [Global].[ExecuteJobScheduleSubSystem]	
   @X XML
AS
BEGIN        
	IF EXISTS (SELECT name FROM sys.databases WHERE name = N'iCRM')
	BEGIN
	   EXEC iCRM.dbo.EXEC_JOBS_P @X = @X -- xml	   
	END;
	
	IF EXISTS (SELECT name FROM sys.databases WHERE name = N'iCRM001')
	BEGIN
	   EXEC iCRM001.dbo.EXEC_JOBS_P @X = @X -- xml	   
	END;
	
	IF EXISTS (SELECT name FROM sys.databases WHERE name = N'iCRM002')
	BEGIN
	   EXEC iCRM002.dbo.EXEC_JOBS_P @X = @X -- xml	   
	END;
	
	IF EXISTS (SELECT name FROM sys.databases WHERE name = N'iDental')
	BEGIN
	   --EXEC iDental.dbo.EXEC_JOBS_P @X = @X -- xml
	   PRINT 'Run Job'
	END;
	
	IF EXISTS (SELECT name FROM sys.databases WHERE name = N'iISP')
	BEGIN
	   --EXEC iISP.dbo.EXEC_JOBS_P @X = @X -- xml
	   PRINT 'Run Job'
	END;
	
	IF EXISTS (SELECT name FROM sys.databases WHERE name = N'iProject')
	BEGIN	   
	   PRINT 'iProject Job Print';
	END;
	
	IF EXISTS (SELECT name FROM sys.databases WHERE name = N'iRoboTech')
	BEGIN
	   --EXEC iRoboTech.dbo.ShrinkLogFileDb;
	   PRINT 'Run Job'
	END;
	
	IF EXISTS (SELECT name FROM sys.databases WHERE name = N'iScsc')
	BEGIN
	   --EXEC iScsc.dbo.ShrinkLogFileDb;
	   PRINT 'Run Job'
	END;
END
GO
