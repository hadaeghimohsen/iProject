SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date, ,>
-- Description:	<Description, ,>
-- =============================================
CREATE FUNCTION [Report].[GetRealNameTable]
(
   @DataSource BIGINT,
   @Table     BIGINT   	
)
RETURNS VARCHAR(52)
AS
BEGIN
	DECLARE @DSTYPE SMALLINT;
	SELECT @DSTYPE = DatabaseServer FROM Report.DataSource WHERE ID = @DataSource;
	DECLARE @TAB VARCHAR(50);
	
	SELECT @TAB = COALESCE(RealName, TitleEn) FROM Report.TableUsage WHERE ID = @Table
	
	IF(@DSTYPE = 0)
	BEGIN	   
	   RETURN '"' + (@TAB) + '"';
	END
	ELSE IF(@DSTYPE = 1)
	BEGIN	   
	   RETURN '[' + (@TAB) + ']';
	END
	
	RETURN '';
END
GO
