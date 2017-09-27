SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [DataGuard].[LoadUsersOfRoleWithCondition]
	-- Add the parameters for the stored procedure here
	@Xml Xml	
AS
BEGIN
	
	Select ARU.UserID, ARU.UserFaName as [TitleFa], ARU.RUActive as [IsActive] 
	From DataGuard.ARU ARU inner join @Xml.nodes('/') [r](id) on (ARU.RoleID = [r].id.query('RoleID').value('.', 'bigint'))
	Where ARU.RUActive = r.id.query('/RUActive').value('.','bit')
	Order by ARU.UserFaName;
	
	SELECT
	 'SUCCESSFUL' AS RESULT
	,'0S' AS TIMERUN
	,'Users' AS TABLESNAME
	,'Mojtama' As TableSpaceName
	,'false' AS [HasRelation];
END
GO
