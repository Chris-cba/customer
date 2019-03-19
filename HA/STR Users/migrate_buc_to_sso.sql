   -------------------------------------------------------------------------
   --   PVCS Identifiers :-
   --
   --       pvcsid           : $Header:   //new_vm_latest/archives/customer/HA/STR Users/migrate_buc_to_sso.sql-arc   1.0   Mar 19 2019 17:01:30   Sarah.Williams  $
   --       Module Name      : $Workfile:   migrate_buc_to_sso.sql  $
   --       Date into PVCS   : $Date:   Mar 19 2019 17:01:30  $
   --       Date fetched Out : $Modtime:   Mar 19 2019 16:19:16  $
   --       PVCS Version     : $Revision:   1.0  $
   ------------------------------------------------------------------
   --   Copyright (c) 2019 Bentley Systems Incorporated. All rights reserved.
   ------------------------------------------------------------------
clear screen

undefine p_midtieruser

ACCEPT p_midtieruser char prompt 'ENTER THE NAME OF THE MIDTIER USER : ';

prompt
prompt registering users for Single Sign-On.............
prompt
--
--SET verify OFF;
--SET feedback OFF;
--SET serveroutput ON

  DECLARE
    --
    CURSOR c_users IS
    SELECT hus_username,
           nmu_email_address
      FROM nm_mail_users,
           hig_users,
           dba_users,
           bulk_user_creation
      WHERE nmu_hus_user_id = hus_user_id
        AND NVL(hus_end_date, sysdate+1) >sysdate
        AND hus_username = username
        AND hus_is_hig_owner_flag = 'N'
        AND account_status = 'OPEN'
        AND nmu_email_address IS NOT NULL
        AND hus_username = buc_actual_username
        AND buc_error is null
        AND NOT EXISTS (SELECT 1
                          FROM hig_relationship
                         WHERE hir_attribute1 = nmu_email_address);
    --
    CURSOR c_midtier IS
    SELECT 1
      FROM hig_user_roles
     WHERE hur_username = UPPER('&P_MIDTIERUSER')
       AND hur_role = 'PROXY_OWNER';
    --
    lr_hig_relationship  hig_relationship%ROWTYPE;
    --
    not_midtier   EXCEPTION;
    lv_key        RAW(32);
    lv_row_found  BOOLEAN;
    lv_dummy      PLS_INTEGER;
    --
    /*############################################## 
      
      All email usernames registered below will be
      excluded from automatic password generation
     
      ##############################################*/
    --
    lv_exclude_list VARCHAR2(32767) := 'USERNAME1,USERNAME2,USERNAME3';
    --
  BEGIN
    --
    -- Check midtier user
    --         
    OPEN c_midtier;
    FETCH c_midtier INTO lv_dummy;
    lv_row_found := c_midtier%FOUND;
    CLOSE c_midtier;
    
    IF NOT lv_row_found THEN
      RAISE not_midtier;
    END IF;
    
    FOR l_rec IN c_users LOOP
      --
      IF INSTR(lv_exclude_list,l_rec.hus_username) > 0
      THEN
        CONTINUE;
      END IF;
      --
      EXECUTE IMMEDIATE 'ALTER USER '||l_rec.hus_username||' GRANT CONNECT THROUGH &P_MIDTIERUSER';
      --
      
      lv_key := DBMS_CRYPTO.RANDOMBYTES(32);
      lr_hig_relationship.hir_attribute1 := l_rec.nmu_email_address;
      lr_hig_relationship.hir_attribute2 := hig_relationship_api.encrypt_input(pi_input_string => l_rec.hus_username,
                                                                               pi_key          => lv_key);
      lr_hig_relationship.hir_attribute3 := 'Y';
      lr_hig_relationship.hir_attribute4 := lv_key;
      
      hig_relationship_api.create_relationship(pi_relationship => lr_hig_relationship);
      --
    END LOOP;
    --
  EXCEPTION 
    WHEN not_midtier 
      THEN
        RAISE_APPLICATION_ERROR(-20001,'User is not recognised as MidTier User');
    WHEN OTHERS THEN
      RAISE;
  END;
/
