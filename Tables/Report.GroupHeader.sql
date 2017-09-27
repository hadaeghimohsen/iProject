CREATE TABLE [Report].[GroupHeader]
(
[ID] [bigint] NOT NULL CONSTRAINT [DF_GroupHeader_ID] DEFAULT ([dbo].[GetNewIdentity]()),
[Shortcut] [bigint] NULL,
[TitleFa] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[TitleEn] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DataSourceID] [bigint] NOT NULL,
[IsActive] [bit] NULL CONSTRAINT [DF_GroupHeader_IsActive] DEFAULT ('true'),
[IsVisible] [bit] NULL CONSTRAINT [DF_GroupHeader_IsVisible] DEFAULT ('true')
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
CREATE TRIGGER [Report].[GroupHeader_AfterUpdate]
   ON  [Report].[GroupHeader]
   AFTER UPDATE
AS 
BEGIN
	/* UPDATE Profiler_GroupHeader */
	MERGE Report.Profiler_GroupHeader PGT
	USING (
	   SELECT
	      ID AS GroupHeaderID,
	      DataSourceID
	   FROM inserted
	) GS
	ON (PGT.GroupHeaderID = GS.GroupHeaderID AND PGT.DataSourceFrom = 1 /* GroupHeader DataSource */ AND PGT.DataSourceType = 2 /* Ref Link */)
	WHEN MATCHED THEN
	   UPDATE SET DataSourceID = GS.DataSourceID;
	
	/* UPDATE Filter */
	MERGE Report.Filter FT
	USING (
		SELECT g.ID, g.DataSourceID
		FROM inserted g
	) GS
	ON (FT.GroupHeaderID = GS.ID)
	WHEN MATCHED THEN
		UPDATE SET DataSourceID = GS.DataSourceID;
END
GO
ALTER TABLE [Report].[GroupHeader] ADD CONSTRAINT [PK__GroupHea__3214EC272C1E8537] PRIMARY KEY CLUSTERED  ([ID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [GroupHeader_ID] ON [Report].[GroupHeader] ([ID]) ON [PRIMARY]
GO
ALTER TABLE [Report].[GroupHeader] ADD CONSTRAINT [FK_GroupHeader__DataSource] FOREIGN KEY ([DataSourceID]) REFERENCES [Report].[DataSource] ([ID])
GO
