SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [ServiceDef].[ActiveService]
   @Xml Xml
AS
BEGIN
   Update ServiceDef.Service
   Set IsActive = 1
   Where 
       RectCode = 1
   And IsActive = 0
   And IsVisible = 1
   And Level = 0
   And Exists(Select * From @Xml.nodes('/Active/ServiceID')t(sid) Where ID = sid.query('.').value('.', 'bigint'));
END
GO
