SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE FUNCTION [DataGuard].[VF$DataBaseFileInfo]
(	
	@DbName VARCHAR(50)
)
RETURNS TABLE 
AS
RETURN 
(
	SELECT [type], type_desc, name, physical_name, [state], state_desc, (CAST(size AS FLOAT) * 8) / 1024 AS size, max_size , 
	       CASE WHEN UPPER(name) LIKE '%LOG%' THEN 'LDF'
	            WHEN UPPER(name) LIKE '%BLOB%' THEN 'NDF'
	            ELSE 'MDF'
	       END File_Type
	  FROM sys.master_files 
	 WHERE DB_NAME(database_id) = @DbName
)
GO
