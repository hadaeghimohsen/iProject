SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
/* View*/
CREATE VIEW [DataGuard].[V#TopNActiveSessionCurrentGateway]
AS
SELECT  TOP (4) a.USGW_USER_ID AS USER_ID, MAX(a.ACTN_DATE) AS ACTN_DATE
FROM     sys.dm_exec_connections AS c INNER JOIN
               sys.dm_exec_sessions AS s ON c.session_id = s.session_id INNER JOIN
               DataGuard.Gateway AS g ON UPPER(s.host_name) COLLATE SQL_Latin1_General_CP1_CI_AS = UPPER(g.COMP_NAME_DNRM) INNER JOIN
               DataGuard.User_Gateway AS ug ON g.MAC_ADRS = ug.GTWY_MAC_ADRS INNER JOIN
               DataGuard.Active_Session AS a ON ug.GTWY_MAC_ADRS = a.USGW_GTWY_MAC_ADRS AND ug.USER_ID = a.USGW_USER_ID AND ug.RWNO = a.USGW_RWNO INNER JOIN
               DataGuard.[User] AS u ON ug.USER_ID = u.ID
WHERE  (c.session_id = @@SPID) AND (ug.VALD_TYPE = '002') AND (a.ACTN_TYPE = '002') AND (ISNULL(u.SHOW_LOGN_FORM, '001') = '002')
GROUP BY a.USGW_USER_ID
HAVING  (a.USGW_USER_ID <> 13941213233653)
ORDER BY ACTN_DATE DESC
GO
EXEC sp_addextendedproperty N'MS_DiagramPane1', N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[41] 4[20] 2[29] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1[50] 4[25] 3) )"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1[50] 2[42] 3) )"
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
         Configuration = "(H (1[75] 4) )"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[47] 2) )"
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
      ActivePaneConfig = 2
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = -96
         Left = 0
      End
      Begin Tables = 
         Begin Table = "c"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 126
               Right = 260
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "s"
            Begin Extent = 
               Top = 8
               Left = 385
               Bottom = 128
               Right = 617
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "g"
            Begin Extent = 
               Top = 111
               Left = 707
               Bottom = 231
               Right = 998
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "ug"
            Begin Extent = 
               Top = 168
               Left = 304
               Bottom = 288
               Right = 499
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "a"
            Begin Extent = 
               Top = 354
               Left = 23
               Bottom = 474
               Right = 254
            End
            DisplayFlags = 280
            TopColumn = 8
         End
         Begin Table = "u"
            Begin Extent = 
               Top = 342
               Left = 586
               Bottom = 477
               Right = 838
            End
            DisplayFlags = 280
            TopColumn = 30
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
      Begin ColumnWidths = 9
         Width = 284
         Width = 1500
         Width = 1500
         Width = 1500
         Width =', 'SCHEMA', N'DataGuard', 'VIEW', N'V#TopNActiveSessionCurrentGateway', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_DiagramPane2', N' 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
      End
   End
   Begin CriteriaPane = 
      PaneHidden = 
      Begin ColumnWidths = 12
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
', 'SCHEMA', N'DataGuard', 'VIEW', N'V#TopNActiveSessionCurrentGateway', NULL, NULL
GO
DECLARE @xp int
SELECT @xp=2
EXEC sp_addextendedproperty N'MS_DiagramPaneCount', @xp, 'SCHEMA', N'DataGuard', 'VIEW', N'V#TopNActiveSessionCurrentGateway', NULL, NULL
GO
