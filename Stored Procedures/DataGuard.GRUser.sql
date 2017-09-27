SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
create PROCEDURE [DataGuard].[GRUser]
	-- Add the parameters for the stored procedure here
	@X XML
AS
BEGIN
	DECLARE @Bpid BIGINT,
	        @Userid BIGINT,
	        @SubSys INT,
	        @ActionType VARCHAR(3);
	
	SELECT @Bpid = @x.query('.').value('(BoxPrivilege/@bpid)[1]', 'BIGINT'),
	       @Userid = @x.query('.').value('(BoxPrivilege/@userid)[1]', 'BIGINT'),
	       @SubSys = @x.query('.').value('(BoxPrivilege/@subsys)[1]', 'BIGINT'),
	       @ActionType = @x.query('.').value('(BoxPrivilege/@actiontype)[1]', 'VARCHAR(3)');
	
	DECLARE @XP XML;

	IF @ActionType = '001' -- Grant
	BEGIN
	   IF @SubSys = 0
	      SELECT @XP = (	   
	         SELECT @Userid AS 'UserID',
	                @SubSys AS 'SubSys',
	                @Bpid AS 'Bpid',
	                (
	                  SELECT p.ID AS 'PrivilegeID',
	                         'DataGuard' AS 'SchemaEnName'
	                    FROM DataGuard.Privilege p
	                   WHERE p.BOXP_BPID = @Bpid
	                     FOR XML PATH('Privilege'), TYPE
	               )
	            FOR XML PATH('Grant')
	     );
	   ELSE IF @SubSys = 1
	      SELECT @XP = (	   
	         SELECT @Userid AS 'UserID',
	                @SubSys AS 'SubSys',
	                @Bpid AS 'Bpid',
	                (
	                  SELECT p.ID AS 'PrivilegeID',
	                         'ServiceDef' AS 'SchemaEnName'
	                    FROM ServiceDef.Privilege p
	                   WHERE p.BOXP_BPID = @Bpid
	                     FOR XML PATH('Privilege'), TYPE
	               )
	            FOR XML PATH('Grant')
	     );
	   ELSE IF @SubSys = 2
	      SELECT @XP = (	   
	         SELECT @Userid AS 'UserID',
	                @SubSys AS 'SubSys',
	                @Bpid AS 'Bpid',
	                (
	                  SELECT p.ID AS 'PrivilegeID',
	                         'Report' AS 'SchemaEnName'
	                    FROM Report.Privilege p
	                   WHERE p.BOXP_BPID = @Bpid
	                     FOR XML PATH('Privilege'), TYPE
	               )
	            FOR XML PATH('Grant')
	     );
      ELSE IF @SubSys = 5
	      SELECT @XP = (	   
	         SELECT @Userid AS 'UserID',
	                @SubSys AS 'SubSys',
	                @Bpid AS 'Bpid',
	                (
	                  SELECT p.ID AS 'PrivilegeID',
	                         'Scsc' AS 'SchemaEnName'
	                    FROM Scsc.Privilege p
	                   WHERE p.BOXP_BPID = @Bpid
	                     FOR XML PATH('Privilege'), TYPE
	               )
	            FOR XML PATH('Grant')
	     );
	   ELSE IF @SubSys = 6
	      SELECT @XP = (	   
	         SELECT @Userid AS 'UserID',
	                @SubSys AS 'SubSys',
	                @Bpid AS 'Bpid',
	                (
	                  SELECT p.ID AS 'PrivilegeID',
	                         'Sas' AS 'SchemaEnName'
	                    FROM Sas.Privilege p
	                   WHERE p.BOXP_BPID = @Bpid
	                     FOR XML PATH('Privilege'), TYPE
	               )
	            FOR XML PATH('Grant')
	     );  
	   ELSE IF @SubSys = 7
	      SELECT @XP = (	   
	         SELECT @Userid AS 'UserID',
	                @SubSys AS 'SubSys',
	                @Bpid AS 'Bpid',
	                (
	                  SELECT p.ID AS 'PrivilegeID',
	                         'Msgb' AS 'SchemaEnName'
	                    FROM Msgb.Privilege p
	                   WHERE p.BOXP_BPID = @Bpid
	                     FOR XML PATH('Privilege'), TYPE
	               )
	            FOR XML PATH('Grant')
	     );
	   ELSE IF @SubSys = 10
	      SELECT @XP = (	   
	         SELECT @Userid AS 'UserID',
	                @SubSys AS 'SubSys',
	                @Bpid AS 'Bpid',
	                (
	                  SELECT p.ID AS 'PrivilegeID',
	                         'ISP' AS 'SchemaEnName'
	                    FROM ISP.Privilege p
	                   WHERE p.BOXP_BPID = @Bpid
	                     FOR XML PATH('Privilege'), TYPE
	               )
	            FOR XML PATH('Grant')
	     );
	   ELSE IF @SubSys = 11
	      SELECT @XP = (	   
	         SELECT @Userid AS 'UserID',
	                @SubSys AS 'SubSys',
	                @Bpid AS 'Bpid',
	                (
	                  SELECT p.ID AS 'PrivilegeID',
	                         'CRM' AS 'SchemaEnName'
	                    FROM CRM.Privilege p
	                   WHERE p.BOXP_BPID = @Bpid
	                     FOR XML PATH('Privilege'), TYPE
	               )
	            FOR XML PATH('Grant')
	     );
	   ELSE IF @SubSys = 12
	      SELECT @XP = (	   
	         SELECT @Userid AS 'UserID',
	                @SubSys AS 'SubSys',
	                @Bpid AS 'Bpid',
	                (
	                  SELECT p.ID AS 'PrivilegeID',
	                         'RoboTech' AS 'SchemaEnName'
	                    FROM RoboTech.Privilege p
	                   WHERE p.BOXP_BPID = @Bpid
	                     FOR XML PATH('Privilege'), TYPE
	               )
	            FOR XML PATH('Grant')
	     );
	   EXEC Global.GrantPrivilegesToUser @Xml = @XP -- xml	   	   
	END
	ELSE IF @ActionType = '002' -- Revoke
	BEGIN
	   IF @SubSys = 0
	      SELECT @XP = (	   
	         SELECT @Userid AS 'UserID',
	                @SubSys AS 'SubSys',
	                @Bpid AS 'Bpid',
	                (
	                  SELECT p.ID AS 'PrivilegeID',
	                         'DataGuard' AS 'SchemaEnName'
	                    FROM DataGuard.Privilege p
	                   WHERE p.BOXP_BPID = @Bpid
	                     FOR XML PATH('Privilege'), TYPE
	               )
	            FOR XML PATH('Revoke')
	     );
	   ELSE IF @SubSys = 1
	      SELECT @XP = (	   
	         SELECT @Userid AS 'UserID',
	                @SubSys AS 'SubSys',
	                @Bpid AS 'Bpid',
	                (
	                  SELECT p.ID AS 'PrivilegeID',
	                         'ServiceDef' AS 'SchemaEnName'
	                    FROM ServiceDef.Privilege p
	                   WHERE p.BOXP_BPID = @Bpid
	                     FOR XML PATH('Privilege'), TYPE
	               )
	            FOR XML PATH('Revoke')
	     );
	   ELSE IF @SubSys = 2
	      SELECT @XP = (	   
	         SELECT @Userid AS 'UserID',
	                @SubSys AS 'SubSys',
	                @Bpid AS 'Bpid',
	                (
	                  SELECT p.ID AS 'PrivilegeID',
	                         'Report' AS 'SchemaEnName'
	                    FROM Report.Privilege p
	                   WHERE p.BOXP_BPID = @Bpid
	                     FOR XML PATH('Privilege'), TYPE
	               )
	            FOR XML PATH('Revoke')
	     );
      ELSE IF @SubSys = 5
	      SELECT @XP = (	   
	         SELECT @Userid AS 'UserID',
	                @SubSys AS 'SubSys',
	                @Bpid AS 'Bpid',
	                (
	                  SELECT p.ID AS 'PrivilegeID',
	                         'Scsc' AS 'SchemaEnName'
	                    FROM Scsc.Privilege p
	                   WHERE p.BOXP_BPID = @Bpid
	                     FOR XML PATH('Privilege'), TYPE
	               )
	            FOR XML PATH('Revoke')
	     );
	   ELSE IF @SubSys = 6
	      SELECT @XP = (	   
	         SELECT @Userid AS 'UserID',
	                @SubSys AS 'SubSys',
	                @Bpid AS 'Bpid',
	                (
	                  SELECT p.ID AS 'PrivilegeID',
	                         'Sas' AS 'SchemaEnName'
	                    FROM Sas.Privilege p
	                   WHERE p.BOXP_BPID = @Bpid
	                     FOR XML PATH('Privilege'), TYPE
	               )
	            FOR XML PATH('Revoke')
	     );  
	   ELSE IF @SubSys = 7
	      SELECT @XP = (	   
	         SELECT @Userid AS 'UserID',
	                @SubSys AS 'SubSys',
	                @Bpid AS 'Bpid',
	                (
	                  SELECT p.ID AS 'PrivilegeID',
	                         'Msgb' AS 'SchemaEnName'
	                    FROM Msgb.Privilege p
	                   WHERE p.BOXP_BPID = @Bpid
	                     FOR XML PATH('Privilege'), TYPE
	               )
	            FOR XML PATH('Revoke')
	     );
	   ELSE IF @SubSys = 10
	      SELECT @XP = (	   
	         SELECT @Userid AS 'UserID',
	                @SubSys AS 'SubSys',
	                @Bpid AS 'Bpid',
	                (
	                  SELECT p.ID AS 'PrivilegeID',
	                         'ISP' AS 'SchemaEnName'
	                    FROM ISP.Privilege p
	                   WHERE p.BOXP_BPID = @Bpid
	                     FOR XML PATH('Privilege'), TYPE
	               )
	            FOR XML PATH('Revoke')
	     );
	   ELSE IF @SubSys = 11
	      SELECT @XP = (	   
	         SELECT @Userid AS 'UserID',
	                @SubSys AS 'SubSys',
	                @Bpid AS 'Bpid',
	                (
	                  SELECT p.ID AS 'PrivilegeID',
	                         'CRM' AS 'SchemaEnName'
	                    FROM CRM.Privilege p
	                   WHERE p.BOXP_BPID = @Bpid
	                     FOR XML PATH('Privilege'), TYPE
	               )
	            FOR XML PATH('Revoke')
	     );
	   ELSE IF @SubSys = 12
	      SELECT @XP = (	   
	         SELECT @Userid AS 'UserID',
	                @SubSys AS 'SubSys',
	                @Bpid AS 'Bpid',
	                (
	                  SELECT p.ID AS 'PrivilegeID',
	                         'RoboTech' AS 'SchemaEnName'
	                    FROM RoboTech.Privilege p
	                   WHERE p.BOXP_BPID = @Bpid
	                     FOR XML PATH('Privilege'), TYPE
	               )
	            FOR XML PATH('Revoke')
	     );
	   EXEC Global.RevokePrivilegesFromUser @Xml = @XP -- xml
	END	
END
GO
