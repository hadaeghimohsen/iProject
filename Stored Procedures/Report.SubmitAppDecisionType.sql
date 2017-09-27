SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [Report].[SubmitAppDecisionType]
	@Xml XML
AS
BEGIN
	DECLARE @RoleID BIGINT,
			@Adid BIGINT,
			@ForceUpdate BIT;
	SELECT @RoleID      = @Xml.query('/AppDecision/RoleID').value('.', 'BIGINT'),
		   @ForceUpdate = @Xml.query('/AppDecision/ForceUpdate').value('.', 'BIT'),
		   @Adid        = @Xml.query('/AppDecision/Adid').value('.', 'BIGINT');
	
	SELECT @Adid = ID From Report.AppDecision WHERE ShortCut = @Adid;
	
	/* Has Bad Side Effect */
	UPDATE ServiceDef.RolesUnitType
	   SET IsReporting = 0, 
			 ADID = NULL
	 WHERE RoleID   = @RoleID
	   AND UnitType = 1
	   AND ADID = @Adid;
	
	MERGE ServiceDef.RolesUnitType RUT
	Using (
		SELECT
			f.query('.').value('.', 'BIGINT') As Fid
		FROM @Xml.nodes('//FileType/Fid')t(f)
	) RUS
	ON (RUT.RoleID = @RoleID AND RUT.UnitTypeID = RUS.Fid)
	WHEN MATCHED AND ((RUT.IsReporting = 1 AND @ForceUpdate = 1) OR RUT.IsReporting = 0) THEN
		UPDATE 
		   SET IsReporting = 1,
			    Adid        = @Adid;
	--WHEN MATCHED			   
	
END
GO
