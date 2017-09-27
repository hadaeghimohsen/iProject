SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [ServiceDef].[ReadTypeOfRoles]
	@Xml Xml
AS
BEGIN
	DECLARE @Roleid BIGINT;
	SELECT @Roleid = @Xml.query('/RoleID').value('.', 'bigint');
	DECLARE @UnitType BIT;
	SELECT @UnitType = @Xml.query('/UnitType').value('.', 'bit');
	DECLARE @IsLinked BIT;
	SELECT @IsLinked = @Xml.query('/IsLinked').value('.','bit');
	Set @IsLinked = ISNULL(@IsLinked, 0);
	
	SELECT rut.TitleFa, rut.UnitTypeID as UnitTypeid
	FROM ServiceDef.RolesUnitType rut
	WHERE rut.RoleID = @Roleid
	And UnitType = @UnitType
	AND (1 = CASE @UnitType WHEN 1 THEN 1 ELSE 0 END OR (1 = CASE @IsLinked WHEN 0 THEN 1 ELSE 0 END OR IsReporting = 0))
	
	
	SELECT
	 'SUCCESSFUL' AS RESULT
	,'0S' AS TIMERUN
	,'UnitType' AS TABLESNAME
	,'Mojtama' As TableSpaceName
	,'false' AS [HasRelation];
END
GO
