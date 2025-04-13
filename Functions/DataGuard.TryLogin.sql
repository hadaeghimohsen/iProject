SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date, ,>
-- Description:	<Description, ,>
-- =============================================
CREATE FUNCTION [DataGuard].[TryLogin]
(
	-- Add the parameters for the function here
	@Xml Xml
)
RETURNS bit
AS
BEGIN
   -- 1391/03/28 
   --      * خب بسم الله یه نرم افزار جامع رو بزنیم، البته خودم نمیدونم میخواد به کجا برسه ولی خب همینکه شروع کردم 
   --      * میدونم به جای خوب میرسونمش
   --      * هدف از این نرم افزار این هست که بتونم یه سیستم مانند سیستم عامل با سرویس های مختلف ایجاد کنم
   --      * حداقل تو دانشگاه دانش خوبی بهمون یاد دادن حالا خودمون عملی ازش استفاده کنیم و این دانش رو به کار ببریم 
   --      * ;) الهی به امید خودت و دانشی که داریم شروع کنیم
   
   DECLARE @ExpireType BIT
          ,@ExpireDate DATE
          ,@SessionType VARCHAR(20)
          ,@SessionMaxConnection INT
          ,@SessionOpenedConnection INT;
   
   IF NOT EXISTS(SELECT * FROM SETTINGS)
      RETURN 0;
   
   SELECT @ExpireType = x.query('//AppExpire').value('(AppExpire/@type)[1]','BIT')
         ,@ExpireDate = x.query('//AppExpire').value('(AppExpire/@value)[1]','DATE')
         ,@SessionType = x.query('//Session').value('(Session/@type)[1]','VARCHAR(20)')
         ,@SessionMaxConnection = x.query('//Session').value('(Session/@max)[1]','INT')
         ,@SessionOpenedConnection = x.query('//Session').value('(Session/@count)[1]','INT')
     FROM SETTINGS X;

   --IF @ExpireType = 1
   --BEGIN
   --   IF NOT(GETDATE() <= @ExpireDate OR (@SessionType = 'limited' AND @SessionOpenedConnection < @SessionMaxConnection))
   --      RETURN 0;
   --END
             
	Declare @UserName nvarchar(100), @Password nvarchar(max);
	Declare @UserID bigint;
	Select 
		@UserName = [login].[data].query('UserName').value('.', 'nvarchar(100)'),
		@Password = [login].[data].query('Password').value('.', 'nvarchar(max)')
	From @Xml.nodes('/Login') [login]([data]);
	
	if(not exists(Select ID from [user] where TitleEn = @UserName And IsVisible = 1 And IsLock = 0))
	Begin
		--RAISERROR ('No More User or User has deleted or islocked :(', 16 /* Severity */, 1 /* State */);				
		Return 0;
	End
	else
		Select @UserID = ID From [User] Where TitleEn = @UserName;
	
	if(not exists(Select * from [User] Where ID = @UserID And Convert(binary, [Password]) = Convert(binary, @Password)))
	Begin
		--RAISERROR ('Password is not matched :(', 16 /* Severity */, 1 /* State */);
		Return 0;
	End
	
	if(not exists(select * from [Role_User] ur where ur.UserID = @UserID And ur.IsActive = 1 And ur.IsVisible = 1) 
	   and
	   not exists(select * from [User_Privilege] up where up.UserID = @UserID and up.IsActive = 1 And up.IsVisible = 1))
	Begin
		--RAISERROR ('No more grant role(s) to user :(', 16 /* Severity */, 1 /* State */);
		Return 0;
	End
	
	-- Check Access "Create Session" Privilege to User
	if(not exists(Select * from DataGuard.URP Where UserID = @UserID And PrivilegeID = 1)
	   and
	   not exists(select * from DataGuard.UP Where UserID = @UserID And PrivilegeID = 1))
	Begin
		--RAISERROR ('User not have Create Session Privilege :(', 16 /* Severity */, 1 /* State */);
		Return 0;
	End

	Return 1;
END
GO
