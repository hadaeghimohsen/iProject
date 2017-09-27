SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [ServiceDef].[LeaveGroupHeadersFromRoles]
	@Xml Xml
AS
Begin
	Update ServiceDef.Role_GroupHeader 
   Set IsVisible = 0
   Where 
   Exists 
   (
      Select * from @Xml.nodes('/Leave/GroupHeader')gh(ghid)
      Where GroupHeaderID = ghid.query('GroupHeaderID').value('.','bigint')
        And RoleID = ghid.query('RoleID').value('.', 'bigint')
   );
   RETURN 0
End
GO
