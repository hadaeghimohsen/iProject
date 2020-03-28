SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [DataGuard].[DeleteUser]
	-- Add the parameters for the stored procedure here	
	@Xml Xml
AS
BEGIN
   DECLARE @AP BIT
          ,@AccessString VARCHAR(250);
   SET @AccessString = N'<AP><UserName>' + SUSER_NAME() + '</UserName><Privilege>38</Privilege><Sub_Sys>0</Sub_Sys></AP>';	
   EXEC iProject.dbo.SP_EXECUTESQL N'SELECT @ap = DataGuard.AccessPrivilege(@P1)',N'@P1 ntext, @ap BIT OUTPUT',@AccessString , @ap = @ap output
   IF @AP = 0 
   BEGIN
      RAISERROR ( N'خطا - عدم دسترسی به ردیف 38 سطوح امینتی', -- Message text.
               16, -- Severity.
               1 -- State.
               );
      RETURN;
   END

   Declare @UserID bigint;
   
   select 
      @UserID = u.d.query('.').value('(DeleteUser/@id)[1]','bigint')
   from @Xml.nodes('/DeleteUser') u(d);

	Declare @TitleEn Nvarchar(max)

	Select @TitleEn = TitleEn
	from DataGuard.[User] ;
	
	DELETE DataGuard.[User] WHERE ID = @UserID;	
	
	-- Exec Other Database For Duplicate user	
	------------------------------
	IF EXISTS (SELECT * FROM SYS.SERVER_PRINCIPALS WHERE UPPER(Name) = UPPER(@TitleEn))
   BEGIN
      DECLARE @sql NVARCHAR(max)
      SET @sql = 'USE master;' + CHAR(10) +
                 'DROP LOGIN [' + @TitleEn + '];' ;
      
      EXEC (@sql);
   END
END
GO
