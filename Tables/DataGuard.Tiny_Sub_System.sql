CREATE TABLE [DataGuard].[Tiny_Sub_System]
(
[TINY_TNID] [bigint] NULL,
[SUB_SYS] [int] NULL,
[TSID] [bigint] NOT NULL,
[STAT] [varchar] (3) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CRET_BY] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CRET_DATE] [datetime] NULL,
[MDFY_BY] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[MDFY_DATE] [datetime] NULL
) ON [PRIMARY]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE TRIGGER [DataGuard].[CG$AINS_TNSS]
   ON  [DataGuard].[Tiny_Sub_System]
   AFTER INSERT
AS 
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for trigger here
   MERGE DataGuard.Tiny_Sub_System T
   USING(SELECT * FROM Inserted) S
   ON(T.TSID = S.TSID)
   WHEN MATCHED THEN
      UPDATE SET
         T.CRET_BY = UPPER(SUSER_NAME())
        ,T.CRET_DATE = GETDATE()
        ,t.TSID = CASE WHEN t.TSID = 0 THEN dbo.GNRT_NVID_U() ELSE t.TSID END;
END
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE TRIGGER [DataGuard].[CG$AUPD_TNSS]
   ON  [DataGuard].[Tiny_Sub_System]
   AFTER UPDATE   
AS 
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for trigger here
   MERGE DataGuard.Tiny_Sub_System T
   USING(SELECT * FROM Inserted) S
   ON(T.TSID = S.TSID)
   WHEN MATCHED THEN
      UPDATE SET
         T.MDFY_BY = UPPER(SUSER_NAME())
        ,T.MDFY_DATE = GETDATE();
   
   DECLARE @Tnid BIGINT;
   SELECT @Tnid = TINY_TNID FROM Inserted;
   
   DECLARE @Opid BIGINT,
           @Year VARCHAR(2);
           
   SELECT @Opid = OPRT_OPID FROM DataGuard.Tiny_Lock WHERE TNID = @Tnid;
   SELECT @Year = SUBSTRING(dbo.MiladiTOShamsi(ISSU_DATE), 3, 2) FROM DataGuard.Opportunity WHERE OPID = @Opid;
   
   DECLARE @ListSubSys VARCHAR(10);
   IF (SELECT COUNT(DISTINCT SUB_SYS) FROM DataGuard.Tiny_Sub_System WHERE TINY_TNID = @Tnid) = 3  
      SET @ListSubSys = '00'
   ELSE   
      SELECT @ListSubSys = (
         SELECT dbo.PADSTR(SUB_SYS, 2) + ''
           FROM DataGuard.Tiny_Sub_System
          WHERE TINY_TNID = @Tnid
          ORDER BY SUB_SYS
          FOR XML PATH('')          
      );
   
   DECLARE @Count INT;
   SELECT @Count = COUNT(*)
     FROM DataGuard.Tiny_Lock
    WHERE TINY_CODE_DNRM LIKE '%' + @Year + @ListSubSys + '-%';
   
   UPDATE DataGuard.Tiny_Lock
      SET TINY_CODE_DNRM = @Year + @ListSubSys + '-' + dbo.PADSTR(@Count + 1, 4)
    WHERE TNID = @Tnid;    
END
GO
ALTER TABLE [DataGuard].[Tiny_Sub_System] ADD CONSTRAINT [PK_Tiny_Sub_System] PRIMARY KEY CLUSTERED  ([TSID]) ON [PRIMARY]
GO
ALTER TABLE [DataGuard].[Tiny_Sub_System] ADD CONSTRAINT [FK_TNSS_SUBS] FOREIGN KEY ([SUB_SYS]) REFERENCES [DataGuard].[Sub_System] ([SUB_SYS])
GO
ALTER TABLE [DataGuard].[Tiny_Sub_System] ADD CONSTRAINT [FK_TNSS_TINY] FOREIGN KEY ([TINY_TNID]) REFERENCES [DataGuard].[Tiny_Lock] ([TNID])
GO
