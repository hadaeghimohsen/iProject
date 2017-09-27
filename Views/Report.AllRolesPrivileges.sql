SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE VIEW [Report].[AllRolesPrivileges]
AS
SELECT     Report.Privilege.ID AS PrivilegeID, Report.Privilege.ShortCut, Report.Privilege.TitleFa AS PrivilegeFaName, 
                      Report.Privilege.IsVisible AS PrivilegeVisible, DataGuard.Role_Privilege.IsActive AS RPActive, DataGuard.Role_Privilege.IsVisible AS RPVisible, 
                      DataGuard.Role_Privilege.Sub_Sys, DataGuard.Role.ID AS RoleID, DataGuard.Role.TitleFa AS RoleFaName, DataGuard.Role.IsVisible AS RoleVisible, 
                      DataGuard.Role.IsActive AS RoleActive
FROM         DataGuard.Role INNER JOIN
                      DataGuard.Role_Privilege ON DataGuard.Role.ID = DataGuard.Role_Privilege.RoleID INNER JOIN
                      Report.Privilege ON DataGuard.Role_Privilege.PrivilegeID = Report.Privilege.ID
WHERE     (Report.Privilege.IsVisible = 1) AND (DataGuard.Role_Privilege.IsVisible = 1) AND (DataGuard.Role.IsVisible = 1)

GO
