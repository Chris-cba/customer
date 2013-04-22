begin
   dbms_scheduler.create_job( job_name => 'BRISTOLWATER_REFRESH_MAT_VIEWS',
                                  job_type => 'PLSQL_BLOCK',
                                  job_action => 'BEGIN X_BRISTOLWATER_REFRESH_MATVIEW; END;',
                                  start_date => systimestamp,
                                  repeat_interval => 'freq=MINUTELY;interval=15',
                                  end_date => null,
                                  enabled => TRUE,
                                  comments => 'Set up by Aileen Heal to refresh Bristol Water Geo.ME materalised views' );
end;


