
declare

cursor dv is select object_name from user_objects where object_type = 'VIEW' and object_name in ('XODOT_BARR_BY_EA_V', 'XODOT_BARR_EA');
begin
    
    for  cr in dv
    loop
           execute immediate 'drop view ' || cr.object_name;
           commit;
    end loop;

 
end;
/

@xodot_barr_v.sql
@xodot_iatn_v.sql