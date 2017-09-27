SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [ServiceDef].[SaveServiceOrGrpSrv]
	-- Add the parameters for the stored procedure here
	@Xml Xml
AS
BEGIN
	Declare @ParentID Bigint;
	Declare @Level smallint;
	Declare @ShortCut Bigint;
	Declare @TitleFa NVarchar(Max);
	Declare @TitleEn NVarchar(Max);
	Declare @ServiceType Bigint;
	Declare @ServiceUnit Bigint;
	Declare @PriceType Bit;
	Declare @Price Bigint;
		
	Select
		@ParentID = data.query('ParentID').value('.', 'bigint'),
		@Level = data.query('Level').value('.', 'smallint'),
		@ShortCut =	data.query('Shortcut').value('.', 'bigint'),
		@TitleFa = data.query('TitleFa').value('.', 'nvarchar(max)'),
		@TitleEn = data.query('TitleEn').value('.', 'nvarchar(max)'),
		@ServiceType = data.query('ServiceType').value('.', 'bigint'),
		@ServiceUnit = data.query('ServiceUnit').value('.', 'bigint'),
		@PriceType = data.query('Price').value('(Price/@Type)[1]', 'Bit'),
		@Price = data.query('Price').value('.','bigint')
	From @Xml.nodes('/Create') t(data);

	Insert Into ServiceDef.Service (ParentID, [Level],ShortCut, TitleFa, TitleEn, ServiceTypeID, ServiceUnitID, PriceType, Price)
	Values(@ParentID, @Level, @ShortCut, @TitleFa, @TitleEn, @ServiceType, @ServiceUnit, @PriceType, @Price);
	
	Declare @PrimaryKey Bigint;
	
	Select @PrimaryKey = MAX(ID)
	From ServiceDef.[Service];
	
	Insert Into ServiceDef.Service_GroupHeader (ServiceID, GroupHeaderID)
	Select @PrimaryKey, gh.id.query('.').value('.','bigint')
	From @Xml.nodes('/Create/GroupHeader/GhID')gh(id);
END
GO
