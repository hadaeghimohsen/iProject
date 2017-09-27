SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE VIEW [Report].[v$UserReportsBookMark]
AS
SELECT     ServiceDef.Service.TitleFa AS LogicalName, ServiceDef.Service.TitleEn AS PhysicalName, Report.UserReportBookMark.ServiceID, Report.UserReportBookMark.UserName, 
                      Report.UserReportBookMark.RoleID
FROM         ServiceDef.Service INNER JOIN
                      Report.UserReportBookMark ON ServiceDef.Service.ID = Report.UserReportBookMark.ServiceID INNER JOIN
                      DataGuard.[User] ON Report.UserReportBookMark.UserName = DataGuard.[User].TitleEn INNER JOIN
                      DataGuard.Role ON Report.UserReportBookMark.RoleID = DataGuard.Role.ID
WHERE     (ServiceDef.Service.IsVisible = 1) AND (ServiceDef.Service.IsActive = 1) AND (ServiceDef.Service.[Level] = 0) AND (DataGuard.Role.IsVisible = 1) AND (DataGuard.Role.IsActive = 1) AND 
                      (DataGuard.[User].IsVisible = 1)
GO
EXEC sp_addextendedproperty N'MS_DiagramPane1', N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[52] 4[16] 2[13] 3) )"
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
         Configuration = "(H (1[50] 4) )"
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
         Begin Table = "Service (ServiceDef)"
            Begin Extent = 
               Top = 26
               Left = 21
               Bottom = 176
               Right = 181
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "UserReportBookMark (Report)"
            Begin Extent = 
               Top = 102
               Left = 327
               Bottom = 222
               Right = 487
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "User (DataGuard)"
            Begin Extent = 
               Top = 142
               Left = 614
               Bottom = 360
               Right = 774
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "Role (DataGuard)"
            Begin Extent = 
               Top = 179
               Left = 22
               Bottom = 364
               Right = 182
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
', 'SCHEMA', N'Report', 'VIEW', N'v$UserReportsBookMark', NULL, NULL
GO
DECLARE @xp int
SELECT @xp=1
EXEC sp_addextendedproperty N'MS_DiagramPaneCount', @xp, 'SCHEMA', N'Report', 'VIEW', N'v$UserReportsBookMark', NULL, NULL
GO
