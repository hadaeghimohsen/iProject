SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [Msgb].[PrepareSendCustSms]
	@X XML
AS
BEGIN
	IF EXISTS (SELECT name FROM sys.databases WHERE name = N'iScsc')
   BEGIN
      EXEC iScsc.dbo.CRET_CSMS_P @X = '<Process />';
   END
END
GO
