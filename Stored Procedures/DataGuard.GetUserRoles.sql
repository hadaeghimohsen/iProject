SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [DataGuard].[GetUserRoles]
	-- Add the parameters for the stored procedure here
	@Xml Xml
AS
BEGIN
	Declare @UserID bigint;
	Select
		@UserID = u.id.query('UserID').value('.','bigint')
	from 
		@Xml.nodes('/')u(id);
	
	Select 
		RoleID,
		cast(roleshortcut as nvarchar(3)) + '- ' + RoleFaName as TitleFa, 
		RUActive as IsActive 
	from DataGuard.AllRolesUsers
	where UserID = @UserID
	order by RoleID;
	
	SELECT
	'SUCCESSFUL' AS RESULT
	,'0S' AS TIMERUN
	,'UserRoles' AS TABLESNAME
	,'iProject' As TableSpaceName
	,'false' AS [HasRelation];	
		
END
GO
