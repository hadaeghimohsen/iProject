SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [Report].[UpdateConnectionString]
	@Xml Xml
AS
BEGIN
   Declare @DatabaseServer SMALLINT,
           @IPAddress      VARCHAR(50),
           @Port           INT,
           @Database       VARCHAR(50),
           @UserID         VARCHAR(50),
           @Password       VARCHAR(50),
           @TitleFa        NVARCHAR(50),
           @ID             BIGINT;
   SELECT 
      @DatabaseServer = c.query('DataBaseServer').value('.', 'SMALLINT'),
      @IPAddress      = c.query('IPAddress').value('.',      'VARCHAR(50)'),
      @Port           = c.query('Port').value('.',           'INT'),
      @Database       = c.query('DataBase').value('.',       'VARCHAR(50)'),
      @UserID         = c.query('UserID').value('.',         'VARCHAR(50)'),
      @Password       = c.query('Password').value('.',       'VARCHAR(50)'),
      @TitleFa        = c.query('TitleFa').value('.',        'NVARCHAR(50)'),
      @ID             = c.query('DataSourceID').value('.',             'BIGINT')
   FROM @Xml.nodes('/Update')t(c);
   
	UPDATE Report.DataSource
	SET DatabaseServer = @DatabaseServer,
	    IPAddress      = @IPAddress,
	    Port           = @Port,
	    [Database]     = @Database,
	    UserID         = @UserID,
	    [Password]     = @Password,
	    TitleFa        = @TitleFa
	WHERE ID = @ID;
END
GO
