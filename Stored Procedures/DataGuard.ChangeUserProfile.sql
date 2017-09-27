SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [DataGuard].[ChangeUserProfile]
	-- Add the parameters for the stored procedure here
	@Xml Xml
AS
BEGIN
	Declare @TitleFa NVarchar(Max), @Password NVarchar(Max);
	Declare @UserId bigint;
	Declare @IsLock Bit;
	
	Select 
	   @TitleFa = u.d.query('TitleFa').value('.', 'nvarchar(max)'),
	   @Password = u.d.query('Password').value('.', 'nvarchar(max)'),
	   @UserId = u.d.query('ID').value('.', 'bigint'),
	   @IsLock = u.d.query('IsLock').value('.','bit')
	From @Xml.nodes('/User') u(d);
	
	Update DataGuard.[User]
	Set TitleFa = @TitleFa,
	    Password = @Password,
	    IsLock = @IsLock
	Where ID = @UserId;
END
GO
