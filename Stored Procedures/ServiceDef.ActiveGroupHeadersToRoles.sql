SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [ServiceDef].[ActiveGroupHeadersToRoles]
	@Xml Xml
AS
Begin
   Update ServiceDef.Role_GroupHeader
   Set IsActive = 1
   Where 
   Exists (Select * From @Xml.nodes('/Active/GroupHeader')t(d)
            Where d.query('GroupHeaderID').value('.','bigint') = GroupHeaderID
              And d.query('RoleID').value('.','bigint') = RoleID);
RETURN 0
End
GO
