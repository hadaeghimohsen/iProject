SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [ServiceDef].[LoadJoinGroupServices]
   @Xml Xml
AS
BEGIN
   
	Select 
   g.ID as GhID, g.TitleFa as GhFaName,
   s.ID as [ServiceID], s.TitleFa as SFaName, s.ParentID,
   0 as IsVisited
   from ServiceDef.Service s, ServiceDef.GroupHeader g, @Xml.nodes('/GroupHeader/GhID') t(gid)
   Where s.Level = 1
     And s.RectCode = 1
     And s.IsActive = 1
     And g.IsActive = 1
     And g.IsVisible = 1
     And g.ID = gid.query('.').value('.', 'bigint')
     And Not Exists (Select * 
                       From ServiceDef.Service_GroupHeader sg 
                       where s.ID = sg.ServiceID 
                         And g.ID = sg.GroupHeaderID
                         And sg.IsActive = 1
                         And sg.IsVisible = 1)
   ORDER BY GhID, ServiceID;
                         
   SELECT
	 'SUCCESSFUL' AS RESULT
	,'0S' AS TIMERUN
	,'ParentService' AS TABLESNAME
	,'Mojtama' As TableSpaceName
	,'false' AS [HasRelation];	                          
END
GO
