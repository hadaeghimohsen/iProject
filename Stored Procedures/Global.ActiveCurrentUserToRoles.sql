SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [Global].[ActiveCurrentUserToRoles]
	-- Add the parameters for the stored procedure here
	@Xml Xml
AS
BEGIN
	Declare @UserID bigint;
	Select
	   @UserID = u.id.query('UserID').value('.','bigint')
	From
	   @Xml.nodes('/Active') u(id);
	
	Update DataGuard.ARU
	Set RUActive = 1
	Where UserID = @UserID and
	Exists
	(
	   Select * 
	   From @Xml.nodes('/Active/Roles/RoleID') [Active]([role])
	   Where [Active].[role].query('.').value('.', 'bigint') = RoleID
	);
END
GO
