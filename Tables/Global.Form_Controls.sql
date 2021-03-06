CREATE TABLE [Global].[Form_Controls]
(
[FORM_ID] [bigint] NULL,
[ID] [bigint] NOT NULL,
[NAME] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[LABL_TEXT] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[TOOL_TIP_TEXT] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PLAC_HLDR_TEXT] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CNTL_TYPE] [varchar] (3) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[STAT] [varchar] (3) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[TRAN_STAT] [varchar] (3) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
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
CREATE TRIGGER [Global].[CG$AINS_FCNT]
   ON  [Global].[Form_Controls]
   AFTER INSERT
AS 
BEGIN
   BEGIN TRY 
   BEGIN TRAN T_AINS_FCNT
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
   
   IF EXISTS(SELECT * FROM Global.Form_Controls t, Inserted s WHERE t.FORM_ID = s.FORM_ID AND t.NAME = s.NAME AND t.ID != s.ID)
   BEGIN
      RAISERROR(N'قبلا این کنترل در جدول برای این فرم ثبت شده است', 16, 1);
      RETURN;
   END   
   
   -- Insert statements for trigger here
   MERGE Global.Form_Controls T
   USING (SELECT * FROM Inserted) S
   ON (T.FORM_ID = S.FORM_ID AND
       T.ID = S.ID)
   WHEN MATCHED THEN
      UPDATE SET
         T.ID = CASE s.ID WHEN 0 THEN dbo.GetNewVerIdentity() ELSE s.ID END;
   
   COMMIT TRAN T_AINS_FCNT;
   END TRY
   BEGIN CATCH
      ROLLBACK TRAN T_AINS_FCNT;
   END CATCH;
   
END
GO
ALTER TABLE [Global].[Form_Controls] ADD CONSTRAINT [PK_FMCL] PRIMARY KEY CLUSTERED  ([ID]) ON [PRIMARY]
GO
ALTER TABLE [Global].[Form_Controls] ADD CONSTRAINT [FK_FROM_FMCL] FOREIGN KEY ([FORM_ID]) REFERENCES [Global].[Form] ([ID]) ON DELETE CASCADE ON UPDATE CASCADE
GO
