SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [Report].[AddNewProfilers]
	-- Add the parameters for the stored procedure here
	@Xml XML,
	@ProfilerID BIGINT OUTPUT
AS
BEGIN
	INSERT INTO Report.Profiler (ShortCut, TitleFa, TitleEn, DataSourceID)
	SELECT
	   p.query('ShortCut').value('.', 'BIGINT'),
	   p.query('FaName').value('.', 'NVARCHAR(50)'),
	   p.query('EnName').value('.', 'NVARCHAR(50)'),
	   p.query('DataSource').value('.', 'BIGINT')
	FROM @Xml.nodes('//AddProfiler')t(p);
	
	SELECT @ProfilerID = MAX(ID)
	FROM Report.Profiler, @Xml.nodes('//AddProfiler')t(p)
	WHERE ShortCut = p.query('ShortCut').value('.', 'BIGINT') 
	  AND TitleFa = p.query('FaName').value('.', 'NVARCHAR(50)')
	  AND TitleEn =  p.query('EnName').value('.', 'NVARCHAR(50)')
	  AND DataSourceID = p.query('DataSource').value('.', 'BIGINT');
	
	INSERT INTO Report.Role_Profiler (RoleID, ProfilerID)
	SELECT
	   pr.query('.').value('.', 'BIGINT'),
	   @ProfilerID
	FROM @XML.nodes('//Role')t(pr);
	
	
	--RETURN @ProfilerID;	
END
GO
