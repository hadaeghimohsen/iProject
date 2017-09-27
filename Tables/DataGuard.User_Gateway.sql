CREATE TABLE [DataGuard].[User_Gateway]
(
[GTWY_MAC_ADRS] [varchar] (17) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[USER_ID] [bigint] NOT NULL,
[RWNO] [int] NOT NULL,
[VALD_TYPE] [varchar] (3) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[CRET_BY] [varchar] (250) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CRET_DATE] [datetime] NULL,
[MDFY_BY] [varchar] (250) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[MDFY_DATE] [datetime] NULL
) ON [PRIMARY]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [DataGuard].[CG$AINS_USGW]
   ON  [DataGuard].[User_Gateway]
   AFTER INSERT
AS 
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
   
   -- Insert statements for trigger here
   MERGE [DataGuard].[User_Gateway] T
   USING (SELECT * FROM INSERTED) S
   ON (T.GTWY_MAC_ADRS = S.GTWY_MAC_ADRS AND
       T.USER_ID       = S.USER_ID AND
       T.VALD_TYPE     = S.VALD_TYPE)
   WHEN MATCHED THEN
      UPDATE
         SET CRET_BY   = UPPER(SUSER_NAME())
            ,CRET_DATE = GETDATE()
            ,RWNO      = (SELECT ISNULL(MAX(RWNO), 0) + 1 FROM DataGuard.User_Gateway WHERE GTWY_MAC_ADRS = S.GTWY_MAC_ADRS AND USER_ID = S.USER_ID);
END
;
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [DataGuard].[CG$AUPD_USGW]
   ON  [DataGuard].[User_Gateway]
   AFTER UPDATE
AS 
BEGIN
   BEGIN TRY
      BEGIN TRAN CG$AUPD_USGW_T
	      -- SET NOCOUNT ON added to prevent extra result sets from
	      -- interfering with SELECT statements.
	      SET NOCOUNT ON;

         -- Insert statements for trigger here
         MERGE [DataGuard].[User_Gateway] T
         USING (SELECT * FROM INSERTED) S
         ON (T.GTWY_MAC_ADRS = S.GTWY_MAC_ADRS AND
             T.USER_ID       = S.USER_ID       AND
             T.RWNO          = S.RWNO)
         WHEN MATCHED THEN
            UPDATE
               SET MDFY_BY   = UPPER(SUSER_NAME())
                  ,MDFY_DATE = GETDATE();
         
         DECLARE C$User_Gateway CURSOR FOR
            SELECT GTWY_MAC_ADRS, USER_ID, RWNO FROM INSERTED WHERE VALD_TYPE = '002';
         
         DECLARE @GTWY_MAC_ADRS VARCHAR(17)
                ,@USER_ID BIGINT
                ,@RWNO INT;          
         
         OPEN C$User_Gateway;
         L$NextRowUSGW:
         FETCH NEXT FROM C$User_Gateway INTO @GTWY_MAC_ADRS, @USER_ID, @RWNO;
         IF @@FETCH_STATUS <> 0
            GOTO L$EndFetchUSGW;
         
         IF EXISTS(
            SELECT * 
              FROM DataGuard.Package_Instance_User_Gateway piug  
             WHERE piug.USGW_GTWY_MAC_ADRS = @GTWY_MAC_ADRS
               AND piug.USGW_USER_ID = @USER_ID
               AND piug.STAT = '002'
         )
         BEGIN
            DECLARE C$Package_Instance_User_Gateway CURSOR FOR
               SELECT PKIN_PAKG_SUB_SYS
                     ,PKIN_PAKG_CODE
                     ,PKIN_RWNO
                     ,USGW_RWNO
                 FROM DataGuard.Package_Instance_User_Gateway piug  
                WHERE piug.USGW_GTWY_MAC_ADRS = @GTWY_MAC_ADRS
                  AND piug.USGW_USER_ID = @USER_ID
                  AND piug.USGW_RWNO <> @RWNO
                  AND piug.STAT = '002';
            
            DECLARE @PKIN_PAKG_SUB_SYS INT
                   ,@PKIN_PAKG_CODE VARCHAR(3)
                   ,@PKIN_RWNO INT
                   ,@USGW_RWNO INT;
            
            OPEN C$Package_Instance_User_Gateway;
            L$NextRowUSGWPIUG:
            FETCH NEXT FROM C$Package_Instance_User_Gateway INTO @PKIN_PAKG_SUB_SYS, @PKIN_PAKG_CODE, @PKIN_RWNO, @USGW_RWNO;
            IF @@FETCH_STATUS <> 0
               GOTO L$EndFetchUSGWPIUG;
            
            UPDATE DataGuard.Package_Instance_User_Gateway 
               SET STAT = '001'
             WHERE PKIN_PAKG_SUB_SYS = @PKIN_PAKG_SUB_SYS
               AND PKIN_PAKG_CODE = @PKIN_PAKG_CODE
               AND PKIN_RWNO = @PKIN_RWNO
               AND USGW_GTWY_MAC_ADRS = @GTWY_MAC_ADRS
               AND USGW_USER_ID = @USER_ID
               AND USGW_RWNO = @USGW_RWNO
               AND STAT = '002';
            
            INSERT INTO DataGuard.Package_Instance_User_Gateway (PKIN_PAKG_SUB_SYS, PKIN_PAKG_CODE, PKIN_RWNO, USGW_GTWY_MAC_ADRS, USGW_USER_ID, USGW_RWNO, STAT)
            VALUES (@PKIN_PAKG_SUB_SYS, @PKIN_PAKG_CODE, @PKIN_RWNO, @GTWY_MAC_ADRS, @USER_ID, @RWNO, '002');
            
            GOTO L$NextRowUSGWPIUG;
            L$EndFetchUSGWPIUG:
            CLOSE C$Package_Instance_User_Gateway;
            DEALLOCATE C$Package_Instance_User_Gateway;
         END
            
         GOTO L$NextRowUSGW;
         L$EndFetchUSGW:
         CLOSE C$User_Gateway;
         DEALLOCATE C$User_Gateway;
      
      COMMIT TRAN CG$AUPD_USGW_T;
      
      END TRY
      BEGIN CATCH
         DECLARE @ErrorMessage NVARCHAR(MAX);
         SET @ErrorMessage = ERROR_MESSAGE();
         RAISERROR ( @ErrorMessage, -- Message text.
                  16, -- Severity.
                  1 -- State.
                  );
         ROLLBACK TRAN CG$AUPD_USGW_T;         
      END CATCH;
END
;
GO
ALTER TABLE [DataGuard].[User_Gateway] ADD CONSTRAINT [PK_USGW] PRIMARY KEY CLUSTERED  ([GTWY_MAC_ADRS], [USER_ID], [RWNO]) ON [PRIMARY]
GO
ALTER TABLE [DataGuard].[User_Gateway] ADD CONSTRAINT [FK_USGW_GTWY] FOREIGN KEY ([GTWY_MAC_ADRS]) REFERENCES [DataGuard].[Gateway] ([MAC_ADRS])
GO
ALTER TABLE [DataGuard].[User_Gateway] ADD CONSTRAINT [FK_USGW_USER] FOREIGN KEY ([USER_ID]) REFERENCES [DataGuard].[User] ([ID]) ON DELETE CASCADE
GO
