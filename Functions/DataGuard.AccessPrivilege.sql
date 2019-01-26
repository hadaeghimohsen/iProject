SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date, ,>
-- Description:	Sub_Sys = 0
-- =============================================
CREATE FUNCTION [DataGuard].[AccessPrivilege]
(
	@Xml Xml
)
RETURNS bit
AS
BEGIN
   Declare @Sub_Sys smallint;
   Declare @PrivilegeID bigint;
   Declare @UserName nvarchar(max);
   Select 
      @Sub_Sys = ISNULL(t.c.query('Sub_Sys').value('.','smallint'), 0),
      @PrivilegeID = t.c.query('Privilege').value('.','bigint'),
      @UserName = t.c.query('UserName').value('.','nvarchar(max)')
   From @Xml.nodes('/AP') t(c);
   
   -- اگر کاربر اصلی باشد تمام دسترسی ها رو بهش داده شود
   IF @UserName = 'scott' 
      RETURN 1;
   
   -- اگر زیر سیستم درون نرم افزار نصب نشده باشد دیگر دسترسی دادن مفهومی ندارد
   --IF NOT EXISTS(SELECT * FROM Report.DataSource WHERE SUB_SYS = @Sub_Sys) 
      --RETURN 0;
   
	if(
         exists (Select * from DataGuard.URP urp Where urp.UserEnName = @UserName and urp.sub_sys = @Sub_Sys and urp.privilegeid = @PrivilegeID ) 	   
      Or exists (Select * from DataGuard.UP up   Where up.UserEnName = @UserName and up.sub_sys = @Sub_Sys and up.privilegeid = @PrivilegeID)
     
      Or exists (Select * from ServiceDef.URP urp Where urp.UserEnName = @UserName and urp.sub_sys = @Sub_Sys and urp.privilegeid = @PrivilegeID ) 	   
      Or exists (Select * from ServiceDef.UP up   Where up.UserEnName = @UserName and up.sub_sys = @Sub_Sys and up.privilegeid = @PrivilegeID)
     
      Or exists (Select * from Report.URP urp Where urp.UserEnName = @UserName and urp.sub_sys = @Sub_Sys and urp.privilegeid = @PrivilegeID ) 	   
      Or exists (Select * from Report.UP up   Where up.UserEnName = @UserName and up.sub_sys = @Sub_Sys and up.privilegeid = @PrivilegeID)
      
      Or exists (Select * from Gas.URP urp Where urp.UserEnName = @UserName and urp.sub_sys = @Sub_Sys and urp.privilegeid = @PrivilegeID ) 	   
      Or exists (Select * from Gas.UP up   Where up.UserEnName = @UserName and up.sub_sys = @Sub_Sys and up.privilegeid = @PrivilegeID)
      
      Or exists (Select * from Global.URP urp Where urp.UserEnName = @UserName and urp.sub_sys = @Sub_Sys and urp.privilegeid = @PrivilegeID ) 	   
      Or exists (Select * from Global.UP up   Where up.UserEnName = @UserName and up.sub_sys = @Sub_Sys and up.privilegeid = @PrivilegeID)
      
      Or exists (Select * from Scsc.URP urp Where urp.UserEnName = @UserName and urp.sub_sys = @Sub_Sys and urp.privilegeid = @PrivilegeID ) 	   
      Or exists (Select * from Scsc.UP up   Where up.UserEnName = @UserName and up.sub_sys = @Sub_Sys and up.privilegeid = @PrivilegeID)

      Or exists (Select * from Sas.URP urp Where urp.UserEnName = @UserName and urp.sub_sys = @Sub_Sys and urp.privilegeid = @PrivilegeID ) 	   
      Or exists (Select * from Sas.UP up   Where up.UserEnName = @UserName and up.sub_sys = @Sub_Sys and up.privilegeid = @PrivilegeID)      
      
      Or exists (Select * from Msgb.URP urp Where urp.UserEnName = @UserName and urp.sub_sys = @Sub_Sys and urp.privilegeid = @PrivilegeID ) 	   
      Or exists (Select * from Msgb.UP up   Where up.UserEnName = @UserName and up.sub_sys = @Sub_Sys and up.privilegeid = @PrivilegeID)      
      
      Or exists (Select * from ISP.URP urp Where urp.UserEnName = @UserName and urp.sub_sys = @Sub_Sys and urp.privilegeid = @PrivilegeID ) 	   
      Or exists (Select * from ISP.UP up   Where up.UserEnName = @UserName and up.sub_sys = @Sub_Sys and up.privilegeid = @PrivilegeID)      
      
      Or exists (Select * from CRM.URP urp Where urp.UserEnName = @UserName and urp.sub_sys = @Sub_Sys and urp.privilegeid = @PrivilegeID ) 	   
      Or exists (Select * from CRM.UP up   Where up.UserEnName = @UserName and up.sub_sys = @Sub_Sys and up.privilegeid = @PrivilegeID)      
      
      Or exists (Select * from RoboTech.URP urp Where urp.UserEnName = @UserName and urp.sub_sys = @Sub_Sys and urp.privilegeid = @PrivilegeID ) 	   
      Or exists (Select * from RoboTech.UP up   Where up.UserEnName = @UserName and up.sub_sys = @Sub_Sys and up.privilegeid = @PrivilegeID)      
     ) 
      Return 1;

   Return 0;	            
END
GO
