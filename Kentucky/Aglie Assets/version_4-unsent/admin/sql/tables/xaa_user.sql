/*
	The contents of this document, including system ideas and concepts, 
	are confidential and proprietary in nature and are not to be distributed 
	in any form without the prior written consent of Bentley Systems.
	
	Author: JMM
	UPDATE01:	Original, 2014.01.06,  JMM
*/

create  bigfile tablespace tbs_exor_to_aa
	datafile 'tbs_exor_to_aa.dat'
	size 20M
	autoextend on;

Create user exor_to_aa 
	identified by exor_to_aa 
	default tablespace tbs_exor_to_aa;
	
    grant connect to exor_to_aa;
    
    grant create session to exor_to_aa;
    
   alter user exor_to_aa default role connect;
   
   --------------------------------------------------------
   
   
grant execute on exor.xky_hig_to_aa to exor_to_aa;


---

grant all on exor.xaa_loc_ident to exor_to_aa; 

grant select on exor.xaa_net_ref  to exor_to_aa;

grant select on exor.xaa_route  to exor_to_aa;

grant select on exor.xaa_spatial_audit  to exor_to_aa;

grant select on exor.xaa_length_change to exor_to_aa;

grant select on exor.xaa_route_sdo to exor_to_aa;



-- as exor_to_aa

create or replace synonym exor_to_aa.xky_hig_to_aa for exor.xky_hig_to_aa;

create or replace synonym exor_to_aa.xaa_loc_ident for exor.xaa_loc_ident;

create or replace synonym exor_to_aa.xaa_net_ref for exor.xaa_net_ref;

create or replace synonym exor_to_aa.xaa_route for exor.xaa_route;

create or replace synonym exor_to_aa.XAA_ROUTE_SDO for exor.XAA_ROUTE_SDO;

create or replace synonym exor_to_aa.xaa_spatial_audit for exor.xaa_spatial_audit;


create or replace synonym exor_to_aa.XAA_LENGTH_CHANGE for exor.XAA_LENGTH_CHANGE;
