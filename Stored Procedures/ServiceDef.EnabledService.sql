SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [ServiceDef].[EnabledService]
	@Xml Xml
AS
BEGIN
	Update ServiceDef.Service
	Set IsVisible = 1
	Where 
	   Exists (
	      Select * From @Xml.nodes('/Enabled/ServiceID')t(sid)
	      Where sid.query('.').value('.','bigint') = ID
	   );
END
GO
