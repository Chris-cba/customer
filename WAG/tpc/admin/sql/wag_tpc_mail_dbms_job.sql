DECLARE
l_jobno number;
BEGIN
DBMS_JOB.SUBMIT(job => l_jobno, what => 'apex_mail.push_queue;',interval => 'SYSDATE+(30/86400)');
COMMIT;
END;
/

commit;