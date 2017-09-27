SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [DataGuard].[DuplicateRole]
	-- Add the parameters for the stored procedure here
	@Xml Xml
AS
BEGIN
	Declare @RoleID bigint;
	Declare @RoleFaName Nvarchar(max), @RoleEnName Nvarchar(max), @STitleFa Nvarchar(max);
	Declare @SavePrivileges bit;
	Declare @SaveUsers bit;
	Declare @SubSys INT;
	
	
	Select 
	   @RoleID = r.c.query('RoleID').value('.', 'bigint'),
	   @RoleFaName = r.c.query('RoleName').value('.','nvarchar(max)'),
	   @RoleEnName = r.c.query('TitleEn').value('.', 'nvarchar(max)'),
	   @STitleFa = r.c.query('STitleFa').value('.', 'nvarchar(max)'),
	   @SavePrivileges = r.c.query('SavePrivileges').value('.', 'bit'),
	   @SaveUsers = r.c.query('SaveUsers').value('.', 'bit'),
	   @SubSys = r.c.query('SubSys').value('.', 'INT')
	From @Xml.nodes('/Role') r(c);
	
	Select @SavePrivileges, @SaveUsers;
	
	Insert into DataGuard.Role (TitleFa, TitleEn, STitleFa, SUB_SYS) Values(@RoleFaName, @RoleEnName, @STitleFa, @SubSys);
	
	Declare @NewRoleID bigint;	
	Select @NewRoleID = ID From Role Where STitleFa = @STitleFa;
	
	IF(@SavePrivileges = 1)
	Begin
	   Insert Into DataGuard.Role_Privilege (RoleID, PrivilegeID, IsActive, IsDefault, IsVisible, Sub_Sys)
	   Select @NewRoleID, rp.PrivilegeID, rp.IsActive, rp.IsDefault, rp.IsVisible, rp.Sub_Sys
	   From Role_Privilege rp
	   Where RoleID = @RoleID;
	End
	
	IF(@SaveUsers = 1)
	Begin
	   Insert Into DataGuard.Role_User (RoleID, UserID, IsActive, IsDefault, IsVisible)
	   Select @NewRoleID, ru.UserID, ru.IsActive, ru.IsDefault, ru.IsVisible
	   From Role_User ru
	   Where ru.RoleID = @RoleID;
	End	
END
GO
