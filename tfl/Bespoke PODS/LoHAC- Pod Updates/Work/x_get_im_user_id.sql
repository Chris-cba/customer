CREATE OR REPLACE function HIGHWAYS.x_get_im_user_id
return number
is
    rtrn number := -1;
begin
  for crec in (
    select hus_user_id
    from hig_users
    where hus_username =     Sys_Context('NM3_SECURITY_CTX','USERNAME'))
   loop
     rtrn := crec.hus_user_id;
   end loop;
   return rtrn;
end x_get_im_user_id;
/