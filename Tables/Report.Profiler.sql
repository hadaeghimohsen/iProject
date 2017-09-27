CREATE TABLE [Report].[Profiler]
(
[ID] [bigint] NOT NULL CONSTRAINT [DF_Profiler_ID] DEFAULT ([dbo].[GetNewIdentity]()),
[ShortCut] [bigint] NULL,
[TitleFa] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[TitleEn] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DataSourceID] [bigint] NULL,
[IsVisible] [bit] NULL CONSTRAINT [DF_Profiler_IsVisible_1] DEFAULT ('true'),
[IsActive] [bit] NULL CONSTRAINT [DF_Profiler_IsActive_1] DEFAULT ('true')
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
CREATE TRIGGER [Report].[Profiler_AfterUpdate]
   ON  [Report].[Profiler]
   AFTER UPDATE
AS 
BEGIN
	MERGE Report.Profiler_GroupHeader PGT
	USING (
	   SELECT 
	      ID AS ProfilerID,
	      DataSourceID
	   FROM inserted 
	) PS
	ON (PGT.ProfilerID = PS.ProfilerID AND PGT.DataSourceFrom = 2 /* Profiler DataSource */ AND PGT.DataSourceType = 0 /* Ref Link */)
	WHEN MATCHED THEN
	   UPDATE SET DataSourceID = PS.DataSourceID;
END
GO
ALTER TABLE [Report].[Profiler] ADD CONSTRAINT [PK_Profiler] PRIMARY KEY CLUSTERED  ([ID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [Profiler_DataSourceID] ON [Report].[Profiler] ([DataSourceID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [Profiler_ID] ON [Report].[Profiler] ([ID]) ON [PRIMARY]
GO
ALTER TABLE [Report].[Profiler] ADD CONSTRAINT [FK_DataSource_Profiler] FOREIGN KEY ([DataSourceID]) REFERENCES [Report].[DataSource] ([ID])
GO
