SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [Global].[JoinUserToRoles]
	@Xml Xml
AS
BEGIN
   
	Declare @UserID Bigint;
	Select
	   @UserID = u.id.query('UserID').value('.','bigint')
	From
	   @Xml.nodes('/Join') u(id);
	
	Declare newrole Cursor For
	Select
	   [join].[role].query('.').value('.', 'bigint') as [RoleID]
	From @Xml.nodes('/Join/Roles/RoleID') [join]([role]);
	
	Declare @RoleID Bigint;
	
	Open  newrole;
	
	NextFetch:	
	Fetch From newrole into @RoleID;
	
	IF @@FETCH_STATUS <> 0
		Goto ExitLoop;
		
	IF(Exists(Select * From DataGuard.Role_User Where RoleID = @RoleID And UserID = @UserID And IsVisible = 0))	
	   Update DataGuard.Role_User
	   Set IsVisible = 1, IsActive = 1
	   Where RoleID = @RoleID
	   And UserID = @UserID;
	ELSE IF EXISTS(SELECT * FROM DataGuard.Role_User Where RoleID = @RoleID And UserID = @UserID And IsVisible = 1)
	   PRINT 'null';
	Else
	   Insert Into DataGuard.Role_User (RoleID, UserID)
	   Values(@RoleID, @UserID)
	Goto NextFetch;
	
	
	ExitLoop:
	Close newrole;
	
	Deallocate newrole;
END
GO
