CREATE TABLE [ServiceDef].[UnitType]
(
[ID] [bigint] NOT NULL CONSTRAINT [DF_ServiceUnitType_ID] DEFAULT ([dbo].[GetNewIdentity]()),
[ShortCut] [bigint] NULL,
[TitleFa] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[TitleEn] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[UnitType] [bit] NULL CONSTRAINT [DF_ServiceUnitType_UnitType] DEFAULT ('true'),
[IsVisible] [bit] NOT NULL CONSTRAINT [DF__ServiceUn__IsVis__1920BF5C] DEFAULT ('true'),
[IsActive] [bit] NOT NULL CONSTRAINT [DF_ServiceUnitType_IsActive] DEFAULT ('true')
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
ALTER TABLE [ServiceDef].[UnitType] ADD CONSTRAINT [PK__ServiceU__3214EC27173876EA] PRIMARY KEY CLUSTERED  ([ID]) ON [PRIMARY]
GO
