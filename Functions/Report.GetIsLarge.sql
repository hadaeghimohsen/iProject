SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date, ,>
-- Description:	<Description, ,>
-- =============================================
CREATE FUNCTION [Report].[GetIsLarge]
(
	@P_RwNo BIGINT
)
RETURNS BIT
AS
BEGIN
   RETURN 
	CASE 
	   WHEN ( @P_RwNo % 14 ) IN (1, 2, 3, 5, 6, 7, 8, 10, 11, 12, 13) THEN 0
	   WHEN ( @P_RwNo % 14 ) IN (0, 4, 9) THEN 1
	END;	   
	RETURN 0;
END
GO
