SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [DataGuard].[GrantUsersToRole]
	-- Add the parameters for the stored procedure here
	@Xml Xml
AS
BEGIN
   Declare @RoleID Bigint;
	select 
	   @RoleID = [grant].[role].query('RoleID').value('.', 'bigint')
   from @Xml.nodes('/Grant') [grant]([role]);
	
	
	Declare newuser Cursor For
	Select
	   [grant].[user].query('.').value('.', 'bigint') as [UserID]
	From @Xml.nodes('/Grant/UserID') [grant]([user]);
	
	Declare @UserID Bigint;
	
	Open  newuser;
	
	NextFetch:	
	Fetch From newuser into @UserID;
	
	IF @@FETCH_STATUS <> 0
		Goto ExitLoop;
		
	IF(Exists(Select * From DataGuard.ARU Where UserID = @UserID And RUVisible = 0))	
	   Update DataGuard.ARU 
	   Set RUVisible = 1, RUActive = 1
	   Where UserID = @UserID;
	Else
	   Insert Into DataGuard.Role_User(RoleID, UserID) Values(@RoleID, @UserID);
	Goto NextFetch;	
	
	ExitLoop:
	Close newuser;
	
	Deallocate newuser;
END
GO
