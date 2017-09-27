SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [ServiceDef].[JoinGroupServiceIntoGroupHeader]
	-- Add the parameters for the stored procedure here
	@Xml Xml
AS
BEGIN
   Declare @idoc int;
   Exec sp_xml_preparedocument @idoc output, @xml;
   
   Merge ServiceDef.Service_GroupHeader as Sgt
   Using (Select * From OpenXml( @idoc, '/Join/GroupHeader/GrpSrv', 1)
            With (GroupHeaderID Bigint '../@ID' 
                , ServiceID Bigint '.')) As Sgs
   On (Sgt.ServiceID = Sgs.ServiceID And Sgt.GroupHeaderID = Sgs.GroupHeaderID)
   When Matched Then
      Update Set IsActive = 1, IsVisible = 1
   When Not Matched Then
      Insert (ServiceID, GroupHeaderID) Values(Sgs.ServiceID, Sgs.GroupHeaderID);
   
   Exec sp_xml_removedocument @idoc;   	
END
GO
