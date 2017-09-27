SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [ServiceDef].[DeactiveGrpSrvFromGrpHdr]
	-- Add the parameters for the stored procedure here
	@Xml Xml
AS
BEGIN
	Declare @idoc int;
	Exec sp_xml_preparedocument @idoc output, @xml;
	
	Merge ServiceDef.Service_GroupHeader as Sgt
	Using (Select * 
	         From OPENXML(@idoc, '/Deactive/GroupHeader/GrpSrv', 1)
	            With(GroupHeaderID bigint '../@ID',
	                 ServiceID bigint '.')) As Sgs
	On (Sgt.GroupHeaderID = Sgs.GroupHeaderID And Sgt.ServiceID = Sgs.ServiceID)
	When Matched Then
	   Update Set IsActive = 0;
	   
	Exec sp_xml_removedocument @idoc;
END
GO
