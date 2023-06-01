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
		    ,@Passdb VARCHAR(255)
		    ,@LastDate DATE
		    ,@AppExprDate DATE
		    ,@AppExprType BIT 
		    ,@CrntDate DATE = GETDATE()
		    ,@MesgText NVARCHAR(MAX) = 
		      N'مدت زمان پشتیبانی نرم افزار به اتمام رسیده، لطفا جهت تمدید پشتیبانی با شماره 09033927103 تماس حاصل فرمایید' + CHAR(10) + 
		      N'ضمنا تمامی رکورد های ثبت شده خارج از تاریخ پشتیبانی فاقد اعتبار میباشند و بعد از بسته شدن نرم افزار تمامی رکوردها به صورت اتومات پاک میشوند' + CHAR(10)
		    ,@Year VARCHAR(4) = SUBSTRING(dbo.MiladiTOShamsi(GETDATE()), 1 , 4);
	
	--1399/12/06 * اگر این قسمت ستون مربوط به تاریخ آخرین ثبت عملیات ذخیره نشده باشد بایستی ستون های آن اضافه گردد و بررسی شود که تاریخ پشتیبانی تمام شده یا خیر
	IF NOT EXISTS (SELECT * FROM dbo.Settings s WHERE s.X.query('/Settings/AppExpire').value('(AppExpire/@lastdate)[1]', 'datetime') IS NOT NULL)
	BEGIN
	   SELECT @LastDate = dbo.GET_STOM_U(@Year + '/12/29');
	   UPDATE dbo.Settings SET x.modify('replace value of (/Settings/AppExpire/@value)[1] with sql:variable("@lastdate")');
	   UPDATE dbo.Settings SET x.modify('replace value of (/Settings/AppExpire/@type)[1] with "true"');
	   SET @LastDate = GETDATE();
	   UPDATE dbo.Settings SET x.modify('insert attribute lastdate {sql:variable("@lastdate")} into (/Settings/AppExpire)[1]');	   	   
	END 
		   
	SELECT @LastDate = s.X.query('/Settings/AppExpire').value('(AppExpire/@lastdate)[1]', 'DATE'),
	       @AppExprDate = s.X.query('/Settings/AppExpire').value('(AppExpire/@value)[1]', 'DATE'),
	       @AppExprType = s.X.query('/Settings/AppExpire').value('(AppExpire/@type)[1]', 'BIT')
	  FROM dbo.Settings s;
   
   -- اگر تاریخ پشتیبانی نرم افزار تمام شده باشد
   -- یا اینکه یک مشتری زبلی مثل خانم هادیان تاریخ سیستم رو عوض کنه
   IF @AppExprType = 1 AND 
      (
         --CAST(@LastDate AS DATE) < CAST(@CrntDate AS DATE) OR 
         CAST(@LastDate AS DATE) > CAST(@CrntDate AS DATE) OR 
         DATEDIFF(DAY, @LastDate, @AppExprDate) < 0 OR 
         (SELECT TOP 1 PERS_EXPR_VALU FROM DataGuard.V#Settings) != SUBSTRING(dbo.MiladiTOShamsi(GETDATE()), 1 , 4) + '/12/29'
      ) AND UPPER(SUSER_NAME()) != 'ARTAUSER'
   BEGIN
      PRINT 'Welldone';
      --RAISERROR(@MesgText, 16, 1);
      --RETURN;      
   END 
   ELSE
   BEGIN
      SET @LastDate = GETDATE();
      UPDATE dbo.Settings SET x.modify('replace value of (/Settings/AppExpire/@lastdate)[1] with sql:variable("@lastdate")');
   END 
   --------------------------------------------------------------------------------------------
		    
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
