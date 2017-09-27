SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [ServiceDef].[ChangeParentOfService]
	@Xml Xml	
AS
BEGIN
	DECLARE @ParentID BIGINT, @ServiceID BIGINT;
	SELECT @ParentID = @Xml.query('/ChangeParent/ParentID').value('.', 'BIGINT'),
	       @ServiceID = @Xml.query('/ChangeParent/ServiceID').value('.', 'BIGINT');
		
	UPDATE ServiceDef.[Service]
	   SET ParentID = @ParentID
	 WHERE ID = @ServiceID;
	
	SELECT 'True';
	
	SELECT
	 'SUCCESSFUL' AS RESULT
	,'0S' AS TIMERUN
	,'Successful' AS TABLESNAME
	,'Mojtama' As TableSpaceName
	,'false' AS [HasRelation];
END
GO
