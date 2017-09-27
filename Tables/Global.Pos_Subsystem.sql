CREATE TABLE [Global].[Pos_Subsystem]
(
[BNKA_BNKB_BANK_CODE] [varchar] (2) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[BNKA_BNKB_CODE] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[BNKA_ACNT_NUMB] [varchar] (15) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[SUB_SYS] [int] NOT NULL,
[POS_STAT] [varchar] (3) COLLATE SQL_Latin1_General_CP1_CI_AS NULL CONSTRAINT [DF_Pos_Subsystem_POS_STAT] DEFAULT ('002'),
[POS_DFLT] [varchar] (3) COLLATE SQL_Latin1_General_CP1_CI_AS NULL CONSTRAINT [DF_Pos_Subsystem_POS_DFLT] DEFAULT ('001'),
[SEND_AMNT_EDIT] [varchar] (3) COLLATE SQL_Latin1_General_CP1_CI_AS NULL CONSTRAINT [DF_Pos_Subsystem_SEND_AMNT_EDIT] DEFAULT ('002'),
[SEND_DATA_ON_DEVC] [varchar] (3) COLLATE SQL_Latin1_General_CP1_CI_AS NULL CONSTRAINT [DF_Pos_Subsystem_SEND_DATA_ON_DEVC] DEFAULT ('001'),
[FILL_RSLT_DATA] [varchar] (3) COLLATE SQL_Latin1_General_CP1_CI_AS NULL CONSTRAINT [DF_Pos_Subsystem_FILL_RSLT_DATA] DEFAULT ('001'),
[POS_CNCT_TYPE] [varchar] (3) COLLATE SQL_Latin1_General_CP1_CI_AS NULL CONSTRAINT [DF_Pos_Subsystem_POS_CNCT_TYPE] DEFAULT ('000'),
[IP_ADRS] [varchar] (15) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[COMM_PORT] [varchar] (15) COLLATE SQL_Latin1_General_CP1_CI_AS NULL CONSTRAINT [DF_Pos_Subsystem_COMM_PORT] DEFAULT ('COM1'),
[BAND_RATE] [int] NULL CONSTRAINT [DF_Pos_Subsystem_BAND_RATE] DEFAULT ((9600)),
[CRET_BY] [varchar] (250) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CRET_DATE] [date] NULL,
[MDFY_BY] [varchar] (250) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[MDFY_DATE] [date] NULL
) ON [BLOB]
GO
ALTER TABLE [Global].[Pos_Subsystem] ADD CONSTRAINT [PK_Pos_Subsystem] PRIMARY KEY CLUSTERED  ([BNKA_BNKB_BANK_CODE], [BNKA_BNKB_CODE], [BNKA_ACNT_NUMB], [SUB_SYS]) ON [BLOB]
GO
ALTER TABLE [Global].[Pos_Subsystem] ADD CONSTRAINT [FK_POS_BNKA] FOREIGN KEY ([BNKA_BNKB_BANK_CODE], [BNKA_BNKB_CODE], [BNKA_ACNT_NUMB]) REFERENCES [Global].[Bank_Account] ([BNKB_BANK_CODE], [BNKB_CODE], [ACNT_NUMB]) ON DELETE CASCADE ON UPDATE CASCADE
GO
ALTER TABLE [Global].[Pos_Subsystem] ADD CONSTRAINT [FK_POS_SUBS] FOREIGN KEY ([SUB_SYS]) REFERENCES [DataGuard].[Sub_System] ([SUB_SYS]) ON DELETE CASCADE ON UPDATE CASCADE
GO
EXEC sp_addextendedproperty N'MS_Description', N'میزان باند ', 'SCHEMA', N'Global', 'TABLE', N'Pos_Subsystem', 'COLUMN', N'BAND_RATE'
GO
EXEC sp_addextendedproperty N'MS_Description', N'پورت سریال', 'SCHEMA', N'Global', 'TABLE', N'Pos_Subsystem', 'COLUMN', N'COMM_PORT'
GO
EXEC sp_addextendedproperty N'MS_Description', N'اطلاعات دریافتی در مورد پرداخت هزینه از دستگاه ذخیره گردد', 'SCHEMA', N'Global', 'TABLE', N'Pos_Subsystem', 'COLUMN', N'FILL_RSLT_DATA'
GO
EXEC sp_addextendedproperty N'MS_Description', N'IP', 'SCHEMA', N'Global', 'TABLE', N'Pos_Subsystem', 'COLUMN', N'IP_ADRS'
GO
EXEC sp_addextendedproperty N'MS_Description', N'روش اتصال به دستگاه', 'SCHEMA', N'Global', 'TABLE', N'Pos_Subsystem', 'COLUMN', N'POS_CNCT_TYPE'
GO
EXEC sp_addextendedproperty N'MS_Description', N'دستگاه پیش فرض', 'SCHEMA', N'Global', 'TABLE', N'Pos_Subsystem', 'COLUMN', N'POS_DFLT'
GO
EXEC sp_addextendedproperty N'MS_Description', N'وضعیت فعال بودن دستگاه', 'SCHEMA', N'Global', 'TABLE', N'Pos_Subsystem', 'COLUMN', N'POS_STAT'
GO
EXEC sp_addextendedproperty N'MS_Description', N'آیا مبلغ ارسالی قابل ویرایش می باشد', 'SCHEMA', N'Global', 'TABLE', N'Pos_Subsystem', 'COLUMN', N'SEND_AMNT_EDIT'
GO
EXEC sp_addextendedproperty N'MS_Description', N'داده ها به روی دستگاه ارسال شود', 'SCHEMA', N'Global', 'TABLE', N'Pos_Subsystem', 'COLUMN', N'SEND_DATA_ON_DEVC'
GO
