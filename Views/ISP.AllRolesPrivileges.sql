SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE VIEW [ISP].[AllRolesPrivileges]
AS
SELECT     ISP.Privilege.ID AS PrivilegeID, ISP.Privilege.ShortCut, ISP.Privilege.TitleFa AS PrivilegeFaName, 
                      ISP.Privilege.IsVisible AS PrivilegeVisible, DataGuard.Role_Privilege.IsActive AS RPActive, DataGuard.Role_Privilege.IsVisible AS RPVisible, 
                      DataGuard.Role_Privilege.Sub_Sys, DataGuard.Role.ID AS RoleID, DataGuard.Role.TitleFa AS RoleFaName, DataGuard.Role.IsActive AS RoleActive, 
                      DataGuard.Role.IsVisible AS RoleVisible
FROM         ISP.Privilege INNER JOIN
                      DataGuard.Role_Privilege ON ISP.Privilege.ID = DataGuard.Role_Privilege.PrivilegeID INNER JOIN
                      DataGuard.Role ON DataGuard.Role_Privilege.RoleID = DataGuard.Role.ID
WHERE     (ISP.Privilege.IsVisible = 1) AND (DataGuard.Role_Privilege.IsVisible = 1) AND (DataGuard.Role.IsVisible = 1)


GO
