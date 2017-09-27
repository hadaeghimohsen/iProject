CREATE TABLE [Report].[ReportScript]
(
[ID] [bigint] NOT NULL IDENTITY(1, 1),
[ScriptID] [bigint] NOT NULL,
[ServiceID] [bigint] NOT NULL,
[ScriptFaName_Dnrm] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ScriptEnName_Dnrm] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[OrderIndex] [int] NULL,
[FaultTelorance] [bit] NULL,
[IsActive] [bit] NULL,
[IsVisible] [bit] NULL
) ON [PRIMARY]
GO
ALTER TABLE [Report].[ReportScript] ADD CONSTRAINT [PK__ReportSc__3214EC277C3A67EB] PRIMARY KEY CLUSTERED  ([ID]) ON [PRIMARY]
GO
CREATE UNIQUE NONCLUSTERED INDEX [ReportScript_ID] ON [Report].[ReportScript] ([ID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [ReportScript_ScriptID] ON [Report].[ReportScript] ([ScriptID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [ReportScript_ServiceID] ON [Report].[ReportScript] ([ServiceID]) ON [PRIMARY]
GO
ALTER TABLE [Report].[ReportScript] ADD CONSTRAINT [FK_ReportScript__Script] FOREIGN KEY ([ScriptID]) REFERENCES [Report].[Script] ([ID])
GO
ALTER TABLE [Report].[ReportScript] ADD CONSTRAINT [FK_ReportScript__Service] FOREIGN KEY ([ServiceID]) REFERENCES [ServiceDef].[Service] ([ID])
GO
