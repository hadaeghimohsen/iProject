SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE VIEW [DataGuard].[AllUsersRolesPrivileges]
AS
SELECT     DataGuard.[User].ID AS UserID, DataGuard.[User].TitleFa AS UserFaName, DataGuard.[User].TitleEn AS UserEnName, DataGuard.[User].IsLock AS UserLock, 
                      DataGuard.[User].IsVisible AS UserVisible, DataGuard.Role_User.IsActive AS RUActive, DataGuard.Role_User.IsVisible AS RUVisible, DataGuard.Role.ID AS RoleID, 
                      DataGuard.Role.TitleEn AS RoleName, DataGuard.Role.IsVisible AS RoleVisible, DataGuard.Role.IsActive AS RoleActive, 
                      DataGuard.Role_Privilege.IsVisible AS RPVisible, DataGuard.Role_Privilege.IsActive AS RPActive, DataGuard.Role_Privilege.Sub_Sys, 
                      DataGuard.Privilege.ShortCut AS PrivilegeID, DataGuard.Privilege.TitleEn AS PrivilegeEnName, DataGuard.Privilege.IsVisible AS PrivilegeVisible, 
                      DataGuard.Privilege.TitleFa AS PrivilegeFaName
FROM         DataGuard.Role INNER JOIN
                      DataGuard.Role_Privilege ON DataGuard.Role.ID = DataGuard.Role_Privilege.RoleID INNER JOIN
                      DataGuard.Privilege ON DataGuard.Role_Privilege.PrivilegeID = DataGuard.Privilege.ID INNER JOIN
                      DataGuard.Role_User ON DataGuard.Role.ID = DataGuard.Role_User.RoleID INNER JOIN
                      DataGuard.[User] ON DataGuard.Role_User.UserID = DataGuard.[User].ID
WHERE     (DataGuard.Role.IsVisible = 1) AND (DataGuard.[User].IsVisible = 1) AND (DataGuard.Role_Privilege.IsVisible = 1) AND (DataGuard.Privilege.IsVisible = 1) AND 
                      (DataGuard.Role_User.IsVisible = 1)
GO
EXEC sp_addextendedproperty N'MS_DiagramPane1', N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[33] 4[28] 2[20] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1[42] 4[22] 3) )"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1[59] 4) )"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 1
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
         Begin Table = "Role (DataGuard)"
            Begin Extent = 
               Top = 11
               Left = 383
               Bottom = 119
               Right = 534
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "Role_Privilege (DataGuard)"
            Begin Extent = 
               Top = 5
               Left = 196
               Bottom = 151
               Right = 347
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "Privilege (DataGuard)"
            Begin Extent = 
               Top = 19
               Left = 10
               Bottom = 127
               Right = 161
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "Role_User (DataGuard)"
            Begin Extent = 
               Top = 10
               Left = 578
               Bottom = 118
               Right = 729
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "User (DataGuard)"
            Begin Extent = 
               Top = 19
               Left = 773
               Bottom = 127
               Right = 924
            End
            DisplayFlags = 280
            TopColumn = 0
         End
      End
   End
   Begin SQLPane = 
      PaneHidden = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
      Begin ColumnWidths = 18
         Width = 284
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500', 'SCHEMA', N'DataGuard', 'VIEW', N'AllUsersRolesPrivileges', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_DiagramPane2', N'
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 11
         Column = 1440
         Alias = 1410
         Table = 2175
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
', 'SCHEMA', N'DataGuard', 'VIEW', N'AllUsersRolesPrivileges', NULL, NULL
GO
DECLARE @xp int
SELECT @xp=2
EXEC sp_addextendedproperty N'MS_DiagramPaneCount', @xp, 'SCHEMA', N'DataGuard', 'VIEW', N'AllUsersRolesPrivileges', NULL, NULL
GO
