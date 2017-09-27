SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE VIEW [ServiceDef].[AllServicesGroupHeaders]
AS
SELECT     ServiceDef.GroupHeader.ID AS GroupHeaderID, ServiceDef.GroupHeader.TitleFa AS GhFaName, ServiceDef.GroupHeader.IsVisible AS GhVisible, 
                      ServiceDef.GroupHeader.IsActive AS GhActive, ServiceDef.Service_GroupHeader.IsActive AS SGActive, ServiceDef.Service_GroupHeader.IsVisible AS SGVisible, 
                      ServiceDef.Service.ID AS ServiceID, ServiceDef.Service.TitleFa AS SFaName, ServiceDef.Service.RectCode, ServiceDef.Service.[Level], ServiceDef.Service.ParentID, 
                      ServiceDef.Service.IsActive AS SActive
FROM         ServiceDef.GroupHeader INNER JOIN
                      ServiceDef.Service_GroupHeader ON ServiceDef.GroupHeader.ID = ServiceDef.Service_GroupHeader.GroupHeaderID INNER JOIN
                      ServiceDef.Service ON ServiceDef.Service_GroupHeader.ServiceID = ServiceDef.Service.ID
WHERE     (ServiceDef.GroupHeader.IsVisible = 1) AND (ServiceDef.Service_GroupHeader.IsVisible = 1) AND (ServiceDef.Service.RectCode = 1) AND 
                      (ServiceDef.Service.[Level] = 1) AND (ServiceDef.Service.IsActive = 1)
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
         Configuration = "(H (1[34] 4[37] 3) )"
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
         Configuration = "(H (1[39] 4[35] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1[32] 4) )"
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
         Begin Table = "GroupHeader (ServiceDef)"
            Begin Extent = 
               Top = 23
               Left = 14
               Bottom = 193
               Right = 165
            End
            DisplayFlags = 280
            TopColumn = 1
         End
         Begin Table = "Service_GroupHeader (ServiceDef)"
            Begin Extent = 
               Top = 38
               Left = 221
               Bottom = 146
               Right = 376
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "Service (ServiceDef)"
            Begin Extent = 
               Top = 10
               Left = 443
               Bottom = 242
               Right = 594
            End
            DisplayFlags = 280
            TopColumn = 4
         End
      End
   End
   Begin SQLPane = 
      PaneHidden = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
      Begin ColumnWidths = 13
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
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 11
         Column = 1440
         Alias = 1350
         Table = 2385
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
', 'SCHEMA', N'ServiceDef', 'VIEW', N'AllServicesGroupHeaders', NULL, NULL
GO
DECLARE @xp int
SELECT @xp=1
EXEC sp_addextendedproperty N'MS_DiagramPaneCount', @xp, 'SCHEMA', N'ServiceDef', 'VIEW', N'AllServicesGroupHeaders', NULL, NULL
GO
