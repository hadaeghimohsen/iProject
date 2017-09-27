SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [DataGuard].[UpdatePrivilegeToBox]
	@X XML
	/*
	   <PrivilegeToBox bpid="" privilegeid="" subsys=""/>
	*/
AS
BEGIN
	DECLARE @Bpid BIGINT,
	        @Privilegeid BIGINT,
	        @Subsys INT;
	
	SELECT @Bpid = @X.query('.').value('(PrivilegeToBox/@bpid)[1]', 'BIGINT'),
	       @Privilegeid = @X.query('.').value('(PrivilegeToBox/@privilegeid)[1]', 'BIGINT'),
	       @Subsys = @X.query('.').value('(PrivilegeToBox/@subsys)[1]', 'INT');
	
	IF @Bpid = 0
	   SET @Bpid = NULL;
	
	IF @Subsys = 0 
	BEGIN
	   UPDATE DataGuard.Privilege
	      SET BOXP_BPID = @Bpid
	    WHERE ID = @Privilegeid;
	END
	ELSE IF @Subsys = 1
	BEGIN
	   UPDATE ServiceDef.Privilege
	      SET BOXP_BPID = @Bpid
	    WHERE ID = @Privilegeid;
	END
	ELSE IF @Subsys = 2
	BEGIN
	   UPDATE Report.Privilege
	      SET BOXP_BPID = @Bpid
	    WHERE ID = @Privilegeid;
	END
	ELSE IF @Subsys = 3
	BEGIN
	   UPDATE Gas.Privilege
	      SET BOXP_BPID = @Bpid
	    WHERE ID = @Privilegeid;
	END
	ELSE IF @Subsys = 4
	BEGIN
	   UPDATE Global.Privilege
	      SET BOXP_BPID = @Bpid
	    WHERE ID = @Privilegeid;
	END
	ELSE IF @Subsys = 5
	BEGIN
	   UPDATE Scsc.Privilege
	      SET BOXP_BPID = @Bpid
	    WHERE ID = @Privilegeid;
	END
	ELSE IF @Subsys = 6
	BEGIN
	   UPDATE Sas.Privilege
	      SET BOXP_BPID = @Bpid
	    WHERE ID = @Privilegeid;
	END
	ELSE IF @Subsys = 7
	BEGIN
	   UPDATE Msgb.Privilege
	      SET BOXP_BPID = @Bpid
	    WHERE ID = @Privilegeid;
	END
	ELSE IF @Subsys = 10
	BEGIN
	   UPDATE ISP.Privilege
	      SET BOXP_BPID = @Bpid
	    WHERE ID = @Privilegeid;
	END
	ELSE IF @Subsys = 11
	BEGIN
	   UPDATE CRM.Privilege
	      SET BOXP_BPID = @Bpid
	    WHERE ID = @Privilegeid;
	END
	ELSE IF @Subsys = 12
	BEGIN
	   UPDATE RoboTech.Privilege
	      SET BOXP_BPID = @Bpid
	    WHERE ID = @Privilegeid;
	END
END
GO
