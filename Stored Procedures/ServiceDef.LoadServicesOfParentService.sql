SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [ServiceDef].[LoadServicesOfParentService]
	@Xml Xml
AS
BEGIN
	Declare @GrpSrv Bigint;
	Select @GrpSrv = @Xml.query('//GrpSrv').value('.', 'bigint');
	
	if((Select @Xml.exist('//Types')) = 0)
	Begin
		Select 
			[ID]
		  ,[TitleFa]
		  ,[TitleEn] 
		  ,[PriceType]
		  ,(Case PriceType 
			 When 0 Then 0
			 Else Price
			End) as [Price]
		  ,[IsActive]
		From ServiceDef.[Service]
		Where ParentID = @GrpSrv
		And RectCode = 1
		And IsVisible = 1
		And Level = 0
		Order By ID;
	End
	Else
	Begin
		Select 
			[ID]
		  ,Cast(Row_Number() Over(Order by ID) as Varchar(3)) + '- ' + [TitleFa] as [TitleFa]
		  ,[TitleEn] 
		  ,[PriceType]
		  ,(Case PriceType 
			 When 0 Then 0
			 Else Price
			End) as [Price]
		  ,[IsActive]
		From ServiceDef.[Service]
		Where ParentID = @GrpSrv
		And RectCode = 1
		And IsVisible = 1
		And Level = 0
		AND Exists (Select * From @Xml.nodes('//Types/Typeid')t(tid) Where tid.query('.').value('.', 'bigint') = ServiceTypeID)
		Order By ID;
	End
	SELECT
	 'SUCCESSFUL' AS RESULT
	,'0S' AS TIMERUN
	,'Services' AS TABLESNAME
	,'iProject' As TableSpaceName
	,'false' AS [HasRelation];
END
GO
