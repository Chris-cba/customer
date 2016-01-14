update nm_inv_items a
set iit_admin_unit =  nvl(xky_surf_au(a.iit_chr_attrib27) ,a.iit_admin_unit) 
where iit_inv_type= 'SURF';

commit;