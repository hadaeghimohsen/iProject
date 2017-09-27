SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE VIEW [Report].[AllGroupHeadersOfRole]
AS
SELECT     Report.GroupHeader.ID AS GroupHeaderID, Report.GroupHeader.TitleFa AS GHFaName, Report.GroupHeader.DataSourceID, Report.GroupHeader.IsActive AS GActive, 
                      Report.GroupHeader.IsVisible AS GVisible, Report.DataSource.TitleFa AS DbFaName, Report.Role_GroupHeader.IsVisible AS RGVisible, 
                      Report.Role_GroupHeader.IsActive AS RGActive, DataGuard.Role.TitleFa AS RoleFaName, DataGuard.Role.IsVisible AS RVisible, DataGuard.Role.IsActive AS RActive, 
                      DataGuard.Role.ID AS RoleID
FROM         DataGuard.Role INNER JOIN
                      Report.Role_GroupHeader ON DataGuard.Role.ID = Report.Role_GroupHeader.RoleID INNER JOIN
                      Report.GroupHeader ON Report.Role_GroupHeader.GroupHeaderID = Report.GroupHeader.ID INNER JOIN
                      Report.DataSource ON Report.GroupHeader.DataSourceID = Report.DataSource.ID
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
         Configuration = "(H (1[45] 4[41] 3) )"
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
         Configuration = "(H (1[58] 4) )"
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
               Top = 8
               Left = 1
               Bottom = 239
               Right = 161
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "Role_GroupHeader (Report)"
            Begin Extent = 
               Top = 89
               Left = 186
               Bottom = 298
               Right = 350
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "GroupHeader (Report)"
            Begin Extent = 
               Top = 220
               Left = 415
               Bottom = 448
               Right = 575
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "DataSource (Report)"
            Begin Extent = 
               Top = 36
               Left = 606
               Bottom = 155
               Right = 773
            End
            DisplayFlags = 280
            TopColumn = 6
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
         Column = 1230
         Alias = 1350
         Table = 2070
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
', 'SCHEMA', N'Report', 'VIEW', N'AllGroupHeadersOfRole', NULL, NULL
GO
DECLARE @xp int
SELECT @xp=1
EXEC sp_addextendedproperty N'MS_DiagramPaneCount', @xp, 'SCHEMA', N'Report', 'VIEW', N'AllGroupHeadersOfRole', NULL, NULL
GO
