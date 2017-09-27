SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROC [DataGuard].[InstallOrUninstallJob] @X XML
AS
    BEGIN
        DECLARE @InstallUnInstall VARCHAR(3) ,
            @FreqIntr INT;
      
        SELECT  @InstallUnInstall = @X.query('JobScheduale').value('(JobScheduale/@stat)[1]',
                                                              'VARCHAR(3)') ,
                @FreqIntr = @X.query('JobScheduale').value('(JobScheduale/@freqintr)[1]',
                                                           'INT');
      
        IF @InstallUnInstall = '002' -- Install Job
            BEGIN
                DECLARE @jobId BINARY(16);
                EXEC msdb.dbo.sp_add_job @job_name = N'KernelJobs',
                    @enabled = 1, @notify_level_eventlog = 0,
                    @notify_level_email = 2, @notify_level_netsend = 2,
                    @notify_level_page = 2, @delete_level = 0,
                    @category_name = N'[Uncategorized (Local)]',
                    @owner_login_name = N'artauser', @job_id = @jobId OUTPUT;


                EXEC msdb.dbo.sp_add_jobserver @job_name = N'KernelJobs',
                    @server_name = N'MOHSEN-LT';

                EXEC msdb.dbo.sp_add_jobstep @job_name = N'KernelJobs',
                    @step_name = N'ExecuteJobScheduleSubSys', @step_id = 1,
                    @cmdexec_success_code = 0, @on_success_action = 1,
                    @on_fail_action = 2, @retry_attempts = 0,
                    @retry_interval = 0, @os_run_priority = 0,
                    @subsystem = N'TSQL', @command = N'BEGIN
   EXEC iProject.[Global].ExecuteJobScheduleSubSystem @X = '''';
END;
', @database_name = N'master', @flags = 0;

                EXEC msdb.dbo.sp_update_job @job_name = N'KernelJobs',
                    @enabled = 1, @start_step_id = 1,
                    @notify_level_eventlog = 0, @notify_level_email = 2,
                    @notify_level_netsend = 2, @notify_level_page = 2,
                    @delete_level = 0, @description = N'',
                    @category_name = N'[Uncategorized (Local)]',
                    @owner_login_name = N'artauser',
                    @notify_email_operator_name = N'',
                    @notify_netsend_operator_name = N'',
                    @notify_page_operator_name = N'';

                DECLARE @schedule_id INT;
                EXEC msdb.dbo.sp_add_jobschedule @job_name = N'KernelJobs',
                    @name = N'ExecuteJobScheduleSubSys', @enabled = 1,
                    @freq_type = 4, @freq_interval = 1, @freq_subday_type = 4,
                    @freq_subday_interval = @FreqIntr, @freq_relative_interval = 0,
                    @freq_recurrence_factor = 1, @active_start_date = 20170828,
                    @active_end_date = 99991231, @active_start_time = 0,
                    @active_end_time = 235959,
                    @schedule_id = @schedule_id OUTPUT;

            END;
        ELSE
            IF @InstallUnInstall = '001' -- Uninstall
                BEGIN
                    EXEC msdb.dbo.sp_stop_job @job_name = 'KernelJobs';
            
                    EXEC msdb.dbo.sp_delete_job @job_name = 'KernelJobs',
                        @delete_unused_schedule = 1;
                END;
    END;
GO
