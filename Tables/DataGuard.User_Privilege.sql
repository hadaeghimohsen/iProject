CREATE TABLE [DataGuard].[User_Privilege]
(
[Sub_Sys] [int] NULL,
[UserID] [bigint] NOT NULL,
[BOXP_BPID] [bigint] NULL,
[PrivilegeID] [bigint] NOT NULL,
[IsActive] [bit] NOT NULL CONSTRAINT [DF_User_Privilege_IsActive] DEFAULT ('true'),
[IsDefault] [bit] NOT NULL CONSTRAINT [DF_User_Privilege_IsDefault] DEFAULT ('False'),
[IsVisible] [bit] NOT NULL CONSTRAINT [DF_User_Privilege_IsVisible] DEFAULT ('true')
) ON [PRIMARY]
GO
ALTER TABLE [DataGuard].[User_Privilege] ADD CONSTRAINT [FK_User_Privilege_Box_Privilege] FOREIGN KEY ([BOXP_BPID]) REFERENCES [DataGuard].[Box_Privilege] ([BPID])
GO
ALTER TABLE [DataGuard].[User_Privilege] ADD CONSTRAINT [FK_User_Privilege_Sub_System] FOREIGN KEY ([Sub_Sys]) REFERENCES [DataGuard].[Sub_System] ([SUB_SYS])
GO
ALTER TABLE [DataGuard].[User_Privilege] ADD CONSTRAINT [FK_USPR_USER] FOREIGN KEY ([UserID]) REFERENCES [DataGuard].[User] ([ID]) ON DELETE CASCADE
GO
