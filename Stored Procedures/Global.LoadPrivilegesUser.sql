SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [Global].[LoadPrivilegesUser]
	-- Add the parameters for the stored procedure here
	@Xml Xml	
AS
BEGIN	
   Declare @UserID Bigint;
   Select
      @UserID = u.id.query('UserID').value('.','bigint')
   From @Xml.nodes('/') u(id);
   
   /* DataGuard Privileges */
	Select AUP.PrivilegeID, CAST(AUP.ShortCut as Nvarchar(max)) + '- ' + AUP.PrivilegeFaName as [TitleFa], AUP.UPActive as [IsActive] , AUP.Sub_Sys, 'DataGuard' as [SchemaEnName], N'دسترسی های امنیتی' As [SchemaFaName]
	From DataGuard.AUP AUP Where AUP.UserID = @UserID
	
	/* ServiceDef Privileges */
	Union All
	Select AUP.PrivilegeID, CAST(AUP.ShortCut as Nvarchar(max)) + '- ' + AUP.PrivilegeFaName as [TitleFa], AUP.UPActive as [IsActive] , AUP.Sub_Sys, 'ServiceDef' as [SchemaEnName], N'تعریف خدمات سیستم' As [SchemaFaName]
	From ServiceDef.AUP AUP Where AUP.UserID = @UserID
	
	/* Report Privileges */
	Union All
	Select AUP.PrivilegeID, CAST(AUP.ShortCut as Nvarchar(max)) + '- ' + AUP.PrivilegeFaName as [TitleFa], AUP.UPActive as [IsActive] , AUP.Sub_Sys, 'Report' as [SchemaEnName], N'دسترسی های آمار و گزارشات' As [SchemaFaName]
	From Report.AUP AUP Where AUP.UserID = @UserID
	
	/* Gas Privileges */
	UNION ALL
	SELECT AUP.PrivilegeID, CAST(AUP.ShortCut as Nvarchar(max)) + '- ' + AUP.PrivilegeFaName as [TitleFa], AUP.UPActive as [IsActive] , AUP.Sub_Sys, 'Gas' as [SchemaEnName], N'چاپ قبض شرکت گاز' As [SchemaFaName]
	From Gas.AUP AUP Where AUP.UserID = @UserID
	
	/* Global Privileges */
	UNION ALL
	SELECT AUP.PrivilegeID, CAST(AUP.ShortCut as Nvarchar(max)) + '- ' + AUP.PrivilegeFaName as [TitleFa], AUP.UPActive as [IsActive] , AUP.Sub_Sys, 'Global' as [SchemaEnName], N'تنظیمات سیستمی' As [SchemaFaName]
	From Global.AUP AUP Where AUP.UserID = @UserID

	/* Scsc Privileges */
	UNION ALL
	SELECT AUP.PrivilegeID, CAST(AUP.ShortCut as Nvarchar(max)) + '- ' + AUP.PrivilegeFaName as [TitleFa], AUP.UPActive as [IsActive] , AUP.Sub_Sys, 'Scsc' as [SchemaEnName], N'تنظیمات سیستم مدیریت باشگاه ها' As [SchemaFaName]
	From Scsc.AUP AUP Where AUP.UserID = @UserID
   
   /* Sas Privileges */
	/*UNION ALL
	SELECT AUP.PrivilegeID, CAST(AUP.ShortCut as Nvarchar(max)) + '- ' + AUP.PrivilegeFaName as [TitleFa], AUP.UPActive as [IsActive] , AUP.Sub_Sys, 'Sas' as [SchemaEnName], N'خدمات پس از فروش' As [SchemaFaName]
	From Sas.AUP AUP Where AUP.UserID = @UserID*/
	
   /* Msgb Privileges */
	UNION ALL
	SELECT AUP.PrivilegeID, CAST(AUP.ShortCut as Nvarchar(max)) + '- ' + AUP.PrivilegeFaName as [TitleFa], AUP.UPActive as [IsActive] , AUP.Sub_Sys, 'Msgb' as [SchemaEnName], N'سیستم ارسال پیام و اطلاع رسانی' As [SchemaFaName]
	From Msgb.AUP AUP Where AUP.UserID = @UserID
	
	/* ISP Privileges */
	UNION ALL
	SELECT AUP.PrivilegeID, CAST(AUP.ShortCut as Nvarchar(max)) + '- ' + AUP.PrivilegeFaName as [TitleFa], AUP.UPActive as [IsActive] , AUP.Sub_Sys, 'ISP' as [SchemaEnName], N'سیستم مدیریت باشگاه مشتریان اینترنت' As [SchemaFaName]
	From ISP.AUP AUP Where AUP.UserID = @UserID

	/* CRM Privileges */
	UNION ALL
	SELECT AUP.PrivilegeID, CAST(AUP.ShortCut as Nvarchar(max)) + '- ' + AUP.PrivilegeFaName as [TitleFa], AUP.UPActive as [IsActive] , AUP.Sub_Sys, 'CRM' as [SchemaEnName], N'سیستم مدیریت ارتباط با مشتریان' As [SchemaFaName]
	From CRM.AUP AUP Where AUP.UserID = @UserID

   /* RoboTech Privileges */
	UNION ALL
	SELECT AUP.PrivilegeID, CAST(AUP.ShortCut as Nvarchar(max)) + '- ' + AUP.PrivilegeFaName as [TitleFa], AUP.UPActive as [IsActive] , AUP.Sub_Sys, 'RoboTech' as [SchemaEnName], N'نرم افزار مدیریت شبکه های اجتماعی' As [SchemaFaName]
	From RoboTech.AUP AUP Where AUP.UserID = @UserID
	
	/* Order Output Result */
	Order by AUP.Sub_Sys, AUP.PrivilegeID;
	
	SELECT
	 'SUCCESSFUL' AS RESULT
	,'0S' AS TIMERUN
	,'Privileges' AS TABLESNAME
	,'Mojtama' As TableSpaceName
	,'false' AS [HasRelation];
END
GO
