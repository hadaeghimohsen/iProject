SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE VIEW [Report].[v$AccessProfilers]
AS
SELECT     DataGuard.[User].TitleEn AS USER_NAME, DataGuard.Role.ID AS ROLE_ID, DataGuard.Role.TitleFa AS ROLE_NAME, Report.Profiler.TitleFa AS PROF_NAME, 
                      Report.Profiler.ID AS PROF_ID, Report.Profiler.DataSourceID AS DSRC_ID, DataGuard.Role.SUB_SYS
FROM         DataGuard.Role INNER JOIN
                      DataGuard.Role_User INNER JOIN
                      DataGuard.[User] ON DataGuard.Role_User.UserID = DataGuard.[User].ID ON DataGuard.Role.ID = DataGuard.Role_User.RoleID INNER JOIN
                      Report.Role_Profiler ON DataGuard.Role.ID = Report.Role_Profiler.RoleID INNER JOIN
                      Report.Profiler ON Report.Role_Profiler.ProfilerID = Report.Profiler.ID
WHERE     (DataGuard.[User].IsVisible = 1) AND (DataGuard.Role_User.IsActive = 1) AND (DataGuard.Role_User.IsVisible = 1) AND (DataGuard.Role.IsVisible = 1) AND 
                      (DataGuard.Role.IsActive = 1) AND (Report.Role_Profiler.IsActive = 1) AND (Report.Role_Profiler.IsVisible = 1) AND (Report.Profiler.IsVisible = 1) AND 
                      (Report.Profiler.IsActive = 1)
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
         Configuration = "(H (1[50] 4[25] 3) )"
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
         Configuration = "(H (1[56] 4[27] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1[64] 4) )"
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
               Top = 5
               Left = 464
               Bottom = 184
               Right = 624
            End
            DisplayFlags = 280
            TopColumn = 1
         End
         Begin Table = "Role_User (DataGuard)"
            Begin Extent = 
               Top = 7
               Left = 250
               Bottom = 142
               Right = 410
            End
            DisplayFlags = 280
            TopColumn = 0
         End
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
         Begin Table = "Role_Profiler (Report)"
            Begin Extent = 
               Top = 104
               Left = 678
               Bottom = 222
               Right = 838
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "Profiler (Report)"
            Begin Extent = 
               Top = 190
               Left = 464
               Bottom = 355
               Right = 624
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
      Begin ColumnWidths = 9
         Width = 284
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
      Beg', 'SCHEMA', N'Report', 'VIEW', N'v$AccessProfilers', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_DiagramPane2', N'in ColumnWidths = 11
         Column = 1440
         Alias = 1140
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
', 'SCHEMA', N'Report', 'VIEW', N'v$AccessProfilers', NULL, NULL
GO
DECLARE @xp int
SELECT @xp=2
EXEC sp_addextendedproperty N'MS_DiagramPaneCount', @xp, 'SCHEMA', N'Report', 'VIEW', N'v$AccessProfilers', NULL, NULL
GO
