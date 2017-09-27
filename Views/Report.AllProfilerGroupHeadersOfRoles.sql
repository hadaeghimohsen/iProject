SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE VIEW [Report].[AllProfilerGroupHeadersOfRoles]
AS
SELECT     Report.GroupHeader.ID AS GroupHeaderID, Report.GroupHeader.TitleFa AS GFaName, Report.GroupHeader.IsActive AS GActive, 
                      Report.GroupHeader.IsVisible AS GVisible, Report.DataSource.TitleFa AS GDataSource, Report.Role_GroupHeader.IsVisible AS RGVisible, 
                      Report.Role_GroupHeader.IsActive AS RGActive, DataGuard.Role.ID AS RoleID, DataGuard.Role.TitleFa AS RFaName, DataGuard.Role.IsVisible AS RVisible, 
                      DataGuard.Role.IsActive AS RActive, Report.Profiler.ID AS ProfilerID, Report.Profiler.TitleFa AS PFaName, Report.Profiler.IsVisible AS PVisible, 
                      Report.Profiler.IsActive AS PActive, DataSource_1.TitleFa AS PDatasource, Report.Profiler_GroupHeader.OrderIndex AS RPGOrderIndex, 
                      Report.Profiler_GroupHeader.IsVisible AS RPGVisible, Report.Profiler_GroupHeader.IsActive AS RPGActive, 
                      Report.Profiler_GroupHeader.DatasourceFrom AS RPGDatasourceFrom, Report.Profiler_GroupHeader.DatasourceType AS RPGDatasourceType, 
                      DataSource_2.TitleFa AS RPGDatasource, Report.Profiler_GroupHeader.DataSourceID AS RPGDsid
FROM         DataGuard.Role INNER JOIN
                      Report.Role_GroupHeader ON DataGuard.Role.ID = Report.Role_GroupHeader.RoleID INNER JOIN
                      Report.GroupHeader ON Report.Role_GroupHeader.GroupHeaderID = Report.GroupHeader.ID INNER JOIN
                      Report.DataSource ON Report.GroupHeader.DataSourceID = Report.DataSource.ID INNER JOIN
                      Report.Profiler_GroupHeader ON Report.Role_GroupHeader.RoleID = Report.Profiler_GroupHeader.RoleID AND 
                      Report.Role_GroupHeader.GroupHeaderID = Report.Profiler_GroupHeader.GroupHeaderID INNER JOIN
                      Report.Profiler ON Report.Profiler_GroupHeader.ProfilerID = Report.Profiler.ID INNER JOIN
                      Report.DataSource AS DataSource_1 ON Report.Profiler.DataSourceID = DataSource_1.ID INNER JOIN
                      Report.DataSource AS DataSource_2 ON Report.Profiler_GroupHeader.DataSourceID = DataSource_2.ID
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
         Configuration = "(H (1[54] 4) )"
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
               Top = 9
               Left = 707
               Bottom = 190
               Right = 867
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "Role_GroupHeader (Report)"
            Begin Extent = 
               Top = 8
               Left = 203
               Bottom = 140
               Right = 367
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "GroupHeader (Report)"
            Begin Extent = 
               Top = 235
               Left = 13
               Bottom = 433
               Right = 173
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "DataSource (Report)"
            Begin Extent = 
               Top = 466
               Left = 203
               Bottom = 694
               Right = 370
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "Profiler_GroupHeader (Report)"
            Begin Extent = 
               Top = 169
               Left = 450
               Bottom = 404
               Right = 678
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "Profiler (Report)"
            Begin Extent = 
               Top = 277
               Left = 708
               Bottom = 444
               Right = 868
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "DataSource_1"
            Begin Extent = 
               Top = 462
               Left = 510
              ', 'SCHEMA', N'Report', 'VIEW', N'AllProfilerGroupHeadersOfRoles', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_DiagramPane2', N' Bottom = 581
               Right = 677
            End
            DisplayFlags = 280
            TopColumn = 6
         End
         Begin Table = "DataSource_2"
            Begin Extent = 
               Top = 254
               Left = 211
               Bottom = 373
               Right = 378
            End
            DisplayFlags = 280
            TopColumn = 7
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
         Alias = 1170
         Table = 2250
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
', 'SCHEMA', N'Report', 'VIEW', N'AllProfilerGroupHeadersOfRoles', NULL, NULL
GO
DECLARE @xp int
SELECT @xp=2
EXEC sp_addextendedproperty N'MS_DiagramPaneCount', @xp, 'SCHEMA', N'Report', 'VIEW', N'AllProfilerGroupHeadersOfRoles', NULL, NULL
GO
