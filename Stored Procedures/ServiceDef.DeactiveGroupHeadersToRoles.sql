SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [ServiceDef].[DeactiveGroupHeadersToRoles]
	@Xml Xml
AS
Begin
   Update ServiceDef.Role_GroupHeader
   Set IsActive = 0
   Where 
   Exists (Select * From @Xml.nodes('/Deactive/GroupHeader')t(d)
            Where d.query('GroupHeaderID').value('.','bigint') = GroupHeaderID
              And d.query('RoleID').value('.','bigint') = RoleID);
RETURN 0
End
GO
