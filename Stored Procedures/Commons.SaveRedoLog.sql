SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [Commons].[SaveRedoLog]
	-- Add the parameters for the stored procedure here
	@Xml Xml
AS
BEGIN	
	--Insert into dbo.[Log] ([UserID], [UserName],[PrgGroupID], [SectionID], [Explain])
	--Select 
	--	(Select ID From DataGuard.[User] Where TitleEn = [logs].[event].query('UserName').value('.', 'nvarchar(max)')),
	--	[logs].[event].query('UserName').value('.', 'nvarchar(max)'),
	--	(Select ID from PrgGroup Where ShortCut = [logs].[event].query('PrgGroupShortCut').value('.', 'bigint')),
	--	[logs].[event].query('SectionID').value('.', 'bigint'),
	--	[logs].[event].query('Explain').value('.', 'nvarchar(max)')
	--From @Xml.nodes('/RedoLog') [logs]([event]);
	Select 'Nolog'
END;
GO
