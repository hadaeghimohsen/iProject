SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [ServiceDef].[ActiveGrpSrv]
	@Xml Xml
AS
BEGIN
	Update ServiceDef.Service
	Set IsActive = 1
	Where Exists
	(
	   Select * 
	   From @Xml.nodes('/Active/GrpSrv') gs(ids)
	   Where gs.ids.query('.').value('.', 'bigint') = ID
	);
END
GO
