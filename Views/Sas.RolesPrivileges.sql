SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE VIEW [Sas].[RolesPrivileges]
AS
SELECT    Sas.Privilege.ID AS PrivilegeID, Sas.Privilege.ShortCut, Sas.Privilege.TitleFa AS PrivilegeFaName, 
          Sas.Privilege.IsVisible AS PrivilegeVisible, DataGuard.Role_Privilege.IsActive AS RPActive, DataGuard.Role_Privilege.IsVisible AS RPVisible, 
          DataGuard.Role_Privilege.Sub_Sys, DataGuard.Role.ID AS RoleID, DataGuard.Role.TitleFa AS RoleFaName, DataGuard.Role.IsActive AS RoleActive, 
          DataGuard.Role.IsVisible AS RoleVisible
FROM         Sas.Privilege INNER JOIN
             DataGuard.Role_Privilege ON Sas.Privilege.ID = DataGuard.Role_Privilege.PrivilegeID INNER JOIN
             DataGuard.Role ON DataGuard.Role_Privilege.RoleID = DataGuard.Role.ID
WHERE     (Sas.Privilege.IsVisible = 1) AND (DataGuard.Role_Privilege.IsVisible = 1) AND (DataGuard.Role.IsVisible = 1)


GO
