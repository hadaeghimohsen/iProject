SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [DataGuard].[LoadPrivilegeRole]
	-- Add the parameters for the stored procedure here
	@Xml Xml	
AS
BEGIN
	
	Select ARP.PrivilegeID, ARP.PrivilegeFaName as [TitleFa], ARP.RPActive as [IsActive] 
	From DataGuard.ARP ARP inner join @Xml.nodes('/') [r](id) on (ARP.RoleID = [r].id.query('RoleID').value('.', 'bigint'))
	Order by ARP.PrivilegeFaName;
	
	SELECT
	 'SUCCESSFUL' AS RESULT
	,'0S' AS TIMERUN
	,'Privileges' AS TABLESNAME
	,'Mojtama' As TableSpaceName
	,'false' AS [HasRelation];
END
GO
