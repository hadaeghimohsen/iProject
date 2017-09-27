SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [DataGuard].[ReCreateExistsUsers]	
AS
BEGIN
	DECLARE @Userdb VARCHAR(255)
		    ,@Passdb VARCHAR(255);
		    
	DECLARE C$USERS CURSOR FOR
	Select
	   UPPER(u.USERDB), u.PASSDB
	From DataGuard.[User] u
	
	OPEN C$USERS;
	L$NextRow:
	FETCH NEXT FROM C$USERS INTO @Userdb, @Passdb;
	
	IF @@FETCH_STATUS <> 0
	   GOTO L$EndFetch;
	
	IF LEN(@Userdb) <> 0 AND  NOT EXISTS (SELECT * FROM SYS.SERVER_PRINCIPALS WHERE UPPER(Name) = UPPER(@Userdb))
    BEGIN
      DECLARE @sql NVARCHAR(max)
      SET @sql = 'USE master;' +
                 'CREATE LOGIN ' + UPPER(@Userdb) + ' WITH PASSWORD = ''' + @Passdb + ''';';                 
      EXEC (@sql)

      EXEC SYS.SP_ADDSRVROLEMEMBER @loginame = @Userdb, @rolename = N'sysadmin'
    END
	
	GOTO L$NextRow;
	L$EndFetch:
	CLOSE C$USERS;
	DEALLOCATE C$USERS;
END
GO
