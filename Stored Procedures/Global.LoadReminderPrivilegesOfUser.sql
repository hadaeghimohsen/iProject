SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [Global].[LoadReminderPrivilegesOfUser]
	-- Add the parameters for the stored procedure here
	@Xml Xml
AS
BEGIN	
	Declare @UserID bigint;
	Select
	   @UserID = [user].[data].query('UserID').value('.', 'bigint')
	From @Xml.nodes('/') [user]([data]);
	
	/* DataGuard */
	Select p.ID as [PrivilegeID], Cast(p.ShortCut as NVarchar(3)) + '- ' + p.TitleFa as TitleFa, 1 as [IsActive] , 'DataGuard' as [SchemaEnName], N'دسترسی های امنیتی' as [SchemaFaName]
	From DataGuard.Privilege p
	Where	Not Exists (Select * From DataGuard.AUP Where UserID = @UserID And PrivilegeID = p.ID and UPVisible = 1)
	
	/* ServiceDef */
	Union All
	Select p.ID as [PrivilegeID], CAST(p.ShortCut as NVarchar(3)) + '- ' + p.TitleFa as TitleFa, 1 as [IsActive] , 'ServiceDef' as [SchemaEnName], N'تعریف خدمات سیستم' as [SchemaFaName]	
	From ServiceDef.Privilege p 
	Where Not Exists (Select * From ServiceDef.AUP Where UserId = @UserID And PrivilegeID = p.ID And UPVisible = 1)
	
	/* Report */
	Union All
	Select p.ID as [PrivilegeID], CAST(p.ShortCut as NVarchar(3)) + '- ' + p.TitleFa as TitleFa, 1 as [IsActive] , 'Report' as [SchemaEnName], N'دسترسی های آمار و گزارشات' as [SchemaFaName]	
	From Report.Privilege p 
	Where Not Exists (Select * From Report.AUP Where UserId = @UserID And PrivilegeID = p.ID And UPVisible = 1)
	
	/* Gas */
	UNION ALL 
	SELECT p.ID as [PrivilegeID], CAST(p.ShortCut as NVarchar(3)) + '- ' + p.TitleFa as TitleFa, 1 as [IsActive] , 'Gas' as [SchemaEnName], N'چاپ قبض شرکت گاز' as [SchemaFaName]	
	From Gas.Privilege p 
	Where Not Exists (Select * From Gas.AUP Where UserId = @UserID And PrivilegeID = p.ID And UPVisible = 1)
	
	/* Global */
	UNION ALL 
	SELECT p.ID as [PrivilegeID], CAST(p.ShortCut as NVarchar(3)) + '- ' + p.TitleFa as TitleFa, 1 as [IsActive] , 'Global' as [SchemaEnName], N'تنظیمات سیستمی' as [SchemaFaName]	
	From [Global].Privilege p 
	Where Not Exists (Select * From [Global].AUP Where UserId = @UserID And PrivilegeID = p.ID And UPVisible = 1) 

	/* Scsc */
	UNION ALL 
	SELECT p.ID as [PrivilegeID], CAST(p.ShortCut as NVarchar(3)) + '- ' + p.TitleFa as TitleFa, 1 as [IsActive] , 'Scsc' as [SchemaEnName], N'تنظیمات سیستم مدیریت باشگاه ها' as [SchemaFaName]	
	From [Scsc].Privilege p 
	Where Not Exists (Select * From [Scsc].AUP Where UserId = @UserID And PrivilegeID = p.ID And UPVisible = 1) 

   /* Sas */
	/*UNION ALL 
	SELECT p.ID as [PrivilegeID], CAST(p.ShortCut as NVarchar(3)) + '- ' + p.TitleFa as TitleFa, 1 as [IsActive] , 'Sas' as [SchemaEnName], N'خدمات پس از فروش' as [SchemaFaName]	
	From [Sas].Privilege p 
	Where Not Exists (Select * From [Sas].AUP Where UserId = @UserID And PrivilegeID = p.ID And UPVisible = 1) */
   
   /* Msgb */
	UNION ALL 
	SELECT p.ID as [PrivilegeID], CAST(p.ShortCut as NVarchar(3)) + '- ' + p.TitleFa as TitleFa, 1 as [IsActive] , 'Msgb' as [SchemaEnName], N'سیستم ارسال پیام و اطلاع رسانی' as [SchemaFaName]	
	From [Msgb].Privilege p 
	Where Not Exists (Select * From [Msgb].AUP Where UserId = @UserID And PrivilegeID = p.ID And UPVisible = 1) 
   
   /* ISP */
	UNION ALL 
	SELECT p.ID as [PrivilegeID], CAST(p.ShortCut as NVarchar(3)) + '- ' + p.TitleFa as TitleFa, 1 as [IsActive] , 'ISP' as [SchemaEnName], N'سیستم مدیریت باشگاه مشتریان اینترنت' as [SchemaFaName]	
	From [ISP].Privilege p 
	Where Not Exists (Select * From [ISP].AUP Where UserId = @UserID And PrivilegeID = p.ID And UPVisible = 1) 

   /* CRM */
	UNION ALL 
	SELECT p.ID as [PrivilegeID], CAST(p.ShortCut as NVarchar(3)) + '- ' + p.TitleFa as TitleFa, 1 as [IsActive] , 'CRM' as [SchemaEnName], N'سیستم مدیریت ارتباط با مشتریان' as [SchemaFaName]	
	From [CRM].Privilege p 
	Where Not Exists (Select * From [CRM].AUP Where UserId = @UserID And PrivilegeID = p.ID And UPVisible = 1) 

   /* RoboTech */
	UNION ALL 
	SELECT p.ID as [PrivilegeID], CAST(p.ShortCut as NVarchar(3)) + '- ' + p.TitleFa as TitleFa, 1 as [IsActive] , 'RoboTech' as [SchemaEnName], N'نرم افزار مدیریت شبکه های اجتماعی' as [SchemaFaName]	
	From [RoboTech].Privilege p 
	Where Not Exists (Select * From [RoboTech].AUP Where UserId = @UserID And PrivilegeID = p.ID And UPVisible = 1) 
   	
	/* Order By */
	Order by p.ID;
	
	SELECT
	 'SUCCESSFUL' AS RESULT
	,'0S' AS TIMERUN
	,'Privileges' AS TABLESNAME
	,'Mojtama' As TableSpaceName
	,'false' AS [HasRelation];
END
GO
