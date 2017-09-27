SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [Report].[UnDeleteProfiler]
	-- Add the parameters for the stored procedure here
	@XML XML
AS
BEGIN
	UPDATE Report.Role_Profiler
	SET IsVisible = 1,
	    IsActive  = 1
	WHERE RoleID = @XML.query('//Role').value('.', 'BIGINT')
	  AND EXISTS ( SELECT * FROM @XML.nodes('//Profilers/Profiler')t(p) WHERE ProfilerID = p.query('.').value('.', 'BIGINT') );
END
GO
