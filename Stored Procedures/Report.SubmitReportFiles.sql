SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [Report].[SubmitReportFiles]
	@Xml XML
AS
BEGIN
	DECLARE @RoleID BIGINT;
	SELECT @RoleID = @Xml.query('/ReportFile/RoleID').value('.', 'BIGINT');
	
	UPDATE ServiceDef.Role_GroupHeader
	SET IsReporting = 0
	WHERE RoleID = @RoleID;
	
	MERGE ServiceDef.Role_GroupHeader RGT
	USING (
		SELECT
			c.query('.').value('.', 'BIGINT') as Cid
		FROM @Xml.nodes('//Cabinets/Cid') t(c)
	) RGS
	ON (RGT.RoleID = @RoleID AND RGT.GRoupHeaderID = RGS.Cid)
	WHEN MATCHED THEN
		UPDATE
		   SET IsReporting = 1
	WHEN NOT MATCHED THEN
		INSERT (RoleID , GroupHeaderID, IsReporting)
		VALUES (@RoleID, RGS.Cid      , 1);
		
	UPDATE ServiceDef.Role_UnitType
	SET IsReporting = 0
	WHERE RoleID = @RoleID;
	
	MERGE ServiceDef.Role_UnitType RUT
	Using (
		SELECT
			f.query('.').value('.', 'BIGINT') As Fid
		FROM @Xml.nodes('//Folders/Fid')t(f)
	) RUS
	ON (RUT.RoleID = @RoleID AND RUT.UnitTypeID = RUS.Fid)
	WHEN MATCHED THEN
		UPDATE 
		   SET IsReporting = 1
	WHEN NOT MATCHED THEN
		INSERT (RoleID, UnitTypeID, IsReporting)
		VALUES (@RoleID, RUS.Fid,   1);
	
END
GO
