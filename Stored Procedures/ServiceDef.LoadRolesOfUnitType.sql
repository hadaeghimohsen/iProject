SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [ServiceDef].[LoadRolesOfUnitType]
	-- Add the parameters for the stored procedure here
	@Xml Xml
AS
BEGIN
   Declare @UnitTypeID bigint;
   Select @UnitTypeID = @Xml.query('/UnitTypeID').value('.', 'bigint');
   
   Select RoleID
   From ServiceDef.Role_UnitType
   Where UnitTypeID = @UnitTypeID
   And IsActive = 1;
   
   SELECT
	 'SUCCESSFUL' AS RESULT
	,'0S' AS TIMERUN
	,'Roles' AS TABLESNAME
	,'Mojtama' As TableSpaceName
	,'false' AS [HasRelation];	
END
GO
