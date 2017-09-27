SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [DataGuard].[ReadAllAccessRoles]
	-- Add the parameters for the stored procedure here	
	@Xml Xml
AS
BEGIN
   Declare @UserEnName nvarchar(max);
   Select
      @UserEnName = u.name.query('UserName').value('.','nvarchar(max)')
   From @Xml.nodes('/AR')u(name);
   
	Select RoleID, RoleFaName from DataGuard.RU
	Where UserEnName = @UserEnName
	Order by RoleFaName;
	
	SELECT
	 'SUCCESSFUL' AS RESULT
	,'0S' AS TIMERUN
	,'Roles' AS TABLESNAME
	,'Mojtama' As TableSpaceName
	,'false' AS [HasRelation];
END
GO
