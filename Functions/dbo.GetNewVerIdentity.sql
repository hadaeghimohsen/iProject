SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE FUNCTION [dbo].[GetNewVerIdentity] ()
RETURNS bigint
--WITH EXEC AS CALLER
AS
BEGIN
   Declare @ResultNewIdentity Bigint;
   Set @ResultNewIdentity =  Convert(Bigint, Replace(Replace(Replace(dbo.GetCurDateTimeDetail(),'/',''),':',''), ' ', '') + CAST(DATEPART(ms, GETDATE()) AS VARCHAR(3)));
   Return @ResultNewIdentity;
END
GO
