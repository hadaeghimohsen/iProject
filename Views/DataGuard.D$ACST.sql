SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE VIEW [DataGuard].[D$ACST] AS SELECT VALU, DOMN_DESC FROM APP_DOMAIN WHERE CODE = 'D ACST'
GO