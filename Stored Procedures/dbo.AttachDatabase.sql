SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[AttachDatabase]
	@X XML
AS
BEGIN
  /*
   '<Request Rqtp_Code="ManualSaveHostInfo">
      <Database>iProject</Database>
      <Dbms>SqlServer</Dbms>
      <User>scott</User>
      <Computer name="DESKTOP-LB0GKTR" 
                ip="192.168.158.1" 
                mac="00:50:56:C0:00:01" 
                cpu="BFEBFBFF000206A7" />
    </Request>'
   */
   DECLARE  @ComputerName VARCHAR(50)
           ,@Cpu      VARCHAR(30);
   
   SELECT @ComputerName = @X.query('//Computer').value('(Computer/@name)[1]', 'VARCHAR(50)')
         ,@Cpu = @X.query('//Computer').value('(Computer/@cpu)[1]', 'VARCHAR(30)');
         
   UPDATE Report.DataSource 
      SET IPAddress = @ComputerName
     WHERE DatabaseServer = 1;
   
   EXEC DataGuard.ReCreateExistsUsers;
   
   UPDATE DataGuard.Gateway_Public
      SET AUTH_TYPE = '002'
    WHERE COMP_NAME = @ComputerName
      AND RECT_CODE = '004';
   
   UPDATE ug
      SET ug.VALD_TYPE = '002'
     FROM DataGuard.Gateway g, DataGuard.User_Gateway ug
    WHERE g.MAC_ADRS = ug.GTWY_MAC_ADRS;
   
   UPDATE a
      SET a.HOST_NAME = g.MAC_ADRS
     FROM Global.Access_User_Datasource a, DataGuard.Gateway g
    WHERE g.COMP_NAME_DNRM = @ComputerName;   
END
GO
