SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [DataGuard].[DuplicateUser]
	-- Add the parameters for the stored procedure here	
	@Xml Xml
AS
BEGIN

   Declare @UserID bigint;
   
   select 
      @UserID = u.d.query('UserID').value('.','bigint')
   from @Xml.nodes('/Duplicate/Role/User') u(d);

	Declare @TitleFa NVarchar(Max), @TitleEn Nvarchar(max), @STitleEn Nvarchar(max);
	Declare @Password NVarchar(max);
	Declare @IsLock Bit;
	Declare @GrantToRole Bit;
	Declare @GrantToPrivilege Bit;
	DECLARE @JustDef VARCHAR(3);
	
	Select
	   @TitleFa = u.d.query('TitleFa').value('.','nvarchar(max)'),
	   @TitleEn = u.d.query('TitleEn').value('.','nvarchar(max)'),
	   @STitleEn = u.d.query('STitleEn').value('.','nvarchar(max)'),
	   @Password = u.d.query('Password').value('.','nvarchar(max)'),
	   @IsLock = u.d.query('IsLock').value('.','bit'),
	   @GrantToRole = u.d.query('GrantToRole').value('.','bit'),
	   @GrantToPrivilege = u.d.query('GrantToPrivilege').value('.','bit'),
	   @JustDef = u.d.query('JustDef').value('.','VARCHAR(3)')
	From @Xml.nodes('/Duplicate/NewUser') u(d);
	
	Declare @Shortcut bigint,
	        @PassDB   VARCHAR(MAX);
	
	SET @PassDB = CONVERT(VARCHAR(MAX), NEWID());
	
	Select @Shortcut = MAX(Shortcut) + 1
	from DataGuard.[User] ;
	
	Insert Into DataGuard.[User] (ShortCut, TitleFa, TitleEn, STitleEn, Password, IsLock, USERDB, PASSDB, MUST_CHNG_PASS, DFLT_FACT, FRST_LOGN, PLCY_FORC_SAFE_ENTR, PASS_MDFY_DATE, ADD_COMP_LIST)
	values(@Shortcut, @TitleFa, @TitleEn, @STitleEn, @Password, @IsLock, @TitleEn, @PassDB, '002', '001', '002', '002', GETDATE(), '002');
	
	Declare @NewUserId bigint;
	Select @NewUserId = u.ID
	from DataGuard.[User] u
	Where u.STitleEn = @STitleEn;
	
	if(@GrantToPrivilege = 1)
	begin
	   Insert into DataGuard.User_Privilege (UserID, PrivilegeID, BOXP_BPID, IsActive, IsDefault, IsVisible, Sub_Sys)
	   Select @NewUserId, PrivilegeID, BOXP_BPID, IsActive, IsDefault, IsVisible, Sub_Sys
	   From DataGuard.User_Privilege
	   Where UserID = @UserID;
	end
	
	if(@GrantToRole = 1)
	begin
	   Insert into DataGuard.Role_User (UserID, RoleID, IsActive, IsDefault, IsVisible)
	   Select @NewUserId, RoleID, IsActive, IsDefault, IsVisible
	   From DataGuard.Role_User
	   Where UserID = @UserID;
	end
	
	IF ISNULL(@JustDef, '001') = '001' OR @JustDef = ''
	   INSERT INTO Global.Access_User_Datasource
	           ( USER_ID, DSRC_ID, STAT, STRT_DATE, END_DATE, ACES_TYPE, HOST_NAME )
	   SELECT @NewUserId, DSRC_ID, STAT, STRT_DATE, END_DATE, ACES_TYPE, HOST_NAME
	     FROM Global.Access_User_Datasource
	    WHERE USER_ID = @UserID;
	
	-- Exec Other Database For Duplicate user
	
	------------------------------
	IF NOT EXISTS (SELECT * FROM SYS.SERVER_PRINCIPALS WHERE UPPER(Name) = UPPER(@TitleEn))
   BEGIN
      DECLARE @sql NVARCHAR(max)
      SET @sql = 'USE master;' +
                 'CREATE LOGIN [' + @TitleEn + '] WITH PASSWORD = ''' + @PassDB + ''';';                 
      EXEC (@sql);
      EXEC SYS.SP_ADDSRVROLEMEMBER @loginame = @TitleEn, @rolename = N'sysadmin';
   END
   
   -- Integration Databases
   IF ISNULL(@JustDef, '001') = '001'   
      EXECUTE dbo.IntegrationSystems;
END
GO
