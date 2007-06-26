CONNECT username/password@DATABASE

SET serveroutput ON

DECLARE
   l_contractor CONSTANT VARCHAR2(3) := 'RAY';

   l_filename varchar2(1000);
   l_interpath hig_options.HOP_VALUE%type := hig.get_user_or_sys_opt('INTERPATH');
BEGIN

   DBMS_OUTPUT.put_line(TO_CHAR(SYSDATE,'DD-MON-YYYY HH24:MI:SS')||' work order extract started');
   l_filename := interfaces.write_wor_file( p_contractor_id	=> l_contractor
                                           ,p_seq_no	      => null
                                           ,p_filepath	   => l_interpath);
   DBMS_OUTPUT.put_line(TO_CHAR(SYSDATE,'DD-MON-YYYY HH24:MI:SS')||' Produced file '||l_interpath||'\'||l_filename);
   DBMS_OUTPUT.put_line(TO_CHAR(SYSDATE,'DD-MON-YYYY HH24:MI:SS')||' work order extract finished');
end;
/
EXIT
