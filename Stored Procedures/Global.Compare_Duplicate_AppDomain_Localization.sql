SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [Global].[Compare_Duplicate_AppDomain_Localization]
   @X XML
AS
BEGIN
   DECLARE @SubSys INT
          ,@SourceRegnLang VARCHAR(3)
          ,@TargetRegnLang VARCHAR(3);
   
   SELECT @SubSys = @X.query('Localization').value('(Localization/@subsys)[1]', 'INT')
         ,@SourceRegnLang = @X.query('Localization').value('(Localization/@sorcregnlang)[1]', 'VARCHAR(3)')
         ,@TargetRegnLang = @X.query('Localization').value('(Localization/@sorcregnlang)[1]', 'VARCHAR(3)');
   
   IF @SubSys = 0 
   BEGIN
      MERGE DataGuard.App_Domain T
      USING (SELECT * FROM DataGuard.App_Domain WHERE REGN_LANG = @SourceRegnLang) S
      ON (T.CODE = S.CODE AND 
          T.REGN_LANG = @TargetRegnLang)
      WHEN NOT MATCHED THEN
         INSERT (code, NAME, VALU, DOMN_DESC, REGN_LANG)
         VALUES (S.CODE, S.NAME, S.VALU, s.DOMN_DESC, @TargetRegnLang);
   END
   ELSE IF @SubSys = 5
   BEGIN
      IF EXISTS (SELECT name FROM sys.databases WHERE name = N'iScsc')
      BEGIN
         MERGE iScsc.dbo.App_Domain T
         USING (SELECT * FROM iScsc.dbo.App_Domain WHERE REGN_LANG = @SourceRegnLang) S
         ON (T.CODE = S.CODE AND 
             T.REGN_LANG = @TargetRegnLang)
         WHEN NOT MATCHED THEN
            INSERT (code, NAME, VALU, DOMN_DESC, REGN_LANG)
            VALUES (S.CODE, S.NAME, S.VALU, s.DOMN_DESC, @TargetRegnLang);
      END
   END
   ELSE IF @SubSys = 11
   BEGIN
      IF EXISTS (SELECT name FROM sys.databases WHERE name = N'iCRM')
      BEGIN
         MERGE iCRM.dbo.App_Domain T
         USING (SELECT * FROM iCRM.dbo.App_Domain WHERE REGN_LANG = @SourceRegnLang) S
         ON (T.CODE = S.CODE AND 
             T.REGN_LANG = @TargetRegnLang)
         WHEN NOT MATCHED THEN
            INSERT (code, NAME, VALU, DOMN_DESC, REGN_LANG)
            VALUES (S.CODE, S.NAME, S.VALU, s.DOMN_DESC, @TargetRegnLang);
      END
   END
   ELSE IF @SubSys = 12
   BEGIN
      IF EXISTS (SELECT name FROM sys.databases WHERE name = N'iRoboTech')
      BEGIN
         MERGE iRoboTech.dbo.App_Domain T
         USING (SELECT * FROM iRoboTech.dbo.App_Domain WHERE REGN_LANG = @SourceRegnLang) S
         ON (T.CODE = S.CODE AND 
             T.REGN_LANG = @TargetRegnLang)
         WHEN NOT MATCHED THEN
            INSERT (code, NAME, VALU, DOMN_DESC, REGN_LANG)
            VALUES (S.CODE, S.NAME, S.VALU, s.DOMN_DESC, @TargetRegnLang);
      END   
   END   
END;
GO
