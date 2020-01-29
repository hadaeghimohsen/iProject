SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE VIEW [DataGuard].[D$BFTP] AS SELECT VALU, DOMN_DESC FROM DataGuard.APP_DOMAIN A, DataGuard.[User] U WHERE A.REGN_LANG = ISNULL(U.REGN_LANG, '054') AND UPPER(u.USERDB) = UPPER(SUSER_NAME()) AND A.CODE = 'D BFTP'
GO