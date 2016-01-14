--..\admin\sql\tables\xaa_route_temp.sql
drop table xaa_route_temp_sql;

--..\admin\sql\tables\XAA_SPATIAL_AUDIT.sql
drop table XAA_SPATIAL_AUDIT;

--..\admin\sql\tables\xaa_asset_type.sql
drop table xaa_asset_type;
drop TABLE XAA_ASSET_ATTRIB;

--..\admin\sql\tables\xaa_length_change.sql
drop table xaa_length_change;
drop SEQUENCE xaa_leng_change_seq;

--..\admin\sql\tables\xaa_loc_ident_net_ref.sql
drop table XAA_LOC_IDENT;
drop table XAA_NET_REF;

--..\admin\sql\views\xaa_route_sdo.sql
drop view XAA_ROUTE_SDO;

--..\admin\sql\views\xaa_route.sql
drop view  xaa_route;

--..\admin\sql\views\xaa_route_all.sql
drop view  xaa_route_all;

drop view xaa_route_all_recal;

--..\admin\sql\triggers\xaa_SPATIAL_AUDIT_trg.sql
drop trigger xaa_spatial_audit_trg ;

--..\admin\sql\packages\x_log_table.pkh
drop package x_log_table;
drop SEQUENCE x_log_table_seq;
drop table  X_LOG_INFORMATION;



--..\admin\sql\packages\xky_hig_to_aa.pkh

drop package body xky_hig_to_aa;
