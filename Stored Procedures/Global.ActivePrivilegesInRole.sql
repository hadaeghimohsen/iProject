SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [Global].[ActivePrivilegesInRole]
	-- Add the parameters for the stored procedure here
	@Xml Xml
AS
BEGIN
	Declare @RoleID Bigint;
	select 
	   @RoleID = [active].[role].query('RoleID').value('.', 'bigint')
   from @Xml.nodes('/Active') [active]([role]);
	
	/* DataGuard */	
	Update DataGuard.ARP
	Set RPActive = 1
	Where RoleID = @RoleID and
	Exists
	(
	   Select * 
	   From @Xml.nodes('/Active/Privilege/PrivilegeID') [active]([role])
	   Where [active].[role].query('.').value('.', 'bigint') = PrivilegeID
	);	
	
	/* ServiceDef */
	Update ServiceDef.ARP
	Set RPActive = 1
	Where RoleID = @RoleID and
	Exists
	(
	   Select * 
	   From @Xml.nodes('/Active/Privilege/PrivilegeID') [active]([role])
	   Where [active].[role].query('.').value('.', 'bigint') = PrivilegeID
	);	
	
	/* Report */
	Update Report.ARP
	Set RPActive = 1
	Where RoleID = @RoleID and
	Exists
	(
	   Select * 
	   From @Xml.nodes('/Active/Privilege/PrivilegeID') [active]([role])
	   Where [active].[role].query('.').value('.', 'bigint') = PrivilegeID
	);	
	
	/* Gas */
	UPDATE Gas.ARP
	SET RPActive = 1
	WHERE RoleID = @RoleID
	  AND EXISTS(
	   Select * 
	   From @Xml.nodes('/Active/Privilege/PrivilegeID') [active]([role])
	   Where [active].[role].query('.').value('.', 'bigint') = PrivilegeID
	  );
	
	/* Global */
	UPDATE Global.ARP
	SET RPActive = 1
	WHERE RoleID = @RoleID
	  AND EXISTS(
	   Select * 
	   From @Xml.nodes('/Active/Privilege/PrivilegeID') [active]([role])
	   Where [active].[role].query('.').value('.', 'bigint') = PrivilegeID
	  );

	/* Scsc */
	UPDATE Scsc.ARP
	SET RPActive = 1
	WHERE RoleID = @RoleID
	  AND EXISTS(
	   Select * 
	   From @Xml.nodes('/Active/Privilege/PrivilegeID') [active]([role])
	   Where [active].[role].query('.').value('.', 'bigint') = PrivilegeID
	  );

	/* Sas */
	UPDATE Sas.ARP
	SET RPActive = 1
	WHERE RoleID = @RoleID
	  AND EXISTS(
	   Select * 
	   From @Xml.nodes('/Active/Privilege/PrivilegeID') [active]([role])
	   Where [active].[role].query('.').value('.', 'bigint') = PrivilegeID
	  );
	
	/* Msgb */
	UPDATE Msgb.ARP
	SET RPActive = 1
	WHERE RoleID = @RoleID
	  AND EXISTS(
	   Select * 
	   From @Xml.nodes('/Active/Privilege/PrivilegeID') [active]([role])
	   Where [active].[role].query('.').value('.', 'bigint') = PrivilegeID
	  );
	  
	/* ISP */
	UPDATE ISP.ARP
	SET RPActive = 1
	WHERE RoleID = @RoleID
	  AND EXISTS(
	   Select * 
	   From @Xml.nodes('/Active/Privilege/PrivilegeID') [active]([role])
	   Where [active].[role].query('.').value('.', 'bigint') = PrivilegeID
	  );
	
	/* CRM */
	UPDATE CRM.ARP
	SET RPActive = 1
	WHERE RoleID = @RoleID
	  AND EXISTS(
	   Select * 
	   From @Xml.nodes('/Active/Privilege/PrivilegeID') [active]([role])
	   Where [active].[role].query('.').value('.', 'bigint') = PrivilegeID
	  );
	
	/* RoboTech */
	UPDATE RoboTech.ARP
	SET RPActive = 1
	WHERE RoleID = @RoleID
	  AND EXISTS(
	   Select * 
	   From @Xml.nodes('/Active/Privilege/PrivilegeID') [active]([role])
	   Where [active].[role].query('.').value('.', 'bigint') = PrivilegeID
	  );

	  
END
GO
