SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [DataGuard].[CRET_DOMN_P] 
AS
begin
   declare c$domain cursor for
   select distinct code from DataGuard.app_domain;
   declare @code varchar(20);
   declare @statement varchar(4000);
   
   open c$domain;
   l$nextrow:
   fetch next from c$domain into @code;
   
   if @@FETCH_STATUS <> 0
      goto l$endloop;
   
   set @statement = '[DataGuard].[d$' + substring(@code, 3, len(@code)) + ']';
   if  exists (select * from sys.views where object_id = object_id(@statement))
   begin
      set @statement = 'DROP VIEW [DataGuard].[D$' + SUBSTRING(@code, 3, LEN(@code)) +']';
      exec sp_sqlexec @statement;
   end
   set @statement = 'CREATE VIEW DataGuard.D$' + SUBSTRING(@code, 3, LEN(@code)) + ' AS SELECT VALU, DOMN_DESC FROM DataGuard.APP_DOMAIN A, DataGuard.[User] U WHERE A.REGN_LANG = ISNULL(U.REGN_LANG, ''054'') AND UPPER(u.USERDB) = UPPER(SUSER_NAME()) AND A.CODE = ''' + @code + '''';
   exec sp_sqlexec @statement;
   goto l$nextrow;
  
   l$endloop:
   close c$domain;
   deallocate c$domain;
end;



GO
