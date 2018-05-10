SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [Global].[SetSubSysAppDomain]
   @X XML
AS
BEGIN
   DECLARE @SubSys INT
          ,@Code VARCHAR(20)
          ,@Valu VARCHAR(3)
          ,@DomnDesc NVARCHAR(255)
          ,@RegnLang VARCHAR(3);
   
   SELECT @SubSys   = @X.query('App_Domain').value('(App_Domain/@subsys)[1]', 'INT')
         ,@RegnLang = @X.query('App_Domain').value('(App_Domain/@regnlang)[1]', 'varchar(3)');
   
   DECLARE C$Domain CURSOR FOR
      SELECT r.query('.').value('(Domain/@code)[1]', 'VARCHAR(20)')
            ,r.query('.').value('(Domain/@valu)[1]', 'VARCHAR(3)')
            ,r.query('.').value('(Domain/@domndesc)[1]', 'NVARCHAR(255)')
        FROM @X.nodes('//Domain') T(r)
   
   OPEN [C$Domain];
   L$LOOP:
   FETCH [C$Domain] INTO @Code, @Valu, @DomnDesc;
   
   IF @@FETCH_STATUS <> 0
      GOTO L$ENDLOOP;
         
   IF @SubSys = 0 
   BEGIN
      UPDATE DataGuard.App_Domain
         SET DOMN_DESC = @DomnDesc
       WHERE CODE = @Code
         AND VALU = @Valu
         AND REGN_LANG = @RegnLang;
   END
   ELSE IF @SubSys = 5
   BEGIN
      UPDATE iScsc.dbo.App_Domain
         SET DOMN_DESC = @DomnDesc
       WHERE CODE = @Code
         AND VALU = @Valu
         AND REGN_LANG = @RegnLang;
   END
   ELSE IF @SubSys = 11
   BEGIN
      UPDATE iCRM.dbo.App_Domain
         SET DOMN_DESC = @DomnDesc
       WHERE CODE = @Code
         AND VALU = @Valu
         AND REGN_LANG = @RegnLang;
   END
   ELSE IF @SubSys = 12
   BEGIN
      UPDATE iRoboTech.dbo.App_Domain
         SET DOMN_DESC = @DomnDesc
       WHERE CODE = @Code
         AND VALU = @Valu
         AND REGN_LANG = @RegnLang;
   END
   
   GOTO L$LOOP;
   L$ENDLOOP:
   CLOSE [C$Domain];
   DEALLOCATE [C$Domain];   
END;
GO
