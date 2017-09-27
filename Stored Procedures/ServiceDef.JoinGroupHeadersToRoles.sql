SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [ServiceDef].[JoinGroupHeadersToRoles]
(
   @Xml Xml
)
AS
Begin
	Merge ServiceDef.[Role_GroupHeader] as RGT
   Using (Select 
            d.query('GroupHeaderID').value('.', 'bigint') as GhID,
            d.query('RoleID').value('.', 'bigint') as RoleID
            From @Xml.nodes('/Join/GroupHeader') t(d) ) as RGS
   On (RGT.GroupHeaderID = RGS.Ghid And RGT.RoleID = RGS.RoleID)
   When Matched Then
      Update 
      Set IsVisible = 1,
          IsActive = 1
   When Not Matched Then
      Insert (RoleID, GroupHeaderID)
      Values (RGS.RoleID, RGS.Ghid);
RETURN 0
End;
GO
