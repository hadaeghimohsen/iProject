CREATE TABLE [DataGuard].[User_Finger]
(
[USER_ID] [bigint] NULL,
[CODE] [bigint] NOT NULL,
[FNGR_INDX] [smallint] NULL,
[IMAG] [image] NULL,
[FNGR_TMPL] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CRET_BY] [varchar] (250) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CRET_DATE] [datetime] NULL,
[MDFY_BY] [varchar] (250) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[MDFY_DATE] [datetime] NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE TRIGGER [DataGuard].[CG$AINS_USRF]
   ON  [DataGuard].[User_Finger]
   AFTER INSERT
AS 
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for trigger here
   MERGE DataGuard.User_Finger T
   USING (SELECT s.USER_ID, s.FNGR_INDX, s.CODE FROM Inserted s ) S
   ON (T.USER_ID = S.USER_ID AND
       T.FNGR_INDX = S.FNGR_INDX AND 
       T.CODE = S.CODE)
   WHEN MATCHED THEN
      UPDATE SET 
         T.CRET_BY = UPPER(SUSER_NAME())
        ,t.CRET_DATE = GETDATE()
        ,T.CODE = CASE s.CODE WHEN 0 THEN dbo.GNRT_NVID_U() ELSE s.CODE END;
END
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE TRIGGER [DataGuard].[CG$AUPD_USRF]
   ON  [DataGuard].[User_Finger]
   AFTER UPDATE   
AS 
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for trigger here
   MERGE DataGuard.User_Finger T
   USING (SELECT s.CODE FROM Inserted s ) S
   ON (T.CODE = S.CODE)
   WHEN MATCHED THEN
      UPDATE SET 
         T.MDFY_BY = UPPER(SUSER_NAME())
        ,t.MDFY_DATE = GETDATE();
END
GO
ALTER TABLE [DataGuard].[User_Finger] ADD CONSTRAINT [PK_User_Finger] PRIMARY KEY CLUSTERED  ([CODE]) ON [PRIMARY]
GO
ALTER TABLE [DataGuard].[User_Finger] ADD CONSTRAINT [FK_USRF_USER] FOREIGN KEY ([USER_ID]) REFERENCES [DataGuard].[User] ([ID]) ON DELETE CASCADE
GO
