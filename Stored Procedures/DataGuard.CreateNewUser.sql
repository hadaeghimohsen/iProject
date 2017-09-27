SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [DataGuard].[CreateNewUser]
	-- Add the parameters for the stored procedure here
	@Xml Xml
AS
BEGIN
	Declare @TitleFa NVarchar(Max), @TitleEn NVarchar(Max), @STitleEn NVarchar(Max);
	Declare @Password NVarchar(Max);
	Declare @IsLock Bit;
	Declare @Shortcut bigint,
	        @PassDb   VARCHAR(MAX);
	SET @PassDb = CONVERT(VARCHAR(MAX), NEWID());
	Select  @Shortcut = MAX(ShortCut) + 1 from DataGuard.[User] ;
	
	
	Insert Into DataGuard.[User] (ShortCut, TitleFa, TitleEn, STitleEn, Password, IsLock, USERDB, PASSDB, AMIL_ADRS, MUST_CHNG_PASS, FRST_LOGN, PLCY_FORC_SAFE_ENTR, PASS_MDFY_DATE, DFLT_FACT)
	Select
	   @Shortcut,
	   u.d.query('TitleFa').value('.', 'nvarchar(max)'),
	   u.d.query('TitleEn').value('.', 'nvarchar(max)'),
	   u.d.query('STitleEn').value('.','nvarchar(max)'),
	   u.d.query('Password').value('.', 'nvarchar(max)'),
	   u.d.query('IsLock').value('.', 'bit'),
	   u.d.query('TitleEn').value('.', 'nvarchar(max)'),
	   @PassDb,
	   u.d.query('TitleEn').value('.', 'nvarchar(max)') + '@anar.com',
	   '002',
	   '002',
	   '002',
	   GETDATE(),
	   '001'
	From @Xml.nodes('/User') [u](d);
	
	-----------------
	DECLARE C$USERS CURSOR FOR
	Select
	   u.d.query('TitleEn').value('.', 'nvarchar(max)')
	From @Xml.nodes('/User') [u](d);
	
	OPEN C$USERS;
	L$NextRow:
	FETCH NEXT FROM C$USERS INTO @TitleEn;
	
	IF NOT EXISTS (SELECT * FROM SYS.SERVER_PRINCIPALS WHERE UPPER(Name) = UPPER(@TitleEn))
   BEGIN
      DECLARE @sql NVARCHAR(max)
      SET @sql = 'USE master;' +
                 'CREATE LOGIN ' + UPPER(@TitleEn) + ' WITH PASSWORD = ''' + @PassDb + ''';';                 
      EXEC (@sql)

      EXEC SYS.SP_ADDSRVROLEMEMBER @loginame = @TitleEn, @rolename = N'sysadmin'
   END
	
	L$EndFetch:
	CLOSE C$USERS;
	DEALLOCATE C$USERS;
	
	return 0;
END
GO
