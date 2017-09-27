SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [Global].[DeactivePrivilegesToUser]
	-- Add the parameters for the stored procedure here
	@Xml Xml
AS
BEGIN
	Declare @UserID Bigint;
	select 
	   @UserID = [deactive].[role].query('UserID').value('.', 'bigint')
   from @Xml.nodes('/Deactive') [deactive]([role]);
	
	
	
	/* DataGuard */
	Update DataGuard.AUP
	Set UPActive = 0
	Where UserID = @UserID and
	Exists
	(
	   Select * 
	   From @Xml.nodes('/Deactive//PrivilegeID') [deactive]([p])
	   Where [deactive].[p].query('.').value('.', 'bigint') = PrivilegeID
	);	
	
	/* ServiceDef */
	Update ServiceDef.AUP
	Set UPActive = 0
	Where UserID = @UserID and
	Exists
	(
	   Select * 
	   From @Xml.nodes('/Deactive//PrivilegeID') [deactive]([p])
	   Where [deactive].[p].query('.').value('.', 'bigint') = PrivilegeID
	);	
	
	/* Report */
	Update Report.AUP
	Set UPActive = 0
	Where UserID = @UserID and
	Exists
	(
	   Select * 
	   From @Xml.nodes('/Deactive//PrivilegeID') [deactive]([p])
	   Where [deactive].[p].query('.').value('.', 'bigint') = PrivilegeID
	);	
	
	/* Gas */
	UPDATE Gas.AUP
	SET UPActive = 0
	WHERE USERID = @UserID
	  AND EXISTS(
      Select * 
      From @Xml.nodes('/Deactive//PrivilegeID') [deactive]([p])
      Where [deactive].[p].query('.').value('.', 'bigint') = PrivilegeID
	  );
	
	/* Global */
	UPDATE Global.AUP
	SET UPActive = 0
	WHERE USERID = @UserID
	  AND EXISTS(
      Select * 
      From @Xml.nodes('/Deactive//PrivilegeID') [deactive]([p])
      Where [deactive].[p].query('.').value('.', 'bigint') = PrivilegeID
	  );
	  
	/* Scsc */
	UPDATE Scsc.AUP
	SET UPActive = 0
	WHERE USERID = @UserID
	  AND EXISTS(
      Select * 
      From @Xml.nodes('/Deactive//PrivilegeID') [deactive]([p])
      Where [deactive].[p].query('.').value('.', 'bigint') = PrivilegeID
	  );
	
	/* Sas */
	/*UPDATE Sas.AUP
	SET UPActive = 0
	WHERE USERID = @UserID
	  AND EXISTS(
      Select * 
      From @Xml.nodes('/Deactive//PrivilegeID') [deactive]([p])
      Where [deactive].[p].query('.').value('.', 'bigint') = PrivilegeID
	  );*/
	
	/* Msgb */
	UPDATE Msgb.AUP
	SET UPActive = 0
	WHERE USERID = @UserID
	  AND EXISTS(
      Select * 
      From @Xml.nodes('/Deactive//PrivilegeID') [deactive]([p])
      Where [deactive].[p].query('.').value('.', 'bigint') = PrivilegeID
	  );
	
	/* ISP */
	UPDATE ISP.AUP
	SET UPActive = 0
	WHERE USERID = @UserID
	  AND EXISTS(
      Select * 
      From @Xml.nodes('/Deactive//PrivilegeID') [deactive]([p])
      Where [deactive].[p].query('.').value('.', 'bigint') = PrivilegeID
	  );

	/* CRM */
	UPDATE CRM.AUP
	SET UPActive = 0
	WHERE USERID = @UserID
	  AND EXISTS(
      Select * 
      From @Xml.nodes('/Deactive//PrivilegeID') [deactive]([p])
      Where [deactive].[p].query('.').value('.', 'bigint') = PrivilegeID
	  );
	
	/* RoboTech */
	UPDATE RoboTech.AUP
	SET UPActive = 0
	WHERE USERID = @UserID
	  AND EXISTS(
      Select * 
      From @Xml.nodes('/Deactive//PrivilegeID') [deactive]([p])
      Where [deactive].[p].query('.').value('.', 'bigint') = PrivilegeID
	  );

END
GO
