-- Create  Security Roles

create role TI_APPROLE_OHMS_USER;

grant TI_APPROLE_OHMS_USER to TRANSINFO;

insert into hig_products (HPR_PRODUCT, HPR_PRODUCT_NAME, HPR_VERSION,HPR_KEY)
values
('OHMS','OHMS Extrct','4.0.0.0','55');

insert into hig_roles (HRO_ROLE, HRO_PRODUCT, HRO_DESCR)
values ('TI_APPROLE_OHMS_USER', 'OHMS','OHMS Extract');

insert into hig_user_roles (
HUR_USERNAME, HUR_ROLE, HUR_START_DATE)
values ('TRANSINFO', 'TI_APPROLE_OHMS_USER', to_date('01-JAN-1901','DD-MON-YYYY'));
