SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [ServiceDef].[DisbaledService]
	@Xml Xml
AS
BEGIN
	Update ServiceDef.Service
	Set IsVisible = 0
	Where 
	   Exists (
	      Select * From @Xml.nodes('/Disabled/ServiceID')t(sid)
	      Where sid.query('.').value('.','bigint') = ID
	   );
END
GO
