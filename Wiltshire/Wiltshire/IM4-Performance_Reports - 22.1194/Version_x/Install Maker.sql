variable v_pods varchar2(50);
exec :v_pods := 'WPR_4_1%';

Select *
From hig_modules
where hmo_module in (select ip_hmo_module from im_pods where ip_hmo_module in (select ip_hmo_module from im_pods where ip_hmo_module like :v_pods )) order by 1;

Select * 
From hig_module_roles 
Where hmr_module in (select ip_hmo_module from im_pods where ip_hmo_module in (select ip_hmo_module from im_pods where ip_hmo_module like :v_pods )) order by 1;

select * from im_pods where ip_hmo_module in (select ip_hmo_module from im_pods where ip_hmo_module like :v_pods and ip_id not in (5684))
order by ip_id
;

select * from im_pod_sql
where ips_ip_id in (select ip_id from im_pods where ip_hmo_module in (select ip_hmo_module from im_pods where ip_hmo_module like :v_pods and ip_id not in (5684) )) order by ips_ip_id;

select * from im_pod_chart 
where ip_id in (select ip_id from im_pods where ip_hmo_module in (select ip_hmo_module from im_pods where ip_hmo_module like :v_pods and ip_id not in (5684) )) order by ip_id;
