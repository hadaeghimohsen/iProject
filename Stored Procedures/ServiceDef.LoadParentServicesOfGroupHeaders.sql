SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [ServiceDef].[LoadParentServicesOfGroupHeaders]
(
   @Xml Xml
)
AS
Begin
   Declare @idoc int;
   Exec sp_xml_preparedocument @idoc output, @Xml;
   
   Select ASG.GroupHeaderID, ASG.GhFaName, ASG.ServiceID, ASG.SFaName, Asg.ParentID, ASG.SGActive, 0 as [IsVisited]
   From ServiceDef.AllServicesGroupHeaders ASG,
   (
    Select [GroupHeaderID]
    From OpenXml(@idoc, '/GroupHeader/GroupHeaderID', 1)
    With ([GroupHeaderID] bigint '.')
   ) SG
   Where SG.GroupHeaderID = ASG.GroupHeaderID
   Order By ASG.GroupHeaderID, ASG.ServiceID, ASG.ParentID;
   
   Exec sp_xml_removedocument @idoc;

   SELECT
	 'SUCCESSFUL' AS RESULT
	,'0S' AS TIMERUN
	,'ParentService' AS TABLESNAME
	,'iProject' As TableSpaceName
	,'false' AS [HasRelation];
RETURN 0
End
GO
