SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE VIEW [DataGuard].[D$BANK] AS SELECT VALU, DOMN_DESC FROM DataGuard.APP_DOMAIN WHERE CODE = 'D BANK'
GO