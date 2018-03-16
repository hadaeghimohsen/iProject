SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE VIEW [Scsc].[UsersRolesPrivileges]
AS
SELECT     DataGuard.[User].ID AS UserID, DataGuard.[User].TitleFa AS UserFaName, DataGuard.[User].TitleEn AS UserEnName, DataGuard.[User].IsLock AS UserLock, 
                      DataGuard.[User].IsVisible AS UserVisible, DataGuard.Role_User.IsActive AS RUActive, DataGuard.Role_User.IsVisible AS RUVisible, DataGuard.Role.ID AS RoleID, 
                      DataGuard.Role.TitleEn AS RoleName, DataGuard.Role.IsVisible AS RoleVisible, DataGuard.Role.IsActive AS RoleActive, 
                      DataGuard.Role_Privilege.IsVisible AS RPVisible, DataGuard.Role_Privilege.IsActive AS RPActive, DataGuard.Role_Privilege.Sub_Sys, 
                      Scsc.Privilege.ShortCut AS PrivilegeID, Scsc.Privilege.TitleEn AS PrivilegeEnName, Scsc.Privilege.IsVisible AS PrivilegeVisible, 
                      Scsc.Privilege.TitleFa AS PrivilegeFaName
FROM         DataGuard.Role INNER JOIN
             DataGuard.Role_Privilege ON DataGuard.Role.ID = DataGuard.Role_Privilege.RoleID INNER JOIN
             Scsc.Privilege ON DataGuard.Role_Privilege.PrivilegeID = Scsc.Privilege.ID INNER JOIN
             DataGuard.Role_User ON DataGuard.Role.ID = DataGuard.Role_User.RoleID INNER JOIN
             DataGuard.[User] ON DataGuard.Role_User.UserID = DataGuard.[User].ID
WHERE     (Scsc.Privilege.IsVisible = 1) AND (DataGuard.Role_Privilege.IsActive = 1) AND (DataGuard.Role_Privilege.IsVisible = 1) AND (DataGuard.Role.IsVisible = 1) AND 
                      (DataGuard.[User].IsVisible = 1) AND (DataGuard.[User].IsLock = 0) AND (DataGuard.Role_User.IsVisible = 1) AND (DataGuard.Role_User.IsActive = 1) AND 
                      (DataGuard.Role.IsActive = 1)

GO