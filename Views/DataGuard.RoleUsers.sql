SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE VIEW [DataGuard].[RoleUsers]
AS
SELECT     DataGuard.[User].ID AS UserID, DataGuard.[User].TitleFa AS UserFaName, LOWER(DataGuard.[User].TitleEn) AS UserEnName, DataGuard.[User].IsLock AS UserLock, 
                      DataGuard.[User].IsVisible AS UserVisible, DataGuard.Role_User.IsActive AS URActive, DataGuard.Role_User.IsVisible AS URVisible, DataGuard.Role.ID AS RoleID, 
                      DataGuard.Role.TitleFa AS RoleFaName, DataGuard.Role.IsVisible AS RoleVisible, DataGuard.Role.IsActive AS RoleActive
FROM         DataGuard.[User] INNER JOIN
                      DataGuard.Role_User ON DataGuard.[User].ID = DataGuard.Role_User.UserID INNER JOIN
                      DataGuard.Role ON DataGuard.Role_User.RoleID = DataGuard.Role.ID
WHERE     (DataGuard.[User].IsVisible = 1) AND (DataGuard.Role_User.IsActive = 1) AND (DataGuard.Role_User.IsVisible = 1) AND (DataGuard.Role.IsVisible = 1) AND 
                      (DataGuard.Role.IsActive = 1)
GO
EXEC sp_addextendedproperty N'MS_DiagramPane1', N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[37] 4[24] 2[20] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1[27] 4[42] 3) )"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1[50] 2[25] 3) )"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1[56] 3) )"
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
         Top = 0
         Left = 0
      End
      Begin Tables = 
         Begin Table = "User (DataGuard)"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 114
               Right = 189
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "Role_User (DataGuard)"
            Begin Extent = 
               Top = 9
               Left = 281
               Bottom = 186
               Right = 432
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "Role (DataGuard)"
            Begin Extent = 
               Top = 14
               Left = 524
               Bottom = 206
               Right = 675
            End
            DisplayFlags = 280
            TopColumn = 0
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
      Begin ColumnWidths = 11
         Width = 284
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1830
         Width = 1500
         Width = 1500
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 11
         Column = 1440
         Alias = 1125
         Table = 1905
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
', 'SCHEMA', N'DataGuard', 'VIEW', N'RoleUsers', NULL, NULL
GO
DECLARE @xp int
SELECT @xp=1
EXEC sp_addextendedproperty N'MS_DiagramPaneCount', @xp, 'SCHEMA', N'DataGuard', 'VIEW', N'RoleUsers', NULL, NULL
GO
