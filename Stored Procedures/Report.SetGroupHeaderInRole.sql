SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [Report].[SetGroupHeaderInRole]
	-- Add the parameters for the stored procedure here
	@XML XML
AS
BEGIN
	DECLARE @RequestType VARCHAR(15);
	DECLARE @Role BIGINT;
   DECLARE @GroupHeader BIGINT;
   DECLARE @idoc INT;
   
	SELECT @RequestType = @XML.query('/Request').value('(/Request/@Type)[1]', 'VARCHAR(15)');
	       
	IF( @RequestType = 'AddNewItem' )
	BEGIN
	   INSERT INTO Report.GroupHeader (Shortcut, TitleFa, TitleEn, DataSourceID)
	   SELECT
	      g.query('ShortCut').value('.', 'BIGINT'),
	      g.query('FaName').value('.', 'NVARCHAR(50)'),
	      g.query('EnName').value('.', 'NVARCHAR(50)'),
	      g.query('Datasource').value('.', 'BIGINT')
	   FROM @XML.nodes('//GroupHeader')t(g);
 
	   SELECT @GroupHeader = MAX(ID)
	   FROM Report.GroupHeader, @XML.nodes('//GroupHeader')t(g)
	   WHERE Shortcut = g.query('ShortCut').value('.', 'BIGINT')
	     AND TitleFa  = g.query('FaName').value('.', 'NVARCHAR(50)')
	     AND TitleEn  = g.query('EnName').value('.', 'NVARCHAR(50)')
	     AND DataSourceID = g.query('Datasource').value('.', 'BIGINT');
	   
	   INSERT INTO Report.Role_GroupHeader (RoleID, GroupHeaderID)
	   SELECT 
	      gr.query('.').value('.', 'BIGINT'),
	      @GroupHeader
	   FROM @XML.nodes('//Roles/Role')t(gr);
	END	
	ELSE IF ( @RequestType = 'Update' )
	BEGIN
	   SELECT @GroupHeader = @XML.query('//GroupHeader').value('.', 'BIGINT');
	   UPDATE Report.GroupHeader
	   SET Shortcut = ISNULL(@XML.query('//ShortCut').value('.', 'BIGINT'), Shortcut),
	       TitleFa  = ISNULL(@XML.query('//FaName').value('.', 'NVARCHAR(50)'), TitleFa),
	       TitleEn  = ISNULL(@XML.query('//EnName').value('.', 'NVARCHAR(50)'), TitleEn),
	       DataSourceID = ISNULL(@XML.query('//Datasource').value('.', 'BIGINT'), DataSourceID)
	   WHERE ID = @GroupHeader;
	   
	   UPDATE Report.Role_GroupHeader
	   SET IsActive = 0,
	       IsVisible = @XML.query('//Roles').value('(//Roles/@RemoveType)[1]','BIT')
	   WHERE GroupHeaderID = @GroupHeader
	     AND NOT EXISTS (SELECT * FROM @XML.nodes('//Role')t(r) WHERE RoleID = r.query('.').value('.', 'BIGINT'));
	   
	   MERGE Report.Role_GroupHeader RGT
	   USING (SELECT r.value('.', 'BIGINT') as [RoleID]
	            FROM @XML.nodes('//Role')t(r)) RGS
	   ON (RGT.RoleID = RGS.RoleID AND RGT.GroupHeaderID = @GroupHeader)
	   WHEN MATCHED THEN
	      UPDATE SET IsActive = 1
	   WHEN NOT MATCHED THEN
	      INSERT (RoleID, GroupHeaderID)
	      VALUES (RGS.RoleID, @GroupHeader);
	END
	ELSE IF ( @RequestType = 'Delete' )
	BEGIN
	   UPDATE Report.Role_GroupHeader
	   SET IsVisible = 0,
	       IsActive = 0
	   WHERE RoleID = @XML.query('//Role').value('.', 'BIGINT')
	   AND EXISTS(SELECT * FROM @XML.nodes('//GroupHeaders/GroupHeader')t(g) WHERE GroupHeaderID = g.value('.', 'BIGINT'));
	END
	ELSE IF ( @RequestType = 'UnDelete' )
	BEGIN
	   UPDATE Report.Role_GroupHeader
	   SET IsVisible = 1,
	       IsActive = 1
	   WHERE RoleID = @XML.query('//Role').value('.', 'BIGINT')
	   AND EXISTS(SELECT * FROM @XML.nodes('//GroupHeaders/GroupHeader')t(g) WHERE GroupHeaderID = g.value('.', 'BIGINT'));
	END
	ELSE IF ( @RequestType = 'Active' )
	BEGIN
	   UPDATE Report.Role_GroupHeader
	   SET IsActive = 1,
	       IsVisible = 1
	   WHERE RoleID = @XML.query('//Role').value('.', 'BIGINT')
	   AND EXISTS(SELECT * FROM @XML.nodes('//GroupHeaders/GroupHeader')t(g) WHERE GroupHeaderID = g.value('.', 'BIGINT'));
	END
	ELSE IF ( @RequestType = 'Deactive' )
	BEGIN
	   UPDATE Report.Role_GroupHeader
	   SET IsActive = 0
	   WHERE RoleID = @XML.query('//Role').value('.', 'BIGINT')
	   AND EXISTS(SELECT * FROM @XML.nodes('//GroupHeaders/GroupHeader')t(g) WHERE GroupHeaderID = g.value('.', 'BIGINT'));
	END
	ELSE IF(@RequestType = 'Leave')
	BEGIN
	   SELECT @Role        = @XML.query('//Role').value('.', 'BIGINT');
		EXEC SP_XML_PREPAREDOCUMENT @idoc OUTPUT, @XML;
	   MERGE Report.Role_GroupHeader RGT
	   USING(
	      SELECT
	         GroupHeaderID,
	         RoleID
	      FROM OPENXML(@idoc, '//GroupHeader', 2)
	      WITH
	      (
	         GroupHeaderID BIGINT '.',
	         RoleID     BIGINT '../Role'
	      ) 
	   ) RGS
	   ON (RGT.RoleID = RGS.RoleID AND RGT.GroupHeaderID = RGS.GroupHeaderID)
	   WHEN MATCHED THEN
	      UPDATE SET IsActive = 0, IsVisible = 0;
	   EXEC SP_XML_REMOVEDOCUMENT @idoc;
	END;
	ELSE IF(@RequestType = 'Join')
	BEGIN
	   SELECT @Role        = @XML.query('//Role').value('.', 'BIGINT');
		EXEC SP_XML_PREPAREDOCUMENT @idoc OUTPUT, @XML;
	   MERGE Report.Role_GroupHeader RGT
	   USING(
	      SELECT
	         GroupHeaderID,
	         RoleID
	      FROM OPENXML(@idoc, '//GroupHeader', 2)
	      WITH
	      (
	         GroupHeaderID BIGINT '.',
	         RoleID     BIGINT '../Role'
	      ) 
	   ) RGS
	   ON (RGT.RoleID = RGS.RoleID AND RGT.GroupHeaderID = RGS.GroupHeaderID)
	   WHEN MATCHED THEN
	      UPDATE SET IsActive = 1, IsVisible = 1
	   WHEN NOT MATCHED THEN
	      INSERT (RoleID, GroupHeaderID)
	      VALUES (RGS.RoleID, RGS.GroupHeaderID);	   
	   EXEC SP_XML_REMOVEDOCUMENT @idoc;
	END;
END
GO
