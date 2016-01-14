CREATE OR REPLACE function x_surf_lookup(p_what varchar2, p_type number) return varchar2
   is
   n_temp number(8);
   s_desc varchar2(188);
   begin
   Case upper(p_what)
	When 'BD'
		then
			select hco_meaning into s_desc from hig_codes
			where hco_domain = 'KY_SURFTYPE'
			and  hco_code = p_type
			;
			
     
     
	When 'PMS'
		then
			
			select IAL_meaning into s_desc from NM_INV_ATTRI_LOOKUP
			where IAL_domain = 'PM_PM_PAVETYPE'
			and  ial_value = p_type
			;
	Else
		s_desc := null;
	end case;
	
	return s_desc;
	
     exception when others then
     return null;
   end;
/

CREATE OR REPLACE function x_surf_lookup_n(p_pm_type number, p_bd_type number) return number
   is
   n_temp number(8);
   s_desc varchar2(188);
   begin
   
        if  p_pm_type is not  null then
            n_temp := p_pm_type;
            select surf_lookup  into n_temp from x_tab_surf_lookup where rownum =1 and pave_type = 'PM' and code =  p_pm_type;
        Elsif p_bd_type is not null then
            n_temp := p_bd_type;
            select surf_lookup  into n_temp from x_tab_surf_lookup where rownum =1 and pave_type = 'BD' and code =  p_bd_type;
        Else 
            n_temp := -1;
        end if;
   
        if n_temp is null then 
         n_temp := -1;
         end if;
        
   
    return n_temp;
    
     exception when others then
     return -1;
   end;
/

CREATE OR REPLACE function x_surf_lookup_v(p_pm_type number, p_bd_type number) return varchar2
   is
   n_temp number(8);
   s_desc varchar2(188);
   begin
   
        if  p_pm_type is not  null then
            n_temp := p_pm_type;
			select surf_lookup  into n_temp from x_tab_surf_lookup where rownum =1 and pave_type = 'PM' and code =  p_pm_type;
            select Description  into s_desc from x_tab_surf_lookup where rownum =1 and pave_type = 'SURF' and code =  n_temp;
        Elsif p_bd_type is not null then
            n_temp := p_bd_type;
			select surf_lookup  into n_temp from x_tab_surf_lookup where rownum =1 and pave_type = 'BD' and code =  p_bd_type;
            select Description  into s_desc from x_tab_surf_lookup where rownum =1 and pave_type = 'SURF' and code =  n_temp;
		Else
		   n_temp := -1;
			s_desc := 'Unresolved Type';
        end if;
   
    
    return s_desc;
    
     exception when others then
     return 'Unresolved Type';
   end;
/

CREATE OR REPLACE function x_surf_lookup_m(p_pm_type number, p_bd_type number) return varchar2
   is
   n_temp number(8);
   s_desc varchar2(188);
   begin
   
        if  p_pm_type is not  null then
           s_desc := 'PM';
        Elsif p_bd_type is not null then
           s_desc := 'BD';
		Else
		   n_temp := -1;
			s_desc := 'N/A';
        end if;
   
    
    return s_desc;
    
     exception when others then
     return 'N/A';
   end;
/
