SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [Global].[LoadReminderRoles]
	@Xml Xml
AS
BEGIN
	Declare @UserID bigint;
	Select
	   @UserID = u.id.query('UserID').value('.','bigint')
	From @Xml.nodes('/')u(id);
	
	Select ID as RoleID, TitleFa, 1 as IsActive
	From DataGuard.[Role] R
	Where 
	  IsVisible = 1
	  And IsActive = 1 
	  And Not Exists(
            Select * from DataGuard.AllRolesUsers aru 
             Where aru.UserID = @UserID 
               And aru.RoleID = R.ID
               And aru.RUVisible = 1);
	
	SELECT
	 'SUCCESSFUL' AS RESULT
	,'0S' AS TIMERUN
	,'Roles' AS TABLESNAME
	,'Mojtama' As TableSpaceName
	,'false' AS [HasRelation];	
END
GO
