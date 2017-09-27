SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date, ,>
-- Description:	<Description, ,>
-- =============================================
CREATE FUNCTION [Report].[RankingFilter]
(
	@Filter BIGINT
)
RETURNS INT
AS
BEGIN
	DECLARE @HAC   SMALLINT /* High Access Control */
	       ,@MS    BIT      /* Multi Selected */
	       ,@HDV   BIT      /* Has Default Value */
	       ,@AFR   BIT      /* All Fetch Rows */
	       ,@RC    BIGINT   /* Row Count */
	       ,@HWC   BIT      /* Has Where Clause */
	       ,@HML   BIT      /* Has Max Len */
	       ,@ML    INT      /* Max Len */
	       ,@HNP   BIT      /* Has Number Point */
	       ,@MNP   INT      /* Max Number Point */
	       ,@HMAXV BIT      /* Has Max Value */
	       ,@HMINV BIT      /* Has Min Value */
	       ,@EMM   BIT      /* Effect Min Max */
   
   SELECT
      @HAC   = HighAccessControl,
      @MS    = MultiSelected,
      @HDV   = HasDefaultValue,
      @AFR   = AllFetchRows,
      @RC    = [RowCount],
      @HWC   = HasWhereClause,
      @HML   = HasMaxLen,
      @ML    = MaxLen,
      @HNP   = HasNumberPoint,
      @MNP   = MaxNumberPoint,
      @HMAXV = HasMaxValue,
      @HMINV = HasMinValue,
      @EMM   = EffectMinMax
   FROM Report.Filter
   WHERE ID = @Filter;

   RETURN 
      (@MS)
     +-1*(
     +(@Hac)  
     --+(@Hac) * (@HDV * (SELECT COUNT(*) FROM Report.DefaultValues WHERE FilterID = @Filter)) -- (+)
     --+(~@AFR * @RC) -- (+)
     +(@HWC)        -- (-)
     --+(@HML * @ML)  -- (-)
     --+(@HNP * @MNP) -- (-)
     +(@HMAXV)      -- (-)
     +(@HMINV)      -- (-)
     +(@EMM) );     -- (-)
END
GO
