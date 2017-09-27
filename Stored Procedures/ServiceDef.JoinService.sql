SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [ServiceDef].[JoinService]
	@Xml Xml
AS
BEGIN
   Declare @GrpSrv Bigint;
   Select @GrpSrv = @Xml.query('/Join/GrpSrv').value('.', 'bigint');
   
   Update ServiceDef.Service
   Set ParentID = @GrpSrv
   Where 
         RectCode = 1
     And Level = 0
     And
         Exists (
            Select * From @Xml.nodes('/Join/ServiceID')t(sid) 
             Where sid.query('.').value('.', 'bigint') = ID);
END
GO
