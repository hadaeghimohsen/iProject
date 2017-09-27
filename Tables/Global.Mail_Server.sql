CREATE TABLE [Global].[Mail_Server]
(
[MSID] [bigint] NOT NULL IDENTITY(1, 1),
[EMAL_SRVR_NAME] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[EMAL_SRVR] [varchar] (3) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[IMAP_ADRS] [varchar] (250) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[IMAP_PORT] [int] NULL,
[IMAP_SSL_MODE] [varchar] (3) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SMTP_ADRS] [varchar] (250) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SMTP_PORT] [int] NULL,
[SMTP_SSL_MODE] [varchar] (3) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SMTP_DLVR_MTOD] [varchar] (3) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SMTP_TIME_OUT] [int] NULL,
[MAIL_SCAL] [varchar] (3) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
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
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE TRIGGER [Global].[CG$AINS_MLSR]
   ON  [Global].[Mail_Server]
   AFTER INSERT
AS 
BEGIN
	
	MERGE Global.Mail_Server T
	USING (SELECT * FROM Inserted) S
	ON (T.MSID = S.MSID)
	WHEN MATCHED THEN
	   UPDATE SET
	          T.CRET_BY = UPPER(SUSER_NAME())
	         ,T.CRET_DATE = GETDATE();	

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
CREATE TRIGGER [Global].[CG$AUPD_MLSR]
   ON  [Global].[Mail_Server]
   AFTER UPDATE
AS 
BEGIN
	
	MERGE Global.Mail_Server T
	USING (SELECT * FROM Inserted) S
	ON (T.MSID = S.MSID)
	WHEN MATCHED THEN
	   UPDATE SET
	          T.MDFY_BY = UPPER(SUSER_NAME())
	         ,T.MDFY_DATE = GETDATE();	

END
GO
ALTER TABLE [Global].[Mail_Server] ADD CONSTRAINT [PK_Mail_Server] PRIMARY KEY CLUSTERED  ([MSID]) ON [PRIMARY]
GO
