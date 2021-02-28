SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE VIEW [DataGuard].[V#Settings] AS
SELECT x.query('/Settings/AppExpire').value('(AppExpire/@lastdate)[1]', 'DATE') AS LAST_DATE,
       dbo.MiladiTOShamsi(x.query('/Settings/AppExpire').value('(AppExpire/@lastdate)[1]', 'DATE')) AS PERS_LAST_DATE,
       x.query('/Settings/AppExpire').value('(AppExpire/@type)[1]', 'BIT') AS [EXPR_TYPE],
       x.query('/Settings/AppExpire').value('(AppExpire/@value)[1]', 'DATE') AS [EXPR_VALU],
       dbo.MiladiTOShamsi(x.query('/Settings/AppExpire').value('(AppExpire/@value)[1]', 'DATE')) AS [PERS_EXPR_VALU],
       x.query('/Settings/Session').value('(Session/@type)[1]', 'VARCHAR(30)') AS [SESN_TYPE],
       x.query('/Settings/Session').value('(Session/@max)[1]', 'BIGINT') AS [SESN_MAX],
       x.query('/Settings/Session').value('(Session/@count)[1]', 'BIGINT') AS [SESN_CONT],
       x.query('/Settings/TinyLock').value('(TinyLock/@serialno)[1]', 'VARCHAR(100)') AS [TINY_SERL]
  FROM settings
GO
