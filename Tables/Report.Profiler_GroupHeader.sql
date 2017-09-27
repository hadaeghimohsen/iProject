CREATE TABLE [Report].[Profiler_GroupHeader]
(
[ProfilerID] [bigint] NOT NULL,
[GroupHeaderID] [bigint] NOT NULL,
[RoleID] [bigint] NOT NULL,
[DataSourceID] [bigint] NOT NULL,
[OrderIndex] [int] NOT NULL,
[DatasourceFrom] [smallint] NOT NULL CONSTRAINT [DF__Profiler___Datas__0A888742] DEFAULT ((1)),
[DatasourceType] [bit] NOT NULL CONSTRAINT [DF__Profiler___Datas__0B7CAB7B] DEFAULT ((1)),
[IsVisible] [bit] NOT NULL CONSTRAINT [DF_Profiler_GroupHeader_IsVisible] DEFAULT ('true'),
[IsActive] [bit] NOT NULL CONSTRAINT [DF_Profiler_GroupHeader_IsActive] DEFAULT ('true')
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
CREATE TRIGGER [Report].[Profiler_GroupHeader_AfterUpdate]
   ON  [Report].[Profiler_GroupHeader]
   AFTER UPDATE
AS 
BEGIN
	MERGE Report.Filter FT
	USING (
	   SELECT 
	      GroupHeaderID,
	      RoleID,
	      DataSourceID
	   FROM inserted 
	) FS
	ON (FT.GroupHeaderID = FS.GroupHeaderID AND FT.RoleID = FS.RoleID)
	WHEN MATCHED THEN
	   UPDATE SET DataSourceID = FS.DataSourceID;

END
GO
ALTER TABLE [Report].[Profiler_GroupHeader] ADD CONSTRAINT [PK__Profiler__4D1F51852FEF161B] PRIMARY KEY CLUSTERED  ([ProfilerID], [GroupHeaderID], [RoleID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [Profiler_GroupHeader_GroupHeaderID] ON [Report].[Profiler_GroupHeader] ([GroupHeaderID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [Profiler_GroupHeader_ProfilerID] ON [Report].[Profiler_GroupHeader] ([ProfilerID]) ON [PRIMARY]
GO
ALTER TABLE [Report].[Profiler_GroupHeader] ADD CONSTRAINT [FK_Profile_Role_GroupHeader] FOREIGN KEY ([RoleID], [GroupHeaderID]) REFERENCES [Report].[Role_GroupHeader] ([RoleID], [GroupHeaderID]) ON DELETE CASCADE ON UPDATE CASCADE
GO
ALTER TABLE [Report].[Profiler_GroupHeader] ADD CONSTRAINT [FK_Profiler_GroupHeader__DataSource] FOREIGN KEY ([DataSourceID]) REFERENCES [Report].[DataSource] ([ID])
GO
ALTER TABLE [Report].[Profiler_GroupHeader] ADD CONSTRAINT [FK_Profiler_GroupHeader__Profiler] FOREIGN KEY ([ProfilerID]) REFERENCES [Report].[Profiler] ([ID])
GO
EXEC sp_addextendedproperty N'MS_Description', N'1 - GroupHeader Datasource
2 - Profiler Datasource
3 - Self Define ', 'SCHEMA', N'Report', 'TABLE', N'Profiler_GroupHeader', 'COLUMN', N'DatasourceFrom'
GO
EXEC sp_addextendedproperty N'MS_Description', N'1 - Copy Datasource Link
2 - Ref Datasource Link', 'SCHEMA', N'Report', 'TABLE', N'Profiler_GroupHeader', 'COLUMN', N'DatasourceType'
GO
