SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [ServiceDef].[GetGroupHeadersOfRoles]
	-- Add the parameters for the stored procedure here
	@Xml Xml
AS
BEGIN
   Declare @Distinct Bit;

   Select @Distinct = IsNull(@Xml.query('/GH/Distinct').value('.','bit'), 0);

   IF(@Distinct = 0)
	   Select RoleFaName, RoleID, GHFaName, GHEnName, GHID, RGActive , GHActive
	   From ServiceDef.ARGH ARGH Inner Join @Xml.nodes('/GH/RoleID') g(h) on (ARGH.RoleID = g.h.query('.').value('.','bigint'))
	   Order By GHFaName;
   Else 
      Select Distinct GHID, GHFaName
      From ServiceDef.RGH
      Where Exists(Select * From @Xml.nodes('/GH/RoleID')r(id) Where RoleID = id.query('.').value('.', 'bigint'));


   SELECT
	 'SUCCESSFUL' AS RESULT
	,'0S' AS TIMERUN
	,'GroupHeader' AS TABLESNAME
	,'Mojtama' As TableSpaceName
	,'false' AS [HasRelation];

Return 0;

END;
GO
