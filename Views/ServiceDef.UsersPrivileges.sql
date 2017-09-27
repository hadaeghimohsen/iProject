SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE VIEW [ServiceDef].[UsersPrivileges]
AS
SELECT     DataGuard.[User].ID AS UserID, DataGuard.[User].TitleEn AS UserEnName, DataGuard.[User].IsVisible AS UserVisible, DataGuard.[User].IsLock AS UserLock, 
                      DataGuard.User_Privilege.IsActive AS UPActive, DataGuard.User_Privilege.IsVisible AS UPVisible, DataGuard.User_Privilege.Sub_Sys, 
                      ServiceDef.Privilege.TitleEn AS PrivilegeName, ServiceDef.Privilege.IsVisible AS PrivilegeVisible, ServiceDef.Privilege.ShortCut AS PrivilegeID
FROM         DataGuard.[User] INNER JOIN
                      DataGuard.User_Privilege ON DataGuard.[User].ID = DataGuard.User_Privilege.UserID INNER JOIN
                      ServiceDef.Privilege ON DataGuard.User_Privilege.PrivilegeID = ServiceDef.Privilege.ID
WHERE     (DataGuard.[User].IsLock = 0) AND (DataGuard.[User].IsVisible = 1) AND (DataGuard.User_Privilege.IsActive = 1) AND (DataGuard.User_Privilege.IsVisible = 1) AND 
                      (ServiceDef.Privilege.IsVisible = 1)

GO
