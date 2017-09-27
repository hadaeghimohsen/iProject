SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [ServiceDef].[LoadGrpSrvWithCondition]
	@Xml Xml
AS
BEGIN
	Declare @WhatAction Bit;
	Select @WhatAction = @Xml.query('/WhatAction').value('.','bit');
	
	Select [ID]
         ,[TitleFa]
         ,[ParentID]
         ,0 as [IsVisited]
	From ServiceDef.[Service]
	Where IsActive = @WhatAction
	  And [Level] = 1
	  And RectCode = 1
	Order By ID, ParentID;

   SELECT
	 'SUCCESSFUL' AS RESULT
	,'0S' AS TIMERUN
	,'ParentService' AS TABLESNAME
	,'Mojtama' As TableSpaceName
	,'false' AS [HasRelation];	 
END
GO
