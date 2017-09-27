SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE VIEW [Report].[v$AccessGroupsOfProfilers]
AS
SELECT     Report.Profiler_GroupHeader.ProfilerID, Report.Profiler_GroupHeader.GroupHeaderID, Report.Profiler_GroupHeader.RoleID, Report.Profiler_GroupHeader.DatasourceType
FROM         Report.Profiler INNER JOIN
                      Report.Role_Profiler ON Report.Profiler.ID = Report.Role_Profiler.ProfilerID INNER JOIN
                      DataGuard.Role ON Report.Role_Profiler.RoleID = DataGuard.Role.ID INNER JOIN
                      Report.Profiler_GroupHeader ON Report.Profiler.ID = Report.Profiler_GroupHeader.ProfilerID AND DataGuard.Role.ID = Report.Profiler_GroupHeader.RoleID INNER JOIN
                      Report.GroupHeader ON Report.Profiler_GroupHeader.GroupHeaderID = Report.GroupHeader.ID INNER JOIN
                      Report.Role_GroupHeader ON DataGuard.Role.ID = Report.Role_GroupHeader.RoleID AND Report.GroupHeader.ID = Report.Role_GroupHeader.GroupHeaderID
WHERE     (Report.Profiler.IsVisible = 1) AND (Report.Profiler.IsActive = 1) AND (Report.Profiler_GroupHeader.IsVisible = 1) AND (Report.Profiler_GroupHeader.IsActive = 1) AND 
                      (Report.Role_Profiler.IsVisible = 1) AND (Report.Role_Profiler.IsActive = 1) AND (Report.GroupHeader.IsActive = 1) AND (Report.GroupHeader.IsVisible = 1) AND (DataGuard.Role.IsVisible = 1) AND 
                      (DataGuard.Role.IsActive = 1) AND (Report.Role_GroupHeader.IsVisible = 1) AND (Report.Role_GroupHeader.IsActive = 1)
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
         Configuration = "(H (1[50] 4[30] 3) )"
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
         Configuration = "(H (1[75] 4) )"
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
         Begin Table = "Profiler (Report)"
            Begin Extent = 
               Top = 282
               Left = 18
               Bottom = 443
               Right = 197
            End
            DisplayFlags = 280
            TopColumn = 1
         End
         Begin Table = "Role_Profiler (Report)"
            Begin Extent = 
               Top = 464
               Left = 263
               Bottom = 584
               Right = 542
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "Role (DataGuard)"
            Begin Extent = 
               Top = 424
               Left = 654
               Bottom = 603
               Right = 838
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "Profiler_GroupHeader (Report)"
            Begin Extent = 
               Top = 175
               Left = 262
               Bottom = 370
               Right = 539
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "GroupHeader (Report)"
            Begin Extent = 
               Top = 37
               Left = 609
               Bottom = 201
               Right = 829
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "Role_GroupHeader (Report)"
            Begin Extent = 
               Top = 234
               Left = 898
               Bottom = 353
               Right = 1062
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
  ', 'SCHEMA', N'Report', 'VIEW', N'v$AccessGroupsOfProfilers', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_DiagramPane2', N'    End
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
      Begin ColumnWidths = 11
         Column = 1440
         Alias = 900
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
', 'SCHEMA', N'Report', 'VIEW', N'v$AccessGroupsOfProfilers', NULL, NULL
GO
DECLARE @xp int
SELECT @xp=2
EXEC sp_addextendedproperty N'MS_DiagramPaneCount', @xp, 'SCHEMA', N'Report', 'VIEW', N'v$AccessGroupsOfProfilers', NULL, NULL
GO
