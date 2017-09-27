SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [Global].[LoadPrivilegesOfRoleWithCondition]
	-- Add the parameters for the stored procedure here
	@Xml Xml	
AS
BEGIN
	Declare @RoleID Bigint, @RPActive bit;
	Select
	   @RoleID = r.id.query('RoleID').value('.','bigint'),
	   @RPActive = r.id.query('RPActive').value('.','bit')
	From @Xml.nodes('/')r(id);
	
	/* DataGurad Privileges */
	Select ARP.PrivilegeID,  Cast( ARP.ShortCut as NVarchar(3)) + '- ' + ARP.PrivilegeFaName as [TitleFa], ARP.RPActive as [IsActive] , Sub_Sys, 'DataGuard' as SchemaEnName, N'دسترسی های امنیتی' as SchemaFaName
	From DataGuard.ARP ARP 
	Where ARP.RoleID = @RoleID And ARP.RPActive = @RPActive
	
	/* ServiceDef Privileges */
	Union All
	Select ARP.PrivilegeID, Cast( ARP.ShortCut as NVarchar(3)) + '- ' + ARP.PrivilegeFaName as [TitleFa], ARP.RPActive as [IsActive] , Sub_Sys, 'ServiceDef' as SchemaEnName, N'تعریف خدمات سیستم' as SchemaFaName
	From ServiceDef.ARP ARP 
	Where ARP.RoleID = @RoleID And ARP.RPActive = @RPActive
	
	/* Report Privileges */
	Union All
	Select ARP.PrivilegeID, Cast( ARP.ShortCut as NVarchar(3)) + '- ' + ARP.PrivilegeFaName as [TitleFa], ARP.RPActive as [IsActive] , Sub_Sys, 'Report' as SchemaEnName, N'دسترسی های آمار و گزارشات' as SchemaFaName
	From Report.ARP ARP 
	Where ARP.RoleID = @RoleID And ARP.RPActive = @RPActive
	
	/* Gas Privileges */
	UNION ALL
	SELECT ARP.PrivilegeID, Cast( ARP.ShortCut as NVarchar(3)) + '- ' + ARP.PrivilegeFaName as [TitleFa], ARP.RPActive as [IsActive] , Sub_Sys, 'Gas' as SchemaEnName, N'چاپ قبض شرکت گاز' as SchemaFaName
	FROM Gas.ARP ARP
	WHERE ARP.RoleID = @RoleID AND ARP.RPActive = @RPActive
	
	/* Global Privileges */
	UNION ALL
	SELECT ARP.PrivilegeID, Cast( ARP.ShortCut as NVarchar(3)) + '- ' + ARP.PrivilegeFaName as [TitleFa], ARP.RPActive as [IsActive] , Sub_Sys, 'Global' as SchemaEnName, N'تنظیمات سیستمی' as SchemaFaName
	FROM [Global].ARP ARP
	WHERE ARP.RoleID = @RoleID AND ARP.RPActive = @RPActive

	/* Scsc Privileges */
	UNION ALL
	SELECT ARP.PrivilegeID, Cast( ARP.ShortCut as NVarchar(3)) + '- ' + ARP.PrivilegeFaName as [TitleFa], ARP.RPActive as [IsActive] , Sub_Sys, 'Scsc' as SchemaEnName, N'تنظیمات سیستم مدیریت باشگاه ها' as SchemaFaName
	FROM [Scsc].ARP ARP
	WHERE ARP.RoleID = @RoleID AND ARP.RPActive = @RPActive

   /* Sas Privileges */
	UNION ALL
	SELECT ARP.PrivilegeID, Cast( ARP.ShortCut as NVarchar(3)) + '- ' + ARP.PrivilegeFaName as [TitleFa], ARP.RPActive as [IsActive] , Sub_Sys, 'Sas' as SchemaEnName, N'خدمات پس از فروش' as SchemaFaName
	FROM [Sas].ARP ARP
	WHERE ARP.RoleID = @RoleID AND ARP.RPActive = @RPActive
	
	/* Msgb Privileges */
	UNION ALL
	SELECT ARP.PrivilegeID, Cast( ARP.ShortCut as NVarchar(3)) + '- ' + ARP.PrivilegeFaName as [TitleFa], ARP.RPActive as [IsActive] , Sub_Sys, 'Msgb' as SchemaEnName, N'سیستم ارسال پیام و اطلاع رسانی' as SchemaFaName
	FROM [Msgb].ARP ARP
	WHERE ARP.RoleID = @RoleID AND ARP.RPActive = @RPActive
	
	/* ISP Privileges */
	UNION ALL
	SELECT ARP.PrivilegeID, Cast( ARP.ShortCut as NVarchar(3)) + '- ' + ARP.PrivilegeFaName as [TitleFa], ARP.RPActive as [IsActive] , Sub_Sys, 'ISP' as SchemaEnName, N'سیستم مدیریت باشگاه مشتریان اینترنت' as SchemaFaName
	FROM [ISP].ARP ARP
	WHERE ARP.RoleID = @RoleID AND ARP.RPActive = @RPActive

	/* CRM Privileges */
	UNION ALL
	SELECT ARP.PrivilegeID, Cast( ARP.ShortCut as NVarchar(3)) + '- ' + ARP.PrivilegeFaName as [TitleFa], ARP.RPActive as [IsActive] , Sub_Sys, 'CRM' as SchemaEnName, N'سیستم مدیریت ارتباط با مشتریان' as SchemaFaName
	FROM [CRM].ARP ARP
	WHERE ARP.RoleID = @RoleID AND ARP.RPActive = @RPActive
	
	/* RoboTech Privileges */
	UNION ALL
	SELECT ARP.PrivilegeID, Cast( ARP.ShortCut as NVarchar(3)) + '- ' + ARP.PrivilegeFaName as [TitleFa], ARP.RPActive as [IsActive] , Sub_Sys, 'RoboTech' as SchemaEnName, N'نرم افزار مدیریت شبکه های اجتماعی' as SchemaFaName
	FROM [RoboTech].ARP ARP
	WHERE ARP.RoleID = @RoleID AND ARP.RPActive = @RPActive

	
	/* Order Output Result */
	Order by ARP.Sub_Sys, ARP.PrivilegeID;
	
	SELECT
	 'SUCCESSFUL' AS RESULT
	,'0S' AS TIMERUN
	,'Privileges' AS TABLESNAME
	,'Mojtama' As TableSpaceName
	,'false' AS [HasRelation];
END
GO
