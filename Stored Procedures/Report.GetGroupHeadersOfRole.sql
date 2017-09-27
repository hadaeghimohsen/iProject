SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [Report].[GetGroupHeadersOfRole]
	-- Add the parameters for the stored procedure here
	@XML XML
	-- <Request Type=""><Role/><GroupHeader/></Request>
AS
BEGIN
	DECLARE @TablesReturn VARCHAR(100);
	SET @TablesReturn = 'GroupHeaders';
	DECLARE @RequestType VARCHAR(15);
	DECLARE @Role BIGINT, @GroupHeader BIGINT;
	SELECT @RequestType = @XML.query('/Request').value('(/Request/@type)[1]', 'VARCHAR(15)'),
	       @Role        = @XML.query('//Role').value('.', 'BIGINT'),
	       @GroupHeader = @XML.query('//GroupHeader').value('.', 'BIGINT');
   
 
   IF(@RequestType = 'Normal')
   
      SELECT GroupHeaderID as ID, GHFaName as FaName, RGActive as [State], DbFaName
      FROM Report.AllGroupHeadersOfRole
      WHERE RoleID = @Role AND RGVisible = 1 AND GVisible = 1 AND RVisible = 1;
      
   ELSE IF(@RequestType = 'Deleted')
      
      SELECT GroupHeaderID as ID, GHFaName as FaName, 0 as [State], DbFaName
      FROM Report.AllGroupHeadersOfRole
      WHERE RoleID = @Role AND RGVisible = 0 AND GVisible = 1 AND RVisible = 1;
      
   ELSE IF(@RequestType = 'Actived')
   
      SELECT GroupHeaderID as ID, GHFaName as FaName, 1 as [State], DbFaName
      FROM Report.AllGroupHeadersOfRole
      WHERE RoleID = @Role AND RGActive = 1 AND RGVisible = 1 AND GVisible = 1 AND RVisible = 1;
      
   ELSE IF(@RequestType = 'Deactived')
      
      SELECT GroupHeaderID as ID, GHFaName as FaName, 0 as [State], DbFaName
      FROM Report.AllGroupHeadersOfRole
      WHERE RoleID = @Role AND RGActive = 0 AND RGVisible = 1 AND GVisible = 1 AND RVisible = 1;
      
   ELSE IF(@RequestType = 'SingleDetail')
   BEGIN
      SELECT TitleFa as FaName, TitleEn as EnName, Shortcut, DataSourceID
      FROM Report.GroupHeader
      WHERE ID = @GroupHeader;
      
      SELECT RoleID
      FROM Report.Role_GroupHeader
      WHERE GroupHeaderID = @GroupHeader AND IsActive = 1 AND IsVisible = 1;
      
      SET @TablesReturn = 'GroupHeader:Roles';
   END
   ELSE IF( @RequestType = 'Leaved' )
   BEGIN
     SELECT p.ID, p.TitleFa AS FaName, 0 AS [State], (SELECT DbFaName FROM Report.AllGroupHeadersOfRole WHERE GroupHeaderID = p.ID) AS DbFaName
	    FROM Report.GroupHeader p
	   WHERE NOT EXISTS(
		   SELECT * FROM Report.Role_GroupHeader rp
		   WHERE rp.RoleID = @Role
		   AND	rp.GroupHeaderID = p.ID
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
