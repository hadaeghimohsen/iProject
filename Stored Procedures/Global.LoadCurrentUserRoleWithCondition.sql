SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [Global].[LoadCurrentUserRoleWithCondition]
	@Xml Xml	
AS
BEGIN
	Declare @UserID bigint;
	Declare @RUActive Bit;
	Select 
		@UserID = u.id.query('UserID').value('.','bigint'),
		@RUActive = u.id.query('RUActive').value('.','bit')
	From @Xml.nodes('/')u(id);
	
	Select 
		RoleID,
		cast(roleshortcut as nvarchar(3)) + '- ' + RoleFaName as TitleFa, 
		RUActive as IsActive 
	from DataGuard.AllRolesUsers ARU
	Where 
	  	  ARU.UserID = @UserID
	  And ARU.RUActive = @RUActive
	Order By ARU.RoleFaName;

	SELECT
	'SUCCESSFUL' AS RESULT
	,'0S' AS TIMERUN
	,'Roles' AS TABLESNAME
	,'iProject' As TableSpaceName
	,'false' AS [HasRelation];		  
END
GO
