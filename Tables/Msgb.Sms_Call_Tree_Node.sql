CREATE TABLE [Msgb].[Sms_Call_Tree_Node]
(
[TNID] [bigint] NOT NULL IDENTITY(1, 1),
[X] [xml] NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
ALTER TABLE [Msgb].[Sms_Call_Tree_Node] ADD CONSTRAINT [PK_Sms_Call_Tree_Node] PRIMARY KEY CLUSTERED  ([TNID]) ON [PRIMARY]
GO
