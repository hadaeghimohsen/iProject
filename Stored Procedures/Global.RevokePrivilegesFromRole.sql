SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [Global].[RevokePrivilegesFromRole]
	-- Add the parameters for the stored procedure here
	@Xml Xml
AS
BEGIN
	Declare @RoleID Bigint;
	select 
	   @RoleID = [grant].[role].query('RoleID').value('.', 'bigint')
   from @Xml.nodes('/Revoke') [grant]([role]);	
	
	/* DataGuard */
	Update DataGuard.ARP
	Set RPVisible = 0
	Where RoleID = @RoleID and
	Exists
	(
	   Select * 
	   From @Xml.nodes('/Revoke//PrivilegeID') [revoke]([role])
	   Where [revoke].[role].query('.').value('.', 'bigint') = PrivilegeID
	);
	
	/* ServiceDef */
	Update ServiceDef.ARP
	Set RPVisible = 0
	Where RoleID = @RoleID and
	Exists
	(
	   Select * 
	   From @Xml.nodes('/Revoke//PrivilegeID') [revoke]([role])
	   Where [revoke].[role].query('.').value('.', 'bigint') = PrivilegeID
	);
	
	/* Report */
	Update Report.ARP
	Set RPVisible = 0
	Where RoleID = @RoleID and
	Exists
	(
	   Select * 
	   From @Xml.nodes('/Revoke//PrivilegeID') [revoke]([role])
	   Where [revoke].[role].query('.').value('.', 'bigint') = PrivilegeID
	);
	
	/* Gas */
	UPDATE Gas.ARP
	SET RPVisible = 0
	WHERE RoleID = @RoleID
	  AND EXISTS(
	   Select * 
	   From @Xml.nodes('/Revoke//PrivilegeID') [revoke]([role])
	   Where [revoke].[role].query('.').value('.', 'bigint') = PrivilegeID
	  );
	
	/* Global */
	UPDATE Global.ARP
	SET RPVisible = 0
	WHERE RoleID = @RoleID
	  AND EXISTS(
	   Select * 
	   From @Xml.nodes('/Revoke//PrivilegeID') [revoke]([role])
	   Where [revoke].[role].query('.').value('.', 'bigint') = PrivilegeID
	  );
	  
	/* Scsc */
	UPDATE Scsc.ARP
	SET RPVisible = 0
	WHERE RoleID = @RoleID
	  AND EXISTS(
	   Select * 
	   From @Xml.nodes('/Revoke//PrivilegeID') [revoke]([role])
	   Where [revoke].[role].query('.').value('.', 'bigint') = PrivilegeID
	  );
	
	/* Sas */
	UPDATE Sas.ARP
	SET RPVisible = 0
	WHERE RoleID = @RoleID
	  AND EXISTS(
	   Select * 
	   From @Xml.nodes('/Revoke//PrivilegeID') [revoke]([role])
	   Where [revoke].[role].query('.').value('.', 'bigint') = PrivilegeID
	  );
	
	/* Msgb */
	UPDATE Msgb.ARP
	SET RPVisible = 0
	WHERE RoleID = @RoleID
	  AND EXISTS(
	   Select * 
	   From @Xml.nodes('/Revoke//PrivilegeID') [revoke]([role])
	   Where [revoke].[role].query('.').value('.', 'bigint') = PrivilegeID
	  );
	
	/* ISP */
	UPDATE ISP.ARP
	SET RPVisible = 0
	WHERE RoleID = @RoleID
	  AND EXISTS(
	   Select * 
	   From @Xml.nodes('/Revoke//PrivilegeID') [revoke]([role])
	   Where [revoke].[role].query('.').value('.', 'bigint') = PrivilegeID
	  );

	/* CRM */
	UPDATE CRM.ARP
	SET RPVisible = 0
	WHERE RoleID = @RoleID
	  AND EXISTS(
	   Select * 
	   From @Xml.nodes('/Revoke//PrivilegeID') [revoke]([role])
	   Where [revoke].[role].query('.').value('.', 'bigint') = PrivilegeID
	  );
	
	/* RoboTech */
	UPDATE RoboTech.ARP
	SET RPVisible = 0
	WHERE RoleID = @RoleID
	  AND EXISTS(
	   Select * 
	   From @Xml.nodes('/Revoke//PrivilegeID') [revoke]([role])
	   Where [revoke].[role].query('.').value('.', 'bigint') = PrivilegeID
	  );

END
GO
