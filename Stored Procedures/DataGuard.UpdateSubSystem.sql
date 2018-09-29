SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROC [DataGuard].[UpdateSubSystem]
   @Sub_Sys INT,
   @Stat VARCHAR(3),
   @Inst_Stat VARCHAR(3),
   @Inst_Date DATETIME,
   @Licn_Type VARCHAR(3),
   @Licn_Tril_Date DATETIME,
   @Clnt_Licn_Desc NVARCHAR(4000),
   @Srvr_Licn_Desc NVARCHAR(4000),
   @Sub_Desc NVARCHAR(500),
   @Jobs_Stat VARCHAR(3),
   @Freq_Intr INT
AS
BEGIN
   IF @Clnt_Licn_Desc IS NULL OR @Clnt_Licn_Desc = '' SET @Srvr_Licn_Desc = NULL;
      
   UPDATE DataGuard.Sub_System
      SET STAT = @Stat      
         ,INST_STAT = @Inst_Stat
         ,INST_DATE = @Inst_Date
         ,LICN_TYPE = @Licn_Type
         ,LICN_TRIL_DATE = @Licn_Tril_Date
         ,CLNT_LICN_DESC = @Clnt_Licn_Desc
         ,SRVR_LICN_DESC = @Srvr_Licn_Desc
         ,SUB_DESC = @Sub_Desc
         ,JOBS_STAT = @Jobs_Stat
         ,FREQ_INTR = @Freq_Intr
    WHERE SUB_SYS = @Sub_Sys;
END
GO
