SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [DataGuard].[LoadUserProfile]
	-- Add the parameters for the stored procedure here
	@Xml Xml
AS
BEGIN
	Declare @UserID bigint;
	Select
	   @UserID = [U].ID.query('UserID').value('.', 'bigint')
	From @Xml.nodes('/Role/User') [U](Id);
	
	Select 
	   ID, ShortCut, TitleEn, TitleFa,IsLock
	From DataGuard.[User] as [User]
	Where [User].ID = @UserID;
	--For Xml Auto;
	
	SELECT
	 'SUCCESSFUL' AS RESULT
	,'0S' AS TIMERUN
	,'User' AS TABLESNAME
	,'Mojtama' As TableSpaceName
	,'false' AS [HasRelation];
END
GO
