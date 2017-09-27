SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE VIEW [ServiceDef].[RolesGroupHeaders]
AS
SELECT     DataGuard.Role.ID AS RoleID, DataGuard.Role.TitleFa AS RoleFaName, DataGuard.Role.IsVisible AS RoleVisible, DataGuard.Role.IsActive AS RoleActive, 
                      ServiceDef.Role_GroupHeader.IsActive AS RGActive, ServiceDef.Role_GroupHeader.IsVisible AS RGVisible, ServiceDef.GroupHeader.ID AS GHID, 
                      ServiceDef.GroupHeader.TitleFa AS GHFaName, ServiceDef.GroupHeader.IsVisible AS GHVisible, ServiceDef.GroupHeader.IsActive AS GHActive
FROM         DataGuard.Role INNER JOIN
                      ServiceDef.Role_GroupHeader ON DataGuard.Role.ID = ServiceDef.Role_GroupHeader.RoleID INNER JOIN
                      ServiceDef.GroupHeader ON ServiceDef.Role_GroupHeader.GroupHeaderID = ServiceDef.GroupHeader.ID
WHERE     (DataGuard.Role.IsVisible = 1) AND (ServiceDef.Role_GroupHeader.IsVisible = 1) AND (DataGuard.Role.IsActive = 1) AND 
                      (ServiceDef.Role_GroupHeader.IsActive = 1) AND (ServiceDef.GroupHeader.IsVisible = 1) AND (ServiceDef.GroupHeader.IsActive = 1)

GO
EXEC sp_addextendedproperty N'MS_DiagramPane1', N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[41] 4[28] 2[12] 3) )"
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
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1[51] 4) )"
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
               Top = 6
               Left = 38
               Bottom = 206
               Right = 189
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "Role_GroupHeader (GroupHeader)"
            Begin Extent = 
               Top = 6
               Left = 227
               Bottom = 204
               Right = 382
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "GroupHeader (GroupHeader)"
            Begin Extent = 
               Top = 6
               Left = 420
               Bottom = 184
               Right = 571
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
      Begin ColumnWidths = 11
         Column = 1440
         Alias = 900
         Table = 2715
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
', 'SCHEMA', N'ServiceDef', 'VIEW', N'RolesGroupHeaders', NULL, NULL
GO
DECLARE @xp int
SELECT @xp=1
EXEC sp_addextendedproperty N'MS_DiagramPaneCount', @xp, 'SCHEMA', N'ServiceDef', 'VIEW', N'RolesGroupHeaders', NULL, NULL
GO
