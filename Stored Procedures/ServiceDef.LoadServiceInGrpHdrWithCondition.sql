SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [ServiceDef].[LoadServiceInGrpHdrWithCondition]
	@Xml Xml
AS
BEGIN
	Declare @GrpSrv Bigint;
	Select @GrpSrv = @Xml.query('/GrpSrv').value('.', 'bigint');
	
	Select 
	    [ID]
      ,[TitleFa]
      ,[PriceType]
      ,[Price]
	From ServiceDef.[Service]
	Where ParentID = @GrpSrv
	And RectCode = 1
	And IsVisible = 0
	Order By ID;
	
	SELECT
	 'SUCCESSFUL' AS RESULT
	,'0S' AS TIMERUN
	,'Services' AS TABLESNAME
	,'iProject' As TableSpaceName
	,'false' AS [HasRelation];

END;
GO
