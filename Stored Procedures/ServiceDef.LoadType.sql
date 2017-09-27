SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [ServiceDef].[LoadType]
	
AS
Begin
	Select ID, TitleFa
   From ServiceDef.UnitType
   Where UnitType = 1;

   SELECT
	 'SUCCESSFUL' AS RESULT
	,'0S' AS TIMERUN
	,'ServiceType' AS TABLESNAME
	,'Mojtama' As TableSpaceName
	,'false' AS [HasRelation];
RETURN 0
End
GO
