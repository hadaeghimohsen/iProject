CREATE TABLE [ServiceDef].[Role_GroupHeader]
(
[RoleID] [bigint] NOT NULL,
[GroupHeaderID] [bigint] NOT NULL,
[IsActive] [bit] NOT NULL CONSTRAINT [DF__Role_PayG__IsAct__02FC7413] DEFAULT ('true'),
[IsVisible] [bit] NOT NULL CONSTRAINT [DF__Role_PayG__IsVis__03F0984C] DEFAULT ('true'),
[IsReporting] [bit] NOT NULL CONSTRAINT [DF_Role_GroupHeader_IsReporting] DEFAULT ('false')
) ON [PRIMARY]
GO
ALTER TABLE [ServiceDef].[Role_GroupHeader] ADD CONSTRAINT [PK__Role_Pay__6FA9F5F701142BA1] PRIMARY KEY CLUSTERED  ([RoleID], [GroupHeaderID]) ON [PRIMARY]
GO
ALTER TABLE [ServiceDef].[Role_GroupHeader] ADD CONSTRAINT [FKRole_PayGr250391] FOREIGN KEY ([GroupHeaderID]) REFERENCES [ServiceDef].[GroupHeader] ([ID]) ON DELETE CASCADE ON UPDATE CASCADE
GO
ALTER TABLE [ServiceDef].[Role_GroupHeader] ADD CONSTRAINT [FKRole_PayGr31877] FOREIGN KEY ([RoleID]) REFERENCES [DataGuard].[Role] ([ID]) ON DELETE CASCADE ON UPDATE CASCADE
GO
