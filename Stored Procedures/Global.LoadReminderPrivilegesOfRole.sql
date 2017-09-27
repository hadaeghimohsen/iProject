SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [Global].[LoadReminderPrivilegesOfRole]
	-- Add the parameters for the stored procedure here
	@Xml Xml
AS
BEGIN	
	Declare @RoleID bigint;
	Select
	   @RoleID = [role].[data].query('RoleID').value('.', 'bigint')
	From @Xml.nodes('/') [role]([data]);
	
	/* DataGuard Privileges */
	Select p.ID as [PrivilegeID], CAST(p.ShortCut as NVarchar(3)) + '- ' +  p.TitleFa as TitleFa , 1 as [IsActive] , 'DataGuard' as [SchemaEnName], N'دسترسی های امنیتی' as [SchemaFaName], 0 as Sub_Sys
	From DataGuard.Privilege p
	Where	Not Exists (Select * From DataGuard.ARP Where RoleID = @RoleID And PrivilegeID = p.ID and RPVisible = 1)
	
	/* ServiceDef Privileges */
	Union All
	Select p.ID as [PrivilegeID], CAST(p.ShortCut as NVarchar(3)) + '- ' + p.TitleFa as TitleFa , 1 as [IsActive] , 'ServiceDef' as [SchemaEnName], N'تعریف خدمات سیستم' as [SchemaFaName], 1 as Sub_Sys
	From ServiceDef.Privilege p
	Where	Not Exists (Select * From ServiceDef.ARP Where RoleID = @RoleID And PrivilegeID = p.ID and RPVisible = 1)
	
	/* Report Privileges */
	Union All
	Select p.ID as [PrivilegeID], CAST(p.ShortCut as NVarchar(3)) + '- ' + p.TitleFa as TitleFa , 1 as [IsActive] , 'Report' as [SchemaEnName], N'دسترسی های آمار و گزارشات' as [SchemaFaName], 2 as Sub_Sys
	From Report.Privilege p
	Where	Not Exists (Select * From Report.ARP Where RoleID = @RoleID And PrivilegeID = p.ID and RPVisible = 1)
	
	
	/* Gas Privileges */
	UNION ALL
	SELECT p.ID as [PrivilegeID], CAST(p.ShortCut as NVarchar(3)) + '- ' + p.TitleFa as TitleFa , 1 as [IsActive] , 'Gas' as [SchemaEnName], N'چاپ قبض شرکت گاز' as [SchemaFaName], 3 as Sub_Sys
	FROM Gas.Privilege p 
	WHERE NOT EXISTS (SELECT * FROM Gas.ARP WHERE RoleID = @RoleID AND PrivilegeID = p.ID AND RPVisible = 1)
	
	/* Global Privileges */
	UNION ALL
	SELECT p.ID as [PrivilegeID], CAST(p.ShortCut as NVarchar(3)) + '- ' + p.TitleFa as TitleFa , 1 as [IsActive] , 'Global' as [SchemaEnName], N'تنظیمات سیستمی' as [SchemaFaName], 4 as Sub_Sys
	FROM [Global].Privilege p 
	WHERE NOT EXISTS (SELECT * FROM [Global].ARP WHERE RoleID = @RoleID AND PrivilegeID = p.ID AND RPVisible = 1)

	/* Scsc Privileges */
	UNION ALL
	SELECT p.ID as [PrivilegeID], CAST(p.ShortCut as NVarchar(3)) + '- ' + p.TitleFa as TitleFa , 1 as [IsActive] , 'Scsc' as [SchemaEnName], N'تنظیمات سیستم مدیریت باشگاه ها' as [SchemaFaName], 5 as Sub_Sys
	FROM [Scsc].Privilege p 
	WHERE NOT EXISTS (SELECT * FROM [Scsc].ARP WHERE RoleID = @RoleID AND PrivilegeID = p.ID AND RPVisible = 1)
	
	/* Sas Privileges */
	UNION ALL
	SELECT p.ID as [PrivilegeID], CAST(p.ShortCut as NVarchar(3)) + '- ' + p.TitleFa as TitleFa , 1 as [IsActive] , 'Sas' as [SchemaEnName], N'خدمات پس از فروش' as [SchemaFaName], 6 as Sub_Sys
	FROM [Sas].Privilege p 
	WHERE NOT EXISTS (SELECT * FROM [Sas].ARP WHERE RoleID = @RoleID AND PrivilegeID = p.ID AND RPVisible = 1)
	
	/* Msgb Privileges */
	UNION ALL
	SELECT p.ID as [PrivilegeID], CAST(p.ShortCut as NVarchar(3)) + '- ' + p.TitleFa as TitleFa , 1 as [IsActive] , 'Msgb' as [SchemaEnName], N'سیستم ارسال پیام و اطلاع رسانی' as [SchemaFaName], 7 as Sub_Sys
	FROM [Msgb].Privilege p 
	WHERE NOT EXISTS (SELECT * FROM [Msgb].ARP WHERE RoleID = @RoleID AND PrivilegeID = p.ID AND RPVisible = 1)
	
	/* ISP Privileges */
	UNION ALL
	SELECT p.ID as [PrivilegeID], CAST(p.ShortCut as NVarchar(3)) + '- ' + p.TitleFa as TitleFa , 1 as [IsActive] , 'ISP' as [SchemaEnName], N'سیستم مدیریت باشگاه مشتریان اینترنت' as [SchemaFaName], 10 as Sub_Sys
	FROM [ISP].Privilege p 
	WHERE NOT EXISTS (SELECT * FROM [ISP].ARP WHERE RoleID = @RoleID AND PrivilegeID = p.ID AND RPVisible = 1)
	
	/* CRM Privileges */
	UNION ALL
	SELECT p.ID as [PrivilegeID], CAST(p.ShortCut as NVarchar(3)) + '- ' + p.TitleFa as TitleFa , 1 as [IsActive] , 'CRM' as [SchemaEnName], N'سیستم مدیریت ارتباط با مشتریان' as [SchemaFaName], 11 as Sub_Sys
	FROM [CRM].Privilege p 
	WHERE NOT EXISTS (SELECT * FROM [CRM].ARP WHERE RoleID = @RoleID AND PrivilegeID = p.ID AND RPVisible = 1)
	
	/* RoboTech Privileges */
	UNION ALL
	SELECT p.ID as [PrivilegeID], CAST(p.ShortCut as NVarchar(3)) + '- ' + p.TitleFa as TitleFa , 1 as [IsActive] , 'RoboTech' as [SchemaEnName], N'نرم افزار مدیریت شبکه های اجتماعی' as [SchemaFaName], 12 as Sub_Sys
	FROM [RoboTech].Privilege p 
	WHERE NOT EXISTS (SELECT * FROM [RoboTech].ARP WHERE RoleID = @RoleID AND PrivilegeID = p.ID AND RPVisible = 1)


	/* Order Output Result */
	Order by p.ID;
	
	SELECT
	 'SUCCESSFUL' AS RESULT
	,'0S' AS TIMERUN
	,'Privileges' AS TABLESNAME
	,'Mojtama' As TableSpaceName
	,'false' AS [HasRelation];
END
GO
