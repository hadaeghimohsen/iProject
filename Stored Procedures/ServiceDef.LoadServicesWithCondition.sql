SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
Create PROCEDURE [ServiceDef].[LoadServicesWithCondition]
	@Xml Xml
AS
BEGIN
	Declare @GrpSrv Bigint;
	Declare @WhatAction Bit;
	Select @GrpSrv = @Xml.query('/Where/GrpSrv').value('.', 'bigint'),
	       @WhatAction = @Xml.query('/Where/WhatAction').value('.', 'bit');
	
	Select 
	    [ID]
      ,[TitleFa]
      ,[PriceType]
      ,[Price]
      ,[IsActive]
	From ServiceDef.[Service]
	Where ParentID = @GrpSrv
	And RectCode = 1
	And IsVisible = 1
	And IsActive = @WhatAction
	Order By ID;
	
	SELECT
	 'SUCCESSFUL' AS RESULT
	,'0S' AS TIMERUN
	,'Services' AS TABLESNAME
	,'iProject' As TableSpaceName
	,'false' AS [HasRelation];
END
GO
