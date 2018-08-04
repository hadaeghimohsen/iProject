SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [DataGuard].[CreateWebUser]
	@X XML
AS
BEGIN
	DECLARE @NatlCode VARCHAR(10), -- 2372499424
	        @CellPhon VARCHAR(11); -- 09033927103
	
	MERGE DataGuard.[User] T
	USING (SELECT @NatlCode AS NATL_CODE, @CellPhon AS CELL_PHON) S
	ON(T.USERDB = S.NATL_CODE)
	WHEN NOT MATCHED THEN
	   INSERT (TitleFa, TitleEn, STitleEn, [Password], USERDB, PASSDB, CELL_PHON, REGN_LANG, RTL_STAT)
	   VALUES (@NatlCode, @NatlCode, @NatlCode, @CellPhon, 'webuser', 'webuser_anardb', @CellPhon, '054', '002');
   
   DECLARE @UserId BIGINT;
   SELECT @UserId = ID
     FROM DataGuard.[User]
    WHERE STitleEn = @NatlCode;
   
   SELECT @UserId;  	   
END
GO
