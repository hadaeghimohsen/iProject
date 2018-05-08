SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [Global].[Compare_Duplicate_Localization]
   @X XML
AS 
BEGIN
   DECLARE @SubSys INT
          ,@SourceLocalizationId BIGINT
          ,@SourceFormId BIGINT
          ,@SourceFormName VARCHAR(250)
          ,@TargetLocalizationRegion VARCHAR(3)
          ,@TargetLocalizationId BIGINT
          ,@FaName NVARCHAR(250)
          ,@EnName VARCHAR(250)
          ,@TargetFormId BIGINT
          ,@TargetName NVARCHAR(50)
          ,@TargetLablText NVARCHAR(100)
          ,@TargetToolTip NVARCHAR(100)
          ,@TargetPlacHldrText NVARCHAR(100)
          ,@TargetCntlType VARCHAR(3)
          ,@TargetStat VARCHAR(3)
          ,@TargetFormControlId BIGINT;
   
   SELECT @SubSys = @X.query('.').value('(Localization/@subsys)[1]', 'INT')
         ,@SourceLocalizationId = @X.query('.').value('(Localization/@sorclcid)[1]', 'BIGINT')
         ,@SourceFormId = @X.query('.').value('(Localization/@sorcfmid)[1]', 'BIGINT')
         ,@TargetLocalizationRegion = @X.query('.').value('(Localization/@trgtlcalregn)[1]', 'VARCHAR(3)');
   
   -- ثبت گزینه منطقه برای زیر سیستم
   IF NOT EXISTS(
      SELECT *
        FROM Global.Localization
       WHERE SUB_SYS = @SubSys
         AND REGN_LANG = @TargetLocalizationRegion
   )
   BEGIN
      INSERT INTO Global.Localization
              ( LCID ,
                SUB_SYS ,
                REGN_LANG 
              )
      VALUES  ( 0 , -- LCID - bigint
                @SubSys , -- SUB_SYS - int
                @TargetLocalizationRegion  -- REGN_LANG - varchar(3)
              );      
   END;
   
   SELECT @TargetLocalizationId = LCID
     FROM Global.Localization
    WHERE SUB_SYS = @SubSys
      AND REGN_LANG = @TargetLocalizationRegion;   
   
   DECLARE C$SORCFORM CURSOR FOR
      SELECT ID, FA_NAME, EN_NAME
        FROM Global.Form
       WHERE LCAL_LCID = @SourceLocalizationId;
   
   OPEN [C$SORCFORM];
   L$LOOPSORCFORM:
   FETCH [C$SORCFORM] INTO @SourceFormId, @FaName, @EnName;
   
   IF @@FETCH_STATUS <> 0
      GOTO L$ENDLOOPSORCFORM;
   
   IF NOT EXISTS(
      SELECT *
        FROM Global.Form
       WHERE LCAL_LCID = @TargetLocalizationId
         AND SUB_SYS = @SubSys
         AND EN_NAME = @EnName
   )
   BEGIN   
      INSERT INTO Global.Form
              ( LCAL_LCID ,
                ID ,
                SUB_SYS ,
                FA_NAME ,
                EN_NAME 
              )
      VALUES  ( @TargetLocalizationId , -- LCAL_LCID - bigint
                0 , -- ID - bigint
                @SubSys , -- SUB_SYS - int
                @FaName , -- FA_NAME - nvarchar(250)
                @EnName  -- EN_NAME - varchar(250)
              );
   END;
   
   SELECT @TargetFormId = ID
     FROM Global.Form
    WHERE LCAL_LCID = @TargetLocalizationId
      AND SUB_SYS = @SubSys
      AND EN_NAME = @EnName;
   
   DECLARE C$SORCFCNT CURSOR FOR
      SELECT NAME, LABL_TEXT, TOOL_TIP_TEXT, PLAC_HLDR_TEXT, CNTL_TYPE, STAT
        FROM Global.Form_Controls
       WHERE FORM_ID = @SourceFormId;         
   
   OPEN [C$SORCFCNT];
   L$LOOPSORCFCNT:
   FETCH [C$SORCFCNT] INTO @TargetName, @TargetLablText, @TargetToolTip, @TargetPlacHldrText, @TargetCntlType, @TargetStat;
   
   IF @@FETCH_STATUS <> 0
      GOTO L$ENDLOOPSORCFCNT;
   
   IF NOT EXISTS(
      SELECT *
        FROM Global.Form_Controls
       WHERE FORM_ID = @TargetFormId
         AND NAME = @TargetName
   )
   BEGIN
      INSERT INTO Global.Form_Controls
              ( FORM_ID ,
                ID ,
                NAME ,
                LABL_TEXT ,
                TOOL_TIP_TEXT ,
                PLAC_HLDR_TEXT ,
                CNTL_TYPE ,
                STAT
              )
      VALUES  ( @TargetFormId , -- FORM_ID - bigint
                0 , -- ID - bigint
                @TargetName , -- NAME - varchar(50)
                @TargetLablText , -- LABL_TEXT - nvarchar(100)
                @TargetToolTip , -- TOOL_TIP_TEXT - nvarchar(100)
                @TargetPlacHldrText , -- PLAC_HLDR_TEXT - nvarchar(100)
                @TargetCntlType , -- CNTL_TYPE - varchar(3)
                @TargetStat  -- STAT - varchar(3)
              );
   END
   
   SELECT @TargetFormControlId = ID
     FROM Global.Form_Controls
    WHERE FORM_ID = @TargetFormId
      AND NAME = @TargetName;
   
   UPDATE Global.Form_Controls
      SET CNTL_TYPE = @TargetCntlType
         ,STAT = @TargetStat
    WHERE ID = @TargetFormControlId;
   
   GOTO L$LOOPSORCFCNT;
   L$ENDLOOPSORCFCNT:
   CLOSE [C$SORCFCNT];
   DEALLOCATE [C$SORCFCNT];
   
   
   GOTO L$LOOPSORCFORM;
   L$ENDLOOPSORCFORM:
   CLOSE [C$SORCFORM];
   DEALLOCATE [C$SORCFORM];
END;
GO
