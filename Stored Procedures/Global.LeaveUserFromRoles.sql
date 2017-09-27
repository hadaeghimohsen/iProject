SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [Global].[LeaveUserFromRoles]
	-- Add the parameters for the stored procedure here
	@Xml Xml
AS
BEGIN
	Declare @UserID Bigint;
	Select
	   @UserID = u.id.query('UserID').value('.','bigint')
	From
	   @Xml.nodes('/Leave') u(id);
	
	Update DataGuard.ARU
	Set RUVisible = 0
	Where UserID = @UserID and
	Exists
	(
	   Select * 
	   From @Xml.nodes('/Leave/Roles/RoleID') [leave]([role])
	   Where [leave].[role].query('.').value('.', 'bigint') = RoleID
	);
END
GO
