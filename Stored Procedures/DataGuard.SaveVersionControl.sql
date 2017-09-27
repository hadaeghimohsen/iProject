SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [DataGuard].[SaveVersionControl]
   @X XML
AS
BEGIN
   BEGIN TRY
      BEGIN TRAN SaveVersionControl_T
         DECLARE @ConfigType VARCHAR(3);
         SELECT @ConfigType = @x.query('Config').value('(Config/@type)[1]', 'VARCHAR(3)');
         
         DECLARE @Code VARCHAR(3)
                ,@SubSys INT
                ,@Name NVARCHAR(250)
                ,@Rwno INT
                ,@InstDesc NVARCHAR(250)
                ,@Stat VARCHAR(3)
                ,@Macadrs VARCHAR(17)
                ,@Userid BIGINT
                ,@UsgwRwno INT;
         
         
         IF @ConfigType = '001'
         BEGIN
		      DECLARE C$Del_Package CURSOR FOR
			      SELECT rx.query('Package').value('(Package/@code)[1]', 'VARCHAR(3)')
			            ,rx.query('Package').value('(Package/@subsys)[1]', 'INT')
		           FROM @X.nodes('//Delete') Dcb(rx);
   		   
		      -------------------------- Delete Package_Method
		      OPEN C$Del_Package;
		      FNFC$Del_Package:
		      FETCH NEXT FROM C$Del_Package INTO @Code, @SubSys;
   		   
		      IF @@FETCH_STATUS <> 0
		         GOTO CDC$Del_Package;
   		   
		      DELETE DataGuard.Package WHERE SUB_SYS = @SubSys AND CODE = @Code;
   		      
		      GOTO FNFC$Del_Package;
		      CDC$Del_Package:
		      CLOSE C$Del_Package;
		      DEALLOCATE C$Del_Package; 		   
		      ------------------------ End Delete
   		   
		      DECLARE C$Ins_Package CURSOR FOR
			      SELECT rx.query('Package').value('(Package/@subsys)[1]', 'INT')
			            ,rx.query('Package').value('(Package/@code)[1]', 'VARCHAR(3)')
			            ,rx.query('Package').value('(Package/@name)[1]', 'NVARCHAR(250)')
		           FROM @X.nodes('//Insert') Dcb(rx);
		      
		      -------------------------- Insert Package_Method
		      OPEN C$Ins_Package;
		      FNFC$Ins_Package:
		      FETCH NEXT FROM C$Ins_Package INTO @SubSys, @Code, @Name;
   		   
		      IF @@FETCH_STATUS <> 0
		         GOTO CDC$Ins_Package;
   		   
		      INSERT INTO Package (SUB_SYS, CODE, NAME)
		      VALUES              (@SubSys, @Code, @Name);
   		      
		      GOTO FNFC$Ins_Package;
		      CDC$Ins_Package:
		      CLOSE C$Ins_Package;
		      DEALLOCATE C$Ins_Package; 
		      ------------------------ End Insert
		      DECLARE C$Upd_Package CURSOR FOR
			      SELECT rx.query('Package').value('(Package/@subsys)[1]', 'INT')
			            ,rx.query('Package').value('(Package/@code)[1]', 'VARCHAR(3)')
			            ,rx.query('Package').value('(Package/@name)[1]', 'NVARCHAR(250)')
		           FROM @X.nodes('//Update') Dcb(rx);
   		   
		      -------------------------- Insert Package_Method
		      OPEN C$Upd_Package;
		      FNFC$Upd_Package:
		      FETCH NEXT FROM C$Upd_Package INTO @SubSys, @Code, @Name;
   		   
		      IF @@FETCH_STATUS <> 0
		         GOTO CDC$Upd_Package;
   		   
		      UPDATE Package
		         SET NAME = @Name		            
		       WHERE CODE = @Code
		         AND SUB_SYS = @SubSys;
   		      
		      GOTO FNFC$Upd_Package;
		      CDC$Upd_Package:
		      CLOSE C$Upd_Package;
		      DEALLOCATE C$Upd_Package; 
		      ------------------------ End Insert
         END
         ELSE IF @ConfigType = '002'
         BEGIN
		      DECLARE C$Del_Package_Activity CURSOR FOR
			      SELECT rx.query('Package_Activity').value('(Package_Activity/@pakgcode)[1]', 'VARCHAR(3)')
			            ,rx.query('Package_Activity').value('(Package_Activity/@pakgsubsys)[1]', 'INT')
			            ,rx.query('Package_Activity').value('(Package_Activity/@ssitrwno)[1]', 'INT')
		           FROM @X.nodes('//Delete') Dcb(rx);
   		   
		      -------------------------- Delete Package_Activity_Method
		      OPEN C$Del_Package_Activity;
		      FNFC$Del_Package_Activity:
		      FETCH NEXT FROM C$Del_Package_Activity INTO @Code, @SubSys, @Rwno;
   		   
		      IF @@FETCH_STATUS <> 0
		         GOTO CDC$Del_Package_Activity;
   		   
		      DELETE DataGuard.Package_Activity WHERE PAKG_SUB_SYS = @SubSys AND PAKG_CODE = @Code AND SSIT_RWNO = @RWNO;
   		      
		      GOTO FNFC$Del_Package_Activity;
		      CDC$Del_Package_Activity:
		      CLOSE C$Del_Package_Activity;
		      DEALLOCATE C$Del_Package_Activity; 		   
		      ------------------------ End Delete
   		   
		      DECLARE C$Ins_Package_Activity CURSOR FOR
			      SELECT rx.query('Package_Activity').value('(Package_Activity/@pakgcode)[1]', 'VARCHAR(3)')
			            ,rx.query('Package_Activity').value('(Package_Activity/@pakgsubsys)[1]', 'INT')
			            ,rx.query('Package_Activity').value('(Package_Activity/@ssitrwno)[1]', 'INT')
			            ,rx.query('Package_Activity').value('(Package_Activity/@stat)[1]', 'VARCHAR(3)')
		           FROM @X.nodes('//Insert') Dcb(rx);
		      
		      -------------------------- Insert Package_Activity_Method
		      OPEN C$Ins_Package_Activity;
		      FNFC$Ins_Package_Activity:
		      FETCH NEXT FROM C$Ins_Package_Activity INTO @Code, @SubSys, @Rwno, @Stat
   		   
		      IF @@FETCH_STATUS <> 0
		         GOTO CDC$Ins_Package_Activity;
   		   
		      INSERT INTO DataGuard.Package_Activity (PAKG_SUB_SYS, PAKG_CODE, SSIT_SUB_SYS, SSIT_RWNO, STAT)
		      VALUES              (@SubSys, @Code, @SubSys, @Rwno, @Stat);
   		      
		      GOTO FNFC$Ins_Package_Activity;
		      CDC$Ins_Package_Activity:
		      CLOSE C$Ins_Package_Activity;
		      DEALLOCATE C$Ins_Package_Activity; 
		      ------------------------ End Insert
		      DECLARE C$Upd_Package_Activity CURSOR FOR
			      SELECT rx.query('Package_Activity').value('(Package_Activity/@pakgcode)[1]', 'VARCHAR(3)')
			            ,rx.query('Package_Activity').value('(Package_Activity/@pakgsubsys)[1]', 'INT')
			            ,rx.query('Package_Activity').value('(Package_Activity/@ssitrwno)[1]', 'INT')
			            ,rx.query('Package_Activity').value('(Package_Activity/@stat)[1]', 'VARCHAR(3)')
		           FROM @X.nodes('//Update') Dcb(rx);
   		   
		      -------------------------- Insert Package_Activity_Method
		      OPEN C$Upd_Package_Activity;
		      FNFC$Upd_Package_Activity:
		      FETCH NEXT FROM C$Upd_Package_Activity INTO @Code, @SubSys, @Rwno, @Stat
   		   
		      IF @@FETCH_STATUS <> 0
		         GOTO CDC$Upd_Package_Activity;
   		   
		      UPDATE DataGuard.Package_Activity
		         SET STAT = @Stat
		       WHERE PAKG_CODE = @Code
		         AND PAKG_SUB_SYS = @SubSys
		         AND SSIT_RWNO = @Rwno;
   		      
		      GOTO FNFC$Upd_Package_Activity;
		      CDC$Upd_Package_Activity:
		      CLOSE C$Upd_Package_Activity;
		      DEALLOCATE C$Upd_Package_Activity; 
		      ------------------------ End Insert
         END
         ELSE IF @ConfigType = '003'
         BEGIN
		      DECLARE C$Del_Package_Instance CURSOR FOR
			      SELECT rx.query('Package_Instance').value('(Package_Instance/@pakgcode)[1]', 'VARCHAR(3)')
			            ,rx.query('Package_Instance').value('(Package_Instance/@pakgsubsys)[1]', 'INT')
			            ,rx.query('Package_Instance').value('(Package_Instance/@rwno)[1]', 'INT')
		           FROM @X.nodes('//Delete') Dcb(rx);
   		   
		      -------------------------- Delete Package_Instance_Method
		      OPEN C$Del_Package_Instance;
		      FNFC$Del_Package_Instance:
		      FETCH NEXT FROM C$Del_Package_Instance INTO @Code, @SubSys, @Rwno;
   		   
		      IF @@FETCH_STATUS <> 0
		         GOTO CDC$Del_Package_Instance;
   		   
		      DELETE DataGuard.Package_Instance WHERE PAKG_SUB_SYS = @SubSys AND PAKG_CODE = @Code AND RWNO = @RWNO;
   		      
		      GOTO FNFC$Del_Package_Instance;
		      CDC$Del_Package_Instance:
		      CLOSE C$Del_Package_Instance;
		      DEALLOCATE C$Del_Package_Instance; 		   
		      ------------------------ End Delete
   		   
		      DECLARE C$Ins_Package_Instance CURSOR FOR
			      SELECT rx.query('Package_Instance').value('(Package_Instance/@pakgcode)[1]', 'VARCHAR(3)')
			            ,rx.query('Package_Instance').value('(Package_Instance/@pakgsubsys)[1]', 'INT')
			            ,rx.query('Package_Instance').value('(Package_Instance/@rwno)[1]', 'INT')
			            ,rx.query('Package_Instance').value('(Package_Instance/@instdesc)[1]', 'NVARCHAR(250)')
			            ,rx.query('Package_Instance').value('(Package_Instance/@stat)[1]', 'VARCHAR(3)')
		           FROM @X.nodes('//Insert') Dcb(rx);
		      
		      -------------------------- Insert Package_Instance_Method
		      OPEN C$Ins_Package_Instance;
		      FNFC$Ins_Package_Instance:
		      FETCH NEXT FROM C$Ins_Package_Instance INTO @Code, @SubSys, @Rwno, @InstDesc, @Stat
   		   
		      IF @@FETCH_STATUS <> 0
		         GOTO CDC$Ins_Package_Instance;
   		   
		      INSERT INTO DataGuard.Package_Instance (PAKG_SUB_SYS, PAKG_CODE, RWNO, INST_DESC, STAT)
		      VALUES              (@SubSys, @Code, @Rwno, @InstDesc, @Stat);
   		      
		      GOTO FNFC$Ins_Package_Instance;
		      CDC$Ins_Package_Instance:
		      CLOSE C$Ins_Package_Instance;
		      DEALLOCATE C$Ins_Package_Instance; 
		      ------------------------ End Insert
		      DECLARE C$Upd_Package_Instance CURSOR FOR
			      SELECT rx.query('Package_Instance').value('(Package_Instance/@pakgcode)[1]', 'VARCHAR(3)')
			            ,rx.query('Package_Instance').value('(Package_Instance/@pakgsubsys)[1]', 'INT')
			            ,rx.query('Package_Instance').value('(Package_Instance/@rwno)[1]', 'INT')
			            ,rx.query('Package_Instance').value('(Package_Instance/@instdesc)[1]', 'NVARCHAR(250)')
			            ,rx.query('Package_Instance').value('(Package_Instance/@stat)[1]', 'VARCHAR(3)')
		           FROM @X.nodes('//Update') Dcb(rx);
   		   
		      -------------------------- Insert Package_Instance_Method
		      OPEN C$Upd_Package_Instance;
		      FNFC$Upd_Package_Instance:
		      FETCH NEXT FROM C$Upd_Package_Instance INTO @Code, @SubSys, @Rwno, @InstDesc, @Stat
   		   
		      IF @@FETCH_STATUS <> 0
		         GOTO CDC$Upd_Package_Instance;
   		   
		      UPDATE DataGuard.Package_Instance
		         SET INST_DESC = @InstDesc
		            ,STAT = @Stat
		       WHERE PAKG_CODE = @Code
		         AND PAKG_SUB_SYS = @SubSys
		         AND RWNO = @Rwno;
   		      
		      GOTO FNFC$Upd_Package_Instance;
		      CDC$Upd_Package_Instance:
		      CLOSE C$Upd_Package_Instance;
		      DEALLOCATE C$Upd_Package_Instance; 
		      ------------------------ End Insert
         END
         ELSE IF @ConfigType = '004'
         BEGIN
		      DECLARE C$Del_Package_Instance_User_Gateway CURSOR FOR
			      SELECT rx.query('Package_Instance_User_Gateway').value('(Package_Instance_User_Gateway/@pkinpakgcode)[1]', 'VARCHAR(3)')
			            ,rx.query('Package_Instance_User_Gateway').value('(Package_Instance_User_Gateway/@pkinpakgsubsys)[1]', 'INT')
			            ,rx.query('Package_Instance_User_Gateway').value('(Package_Instance_User_Gateway/@pkinrwno)[1]', 'INT')
			            ,rx.query('Package_Instance_User_Gateway').value('(Package_Instance_User_Gateway/@usgwgtwymacadrs)[1]', 'VARCHAR(17)')
			            ,rx.query('Package_Instance_User_Gateway').value('(Package_Instance_User_Gateway/@usgwuserid)[1]', 'BIGINT')
			            ,rx.query('Package_Instance_User_Gateway').value('(Package_Instance_User_Gateway/@usgwrwno)[1]', 'INT')
		           FROM @X.nodes('//Delete') Dcb(rx);
   		   
		      -------------------------- Delete Package_Instance_User_Gateway_Method
		      OPEN C$Del_Package_Instance_User_Gateway;
		      FNFC$Del_Package_Instance_User_Gateway:
		      FETCH NEXT FROM C$Del_Package_Instance_User_Gateway INTO @Code, @SubSys, @Rwno, @Macadrs, @Userid, @UsgwRwno;
   		   
		      IF @@FETCH_STATUS <> 0
		         GOTO CDC$Del_Package_Instance_User_Gateway;
   		   
		      DELETE DataGuard.Package_Instance_User_Gateway WHERE PKIN_PAKG_SUB_SYS = @SubSys AND PKIN_PAKG_CODE = @Code AND PKIN_RWNO = @RWNO AND USGW_GTWY_MAC_ADRS = @MacAdrs AND USGW_USER_ID = @Userid AND USGW_RWNO = @UsgwRwno;
   		      
		      GOTO FNFC$Del_Package_Instance_User_Gateway;
		      CDC$Del_Package_Instance_User_Gateway:
		      CLOSE C$Del_Package_Instance_User_Gateway;
		      DEALLOCATE C$Del_Package_Instance_User_Gateway; 		   
		      ------------------------ End Delete
   		   
		      DECLARE C$Ins_Package_Instance_User_Gateway CURSOR FOR
			      SELECT rx.query('Package_Instance_User_Gateway').value('(Package_Instance_User_Gateway/@pkinpakgcode)[1]', 'VARCHAR(3)')
			            ,rx.query('Package_Instance_User_Gateway').value('(Package_Instance_User_Gateway/@pkinpakgsubsys)[1]', 'INT')
			            ,rx.query('Package_Instance_User_Gateway').value('(Package_Instance_User_Gateway/@pkinrwno)[1]', 'INT')
			            ,rx.query('Package_Instance_User_Gateway').value('(Package_Instance_User_Gateway/@usgwgtwymacadrs)[1]', 'VARCHAR(17)')
			            ,rx.query('Package_Instance_User_Gateway').value('(Package_Instance_User_Gateway/@usgwuserid)[1]', 'BIGINT')
			            ,rx.query('Package_Instance_User_Gateway').value('(Package_Instance_User_Gateway/@usgwrwno)[1]', 'INT')
			            ,rx.query('Package_Instance_User_Gateway').value('(Package_Instance_User_Gateway/@stat)[1]', 'VARCHAR(3)')
		           FROM @X.nodes('//Insert') Dcb(rx);
		      
		      -------------------------- Insert Package_Instance_User_Gateway_Method
		      OPEN C$Ins_Package_Instance_User_Gateway;
		      FNFC$Ins_Package_Instance_User_Gateway:
		      FETCH NEXT FROM C$Ins_Package_Instance_User_Gateway INTO @Code, @SubSys, @Rwno, @Macadrs, @Userid, @UsgwRwno, @Stat;
   		   
		      IF @@FETCH_STATUS <> 0
		         GOTO CDC$Ins_Package_Instance_User_Gateway;
   		   
		      INSERT INTO DataGuard.Package_Instance_User_Gateway (PKIN_PAKG_SUB_SYS, PKIN_PAKG_CODE, PKIN_RWNO, USGW_GTWY_MAC_ADRS, USGW_USER_ID, USGW_RWNO, STAT)
		      VALUES              (@SubSys, @Code, @Rwno, @Macadrs, @Userid, @UsgwRwno, @Stat);
   		      
		      GOTO FNFC$Ins_Package_Instance_User_Gateway;
		      CDC$Ins_Package_Instance_User_Gateway:
		      CLOSE C$Ins_Package_Instance_User_Gateway;
		      DEALLOCATE C$Ins_Package_Instance_User_Gateway; 
		      ------------------------ End Insert
		      DECLARE C$Upd_Package_Instance_User_Gateway CURSOR FOR
			      SELECT rx.query('Package_Instance_User_Gateway').value('(Package_Instance_User_Gateway/@pkinpakgcode)[1]', 'VARCHAR(3)')
			            ,rx.query('Package_Instance_User_Gateway').value('(Package_Instance_User_Gateway/@pkinpakgsubsys)[1]', 'INT')
			            ,rx.query('Package_Instance_User_Gateway').value('(Package_Instance_User_Gateway/@pkinrwno)[1]', 'INT')
			            ,rx.query('Package_Instance_User_Gateway').value('(Package_Instance_User_Gateway/@usgwgtwymacadrs)[1]', 'VARCHAR(17)')
			            ,rx.query('Package_Instance_User_Gateway').value('(Package_Instance_User_Gateway/@usgwuserid)[1]', 'BIGINT')
			            ,rx.query('Package_Instance_User_Gateway').value('(Package_Instance_User_Gateway/@usgwrwno)[1]', 'INT')
			            ,rx.query('Package_Instance_User_Gateway').value('(Package_Instance_User_Gateway/@stat)[1]', 'VARCHAR(3)')
		           FROM @X.nodes('//Update') Dcb(rx);
   		   
		      -------------------------- Insert Package_Instance_User_Gateway_Method
		      OPEN C$Upd_Package_Instance_User_Gateway;
		      FNFC$Upd_Package_Instance_User_Gateway:
		      FETCH NEXT FROM C$Upd_Package_Instance_User_Gateway INTO @Code, @SubSys, @Rwno, @Macadrs, @Userid, @UsgwRwno, @Stat;
   		   
		      IF @@FETCH_STATUS <> 0
		         GOTO CDC$Upd_Package_Instance_User_Gateway;
   		   
		      UPDATE DataGuard.Package_Instance_User_Gateway
		         SET STAT = @Stat
		       WHERE PKIN_PAKG_CODE = @Code
		         AND PKIN_PAKG_SUB_SYS = @SubSys
		         AND PKIN_RWNO = @Rwno
		         AND USGW_GTWY_MAC_ADRS = @MacAdrs
		         AND USGW_USER_ID = @Userid
		         AND USGW_RWNO = @UsgwRwno;
   		      
		      GOTO FNFC$Upd_Package_Instance_User_Gateway;
		      CDC$Upd_Package_Instance_User_Gateway:
		      CLOSE C$Upd_Package_Instance_User_Gateway;
		      DEALLOCATE C$Upd_Package_Instance_User_Gateway; 
		      ------------------------ End Insert
         END
      COMMIT TRAN SaveVersionControl_T;
   END TRY
   BEGIN CATCH
      DECLARE @ErrorMessage NVARCHAR(MAX);
      SET @ErrorMessage = ERROR_MESSAGE();
      RAISERROR ( @ErrorMessage, -- Message text.
               16, -- Severity.
               1 -- State.
               );
      ROLLBACK TRAN SaveVersionControl_T;
   END CATCH
END;
GO
