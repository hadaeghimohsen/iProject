SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [ServiceDef].[LoadActiveUnitTypeWithCondition]
	@Xml Xml
AS
BEGIN
   Declare @WhatAction Bit;
   Declare @UnitType Smallint;
   
   Select
      @WhatAction = @Xml.query('//WhatAction').value('.', 'bit'),
      @UnitType   = @Xml.query('//UnitType').value('.', 'smallint');
   
   Select ID,
          TitleFa,
          (Case UnitType When 0 Then N'واحد' Else N'نوع' End) As [Desc],
          IsActive
   From ServiceDef.UnitType
   Where IsActive = @WhatAction
     And (UnitType = Case @UnitType When 1 Then 0 When 2 Then 1 End 
          OR
          1 = Case @UnitType When 0 Then 1 Else 0 End);
   
   SELECT
	 'SUCCESSFUL' AS RESULT
	,'0S' AS TIMERUN
	,'UnitType' AS TABLESNAME
	,'Mojtama' As TableSpaceName
	,'false' AS [HasRelation];
END
GO
