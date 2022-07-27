SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[EXEC_JOBS_P]
	-- Add the parameters for the stored procedure here
	@X XML
AS
BEGIN
	Print 'iProject Job Run OK';
END
GO
