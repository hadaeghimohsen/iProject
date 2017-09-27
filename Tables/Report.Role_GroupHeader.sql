CREATE TABLE [Report].[Role_GroupHeader]
(
[RoleID] [bigint] NOT NULL,
[GroupHeaderID] [bigint] NOT NULL,
[IsVisible] [bit] NULL CONSTRAINT [DF_Role_GroupHeader_IsVisible] DEFAULT ('true'),
[IsActive] [bit] NULL CONSTRAINT [DF_Role_GroupHeader_IsActive] DEFAULT ('true')
) ON [PRIMARY]
GO
ALTER TABLE [Report].[Role_GroupHeader] ADD CONSTRAINT [PK__Role_Gro__741F9156420DC656] PRIMARY KEY CLUSTERED  ([RoleID], [GroupHeaderID]) ON [PRIMARY]
GO
ALTER TABLE [Report].[Role_GroupHeader] ADD CONSTRAINT [FK_Role_GroupHeader__GroupHeader] FOREIGN KEY ([GroupHeaderID]) REFERENCES [Report].[GroupHeader] ([ID]) ON DELETE CASCADE ON UPDATE CASCADE
GO
ALTER TABLE [Report].[Role_GroupHeader] ADD CONSTRAINT [FK_Role_GroupHeader__Role] FOREIGN KEY ([RoleID]) REFERENCES [DataGuard].[Role] ([ID]) ON DELETE CASCADE ON UPDATE CASCADE
GO
