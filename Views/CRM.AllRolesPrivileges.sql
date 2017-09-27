SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE VIEW [CRM].[AllRolesPrivileges]
AS
SELECT     CRM.Privilege.ID AS PrivilegeID, CRM.Privilege.ShortCut, CRM.Privilege.TitleFa AS PrivilegeFaName, 
                      CRM.Privilege.IsVisible AS PrivilegeVisible, DataGuard.Role_Privilege.IsActive AS RPActive, DataGuard.Role_Privilege.IsVisible AS RPVisible, 
                      DataGuard.Role_Privilege.Sub_Sys, DataGuard.Role.ID AS RoleID, DataGuard.Role.TitleFa AS RoleFaName, DataGuard.Role.IsActive AS RoleActive, 
                      DataGuard.Role.IsVisible AS RoleVisible
FROM         CRM.Privilege INNER JOIN
                      DataGuard.Role_Privilege ON CRM.Privilege.ID = DataGuard.Role_Privilege.PrivilegeID INNER JOIN
                      DataGuard.Role ON DataGuard.Role_Privilege.RoleID = DataGuard.Role.ID
WHERE     (CRM.Privilege.IsVisible = 1) AND (DataGuard.Role_Privilege.IsVisible = 1) AND (DataGuard.Role.IsVisible = 1)


GO
