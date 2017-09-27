CREATE TABLE [Report].[Schemas]
(
[ID] [bigint] NOT NULL CONSTRAINT [DF_Schemas_ID] DEFAULT ([dbo].[GetNewIdentity]()),
[ShortCut] [int] NULL,
[TitleFa] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[TitleEn] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[IsVisible] [bit] NULL CONSTRAINT [DF_Schemas_IsVisible] DEFAULT ('TRUE'),
[IsActive] [bit] NULL CONSTRAINT [DF_Schemas_IsActive] DEFAULT ('TRUE')
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
CREATE TRIGGER [Report].[Schemas_AfterUpdate]
   ON  [Report].[Schemas]
   AFTER UPDATE
AS 
BEGIN
	MERGE Report.Filter FT
	USING (
	   SELECT ID,
	          TitleEn
	   FROM inserted
	) FS
	ON (FT.[SchemaID] = FS.[ID])
	WHEN MATCHED THEN
	   UPDATE SET [Schemas] = FS.TitleEn;
END
GO
ALTER TABLE [Report].[Schemas] ADD CONSTRAINT [PK_Schemas_ID] PRIMARY KEY CLUSTERED  ([ID]) ON [PRIMARY]
GO
