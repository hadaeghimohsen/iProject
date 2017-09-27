CREATE TABLE [ServiceDef].[Service_GroupHeader]
(
[ServiceID] [bigint] NULL,
[GroupHeaderID] [bigint] NULL,
[IsActive] [bit] NULL CONSTRAINT [DF_Service_GroupHeader_IsActive] DEFAULT ('true'),
[IsVisible] [bit] NULL CONSTRAINT [DF_Service_GroupHeader_IsVisible] DEFAULT ('true')
) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_Service_GroupHeader_1] ON [ServiceDef].[Service_GroupHeader] ([GroupHeaderID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_Service_GroupHeader] ON [ServiceDef].[Service_GroupHeader] ([ServiceID]) ON [PRIMARY]
GO
ALTER TABLE [ServiceDef].[Service_GroupHeader] ADD CONSTRAINT [FK_Service_GroupHeader_GroupHeader] FOREIGN KEY ([GroupHeaderID]) REFERENCES [ServiceDef].[GroupHeader] ([ID])
GO
ALTER TABLE [ServiceDef].[Service_GroupHeader] ADD CONSTRAINT [FK_Service_GroupHeader_Service] FOREIGN KEY ([ServiceID]) REFERENCES [ServiceDef].[Service] ([ID])
GO
