CREATE TABLE [ServiceDef].[Role_UnitType]
(
[RoleID] [bigint] NULL,
[UnitTypeID] [bigint] NULL,
[IsActive] [bit] NULL CONSTRAINT [DF_Role_UnitType_IsActive] DEFAULT ('true'),
[IsReporting] [bit] NULL CONSTRAINT [DF_Role_UnitType_IsReporting] DEFAULT ('false'),
[ADID] [bigint] NULL
) ON [PRIMARY]
GO
