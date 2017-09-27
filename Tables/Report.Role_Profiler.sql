CREATE TABLE [Report].[Role_Profiler]
(
[ProfilerID] [bigint] NULL,
[RoleID] [bigint] NULL,
[IsVisible] [bit] NULL CONSTRAINT [DF_Role_Profiler_IsVisible] DEFAULT ('true'),
[IsActive] [bit] NULL CONSTRAINT [DF_Role_Profiler_IsActive] DEFAULT ('true')
) ON [PRIMARY]
GO
ALTER TABLE [Report].[Role_Profiler] ADD CONSTRAINT [FK_Role_Profiler_Profiler] FOREIGN KEY ([ProfilerID]) REFERENCES [Report].[Profiler] ([ID])
GO
ALTER TABLE [Report].[Role_Profiler] ADD CONSTRAINT [FK_Role_Profiler_Role] FOREIGN KEY ([RoleID]) REFERENCES [DataGuard].[Role] ([ID]) ON DELETE CASCADE ON UPDATE CASCADE
GO
