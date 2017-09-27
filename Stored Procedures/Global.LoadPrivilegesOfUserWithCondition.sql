SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [Global].[LoadPrivilegesOfUserWithCondition]
	-- Add the parameters for the stored procedure here
	@Xml Xml	
AS
BEGIN
   Declare @UserID Bigint, @UPActive bit;
	Select
	   @UserID = r.id.query('UserID').value('.','bigint'),
	   @UPActive = r.id.query('UPActive').value('.','bit')
	From @Xml.nodes('/')r(id);
	
	/* DataGuard */
	Select AUP.PrivilegeID, CAST(AUP.Shortcut as nvarchar(3)) + '- ' + AUP.PrivilegeFaName as [TitleFa], AUP.UPActive as [IsActive] , Sub_Sys, 'DataGuard' As [SchemaEnName], N'دسترسی های امنیتی' as [SchemaFaName]
	From DataGuard.AUP AUP 
	Where AUP.UserID = @UserID And AUP.UPActive = @UPActive
	
	/* ServiceDef */
	Union All
	Select AUP.PrivilegeID, CAST(AUP.ShortCut as nvarchar(3)) + '- ' + AUP.PrivilegeFaName as [TitleFa], AUP.UPActive as [IsActive] , Sub_Sys, 'ServiceDef' As [SchemaEnName], N'تعریف خدمات سیستم' as [SchemaFaName]
	From ServiceDef.AUP AUP 
	Where AUP.UserID = @UserID And AUP.UPActive = @UPActive
	
	/* Report */
	Union All
	Select AUP.PrivilegeID, CAST(AUP.ShortCut as nvarchar(3)) + '- ' + AUP.PrivilegeFaName as [TitleFa], AUP.UPActive as [IsActive] , Sub_Sys, 'Report' As [SchemaEnName], N'دسترسی های آمار و گزارشات' as [SchemaFaName]
	From Report.AUP AUP 
	Where AUP.UserID = @UserID And AUP.UPActive = @UPActive
	
	/* Gas */
	UNION ALL
	SELECT AUP.PrivilegeID, CAST(AUP.ShortCut as nvarchar(3)) + '- ' + AUP.PrivilegeFaName as [TitleFa], AUP.UPActive as [IsActive] , Sub_Sys, 'Gas' As [SchemaEnName], N'چاپ قبض شرکت گاز' as [SchemaFaName]
	From Gas.AUP AUP 
	Where AUP.UserID = @UserID And AUP.UPActive = @UPActive
	
	/* Global */
	UNION ALL
	SELECT AUP.PrivilegeID, CAST(AUP.ShortCut as nvarchar(3)) + '- ' + AUP.PrivilegeFaName as [TitleFa], AUP.UPActive as [IsActive] , Sub_Sys, 'Global' As [SchemaEnName], N'تنظیمات سیستمی' as [SchemaFaName]
	From [Global].AUP AUP 
	Where AUP.UserID = @UserID And AUP.UPActive = @UPActive
	
	/* Scsc */
	UNION ALL
	SELECT AUP.PrivilegeID, CAST(AUP.ShortCut as nvarchar(3)) + '- ' + AUP.PrivilegeFaName as [TitleFa], AUP.UPActive as [IsActive] , Sub_Sys, 'Scsc' As [SchemaEnName], N'تنظیمات سیستم مدیریت باشگاه ها' as [SchemaFaName]
	From [Scsc].AUP AUP 
	Where AUP.UserID = @UserID And AUP.UPActive = @UPActive
	
	/* Sas */
	/*UNION ALL
	SELECT AUP.PrivilegeID, CAST(AUP.ShortCut as nvarchar(3)) + '- ' + AUP.PrivilegeFaName as [TitleFa], AUP.UPActive as [IsActive] , Sub_Sys, 'Scsc' As [SchemaEnName], N'تنظیمات سیستم مدیریت باشگاه ها' as [SchemaFaName]
	From [Sas].AUP AUP 
	Where AUP.UserID = @UserID And AUP.UPActive = @UPActive*/
	
	/* Msgb */
	UNION ALL
	SELECT AUP.PrivilegeID, CAST(AUP.ShortCut as nvarchar(3)) + '- ' + AUP.PrivilegeFaName as [TitleFa], AUP.UPActive as [IsActive] , Sub_Sys, 'Msgb' As [SchemaEnName], N'سیستم ارسال پیام و اطلاع رسانی' as [SchemaFaName]
	From [Msgb].AUP AUP 
	Where AUP.UserID = @UserID And AUP.UPActive = @UPActive
	
	/* ISP */
	UNION ALL
	SELECT AUP.PrivilegeID, CAST(AUP.ShortCut as nvarchar(3)) + '- ' + AUP.PrivilegeFaName as [TitleFa], AUP.UPActive as [IsActive] , Sub_Sys, 'ISP' As [SchemaEnName], N'سیستم مدیریت باشگاه مشتریان اینترنت' as [SchemaFaName]
	From [ISP].AUP AUP 
	Where AUP.UserID = @UserID And AUP.UPActive = @UPActive

	/* CRM */
	UNION ALL
	SELECT AUP.PrivilegeID, CAST(AUP.ShortCut as nvarchar(3)) + '- ' + AUP.PrivilegeFaName as [TitleFa], AUP.UPActive as [IsActive] , Sub_Sys, 'CRM' As [SchemaEnName], N'سیستم مدیریت ارتباط با مشتریان' as [SchemaFaName]
	From [CRM].AUP AUP 
	Where AUP.UserID = @UserID And AUP.UPActive = @UPActive
   
   /* RoboTech */
	UNION ALL
	SELECT AUP.PrivilegeID, CAST(AUP.ShortCut as nvarchar(3)) + '- ' + AUP.PrivilegeFaName as [TitleFa], AUP.UPActive as [IsActive] , Sub_Sys, 'RoboTech' As [SchemaEnName], N'نرم افزار مدیریت شبکه های اجتماعی' as [SchemaFaName]
	From [RoboTech].AUP AUP 
	Where AUP.UserID = @UserID And AUP.UPActive = @UPActive

	
	/* Order Output Result */
	Order by Sub_Sys, AUP.PrivilegeID;
	
	SELECT
	 'SUCCESSFUL' AS RESULT
	,'0S' AS TIMERUN
	,'Privileges' AS TABLESNAME
	,'Mojtama' As TableSpaceName
	,'false' AS [HasRelation];
END
GO
