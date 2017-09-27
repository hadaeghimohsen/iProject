SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [Global].[GrantPrivilegesToUser]
	-- Add the parameters for the stored procedure here
	@Xml Xml
AS
BEGIN
	Declare @UserID BIGINT,
	        @SubSys INT,
	        @Bpid BIGINT;	
	select 
	   @UserID = [grant].[role].query('UserID').value('.', 'bigint'),
 	   @SubSys = [grant].[role].query('SubSys').value('.', 'int'),
	   @Bpid   = [grant].[role].query('Bpid').value('.', 'bigint')
   from @Xml.nodes('/Grant') [grant]([role]);

	Declare newprivilege Cursor For
	Select
	   [grant].[privilege].query('PrivilegeID').value('.', 'bigint') as [PrivilegeID],
	   [grant].[privilege].query('SchemaEnName').value('.', 'nvarchar(max)') as [SchemaEnName]
	From @Xml.nodes('/Grant/Privilege') [grant]([privilege]);
	
	Declare @PrivilegeID Bigint, @SchemaEnName Nvarchar(Max);
	
	Open  newprivilege;
	
	NextFetch:	
	Fetch From newprivilege into @PrivilegeID, @SchemaEnName;
	
	IF @@FETCH_STATUS <> 0
		Goto ExitLoop;
   
   -- 1396/02/18 * بخواهیم متوجه شویم که جعبه دسترسی کدام می باشد
	IF @Bpid = 0
	BEGIN
	   SET @Bpid = 
	      Case 
            When @SchemaEnName = 'DataGuard' Then (SELECT BOXP_BPID FROM DataGuard.Privilege WHERE id = @PrivilegeID) 
            When @SchemaEnName = 'ServiceDef' Then (SELECT BOXP_BPID FROM ServiceDef.Privilege WHERE id = @PrivilegeID)  
            When @SchemaEnName = 'Report' Then (SELECT BOXP_BPID FROM Report.Privilege WHERE id = @PrivilegeID) 
            WHEN @SchemaEnName = 'Gas' THEN (SELECT BOXP_BPID FROM Gas.Privilege WHERE id = @PrivilegeID) 
            WHEN @SchemaEnName = 'Global' THEN (SELECT BOXP_BPID FROM Global.Privilege WHERE id = @PrivilegeID) 
            WHEN @SchemaEnName = 'Scsc' THEN (SELECT BOXP_BPID FROM Scsc.Privilege WHERE id = @PrivilegeID) 
            WHEN @SchemaEnName = 'Sas' THEN (SELECT BOXP_BPID FROM Sas.Privilege WHERE id = @PrivilegeID) 
            WHEN @SchemaEnName = 'Msgb' THEN (SELECT BOXP_BPID FROM Msgb.Privilege WHERE id = @PrivilegeID) 
            WHEN @SchemaEnName = 'ISP' THEN (SELECT BOXP_BPID FROM ISP.Privilege WHERE id = @PrivilegeID) 
            WHEN @SchemaEnName = 'CRM' THEN (SELECT BOXP_BPID FROM CRM.Privilege WHERE id = @PrivilegeID) 
            WHEN @SchemaEnName = 'RoboTech' THEN (SELECT BOXP_BPID FROM RoboTech.Privilege WHERE id = @PrivilegeID) 
         End
	END   
   
	IF(Exists(Select * From DataGuard.User_Privilege Where UserID = @UserID And PrivilegeID = @PrivilegeID And IsVisible = 0))	
	Begin
	   Update DataGuard.User_Privilege
	   Set IsVisible = 1, IsActive = 1
	   Where PrivilegeID = @PrivilegeID
	   And UserID = @UserID;
	END
	ELSE IF Exists(Select * From DataGuard.User_Privilege Where UserID = @UserID And PrivilegeID = @PrivilegeID And IsVisible = 1)
	   PRINT 'null';	   
	Else
	Begin
	   Insert Into DataGuard.User_Privilege (UserID, PrivilegeID, BOXP_BPID, Sub_Sys) 
	   Values(@UserID, @PrivilegeID,@Bpid,
	   Case 
	      When @SchemaEnName = 'DataGuard' Then 0 
	      When @SchemaEnName = 'ServiceDef' Then 1 
	      When @SchemaEnName = 'Report' Then 2 
	      WHEN @SchemaEnName = 'Gas' THEN 3
	      WHEN @SchemaEnName = 'Global' THEN 4
         WHEN @SchemaEnName = 'Scsc' THEN 5
         WHEN @SchemaEnName = 'Sas' THEN 6
         WHEN @SchemaEnName = 'Msgb' THEN 7
         WHEN @SchemaEnName = 'ISP' THEN 10
         WHEN @SchemaEnName = 'CRM' THEN 11
         WHEN @SchemaEnName = 'RoboTech' THEN 12
	   End);
	End
	Goto NextFetch;
	
	
	ExitLoop:
	Close newprivilege;
	
	Deallocate newprivilege;
	
END
GO
