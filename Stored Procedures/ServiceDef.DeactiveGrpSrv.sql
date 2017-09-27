SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [ServiceDef].[DeactiveGrpSrv]
	@Xml Xml
AS
BEGIN
	Update ServiceDef.Service
	Set IsActive = 0
	Where Exists
	(
	   Select * 
	   From @Xml.nodes('/Deactive/GrpSrv') gs(ids)
	   Where gs.ids.query('.').value('.', 'bigint') = ID
	);
END
GO
