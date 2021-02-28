SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [DataGuard].[EXEC_CMND_P]
	-- Add the parameters for the stored procedure here
	@X XML
AS
BEGIN
	DECLARE @SubSys INT,
	        @CmndText VARCHAR(100),
	        @TinyKey VARCHAR(20),
	        @CmndDate DATE,
	        @Valu VARCHAR(100);
	
	SELECT @CmndText = CASE id WHEN 1 THEN Item ELSE @CmndText END,
	       @TinyKey = CASE id WHEN 2 THEN Item ELSE @TinyKey END,
	       @CmndDate = CASE id WHEN 3 THEN Item ELSE @CmndDate END,
	       @Valu = CASE id WHEN 4 THEN Item ELSE @Valu END,
	       @SubSys = CASE id WHEN 5 THEN Item ELSE @SubSys END
	  FROM dbo.SplitString((@x.query('/Command').value('(/Command/@text)[1]', 'VARCHAR(500)')), ':');
	
	IF EXISTS (SELECT * FROM DataGuard.Command c WHERE c.OPEN_CMND_TEXT = @x.query('/Command').value('(/Command/@text)[1]', 'VARCHAR(500)')) RETURN;
	
	IF @SubSys = 5
	BEGIN
	   IF @CmndText = 'addnewcard'
	   BEGIN
	      INSERT INTO DataGuard.Command (SUB_SYS ,CODE ,OPEN_CMND_TEXT ,VALU ,CMND_DATE ,RUN_STAT)
	      VALUES (@SubSys, 0, @x.query('/Command').value('(/Command/@text)[1]', 'VARCHAR(500)'), @Valu, @CmndDate, '002');
	      
	      UPDATE DataGuard.Sub_System 
	         SET RECD_NUMB += @Valu
	       WHERE SUB_SYS = @SubSys;	      
	   END 
	END 
END
GO
