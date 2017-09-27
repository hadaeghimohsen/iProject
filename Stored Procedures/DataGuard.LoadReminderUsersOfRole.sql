SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [DataGuard].[LoadReminderUsersOfRole]
	-- Add the parameters for the stored procedure here
	@Xml Xml
AS
BEGIN	
	Declare @RoleID bigint;
	Select
	   @RoleID = [role].[data].query('RoleID').value('.', 'bigint')
	From @Xml.nodes('/') [role]([data]);
	
	Select p.ID as [UserID], p.TitleFa , 1 as [IsActive] 
	From DataGuard.[User] p
	Where	Not Exists (Select * From DataGuard.ARU Where RoleID = @RoleID And UserID = p.ID and RUVisible = 1)
	Order by p.TitleFa;
	
	SELECT
	 'SUCCESSFUL' AS RESULT
	,'0S' AS TIMERUN
	,'Users' AS TABLESNAME
	,'Mojtama' As TableSpaceName
	,'false' AS [HasRelation];
END
GO
