SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [DataGuard].[ChangeRoleName]
	-- Add the parameters for the stored procedure here
	@Xml Xml
AS
BEGIN
   
   Declare @RoleID bigint;
   Declare @NewRoleName nvarchar(max);
   Declare @STitleFa nvarchar(max);
   
   Select
      @RoleID = r.c.query('RoleID').value('.', 'bigint'),
      @NewRoleName = r.c.query('RoleName').value('.', 'nvarchar(max)'),
      @STitleFa = r.c.query('STitleFa').value('.', 'nvarchar(max)')
   From @Xml.nodes('/Role') r(c);

	Update DataGuard.Role
	Set TitleFa = @NewRoleName, STitleFa = @STitleFa	
	Where ID = @RoleID;
END
GO
