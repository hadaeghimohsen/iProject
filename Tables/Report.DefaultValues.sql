CREATE TABLE [Report].[DefaultValues]
(
[FilterID] [bigint] NULL,
[Code] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[IsVisible] [bit] NULL CONSTRAINT [DF_DefaultValues_IsVisible] DEFAULT ('true'),
[IsChecked] [bit] NULL CONSTRAINT [DF_DefaultValues_IsChecked] DEFAULT ('true')
) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [DefaultValues_GroupHeader_TableUsageID] ON [Report].[DefaultValues] ([FilterID]) ON [PRIMARY]
GO
