SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [Report].[GetProfilesofRole]
	-- Add the parameters for the stored procedure here
	@Xml XML
AS
BEGIN
   DECLARE @TablesReturn VARCHAR(50);
   SET @TablesReturn = 'Profilers';
   
	DECLARE @RequestType VARCHAR(15);
	DECLARE @Role BIGINT, @Profiler BIGINT;
	SELECT @RequestType = @XML.query('/Request').value('(/Request/@type)[1]', 'VARCHAR(15)'), 
	       @Role = @XML.query('/Request/Role').value('.', 'BIGINT'),
	       @Profiler = @Xml.query('//Request/Profiler').value('.', 'BIGINT');
	
	IF( @RequestType = 'Normal')
      
      SELECT ProfilerID as ID, ProfileFaName As FaName, RPActive As [State], DbFaName 
      FROM Report.AllProfilersOfRole 
      WHERE RoleID = @Role AND RPVisible = 1 AND PVisible = 1 AND RVisible = 1
      
   ELSE IF ( @RequestType = 'Deleted')
      
      SELECT ProfilerID as ID, ProfileFaName As FaName, 0        As [State], DbFaName 
      FROM Report.AllProfilersOfRole 
      WHERE RoleID = @Role AND RPVisible = 0 AND PVisible = 1 AND RVisible = 1
      
   ELSE IF ( @RequestType = 'Actived' )
   
      SELECT ProfilerID as ID, ProfileFaName As FaName, 1        As [State], DbFaName 
      FROM Report.AllProfilersOfRole 
      WHERE RoleID = @Role AND RPActive = 1 AND RPVisible = 1 AND PVisible = 1 AND RVisible = 1
   
   ELSE IF ( @RequestType = 'Deactived' )
   
      SELECT ProfilerID as ID, ProfileFaName As FaName, 0        As [State], DbFaName 
      FROM Report.AllProfilersOfRole 
      WHERE RoleID = @Role AND RPActive = 0 AND RPVisible = 1 AND PVisible = 1 AND RVisible = 1
   
   ELSE IF ( @RequestType = 'SingleDetail' )
   BEGIN
      SELECT TitleFa as [FaName], TitleEn as [EnName], ShortCut, DataSourceID 
      FROM Report.Profiler 
      WHERE ID = @Profiler;
      
      SELECT RoleID 
      FROM Report.Role_Profiler 
      WHERE ProfilerID = @Profiler AND IsActive = 1 AND IsVisible = 1;
      
      SET @TablesReturn = 'Profiler:Roles';      
   END  
   ELSE IF( @RequestType = 'Leaved' )
   BEGIN
     SELECT p.ID, p.TitleFa AS FaName, 0 AS [State], (SELECT DbFaName FROM Report.AllProfilersOfRole WHERE ProfilerID = p.ID) AS DbFaName
	    FROM Report.Profiler p
	   WHERE NOT EXISTS(
		   SELECT * FROM Report.Role_Profiler rp
		   WHERE rp.RoleID = @Role
		   AND	rp.ProfilerID = p.ID
		   AND rp.IsVisible = 1
	   );
   END;    

   SELECT
	 'SUCCESSFUL' AS RESULT
	,'0S' AS TIMERUN
	,@TablesReturn AS TABLESNAME
	,'Mojtama' As TableSpaceName
	,'false' AS [HasRelation];  		
	
END
GO
