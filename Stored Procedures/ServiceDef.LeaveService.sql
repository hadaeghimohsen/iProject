SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [ServiceDef].[LeaveService]
	@Xml Xml
AS
BEGIN
  
   Update ServiceDef.Service
   Set ParentID = null
   Where 
         RectCode = 1
     And Level = 0
     And 
         Exists (
            Select * From @Xml.nodes('/Leave/ServiceID')t(sid) 
             Where sid.query('.').value('.', 'bigint') = ID);
END
GO
