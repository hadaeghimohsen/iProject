CREATE TABLE [DataGuard].[Role_Privilege]
(
[Sub_Sys] [int] NOT NULL,
[RoleID] [bigint] NOT NULL,
[BOXP_BPID] [bigint] NULL,
[PrivilegeID] [bigint] NOT NULL,
[RPID] [bigint] NOT NULL IDENTITY(1, 1),
[IsActive] [bit] NOT NULL CONSTRAINT [DF__Role_Priv__IsAct__08EA5793] DEFAULT ('true'),
[IsDefault] [bit] NOT NULL CONSTRAINT [DF__Role_Priv__IsDef__09DE7BCC] DEFAULT ('false'),
[IsVisible] [bit] NOT NULL CONSTRAINT [DF__Role_Priv__IsVis__0AD2A005] DEFAULT ('true')
) ON [PRIMARY]
GO
ALTER TABLE [DataGuard].[Role_Privilege] ADD CONSTRAINT [PK_Role_Privilege] PRIMARY KEY CLUSTERED  ([RPID]) ON [PRIMARY]
GO
ALTER TABLE [DataGuard].[Role_Privilege] ADD CONSTRAINT [FK_Role_Privilege_Box_Privilege] FOREIGN KEY ([BOXP_BPID]) REFERENCES [DataGuard].[Box_Privilege] ([BPID])
GO
ALTER TABLE [DataGuard].[Role_Privilege] ADD CONSTRAINT [FK_Role_Privilege_Role] FOREIGN KEY ([RoleID]) REFERENCES [DataGuard].[Role] ([ID]) ON DELETE CASCADE ON UPDATE CASCADE
GO
ALTER TABLE [DataGuard].[Role_Privilege] ADD CONSTRAINT [FK_Role_Privilege_Sub_System] FOREIGN KEY ([Sub_Sys]) REFERENCES [DataGuard].[Sub_System] ([SUB_SYS])
GO
