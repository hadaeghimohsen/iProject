SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [Global].[RevokePrivilegesFromUser]
	-- Add the parameters for the stored procedure here
	@Xml Xml
AS
BEGIN
	Declare @UserID Bigint;
	select 
	   @UserID = [grant].[user].query('UserID').value('.', 'bigint')
   from @Xml.nodes('/Revoke') [grant]([user]);	
	
	/* DataGuard */
	Update DataGuard.AUP
	Set UPVisible = 0
	Where UserID = @UserID and
	Exists
	(
	   Select * 
	   From @Xml.nodes('/Revoke//PrivilegeID') [revoke]([user])
	   Where [revoke].[user].query('.').value('.', 'bigint') = PrivilegeID
	);
	
	/* ServiceDef */
	Update ServiceDef.AUP
	Set UPVisible = 0
	Where UserID = @UserID and
	Exists
	(
	   Select * 
	   From @Xml.nodes('/Revoke//PrivilegeID') [revoke]([user])
	   Where [revoke].[user].query('.').value('.', 'bigint') = PrivilegeID
	);
	
	/* Report */
	Update Report.AUP
	Set UPVisible = 0
	Where UserID = @UserID and
	Exists
	(
	   Select * 
	   From @Xml.nodes('/Revoke//PrivilegeID') [revoke]([user])
	   Where [revoke].[user].query('.').value('.', 'bigint') = PrivilegeID
	);
	
	/* Gas */
	UPDATE Gas.AUP
	SET UPVisible = 0
	WHERE USERID = @UserID 
	  AND EXISTS(
	   Select * 
	   From @Xml.nodes('/Revoke//PrivilegeID') [revoke]([user])
	   Where [revoke].[user].query('.').value('.', 'bigint') = PrivilegeID
	  );
	
	/* Global */
	UPDATE Global.AUP
	SET UPVisible = 0
	WHERE USERID = @UserID 
	  AND EXISTS(
	   Select * 
	   From @Xml.nodes('/Revoke//PrivilegeID') [revoke]([user])
	   Where [revoke].[user].query('.').value('.', 'bigint') = PrivilegeID
	  );
	
	/* Scsc */
	UPDATE Scsc.AUP
	SET UPVisible = 0
	WHERE USERID = @UserID 
	  AND EXISTS(
	   Select * 
	   From @Xml.nodes('/Revoke//PrivilegeID') [revoke]([user])
	   Where [revoke].[user].query('.').value('.', 'bigint') = PrivilegeID
	  );
   
   /* Sas */
	/*UPDATE Sas.AUP
	SET UPVisible = 0
	WHERE USERID = @UserID 
	  AND EXISTS(
	   Select * 
	   From @Xml.nodes('/Revoke//PrivilegeID') [revoke]([user])
	   Where [revoke].[user].query('.').value('.', 'bigint') = PrivilegeID
	  );*/
	
	/* Msgb */
	UPDATE Msgb.AUP
	SET UPVisible = 0
	WHERE USERID = @UserID 
	  AND EXISTS(
	   Select * 
	   From @Xml.nodes('/Revoke//PrivilegeID') [revoke]([user])
	   Where [revoke].[user].query('.').value('.', 'bigint') = PrivilegeID
	  );
	
	/* ISP */
	UPDATE ISP.AUP
	SET UPVisible = 0
	WHERE USERID = @UserID 
	  AND EXISTS(
	   Select * 
	   From @Xml.nodes('/Revoke//PrivilegeID') [revoke]([user])
	   Where [revoke].[user].query('.').value('.', 'bigint') = PrivilegeID
	  );

	/* CRM */
	UPDATE CRM.AUP
	SET UPVisible = 0
	WHERE USERID = @UserID 
	  AND EXISTS(
	   Select * 
	   From @Xml.nodes('/Revoke//PrivilegeID') [revoke]([user])
	   Where [revoke].[user].query('.').value('.', 'bigint') = PrivilegeID
	  );
	
	/* RoboTech */
	UPDATE RoboTech.AUP
	SET UPVisible = 0
	WHERE USERID = @UserID 
	  AND EXISTS(
	   Select * 
	   From @Xml.nodes('/Revoke//PrivilegeID') [revoke]([user])
	   Where [revoke].[user].query('.').value('.', 'bigint') = PrivilegeID
	  );

END
GO
