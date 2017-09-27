SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [DataGuard].[RevokeUsersFromRole]
	-- Add the parameters for the stored procedure here
	@Xml Xml
AS
BEGIN
	Declare @RoleID Bigint;
	select 
	   @RoleID = [grant].[role].query('RoleID').value('.', 'bigint')
   from @Xml.nodes('/Revoke') [grant]([role]);	
	
	Update DataGuard.ARU
	Set RUVisible = 0
	Where RoleID = @RoleID and
	Exists
	(
	   Select * 
	   From @Xml.nodes('/Revoke/UserID') [revoke]([user])
	   Where [revoke].[user].query('.').value('.', 'bigint') = UserID
	);
	
END
GO
