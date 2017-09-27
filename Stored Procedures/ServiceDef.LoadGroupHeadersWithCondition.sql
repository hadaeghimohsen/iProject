SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [ServiceDef].[LoadGroupHeadersWithCondition]
	-- Add the parameters for the stored procedure here
	@Xml Xml
AS
BEGIN
   Declare @WhatActive Bit;
   Select 
      @WhatActive = @Xml.query('/WhatActive').value('.','bit');
   
	Select ID, TitleFa, IsActive
	From ServiceDef.GroupHeader 
	Where IsActive = @WhatActive;

	SELECT
	 'SUCCESSFUL' AS RESULT
	,'0S' AS TIMERUN
	,'GroupHeader' AS TABLESNAME
	,'Mojtama' As TableSpaceName
	,'false' AS [HasRelation];
END
GO
