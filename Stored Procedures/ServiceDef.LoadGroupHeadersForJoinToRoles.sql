SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [ServiceDef].[LoadGroupHeadersForJoinToRoles]
	@Xml Xml
AS
Begin
	Select R.ID RoleID, R.TitleFa RoleFaName, G.ID GhID, G.TitleFa GhFaName
   From DataGuard.Role R, ServiceDef.GroupHeader G
   Where (R.IsActive = 1 And R.IsVisible = 1)
     And (G.IsActive = 1 And G.IsVisible = 1)
     And Not Exists (Select * From ServiceDef.Role_GroupHeader RG 
                      Where (Rg.GroupHeaderID = G.ID And Rg.RoleID = R.ID) And Not (RG.IsVisible = 0))
     And Exists (Select * From @Xml.nodes('/Join/RoleID') [role](rid) 
                  Where rid.query('.').value('.', 'bigint') = R.ID)
   Order By R.TitleFa, G.TitleFa;
	
   SELECT
	 'SUCCESSFUL' AS RESULT
	,'0S' AS TIMERUN
	,'GroupHeader' AS TABLESNAME
	,'Mojtama' As TableSpaceName
	,'false' AS [HasRelation];
RETURN 0
End
GO
