create or replace view xNORFOLK_V_USER_ROLE as

select
cast('user' as varchar2(50)) puser,
cast('role' as varchar2(100)) prole,
cast('command' as varchar2(10)) pcommand,
cast('admin_option' as varchar2(15)) padmin_option

from 
dual;

