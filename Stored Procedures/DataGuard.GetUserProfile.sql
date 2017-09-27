SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [DataGuard].[GetUserProfile]
	-- Add the parameters for the stored procedure here
	@Xml xml
AS
BEGIN
	Declare @UserEnName nvarchar(max);
	Select 
		@UserEnName = u.name.query('UserName').value('.','nvarchar(max)')
	From @Xml.nodes('/') u(name);
	
	EXEC DataGuard.UpdateSettings '';
	
	Select ID, TitleEn, TitleFa from DataGuard.[User] 
	where lower(TitleEn) = @UserEnName;
	
	SELECT
	'SUCCESSFUL' AS RESULT
	,'0S' AS TIMERUN
	,'User' AS TABLESNAME
	,'iProject' As TableSpaceName
	,'false' AS [HasRelation];
END
GO
