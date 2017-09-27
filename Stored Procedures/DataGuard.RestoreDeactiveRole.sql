SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [DataGuard].[RestoreDeactiveRole]
	-- Add the parameters for the stored procedure here
	@Xml Xml
AS
BEGIN
	Update DataGuard.Role
	Set IsActive = 1
	Where IsVisible = 1 And
	exists (select * from @xml.nodes('/Role') r(c) where r.c.query('RoleID').value('.', 'bigint') = ID)
END
GO
