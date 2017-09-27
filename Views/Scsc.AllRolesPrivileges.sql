SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE VIEW [Scsc].[AllRolesPrivileges]
AS
SELECT     Scsc.Privilege.ID AS PrivilegeID, Scsc.Privilege.ShortCut, Scsc.Privilege.TitleFa AS PrivilegeFaName, 
                      Scsc.Privilege.IsVisible AS PrivilegeVisible, DataGuard.Role_Privilege.IsActive AS RPActive, DataGuard.Role_Privilege.IsVisible AS RPVisible, 
                      DataGuard.Role_Privilege.Sub_Sys, DataGuard.Role.ID AS RoleID, DataGuard.Role.TitleFa AS RoleFaName, DataGuard.Role.IsActive AS RoleActive, 
                      DataGuard.Role.IsVisible AS RoleVisible
FROM         Scsc.Privilege INNER JOIN
                      DataGuard.Role_Privilege ON Scsc.Privilege.ID = DataGuard.Role_Privilege.PrivilegeID INNER JOIN
                      DataGuard.Role ON DataGuard.Role_Privilege.RoleID = DataGuard.Role.ID
WHERE     (Scsc.Privilege.IsVisible = 1) AND (DataGuard.Role_Privilege.IsVisible = 1) AND (DataGuard.Role.IsVisible = 1)

GO
