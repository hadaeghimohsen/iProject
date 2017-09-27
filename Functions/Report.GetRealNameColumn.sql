SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date, ,>
-- Description:	<Description, ,>
-- =============================================
CREATE FUNCTION [Report].[GetRealNameColumn]
(
   @DataSource BIGINT,
   @Column     BIGINT   	
)
RETURNS VARCHAR(52)
AS
BEGIN
	DECLARE @DSTYPE SMALLINT;
	SELECT @DSTYPE = DatabaseServer FROM Report.DataSource WHERE ID = @DataSource;
	DECLARE @COL VARCHAR(50);
	
	SELECT @COL = CodeEnName FROM Report.ColumnUsage WHERE ID = @Column
	
	IF(@DSTYPE = 0)
	BEGIN	   
	   RETURN '"' + (@COL) + '"';
	END
	ELSE IF(@DSTYPE = 1)
	BEGIN	   
	   RETURN '[' + (@COL) + ']';
	END
	
	RETURN '';
END
GO
