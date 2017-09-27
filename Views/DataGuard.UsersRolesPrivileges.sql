SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE VIEW [DataGuard].[UsersRolesPrivileges]
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
WHERE     (DataGuard.Privilege.IsVisible = 1) AND (DataGuard.Role_Privilege.IsActive = 1) AND (DataGuard.Role_Privilege.IsVisible = 1) AND (DataGuard.Role.IsVisible = 1) AND 
                      (DataGuard.[User].IsVisible = 1) AND (DataGuard.[User].IsLock = 0) AND (DataGuard.Role_User.IsVisible = 1) AND (DataGuard.Role_User.IsActive = 1) AND 
                      (DataGuard.Role.IsActive = 1)
GO
EXEC sp_addextendedproperty N'MS_DiagramPane1', N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[35] 4[26] 2[20] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1[43] 4[45] 3) )"
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
         Configuration = "(H (1[45] 4) )"
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
      ActivePaneConfig = 9
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
         Begin Table = "Role (DataGuard)"
            Begin Extent = 
               Top = 206
               Left = 346
               Bottom = 336
               Right = 497
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "Role_Privilege (DataGuard)"
            Begin Extent = 
               Top = 23
               Left = 535
               Bottom = 160
               Right = 686
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "Privilege (DataGuard)"
            Begin Extent = 
               Top = 230
               Left = 729
               Bottom = 355
               Right = 880
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "Role_User (DataGuard)"
            Begin Extent = 
               Top = 23
               Left = 163
               Bottom = 146
               Right = 314
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "User (DataGuard)"
            Begin Extent = 
               Top = 231
               Left = 0
               Bottom = 339
               Right = 151
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
      PaneHidden = 
      Begin ParameterDefaults = ""
      End
      Begin ColumnWidths = 19
         Width = 284
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500', 'SCHEMA', N'DataGuard', 'VIEW', N'UsersRolesPrivileges', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_DiagramPane2', N'
         Width = 1500
         Width = 1500
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
         Alias = 2160
         Table = 2490
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
', 'SCHEMA', N'DataGuard', 'VIEW', N'UsersRolesPrivileges', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_DiagramPane3', N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[35] 4[26] 2[20] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
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
         Configuration = "(H (1 [75] 4))"
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
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = -192
         Left = 0
      End
      Begin Tables = 
         Begin Table = "Role"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 150
               Right = 189
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "Role_Privilege"
            Begin Extent = 
               Top = 141
               Left = 357
               Bottom = 311
               Right = 508
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "Privilege"
            Begin Extent = 
               Top = 169
               Left = 27
               Bottom = 277
               Right = 178
            End
            DisplayFlags = 280
            TopColumn = 1
         End
         Begin Table = "User_Role"
            Begin Extent = 
               Top = 7
               Left = 354
               Bottom = 115
               Right = 505
            End
            DisplayFlags = 280
            TopColumn = 1
         End
         Begin Table = "User"
            Begin Extent = 
               Top = 312
               Left = 38
               Bottom = 420
               Right = 189
            End
            DisplayFlags = 280
            TopColumn = 1
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
      Begin ColumnWidths = 15
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
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
       ', 'SCHEMA', N'DataGuard', 'VIEW', N'UsersRolesPrivileges', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_DiagramPane4', N'  Width = 1500
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 11
         Column = 1440
         Alias = 2160
         Table = 1170
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
', 'SCHEMA', N'DataGuard', 'VIEW', N'UsersRolesPrivileges', NULL, NULL
GO
DECLARE @xp int
SELECT @xp=2
EXEC sp_addextendedproperty N'MS_DiagramPaneCount', @xp, 'SCHEMA', N'DataGuard', 'VIEW', N'UsersRolesPrivileges', NULL, NULL
GO
