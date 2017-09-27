SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [ServiceDef].[LoadJoinServiceWithCondition]
AS
BEGIN
   Select 
	    [ID]
      ,[TitleFa]
      ,[PriceType]
      ,[Price]
	From ServiceDef.[Service]
	Where ParentID Is Null
	And RectCode = 1
	Order By ID;
	
	SELECT
	 'SUCCESSFUL' AS RESULT
	,'0S' AS TIMERUN
	,'Services' AS TABLESNAME
	,'iProject' As TableSpaceName
	,'false' AS [HasRelation];
END
GO
