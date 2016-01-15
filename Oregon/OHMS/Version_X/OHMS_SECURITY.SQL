-- Create  Security Roles

declare 
Begin


  begin 
    execute immediate  'create role TI_APPROLE_OHMS_USER';
    EXCEPTION when OTHERS then null;
  end;




  execute immediate 'grant TI_APPROLE_OHMS_USER to TRANSINFO';



  begin 
      insert into hig_products (HPR_PRODUCT, HPR_PRODUCT_NAME, HPR_VERSION,HPR_KEY)
      values
      ('OHMS','OHMS Extrct','4.0.0.0','55');
  
    EXCEPTION when OTHERS then  null;
  end;


  begin
    insert into hig_roles (HRO_ROLE, HRO_PRODUCT, HRO_DESCR)
    values ('TI_APPROLE_OHMS_USER', 'OHMS','OHMS Extract');
  
  EXCEPTION when OTHERS then null;
  end;
  


  begin 
    insert into hig_user_roles (
    HUR_USERNAME, HUR_ROLE, HUR_START_DATE)
    values ('TRANSINFO', 'TI_APPROLE_OHMS_USER', TO_DATE('01-JAN-1901','DD-MON-YYYY'));
  
  EXCEPTION when OTHERS then null;
  end;
End;
  /