SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE VIEW [DataGuard].[D$BMPL] AS SELECT VALU, DOMN_DESC FROM APP_DOMAIN WHERE CODE = 'D BMPL'
GO
