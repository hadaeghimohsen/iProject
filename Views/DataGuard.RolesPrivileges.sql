SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE VIEW [DataGuard].[RolesPrivileges]
AS
SELECT     DataGuard.Privilege.ID AS PrivilegeID, DataGuard.Privilege.ShortCut, DataGuard.Privilege.TitleFa AS PrivilegeFaName, 
                      DataGuard.Privilege.IsVisible AS PrivilegeVisible, DataGuard.Role_Privilege.IsActive AS RPActive, DataGuard.Role_Privilege.IsVisible AS RPVisible, 
                      DataGuard.Role_Privilege.Sub_Sys, DataGuard.Role.ID AS RoleID, DataGuard.Role.TitleFa AS RoleFaName, DataGuard.Role.IsActive AS RoleActive, 
                      DataGuard.Role.IsVisible AS RoleVisible
FROM         DataGuard.Privilege INNER JOIN
                      DataGuard.Role_Privilege ON DataGuard.Privilege.ID = DataGuard.Role_Privilege.PrivilegeID INNER JOIN
                      DataGuard.Role ON DataGuard.Role_Privilege.RoleID = DataGuard.Role.ID
WHERE     (DataGuard.Privilege.IsVisible = 1) AND (DataGuard.Role_Privilege.IsVisible = 1) AND (DataGuard.Role.IsVisible = 1)
GO
EXEC sp_addextendedproperty N'MS_DiagramPane1', N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[40] 4[20] 2[20] 3) )"
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
         Configuration = "(H (1[41] 4) )"
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
         Begin Table = "Privilege (DataGuard)"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 114
               Right = 189
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "Role_Privilege (DataGuard)"
            Begin Extent = 
               Top = 12
               Left = 304
               Bottom = 130
               Right = 455
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "Role (DataGuard)"
            Begin Extent = 
               Top = 16
               Left = 577
               Bottom = 124
               Right = 728
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
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 11
         Column = 1440
         Alias = 1830
         Table = 2100
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
', 'SCHEMA', N'DataGuard', 'VIEW', N'RolesPrivileges', NULL, NULL
GO
DECLARE @xp int
SELECT @xp=1
EXEC sp_addextendedproperty N'MS_DiagramPaneCount', @xp, 'SCHEMA', N'DataGuard', 'VIEW', N'RolesPrivileges', NULL, NULL
GO
