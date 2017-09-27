SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE VIEW [Report].[AllUserPrivileges]
AS
SELECT     DataGuard.[User].ID AS UserID, DataGuard.[User].IsVisible AS UserVisible, DataGuard.[User].IsLock AS UserLock, DataGuard.[User].TitleEn AS UserTitle, 
                      DataGuard.User_Privilege.IsActive AS UPActive, DataGuard.User_Privilege.IsVisible AS UPVisible, DataGuard.User_Privilege.Sub_Sys, 
                      Report.Privilege.IsVisible AS PrivilegeVisible, Report.Privilege.ID AS PrivilegeID, Report.Privilege.ShortCut, 
                      Report.Privilege.TitleFa AS PrivilegeFaName
FROM         DataGuard.[User] INNER JOIN
                      DataGuard.User_Privilege ON DataGuard.[User].ID = DataGuard.User_Privilege.UserID INNER JOIN
                      Report.Privilege ON DataGuard.User_Privilege.PrivilegeID = Report.Privilege.ID
WHERE     (DataGuard.[User].IsVisible = 1) AND (DataGuard.User_Privilege.IsVisible = 1) AND (DataGuard.[User].IsLock = 0) AND (Report.Privilege.IsVisible = 1)

GO
