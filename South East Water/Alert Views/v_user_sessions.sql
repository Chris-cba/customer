create or replace view v_user_sessions as
select hus.hus_username||to_char(sysdate,'YYYYMMDDHH24MISS') pk_id, hus.hus_username "USERNAME", hus.hus_name full_name, min(vs.LOGON_TIME) logon_time
from hig_users hus
, v$session vs
where hus.hus_username = vs.USERNAME
and hus.hus_username <> 'TMAWS'
group by hus.hus_username, hus.hus_name


select * from v_user_sessions