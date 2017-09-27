SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
Create PROCEDURE [DataGuard].[ActiveUsersFromRole]
	-- Add the parameters for the stored procedure here
	@Xml Xml
AS
BEGIN
	Update DataGuard.ARU
	Set RUActive = 1
	Where RUVisible = 1 And
	exists (select * from @xml.nodes('/Active') r(c) where r.c.query('RoleID').value('.', 'bigint') = RoleID and r.c.query('UserID').value('.', 'bigint') = UserID)
END
GO
