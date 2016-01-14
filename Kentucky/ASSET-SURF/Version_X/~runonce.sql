DECLARE
  X NUMBER;
BEGIN
  SYS.DBMS_JOB.SUBMIT
  ( job       => X 
   ,what      => '-- Derived Assets ad hoc: SURF
nm3inv_composite2.call_rebuild(
   p_dbms_job_no => job
  ,p_inv_type => ''SURF''
  ,p_effective_date => TO_DATE(sysdate)
  ,p_send_mail => TRUE
  
);'
   ,next_date => sysdate
   ,interval  => null
   ,no_parse  => FALSE
  );
  SYS.DBMS_OUTPUT.PUT_LINE('Job Number is: ' || to_char(x));
COMMIT;
END; 
