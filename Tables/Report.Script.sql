CREATE TABLE [Report].[Script]
(
[ID] [bigint] NOT NULL IDENTITY(1, 1),
[ScriptFaName] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ScriptEnName] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[IsActive] [bit] NULL,
[IsVisible] [bit] NULL
) ON [PRIMARY]
GO
ALTER TABLE [Report].[Script] ADD CONSTRAINT [PK__Script__3214EC27000AF8CF] PRIMARY KEY CLUSTERED  ([ID]) ON [PRIMARY]
GO
CREATE UNIQUE NONCLUSTERED INDEX [Script_ID] ON [Report].[Script] ([ID]) ON [PRIMARY]
GO
