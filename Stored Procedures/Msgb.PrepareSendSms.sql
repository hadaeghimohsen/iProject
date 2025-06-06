SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [Msgb].[PrepareSendSms]
	-- Add the parameters for the stored procedure here
    @X XML
AS
BEGIN
    BEGIN TRY 
        BEGIN TRAN T_PrepareSendSms;
	      -- در اینجا باید چک کنیم که قبلا برای شماره تلفن مورد نظر 
	      -- پیام قبلا در این روز ارسال نشده است که جلو دوباره کاری را بگیریم
	      /*
	      <Process>
	         <Contacts subsys="" linetype="">
	            <Contact phonnumb="">
	               <Message type="">TextMessage</Message>
	            </Contact>
	         </Contacts>
	      </Process>
	      */
        DECLARE @docHandle INT;	
        EXEC sp_xml_preparedocument @docHandle OUTPUT, @X;
	
        DECLARE C$PrepareSendSms CURSOR
        FOR
        SELECT  *
        FROM    OPENXML(@docHandle, N'//Contact')
	     WITH (
	        Sub_Sys SMALLINT '../../Contacts/@subsys',
	        Line_Type VARCHAR(3) '../../Contacts/@linetype',
	        Phon_Numb VARCHAR(11) './@phonnumb',
	        Chat_Id BIGINT './@chatid',
	        Msgb_Text NVARCHAR(MAX) './Message/.',
	        Msgb_Type VARCHAR(3) './Message/@type',
	        Rfid BIGINT './Message/@rfid',
	        ActnDate DATETIME './Message/@actndate',
	        SendType VARCHAR(3) './Message/@sendtype',
	        ScdlDate DATETIME './Message/@scdldate',
	        BtchNumb INT './Message/@btchdate',
	        StepMin INT './Message/@stepmin'
	     );
	
        DECLARE @SubSys SMALLINT ,
            @LineType VARCHAR(3) ,
            @PhonNumb VARCHAR(11) ,
            @ChatId BIGINT,
            @MsgbText NVARCHAR(MAX) ,
            @MsgbType VARCHAR(3) ,
            @Rfid BIGINT ,
            @ActnDate DATETIME ,
            @SendType VARCHAR(3),
            @ScdlDate DATETIME,
            @BtchNumb INT,
            @StepMin INT,
            @i INT = 0,
            @Xtemp XML;
	
        OPEN C$PrepareSendSms;
        LOOP_C$PrepareSendSms:
        FETCH NEXT FROM C$PrepareSendSms INTO @SubSys, @LineType, @PhonNumb, @ChatId,
            @MsgbText, @MsgbType, @Rfid, @ActnDate, @SendType, @ScdlDate,
            @BtchNumb, @StepMin;
	      
        IF @@FETCH_STATUS <> 0
            GOTO ENDLOOP_C$PrepareSendSms;	
	
        IF @PhonNumb IS NULL
            GOTO LOOP_C$PrepareSendSms;
        
        -- 1403/06/03 * IF EXISTS Grouping Permission CANNOT SEND SMS
        IF @SubSys = 5 /* Arta System */ AND
           EXISTS (
                SELECT *
                  FROM iScsc.dbo.Fighter f,
                       iScsc.dbo.Fighter_Grouping fg,
                       iScsc.dbo.Fighter_Grouping_Permission gp
                 WHERE f.FILE_NO = fg.FIGH_FILE_NO
                   AND fg.CODE = gp.FGRP_CODE
                   AND @PhonNumb IN (f.CELL_PHON_DNRM)
                   AND fg.GROP_STAT = '002'
                   AND gp.PERM_TYPE = '004' -- SMS
                   AND gp.PERM_STAT = '001' -- NO PERMISSION
           )
        BEGIN
           -- 1403/06/03 * Save log in db for not save and send sms for customer
           SET @Xtemp = (
              SELECT TOP 1 
                     f.FILE_NO AS '@fileno',
                     '017' AS '@type',
                     @MsgbText AS '@text'
                FROM iScsc.dbo.Fighter f,
                     iScsc.dbo.Fighter_Grouping fg,
                     iScsc.dbo.Fighter_Grouping_Permission gp
               WHERE f.FILE_NO = fg.FIGH_FILE_NO
                 AND fg.CODE = gp.FGRP_CODE
                 AND @PhonNumb IN (f.CELL_PHON_DNRM)
                 AND fg.GROP_STAT = '002'
                 AND gp.PERM_TYPE = '004' -- SMS
                 AND gp.PERM_STAT = '001' -- NO PERMISSION
                 FOR XML PATH('Log'));              
           EXEC iScsc.dbo.INS_LGOP_P @X = @Xtemp -- xml
           
           GOTO LOOP_C$PrepareSendSms;
        END
        
        -- 1398/07/05 * زمان بندی کردن پیامکهای ارسالی
        IF NOT EXISTS ( SELECT  *
                        FROM    Msgb.Sms_Message_Box
                        WHERE   SUB_SYS = @SubSys
                                AND CAST(ACTN_DATE AS DATE) = CAST(ISNULL(@ActnDate,
                                                              GETDATE()) AS DATE)
                                AND @PhonNumb = PHON_NUMB
                                AND RFID = @Rfid
                                AND @MsgbType = MSGB_TYPE
                                AND STAT IN ( '001', '002' )
                                AND LINE_TYPE = @LineType )
        BEGIN
            INSERT  INTO Msgb.Sms_Message_Box
                    (
                      SUB_SYS ,
                      LINE_TYPE ,
                      PHON_NUMB ,
                      CHAT_ID,
                      MSGB_TEXT ,
                      MSGB_TYPE ,
                      STAT ,
                      RFID ,
                      ACTN_DATE ,
                      SEND_TYPE
	                 )
            VALUES  (
                      @SubSys , -- SUB_SYS - smallint
                      @LineType , -- Line_Type
                      @PhonNumb , -- PHON_NUMB - varchar(11)
                      @ChatId , -- CHAT_ID
                      @MsgbText , -- MSGB_TEXT - nvarchar(max)
                      @MsgbType , -- MSGB_TYPE - varchar(3)
                      '001' ,
                      @Rfid ,
                      @ActnDate ,
                      @SendType
	                 );
        END;
	
        GOTO LOOP_C$PrepareSendSms;
        ENDLOOP_C$PrepareSendSms:
        CLOSE C$PrepareSendSms;
        DEALLOCATE C$PrepareSendSms;
	
        EXEC sp_xml_removedocument @docHandle;  
	
        COMMIT TRAN T_PrepareSendSms;
    END TRY
    BEGIN CATCH
        IF ( SELECT CURSOR_STATUS('local', 'C$PrepareSendSms')
           ) >= -1
        BEGIN
            IF ( SELECT CURSOR_STATUS('local', 'C$PrepareSendSms')
               ) > -1
            BEGIN
                CLOSE C$PrepareSendSms;
            END;
            DEALLOCATE C$PrepareSendSms;
        END;

        DECLARE @ErrorMessage NVARCHAR(MAX);
        SET @ErrorMessage = ERROR_MESSAGE();
        RAISERROR ( @ErrorMessage, -- Message text.
               16, -- Severity.
               1 -- State.
               );
        ROLLBACK TRAN T_PrepareSendSms;
    END CATCH;	
END;
GO
