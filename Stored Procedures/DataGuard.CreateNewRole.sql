SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [DataGuard].[CreateNewRole]
	-- Add the parameters for the stored procedure here
	@Xml Xml
AS
BEGIN
	Insert Into DataGuard.[Role] (TitleFa, TitleEn, STitleFa, SUB_SYS)
	select 
	   [R].[c].query('TitleFa').value('.', 'nvarchar(max)'),
	   [R].[c].query('TitleEn').value('.', 'nvarchar(max)'),
	   [R].[c].query('STitleFa').value('.', 'nvarchar(max)'),
	   [R].[c].query('SubSys').value('.', 'INT')	   
	from @Xml.nodes('/Role') [R](c);
END
GO
