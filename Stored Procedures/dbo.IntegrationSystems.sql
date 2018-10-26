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
	
	IF EXISTS (SELECT name FROM sys.databases WHERE name = N'iScsc')
	BEGIN
	   EXEC iScsc.dbo.IntegrationSystems
	END
	
	IF EXISTS (SELECT name FROM sys.databases WHERE name = N'iScsc001')
	BEGIN
	   EXEC iScsc.dbo.IntegrationSystems
	End
END
GO
