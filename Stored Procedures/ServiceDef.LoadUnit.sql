SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [ServiceDef].[LoadUnit]
	
AS
Begin
	Select ID, TitleFa
   From ServiceDef.UnitType
   Where UnitType = 0;

   SELECT
	 'SUCCESSFUL' AS RESULT
	,'0S' AS TIMERUN
	,'ServiceUnit' AS TABLESNAME
	,'Mojtama' As TableSpaceName
	,'false' AS [HasRelation];
RETURN 0
End
GO
