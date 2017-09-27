SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [DataGuard].[IUDRole]
	-- Add the parameters for the stored procedure here
	@X XML
AS
BEGIN
	DECLARE @Roleid BIGINT
	       ,@RoleName NVARCHAR(max)
	       ,@Active BIT
	       ,@SubSys INT
	       ,@ActionType VARCHAR(3);
	
	SELECT @Roleid = @X.query('.').value('(Role/@id)[1]', 'BIGINT'),
	       @RoleName = @X.query('.').value('(Role/@name)[1]', 'NVARCHAR(MAX)'),
	       @Active = @X.query('.').value('(Role/@active)[1]', 'BIT'),
	       @SubSys = @X.query('.').value('(Role/@subsys)[1]', 'INT'),
	       @ActionType = @X.query('.').value('(Role/@actiontype)[1]', 'VARCHAR(3)');
	
	IF @ActionType = '001' -- Insert
	   INSERT INTO DataGuard.Role
	           ( SUB_SYS ,
	             ID ,
	             TitleFa ,
	             IsDefualt ,
	             IsVisible ,
	             IsActive
	           )
	   VALUES  ( @SubSys , -- SUB_SYS - int
	             dbo.GetNewIdentity() , -- ID - bigint
	             @RoleName , -- TitleFa - nvarchar(max)
	             0 , -- IsDefualt - bit
	             1 , -- IsVisible - bit
	             1  -- IsActive - bit
	           );
	ELSE IF @ActionType = '002' -- Update
	   UPDATE DataGuard.Role
	      SET TitleFa = @RoleName
	         ,IsActive = ISNULL(@Active, 1)
	    WHERE ID = @Roleid
	      AND SUB_SYS = @SubSys;
	ELSE IF @ActionType = '003' -- Delete
	   DELETE DataGuard.Role
	    WHERE ID = @Roleid;
END
GO
