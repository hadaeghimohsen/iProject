SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		Aref
-- Create date: 2/9/2014
-- Description:	
-- =============================================
CREATE PROCEDURE [ServiceDef].[UpdateServiceOrGrpSrv]
	@Xml Xml
AS
BEGIN
   Declare @ServiceID Bigint;
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
	   @ServiceID = data.query('ServiceID').value('.', 'bigint'),
		--@ParentID = data.query('ParentID').value('.', 'bigint'),
		@Level = data.query('Level').value('.', 'smallint'),
		@ShortCut =	data.query('Shortcut').value('.', 'bigint'),
		@TitleFa = data.query('TitleFa').value('.', 'nvarchar(max)'),
		@TitleEn = data.query('TitleEn').value('.', 'nvarchar(max)'),
		@ServiceType = data.query('ServiceType').value('.', 'bigint'),
		@ServiceUnit = data.query('ServiceUnit').value('.', 'bigint'),
		@PriceType = data.query('Price').value('(Price/@Type)[1]', 'Bit'),
		@Price = data.query('Price').value('.','bigint')
	From @Xml.nodes('/Update') t(data);
	
	Update ServiceDef.Service
	Set 
	   --ParentID = @ParentID,
	   Level = @Level,
	   ShortCut = @ShortCut,
	   TitleFa = @TitleFa,
	   TitleEn = @TitleEn,
	   ServiceTypeID = @ServiceType,
	   ServiceUnitID = @ServiceUnit,
	   PriceType = @PriceType,
	   Price = @Price	
	Where ID = @ServiceID;
	
	Update ServiceDef.Service_GroupHeader
	Set IsVisible = 0
	Where ServiceID = @ServiceID;
	
	Merge ServiceDef.Service_GroupHeader as Sgt
	Using (Select ghid.query('.').value('.', 'bigint') as GroupHeaderID
	         From @Xml.nodes('/Update/GroupHeader/GhID') t(ghid)) As Sgs
	On (Sgs.GroupHeaderID = Sgt.GroupHeaderID And Sgt.ServiceID = @ServiceID)
	When Matched Then
	   Update Set IsVisible = 1, IsActive = 1
	When Not Matched Then
	   Insert (GroupHeaderID, ServiceID)
	   Values (Sgs.GroupHeaderID, @ServiceID);
	
END
GO
