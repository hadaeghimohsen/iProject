SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [ServiceDef].[LoadJoinGroupHeadersWithCondition]
(
	@Xml Xml
)
AS
Begin
   Declare @WhatActive Bit;
   Select @WhatActive = @Xml.query('/JGH/WhatActive').value('.','bit');
   
   Select RoleID, RoleFaName, GHID, GHFaName,RGActive 
   From ServiceDef.AllRolesGroupHeaders
   Where RGActive = @WhatActive
   And Exists(Select * From @Xml.nodes('/JGH/Roles/RoleID') t(c)
               Where RoleID = c.query('.').value('.','bigint'));

   SELECT
	 'SUCCESSFUL' AS RESULT
	,'0S' AS TIMERUN
	,'GroupHeader' AS TABLESNAME
	,'Mojtama' As TableSpaceName
	,'false' AS [HasRelation];
RETURN 0;
End;
GO
