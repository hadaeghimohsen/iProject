SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE VIEW [DataGuard].[V#Top_Active_Session] as
SELECT * FROM DataGuard.Active_Session t
WHERE t.RWNO = (
   SELECT MAX(s.RWNO)
     FROM DataGuard.Active_Session s
    WHERE CAST(t.ACTN_DATE AS date) = CAST(s.ACTN_DATE AS date)
      AND t.USGW_GTWY_MAC_ADRS = s.USGW_GTWY_MAC_ADRS
      AND t.USGW_USER_ID = s.USGW_USER_ID
      AND t.USGW_RWNO = s.USGW_RWNO
      AND t.AUDS_ID = s.AUDS_ID
)
GO
