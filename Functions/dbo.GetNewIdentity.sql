SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE FUNCTION [dbo].[GetNewIdentity] ()
RETURNS bigint
WITH EXEC AS CALLER
AS
BEGIN
Declare @ResultNewIdentity Bigint;
Set @ResultNewIdentity =  Convert(Bigint, Replace(Replace(Replace(dbo.GetCurDateTimeDetail(),'/',''),':',''), ' ', ''));
Return @ResultNewIdentity;
END
GO
