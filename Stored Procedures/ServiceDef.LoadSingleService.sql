SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [ServiceDef].[LoadSingleService]
	@Xml Xml	
AS
BEGIN
	Declare @ServiceID bigint;
	Select @ServiceID = @Xml.query('/ServiceID').value('.','bigint');
	
	Select 
	   s.*,
	   IsNuLL((Select TitleFa From ServiceDef.Service Where ID = s.ParentID), N'به عنوان گروه خدمت سطح یک سرفصل') As ParentName
	From ServiceDef.Service s
	Where ID = @ServiceID
	And RectCode = 1;
	
	Select GroupHeaderID from ServiceDef.Service_GroupHeader
   Where ServiceID = @ServiceID
     And IsActive = 1 
     And IsVisible = 1;
	
	SELECT
	 'SUCCESSFUL' AS RESULT
	,'0S' AS TIMERUN
	,'Service:GroupHeader' AS TABLESNAME
	,'iProject' As TableSpaceName
	,'false' AS [HasRelation];	
END
GO
