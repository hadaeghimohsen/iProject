SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		Aref
-- Create date: 2/11/2014
-- Description:	
-- =============================================
CREATE PROCEDURE [ServiceDef].[LoadUnitType]
   @Xml Xml
AS
BEGIN
	Declare @UnitType Smallint;
	Select @UnitType = @Xml.query('/UnitType').value('.', 'smallint');
	
	Select ID,
	       (Cast(ShortCut as NVarchar(3)) + '- ' + TitleFa) As TitleFa,
	       (Case UnitType
	         When 0 Then N'واحد'
	         When 1 Then N'نوع'
	        End) As UnitTypeDesc,
	       IsActive
	From ServiceDef.UnitType
	Where (UnitType = Case @UnitType
	                  When 1 Then 0
	                  When 2 Then 1
	                 End
	   Or 1 = Case @UnitType
	           When 0 Then 1
	           Else 0
	          End)
	   And IsVisible = 1
	Order By UnitType;

	   
	SELECT
	 'SUCCESSFUL' AS RESULT
	,'0S' AS TIMERUN
	,'UnitType' AS TABLESNAME
	,'Mojtama' As TableSpaceName
	,'false' AS [HasRelation];	                 
END
GO
