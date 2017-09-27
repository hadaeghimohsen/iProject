SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE VIEW [Report].[v$AccessReports]
AS
SELECT     TOP (100) PERCENT DataGuard.Role.ID AS ROLE_ID, DataGuard.Role.TitleFa AS ROLE_NAME, ServiceDef.Service.ID AS SERV_ID, 
                      ServiceDef.Service.TitleFa AS SERV_NAME, ServiceDef.Service.TitleEn AS SERV_FILE_PATH, DataGuard.[User].TitleEn AS USER_NAME, 
                      ServiceDef.Service.ServiceUnitID AS UNIT_ID, ServiceDef.Service.ServiceTypeID AS TYPE_ID, DataGuard.Role.SUB_SYS
FROM         DataGuard.Role_User INNER JOIN
                      DataGuard.Role ON DataGuard.Role_User.RoleID = DataGuard.Role.ID INNER JOIN
                      DataGuard.[User] ON DataGuard.Role_User.UserID = DataGuard.[User].ID INNER JOIN
                      ServiceDef.Role_GroupHeader ON DataGuard.Role.ID = ServiceDef.Role_GroupHeader.RoleID INNER JOIN
                      ServiceDef.Service_GroupHeader ON ServiceDef.Role_GroupHeader.GroupHeaderID = ServiceDef.Service_GroupHeader.GroupHeaderID INNER JOIN
                      ServiceDef.Service ON ServiceDef.Service_GroupHeader.ServiceID = ServiceDef.Service.ParentID INNER JOIN
                      ServiceDef.UnitType ON ServiceDef.Service.ServiceTypeID = ServiceDef.UnitType.ID INNER JOIN
                      ServiceDef.Role_UnitType ON DataGuard.Role.ID = ServiceDef.Role_UnitType.RoleID AND ServiceDef.UnitType.ID = ServiceDef.Role_UnitType.UnitTypeID
WHERE     (ServiceDef.Service.[Level] = 0) AND (ServiceDef.Role_GroupHeader.IsReporting = 1) AND (ServiceDef.Role_UnitType.IsReporting = 1) AND 
                      (DataGuard.[User].IsVisible = 1) AND (ServiceDef.Service.IsVisible = 1) AND (ServiceDef.Service.IsActive = 1) AND (ServiceDef.Service.RectCode = 1) AND 
                      (ServiceDef.Service_GroupHeader.IsActive = 1) AND (ServiceDef.Service_GroupHeader.IsVisible = 1) AND (ServiceDef.UnitType.IsActive = 1) AND 
                      (ServiceDef.UnitType.IsVisible = 1) AND (ServiceDef.Role_GroupHeader.IsVisible = 1) AND (ServiceDef.Role_GroupHeader.IsActive = 1) AND 
                      (ServiceDef.Role_UnitType.IsActive = 1) AND (DataGuard.Role_User.IsActive = 1) AND (DataGuard.Role_User.IsVisible = 1) AND (DataGuard.Role.IsActive = 1) AND 
                      (DataGuard.Role.IsVisible = 1)
ORDER BY ROLE_NAME, SERV_NAME
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
         Configuration = "(H (1[53] 4[22] 3) )"
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
         Configuration = "(H (4[50] 3) )"
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
         Configuration = "(H (1[40] 4) )"
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
         Top = -288
         Left = 0
      End
      Begin Tables = 
         Begin Table = "Role_User (DataGuard)"
            Begin Extent = 
               Top = 376
               Left = 228
               Bottom = 513
               Right = 388
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "Role (DataGuard)"
            Begin Extent = 
               Top = 391
               Left = 487
               Bottom = 574
               Right = 647
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
         Begin Table = "Role_GroupHeader (ServiceDef)"
            Begin Extent = 
               Top = 174
               Left = 747
               Bottom = 314
               Right = 981
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "Service_GroupHeader (ServiceDef)"
            Begin Extent = 
               Top = 23
               Left = 484
               Bottom = 142
               Right = 648
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "Service (ServiceDef)"
            Begin Extent = 
               Top = 9
               Left = 238
               Bottom = 294
               Right = 408
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "UnitType (ServiceDef)"
            Begin Extent = 
               Top = 149
               Left = 4', 'SCHEMA', N'Report', 'VIEW', N'v$AccessReports', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_DiagramPane2', N'84
               Bottom = 268
               Right = 644
            End
            DisplayFlags = 280
            TopColumn = 3
         End
         Begin Table = "Role_UnitType (ServiceDef)"
            Begin Extent = 
               Top = 272
               Left = 485
               Bottom = 391
               Right = 645
            End
            DisplayFlags = 280
            TopColumn = 1
         End
      End
   End
   Begin SQLPane = 
      PaneHidden = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
      Begin ColumnWidths = 19
         Width = 284
         Width = 1500
         Width = 1620
         Width = 1650
         Width = 3240
         Width = 4185
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
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 11
         Column = 3795
         Alias = 1740
         Table = 3270
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
', 'SCHEMA', N'Report', 'VIEW', N'v$AccessReports', NULL, NULL
GO
DECLARE @xp int
SELECT @xp=2
EXEC sp_addextendedproperty N'MS_DiagramPaneCount', @xp, 'SCHEMA', N'Report', 'VIEW', N'v$AccessReports', NULL, NULL
GO
