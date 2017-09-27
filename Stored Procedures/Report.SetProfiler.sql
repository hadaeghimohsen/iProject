SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [Report].[SetProfiler]
	-- Add the parameters for the stored procedure here
	@XML XML
AS
BEGIN
	DECLARE @Request_Type VARCHAR(20);
	SELECT @Request_Type = @XML.query('/Request').value('(Request/@type)[1]', 'VARCHAR(20)');
	DECLARE @Tabl_Ret VARCHAR(100);
	DECLARE @Has_Relt BIT;
	DECLARE @idoc INT;
	
	IF(@Request_Type = 'CreateNewCoProfiler')
	BEGIN		
		/* اگر حداقل تعداد سربرگهای بدست آمده دراین خروجی بیش از 2 مورد باشد کار 
		   را ادامه می دهیم در غیر اینصورت در همینجا کار را متوقف می کنیم */
		IF (SELECT COUNT(*) FROM(
				SELECT DISTINCT GroupHeaderID, RoleID, DatasourceType FROM Report.v$AccessGroupsOfProfilers
				WHERE EXISTS(
					SELECT * FROM @XML.nodes('//Profiler') t(p)
					WHERE p.value('(@id)[1]', 'BIGINT') = ProfilerID
				)
			) TResult) < 2
			/* اگر تعداد سربرگها از دو تا کمتر باشد */
		BEGIN
			PRINT'RETURN';
			--RETURN;
			GOTO ENDWORK;
		END;
		/* ایجاد کردن یک پروفایل جدید درون جدول و بدست آوردن شماره شناسایی پروفایل */
		DECLARE @RoleID         BIGINT, 
				@DataSourceID   BIGINT,
				@DataSourceType SMALLINT;
		
		SELECT @RoleID       = (SELECT TOP 1 p.value('(@role_id)[1]', 'BIGINT') FROM @XML.nodes('//Profiler')t(p) );
		SELECT @DataSourceID = (SELECT TOP 1 p.value('(@dataSource)[1]', 'BIGINT') FROM @XML.nodes('//Profiler')t(p));
		SELECT @DataSourceType = (SELECT TOP 1 DatasourceType FROM Report.v$AccessGroupsOfProfilers);
		
		DECLARE @ProfilerID BIGINT;
		
		DECLARE @XMLDATA XML;
		SELECT @XMLDATA = (
						SELECT 
							1 AS 'ShortCut',
							N'بی نام' AS 'FaName',
							'NoName' AS 'EnName',
							@DataSourceID AS 'DataSource',
							@RoleID AS 'Roles/Role'
						FOR XML PATH('AddProfiler'), ROOT('ParametersData')
						);
		
		EXEC [Report].[AddNewProfilers] @XMLDATA , @ProfilerID OUTPUT;
		
		/* قرار دادن لیست سربرگ های مشخص شده درون لیست جدید پروفایل */
		SELECT @XMLDATA = (
				SELECT 
					'AddNewItem' AS '@type',
					@ProfilerID AS 'Profiler',
					(
						SELECT 
						    GroupHeaderID AS '@id'
						   ,@RoleID AS 'Role'
						   ,1 AS 'Datasource/@from'
						   ,@DataSourceType AS 'Datasource/@type'
						   ,ROW_NUMBER() OVER (ORDER BY GroupHeaderID) AS 'OrderIndex'
						FROM(
							SELECT DISTINCT
								GroupHeaderID
							   ,@RoleID AS RoleID
							   ,1 AS DsFrom
							   ,@DataSourceType AS DsType
							FROM Report.v$AccessGroupsOfProfilers
							WHERE EXISTS (
								SELECT *
								FROM @XML.nodes('//Profiler')t(p)
								WHERE ProfilerID = p.value('(@id)[1]', 'BIGINT')
							)
						) t
						FOR XML PATH('Group'), ROOT('Groups'), TYPE, ELEMENTS
					)
				FOR XML PATH('Request'), ROOT('ParametersData')
			);
		EXEC [Report].[SetProfilerGroupHeader] @XMlDATA;				
		
		/* برگرداندن اطلاعات مربوط به پروفایل به کاربر برای انجام تغییر نام */	
		SELECT
			@ProfilerID AS '@id',
			N'بی نام' AS '@faName'
		FOR XML PATH('Profiler'), ROOT('Profilers');
		SET @Tabl_Ret = 'Profiler';
		SET @Has_Relt = 0;
	END
	ELSE IF(@Request_Type = 'Rename')
	BEGIN
		UPDATE Report.Profiler
		SET TitleFa = @XML.query('//Profiler').value('(Profiler/@faName)[1]', 'NVARCHAR(50)')
		WHERE ID = @XML.query('//Profiler').value('(Profiler/@id)[1]', 'BIGINT');
	END;
	ELSE IF(@Request_Type = 'Leave')
	BEGIN
		EXEC SP_XML_PREPAREDOCUMENT @idoc OUTPUT, @XML;
	   MERGE Report.Role_Profiler RPT
	   USING(
	      SELECT
	         ProfilerID,
	         RoleID
	      FROM OPENXML(@idoc, '//Profiler', 2)
	      WITH
	      (
	         ProfilerID BIGINT '.',
	         RoleID     BIGINT '../Role'
	      ) 
	   ) RPS
	   ON (RPT.RoleID = RPS.RoleID AND RPT.ProfilerID = RPS.ProfilerID)
	   WHEN MATCHED THEN
	      UPDATE SET IsActive = 0, IsVisible = 0;
	   EXEC SP_XML_REMOVEDOCUMENT @idoc;
	END;
	ELSE IF(@Request_Type = 'Join')
	BEGIN
		EXEC SP_XML_PREPAREDOCUMENT @idoc OUTPUT, @XML;
	   MERGE Report.Role_Profiler RPT
	   USING(
	      SELECT
	         ProfilerID,
	         RoleID
	      FROM OPENXML(@idoc, '//Profiler', 2)
	      WITH
	      (
	         ProfilerID BIGINT '.',
	         RoleID     BIGINT '../Role'
	      ) 
	   ) RPS
	   ON (RPT.RoleID = RPS.RoleID AND RPT.ProfilerID = RPS.ProfilerID)
	   WHEN MATCHED THEN
	      UPDATE SET IsActive = 1, IsVisible = 1
	   WHEN NOT MATCHED THEN
	      INSERT (RoleID, ProfilerID)
	      VALUES (RPS.RoleID, RPS.ProfilerID);	   
	   EXEC SP_XML_REMOVEDOCUMENT @idoc;
	END;
	
	ENDWORK:
	SELECT
	 'SUCCESSFUL' AS RESULT
	,'0S' AS TIMERUN
	,@Tabl_Ret AS TABLESNAME
	,'iProject' As TableSpaceName
	,@Has_Relt AS [HasRelation];
END
GO
