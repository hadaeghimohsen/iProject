SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [Report].[CreateNewConnectionString]
	@Xml Xml
AS
BEGIN

   DECLARE @ShortCut Bigint;
   SELECT @ShortCut = IsNull(MAX(ShortCut), 0) + 1 From Report.DataSource;

   Merge Report.DataSource T
   Using (
      Select 
	      c.query('TitleFa').value('.', 'nVarchar(50)') as P_TitleFa,
	      c.query('DataBaseServer').value('.', 'smallint') as P_DatabaseServer,
	      c.query('IPAddress').value('.', 'Varchar(50)') as P_IPAddress,
	      c.query('Port').value('.', 'int') as P_Port,
	      c.query('DataBase').value('.', 'Varchar(50)') as P_Database,
	      c.query('UserID').value('.', 'Varchar(50)') as P_UserID,
	      c.query('Password').value('.', 'Varchar(50)') as P_Password
	   From @Xml.nodes('/Create') t(c)
	) S
	On ( 
	   T.DatabaseServer = S.P_DatabaseServer And 
	   T.IPAddress = S.P_IPAddress And 
	   T.Port = S.P_Port And 
	   T.[Database] = S.P_Database And
	   T.UserID = S.P_UserID
	   )
	When Matched Then
	   Update Set TitleFa = P_TitleFa, UserID = P_UserID, [Password] = P_Password
	When Not Matched Then
	   Insert (  TitleFa,  ShortCut,   DatabaseServer,   IPAddress,   Port,  [Database],   UserID,  [Password])
	   Values (P_TitleFa, @ShortCut, P_DatabaseServer, P_IPAddress, P_Port, P_Database,   P_UserID, P_Password);

	   
END
GO
