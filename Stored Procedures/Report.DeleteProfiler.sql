SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [Report].[DeleteProfiler]
	-- Add the parameters for the stored procedure here
	@XML XML
AS
BEGIN
	UPDATE Report.Role_Profiler
	SET IsVisible = 0,
	    IsActive  = 0
	WHERE RoleID = @XML.query('//Role').value('.', 'BIGINT')
	  AND EXISTS ( SELECT * FROM @XML.nodes('//Profilers/Profiler')t(p) WHERE ProfilerID = p.query('.').value('.', 'BIGINT') );
END
GO
