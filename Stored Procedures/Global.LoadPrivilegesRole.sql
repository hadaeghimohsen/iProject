SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [Global].[LoadPrivilegesRole]
	-- Add the parameters for the stored procedure here
	@Xml Xml	
AS
BEGIN
	
	/* DataGuard Privileges */
	Select ARP.PrivilegeID, Cast(ARP.Shortcut as Nvarchar(max)) + '- ' + ARP.PrivilegeFaName as [TitleFa], ARP.RPActive as [IsActive] ,  ARP.[Sub_Sys], 'DataGuard' As [SchemaEnName], N'دسترسی های امنیتی' As [SchemaFaName]
	From DataGuard.ARP ARP inner join @Xml.nodes('/') [r](id) on (ARP.RoleID = [r].id.query('RoleID').value('.', 'bigint'))
	
	/* ServiceDef Privileges */
	Union All
	Select ARP.PrivilegeID, Cast(ARP.Shortcut as Nvarchar(max)) + '- ' + ARP.PrivilegeFaName as [TitleFa], ARP.RPActive as [IsActive] ,  ARP.[Sub_Sys], 'ServiceDef' As [SchemaEnName], N'تعریف خدمات سیستم' As [SchemaFaName]
	From ServiceDef.ARP ARP inner join @Xml.nodes('/') [r](id) on (ARP.RoleID = [r].id.query('RoleID').value('.', 'bigint'))
	
	/* Report Privileges */
	Union All
	Select ARP.PrivilegeID, Cast(ARP.Shortcut as Nvarchar(max)) + '- ' + ARP.PrivilegeFaName as [TitleFa], ARP.RPActive as [IsActive] ,  ARP.[Sub_Sys], 'Report' As [SchemaEnName], N'دسترسی های آمار و گزارشات' As [SchemaFaName]
	From Report.ARP ARP inner join @Xml.nodes('/') [r](id) on (ARP.RoleID = [r].id.query('RoleID').value('.', 'bigint'))
	
	/* Gas Privileges */
	UNION ALL
	SELECT ARP.PrivilegeID, Cast(ARP.Shortcut as Nvarchar(max)) + '- ' + ARP.PrivilegeFaName as [TitleFa], ARP.RPActive as [IsActive] ,  ARP.[Sub_Sys], 'Gas' As [SchemaEnName], N'چاپ قبض شرکت گاز' As [SchemaFaName]
	FROM Gas.ARP ARP INNER JOIN @Xml.nodes('/') [r](id) on (ARP.RoleID = [r].id.query('RoleID').value('.', 'bigint'))
	
	/* Global Privileges */
	UNION ALL
	SELECT ARP.PrivilegeID, Cast(ARP.Shortcut as Nvarchar(max)) + '- ' + ARP.PrivilegeFaName as [TitleFa], ARP.RPActive as [IsActive] ,  ARP.[Sub_Sys], 'Global' As [SchemaEnName], N'تنظیمات سیستمی' As [SchemaFaName]
	FROM [Global].ARP ARP INNER JOIN @Xml.nodes('/') [r](id) on (ARP.RoleID = [r].id.query('RoleID').value('.', 'bigint'))
	
   /* Scsc Privileges */
	UNION ALL
	SELECT ARP.PrivilegeID, Cast(ARP.Shortcut as Nvarchar(max)) + '- ' + ARP.PrivilegeFaName as [TitleFa], ARP.RPActive as [IsActive] ,  ARP.[Sub_Sys], 'Scsc' As [SchemaEnName], N'تنظیمات سیستم مدیریت باشگاه ها' As [SchemaFaName]
	FROM [Scsc].ARP ARP INNER JOIN @Xml.nodes('/') [r](id) on (ARP.RoleID = [r].id.query('RoleID').value('.', 'bigint'))

   /* Sas Privileges */
	UNION ALL
	SELECT ARP.PrivilegeID, Cast(ARP.Shortcut as Nvarchar(max)) + '- ' + ARP.PrivilegeFaName as [TitleFa], ARP.RPActive as [IsActive] ,  ARP.[Sub_Sys], 'Sas' As [SchemaEnName], N'خدمات پس از فروش' As [SchemaFaName]
	FROM [Sas].ARP ARP INNER JOIN @Xml.nodes('/') [r](id) on (ARP.RoleID = [r].id.query('RoleID').value('.', 'bigint'))
	
	/* Msgb Privileges */
	UNION ALL
	SELECT ARP.PrivilegeID, Cast(ARP.Shortcut as Nvarchar(max)) + '- ' + ARP.PrivilegeFaName as [TitleFa], ARP.RPActive as [IsActive] ,  ARP.[Sub_Sys], 'Msgb' As [SchemaEnName], N'سیستم ارسال پیام و اطلاع رسانی' As [SchemaFaName]
	FROM [Msgb].ARP ARP INNER JOIN @Xml.nodes('/') [r](id) on (ARP.RoleID = [r].id.query('RoleID').value('.', 'bigint'))
	
	/* ISP Privileges */
	UNION ALL
	SELECT ARP.PrivilegeID, Cast(ARP.Shortcut as Nvarchar(max)) + '- ' + ARP.PrivilegeFaName as [TitleFa], ARP.RPActive as [IsActive] ,  ARP.[Sub_Sys], 'ISP' As [SchemaEnName], N'سیستم مدیریت باشگاه مشتریان اینترنت' As [SchemaFaName]
	FROM [ISP].ARP ARP INNER JOIN @Xml.nodes('/') [r](id) on (ARP.RoleID = [r].id.query('RoleID').value('.', 'bigint'))

	/* CRM Privileges */
	UNION ALL
	SELECT ARP.PrivilegeID, Cast(ARP.Shortcut as Nvarchar(max)) + '- ' + ARP.PrivilegeFaName as [TitleFa], ARP.RPActive as [IsActive] ,  ARP.[Sub_Sys], 'CRM' As [SchemaEnName], N'سیستم مدیریت ارتباط با مشتریان' As [SchemaFaName]
	FROM [CRM].ARP ARP INNER JOIN @Xml.nodes('/') [r](id) on (ARP.RoleID = [r].id.query('RoleID').value('.', 'bigint'))
	
	/* RoboTech Privileges */
	UNION ALL
	SELECT ARP.PrivilegeID, Cast(ARP.Shortcut as Nvarchar(max)) + '- ' + ARP.PrivilegeFaName as [TitleFa], ARP.RPActive as [IsActive] ,  ARP.[Sub_Sys], 'RoboTech' As [SchemaEnName], N'نرم افزار مدیریت شبکه های اجتماعی' As [SchemaFaName]
	FROM [RoboTech].ARP ARP INNER JOIN @Xml.nodes('/') [r](id) on (ARP.RoleID = [r].id.query('RoleID').value('.', 'bigint'))

	/* Order Output Result */
	Order by ARP.Sub_Sys,ARP.PrivilegeID;
	
	SELECT
	 'SUCCESSFUL' AS RESULT
	,'0S' AS TIMERUN
	,'Privileges' AS TABLESNAME
	,'Mojtama' As TableSpaceName
	,'false' AS [HasRelation];
END
GO
