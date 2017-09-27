SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [ServiceDef].[LeaveGroupServiceFromGroupHeader]
	-- Add the parameters for the stored procedure here
	@Xml Xml
AS
BEGIN
   Declare @idoc int;
   Exec sp_xml_preparedocument @idoc output, @xml;
   
   Merge ServiceDef.Service_GroupHeader as Sgt
   Using (Select Distinct * From OpenXml( @idoc, '/Leave/GroupHeader/GrpSrv', 1)
            With (GroupHeaderID Bigint '../@ID' 
                , ServiceID Bigint '.')) As Sgs
   On (Sgt.ServiceID = Sgs.ServiceID And Sgt.GroupHeaderID = Sgs.GroupHeaderID)
   When Matched Then
      Update Set IsActive = 0, IsVisible = 0;
         
   Exec sp_xml_removedocument @idoc;   	
END
GO
