CREATE OR REPLACE PACKAGE BODY generate_hestrusers
AS
   -------------------------------------------------------------------------
   --   PVCS Identifiers :-
   --
   --       pvcsid           : $Header:   //new_vm_latest/archives/customer/HA/STR Users/generate_hestrusers.pkb-arc   1.1   Aug 28 2019 10:58:54   Sarah.Williams  $
   --       Module Name      : $Workfile:   generate_hestrusers.pkb  $
   --       Date into PVCS   : $Date:   Aug 28 2019 10:58:54  $
   --       Date fetched Out : $Modtime:   Aug 28 2019 10:58:58  $
   --       PVCS Version     : $Revision:   1.1  $
   ------------------------------------------------------------------
   --   Copyright (c) 2019 Bentley Systems Incorporated. All rights reserved.
   ------------------------------------------------------------------
   --
   --all global package variables here

   -----------
   --constants
   -----------
   --g_body_sccsid is the SCCS ID for the package body
   g_body_sccsid    CONSTANT VARCHAR2 (2000) := '"$Revision:   1.1  $"';
   g_package_name   CONSTANT VARCHAR2 (30) := 'generate_hestrusers';

   --
   --
   -----------------------------------------------------------------------------
   --
   FUNCTION get_version
      RETURN VARCHAR2
   IS
   BEGIN
      RETURN g_sccsid;
   END get_version;

   --
   -----------------------------------------------------------------------------
   --
   FUNCTION get_body_version
      RETURN VARCHAR2
   IS
   BEGIN
      RETURN g_body_sccsid;
   END get_body_version;

   --
   -----------------------------------------------------------------------------
   --
   PROCEDURE validate_highways_owner
   IS
      --
      lv_result   PLS_INTEGER;
   --
   BEGIN
      -- validate user
      SELECT 1
        INTO lv_result
        FROM hig_users
       WHERE hus_is_hig_owner_flag = 'Y' AND hus_username = USER;
   --
   EXCEPTION
      WHEN NO_DATA_FOUND
      THEN
         RAISE_APPLICATION_ERROR (-20001,
                                  'Script must be run as Highways Owner');
      WHEN OTHERS
      THEN
         RAISE;
   END validate_highways_owner;

   --
   -----------------------------------------------------------------------------
   --
   PROCEDURE validate_role (pi_role hig_roles.hro_role%TYPE)
   IS
      --
      lv_result   PLS_INTEGER;
   --
   BEGIN
      -- validate role
      SELECT 1
        INTO lv_result
        FROM hig_roles
       WHERE hro_role = pi_role;
   --
   EXCEPTION
      WHEN NO_DATA_FOUND
      THEN
         RAISE_APPLICATION_ERROR (
            -20001,
            'Invalid Role ''' || pi_role || ''' defined');
      WHEN OTHERS
      THEN
         RAISE;
   END validate_role;

   --
   -----------------------------------------------------------------------------
   --
   PROCEDURE validate_admin_unit (
      pi_admin_unit    nm_admin_units.nau_unit_code%TYPE)
   IS
      --
      lv_result   PLS_INTEGER;
   --
   BEGIN
      -- validate admin unit
      SELECT 1
        INTO lv_result
        FROM nm_admin_units
       WHERE nau_admin_unit = pi_admin_unit AND nau_admin_type = 'NETW';
   --
   EXCEPTION
      WHEN NO_DATA_FOUND
      THEN
         g_error :=
               'Validate_Admin_Unit: Invalid Admin Unit '''
            || pi_admin_unit
            || ''' defined';
      WHEN OTHERS
      THEN
         g_error := 'Validate_Admin_Unit: ' || SUBSTR (SQLERRM, 1, 900);
   END validate_admin_unit;

   --
   -----------------------------------------------------------------------------
   --
   PROCEDURE validate_email (pi_email nm_mail_users.nmu_email_address%TYPE)
   IS
      --
      lv_result      PLS_INTEGER := 0;
      email_exists   EXCEPTION;
      no_email       EXCEPTION;
   --
   BEGIN
      lv_result := NVL (INSTR (pi_email, '@'), -99);

      IF lv_result < 0
      THEN
         RAISE no_email;
      ELSE
         lv_result := 0;
      END IF;

      SELECT COUNT (1)
        INTO lv_result
        FROM nm_mail_users
       WHERE LOWER (REPLACE (nmu_email_address, ' ')) =
                LOWER (REPLACE (pi_email, ' '));

      IF lv_result > 0
      THEN
         RAISE email_exists;
      END IF;
   EXCEPTION
      WHEN email_exists
      THEN
         g_error :=
            'Validate Email: Email address already exists ' || pi_email;
      WHEN no_email
      THEN
         g_error :=
            'Validate Email: Missing or invalid email cannot process user';
      WHEN NO_DATA_FOUND
      THEN
         NULL;
      WHEN OTHERS
      THEN
         g_error := 'Validate Email: ' || SUBSTR (SQLERRM, 1, 900);
   END validate_email;

   --
   -----------------------------------------------------------------------------
   --
   PROCEDURE add_role (pi_role          hig_roles.hro_role%TYPE,
                       pi_percent       PLS_INTEGER,
                       pi_admin_user    BOOLEAN DEFAULT FALSE)
   IS
      --
      lv_index   PLS_INTEGER := g_roles_tab.COUNT + 1;
   --
   BEGIN
      --
      validate_role (pi_role => pi_role);
      --

      -- add role to tab
      g_roles_tab (lv_index).role := pi_role;
      g_roles_tab (lv_index).percent := pi_percent;
      g_roles_tab (lv_index).admin_user := pi_admin_user;
   --
   END add_role;

   --
   -----------------------------------------------------------------------------
   --
   PROCEDURE add_admin_unit (
      pi_admin_unit    nm_admin_units.nau_admin_unit%TYPE)
   IS
      --
      lv_index   PLS_INTEGER := g_admin_unit_tab.COUNT + 1;
   --
   BEGIN
      -- validate admin unit
      validate_admin_unit (pi_admin_unit => pi_admin_unit);
      --
      g_admin_unit_tab (lv_index) := pi_admin_unit;
   --
   END add_admin_unit;

   --
   -----------------------------------------------------------------------------
   --
   PROCEDURE add_user_option (pi_option    hig_user_options.huo_id%TYPE,
                              pi_value     hig_user_options.huo_value%TYPE)
   IS
      --
      lv_index   PLS_INTEGER := g_user_options_tab.COUNT + 1;
   --
   BEGIN
      g_user_options_tab (lv_index).huo_id := pi_option;
      g_user_options_tab (lv_index).huo_value := pi_value;
   END add_user_option;

   -----------------------------------------------------------------------------
   --
   --
   -----------------------------------------------------------------------------
   --
   PROCEDURE initialise
   IS
   BEGIN
      --
      validate_highways_owner;
      --
      g_num_users := 0;
      g_roles_tab.DELETE;
      g_admin_unit_tab.DELETE;
      g_user_options_tab.DELETE;
   --
   END initialise;

   --
   -----------------------------------------------------------------------------
   --
   FUNCTION generate_username (pi_curr_username VARCHAR2)
      RETURN VARCHAR2
   IS
      --
      CURSOR check_existing (l_username VARCHAR2)
      IS
         SELECT hus_name
           FROM hig_users
          WHERE hus_username = l_username;

      --
      lv_count            NUMBER := 1;
      lv_final_username   hig_users.hus_username%TYPE;
      lv_name             hig_users.hus_name%TYPE := NULL;
      OUT_OF_INTEGERS     EXCEPTION;
   BEGIN
      lv_final_username := pi_curr_username;

      LOOP
         OPEN check_existing (lv_final_username);

         FETCH check_existing INTO lv_name;

         IF check_existing%FOUND
         THEN
            CLOSE check_existing;

            lv_final_username := pi_curr_username || TO_CHAR (lv_count);
         ELSE
            CLOSE check_existing;

            EXIT;
         END IF;

         lv_count := lv_count + 1;

         IF lv_count > 99
         THEN
            RAISE OUT_OF_INTEGERS;
            EXIT;
         END IF;
      END LOOP;

      --
      RETURN lv_final_username;
   --
   EXCEPTION
      WHEN OUT_OF_INTEGERS
      THEN
         g_error :=
               'Generate username: No available combinations for '
            || pi_curr_username
            || ' please reassign';
      WHEN OTHERS
      THEN
         g_error := 'Generate username: ' || SUBSTR (SQLERRM, 1, 900);
   --
   END generate_username;

   --
   -----------------------------------------------------------------------------
   --
   FUNCTION generate_initials (pi_curr_initials VARCHAR2)
      RETURN VARCHAR2
   IS
      --
      CURSOR check_existing (l_init VARCHAR2)
      IS
         SELECT hus_username
           FROM hig_users
          WHERE hus_initials = l_init;

      --
      lv_count            NUMBER := 1;
      lv_final_initials   hig_users.hus_initials%TYPE;
      lv_username         hig_users.hus_username%TYPE := NULL;
      OUT_OF_INTEGERS     EXCEPTION;
   BEGIN
      nm_debug.debug ('BUC pi curr initials = ' || pi_curr_initials);
      lv_final_initials := pi_curr_initials;

      LOOP
         OPEN check_existing (lv_final_initials);

         FETCH check_existing INTO lv_username;

         IF check_existing%FOUND
         THEN
            nm_debug.debug ('BUC in found check inits ' || lv_final_initials);

            CLOSE check_existing;

            IF lv_count > 9
            THEN
               lv_final_initials :=
                  SUBSTR (pi_curr_initials, 1, 1) || TO_CHAR (lv_count);
            ELSE
               lv_final_initials :=
                  SUBSTR (pi_curr_initials, 1, 2) || TO_CHAR (lv_count);
               nm_debug.debug (
                  'BUC in found check inits ' || lv_final_initials);
            END IF;
         ELSE
            CLOSE check_existing;

            EXIT;
         END IF;

         lv_count := lv_count + 1;

         IF lv_count > 99
         THEN
            RAISE OUT_OF_INTEGERS;
            EXIT;
         END IF;
      END LOOP;

      --
      RETURN lv_final_initials;
   --
   EXCEPTION
      WHEN OUT_OF_INTEGERS
      THEN
         g_error :=
               'Generate initials: No available combinations for '
            || pi_curr_initials
            || ' please reassign';
      WHEN OTHERS
      THEN
         g_error := 'Generate initials: ' || SUBSTR (SQLERRM, 1, 900);
   --
   END generate_initials;

   --
   -----------------------------------------------------------------------------
   --
   FUNCTION get_admin_unit (pi_admin_unit nm_admin_units.nau_unit_code%TYPE)
      RETURN nm_admin_units%ROWTYPE
   IS
      --
      CURSOR c1 (cv_au VARCHAR2)
      IS
         SELECT *
           FROM nm_admin_units
          WHERE nau_unit_code = cv_au AND nau_admin_type = 'NETW';

      --
      lv_au       nm_admin_units.nau_unit_code%TYPE;
      lv_return   nm_admin_units%ROWTYPE;
   --
   BEGIN
      --
      -- translate numeric or SWR from bulk table
      --
      IF pi_admin_unit = 'SWR'
      THEN
         lv_au := pi_admin_unit;
      ELSIF LENGTH (pi_admin_unit) < 3
      THEN
         lv_au := 'A' || LPAD (pi_admin_unit, 2, '0');
      ELSE
         lv_au := pi_admin_unit;
      END IF;

      --
      OPEN c1 (lv_au);

      FETCH c1 INTO lv_return;

      CLOSE c1;

      --
      RETURN lv_return;
   --
   EXCEPTION
      WHEN OTHERS
      THEN
         g_error := 'Get Admin Unit: ' || SUBSTR (SQLERRM, 1, 900);
   END get_admin_unit;

   --
   -----------------------------------------------------------------------------
   --
   PROCEDURE create_users
   IS
      --
      TYPE perc_tab IS TABLE OF PLS_INTEGER
         INDEX BY BINARY_INTEGER;

      lt_perc_tab             perc_tab;

      lv_role_percent         PLS_INTEGER;
      lv_admin_unit_percent   PLS_INTEGER;
      lv_perc_sum             PLS_INTEGER := 0;
      lv_perc_num             PLS_INTEGER := 1;
      --
      lt_role_tab             user_roles_tab;
      lr_user_rec             hig_users%ROWTYPE;
      lr_admin_unit_rec       nm_admin_units%ROWTYPE;
      lv_admin_unit           nm_admin_units.nau_unit_code%TYPE;
      lv_user_no              PLS_INTEGER := 0;
      lv_admin_user_no        PLS_INTEGER := 0;
      lv_username             hig_users.hus_username%TYPE;
      lv_initials             VARCHAR2 (3) := '000';
      lv_db_name              VARCHAR2 (30);
      --
      e_data_issue            EXCEPTION;

      --
      PROCEDURE create_test_user (pi_user_rec          hig_users%ROWTYPE,
                                  pi_user_roles_tab    user_roles_tab)
      IS
         --
         CURSOR c1
         IS
            SELECT default_tablespace, temporary_tablespace, 'DEFAULT'
              FROM dba_users
             WHERE username = USER;

         --
         lr_user_rec               hig_users%ROWTYPE;
         lv_default_tablespace     dba_users.default_tablespace%TYPE;
         lv_temp_tablespace        dba_users.temporary_tablespace%TYPE;
         lv_profile                dba_users.profile%TYPE;
         lv_sql                    VARCHAR2 (2000);
         --
         username_already_exists   EXCEPTION;

         --
         FUNCTION validate_user_existence (
            pi_username    hig_users.hus_username%TYPE)
            RETURN BOOLEAN
         IS
            --
            CURSOR c1
            IS
               SELECT 1
                 FROM hig_users
                WHERE hus_username = pi_username
               UNION
               SELECT 1
                 FROM dba_users
                WHERE username = pi_username;

            --
            lv_result      PLS_INTEGER;
            lv_row_found   BOOLEAN;
         --
         BEGIN
            --
            OPEN c1;

            FETCH c1 INTO lv_result;

            lv_row_found := c1%FOUND;

            CLOSE c1;

            --
            IF lv_row_found
            THEN
               RETURN FALSE;
            ELSE
               RETURN TRUE;
            END IF;

            --
            RETURN TRUE;
         EXCEPTION
            WHEN OTHERS
            THEN
               g_error :=
                  'Validate user existence: ' || SUBSTR (SQLERRM, 1, 900);
         END validate_user_existence;

         --
         PROCEDURE grant_role (pi_role            VARCHAR2,
                               pi_username        hig_users.hus_username%TYPE,
                               pi_admin_option    BOOLEAN DEFAULT FALSE,
                               pi_create_role     BOOLEAN DEFAULT FALSE,
                               pi_create_date     DATE DEFAULT NULL)
         IS
         BEGIN
            --
            IF pi_admin_option
            THEN
               EXECUTE IMMEDIATE
                     'GRANT '
                  || pi_role
                  || ' TO '
                  || pi_username
                  || ' WITH ADMIN OPTION';
            ELSE
               EXECUTE IMMEDIATE 'GRANT ' || pi_role || ' TO ' || pi_username;
            END IF;

            --
            IF pi_create_role
            THEN
               INSERT
                 INTO hig_user_roles (hur_username, hur_role, hur_start_date)
               VALUES (pi_username, pi_role, pi_create_date);
            END IF;
         --
         END grant_role;
      --
      BEGIN
         -- Check if the username or Oracle user name already exists
         IF validate_user_existence (pi_username => pi_user_rec.hus_username)
         THEN
            -- Get the Oracle user attributes from the highways owner user
            OPEN c1;

            FETCH c1
               INTO lv_default_tablespace, lv_temp_tablespace, lv_profile;

            CLOSE c1;

            -- Create the user
            lr_user_rec := pi_user_rec;
            nm3ddl.create_user (
               p_rec_hus              => lr_user_rec,
               p_password             =>    LOWER (lr_user_rec.hus_initials)
                                         || TO_CHAR (lr_user_rec.hus_user_id),
               p_default_tablespace   => lv_default_tablespace,
               p_temp_tablespace      => lv_temp_tablespace,
               p_default_quota        => '10M',
               p_profile              => lv_profile);

            -- Grant connection privileges
            grant_role (pi_role       => 'ANALYZE ANY',
                        pi_username   => lr_user_rec.hus_username);
            grant_role (pi_role       => 'CREATE SEQUENCE',
                        pi_username   => lr_user_rec.hus_username);
            grant_role (pi_role       => 'CREATE SESSION',
                        pi_username   => lr_user_rec.hus_username);
            grant_role (pi_role       => 'CREATE TABLE',
                        pi_username   => lr_user_rec.hus_username);
            grant_role (pi_role       => 'CREATE VIEW',
                        pi_username   => lr_user_rec.hus_username);
            grant_role (pi_role       => 'DELETE ANY TABLE',
                        pi_username   => lr_user_rec.hus_username);
            grant_role (pi_role       => 'EXECUTE ANY PROCEDURE',
                        pi_username   => lr_user_rec.hus_username);
            grant_role (pi_role           => 'EXECUTE ANY TYPE',
                        pi_username       => lr_user_rec.hus_username,
                        pi_admin_option   => TRUE);
            grant_role (pi_role       => 'INSERT ANY TABLE',
                        pi_username   => lr_user_rec.hus_username);
            grant_role (pi_role       => 'LOCK ANY TABLE',
                        pi_username   => lr_user_rec.hus_username);
            grant_role (pi_role       => 'SELECT ANY DICTIONARY',
                        pi_username   => lr_user_rec.hus_username);
            grant_role (pi_role       => 'SELECT ANY SEQUENCE',
                        pi_username   => lr_user_rec.hus_username);
            grant_role (pi_role       => 'SELECT ANY TABLE',
                        pi_username   => lr_user_rec.hus_username);
            grant_role (pi_role       => 'UPDATE ANY TABLE',
                        pi_username   => lr_user_rec.hus_username);

            -- Grant required roles
            grant_role (pi_role          => 'HIG_USER',
                        pi_username      => lr_user_rec.hus_username,
                        pi_create_role   => TRUE,
                        pi_create_date   => lr_user_rec.hus_start_date);
            grant_role (pi_role          => 'LB_USER',
                        pi_username      => lr_user_rec.hus_username,
                        pi_create_role   => TRUE,
                        pi_create_date   => lr_user_rec.hus_start_date);

            -- Create login trigger
            lv_sql :=
                  'CREATE OR REPLACE TRIGGER '
               || lr_user_rec.hus_username
               || '.INSTANTIATE_USER'
               || CHR (10)
               || '  AFTER LOGON ON '
               || lr_user_rec.hus_username
               || '.SCHEMA'
               || CHR (10)
               || 'BEGIN'
               || CHR (10)
               || '  nm3security.set_user;'
               || CHR (10)
               || '  nm3context.initialise_context;'
               || CHR (10)
               || '  nm3user.instantiate_user;'
               || CHR (10)
               || 'EXCEPTION'
               || CHR (10)
               || '  WHEN OTHERS THEN NULL;'
               || CHR (10)
               || 'END instantiate_user;';

            --
            EXECUTE IMMEDIATE lv_sql;
         ELSE
            RAISE username_already_exists;
         END IF;
      EXCEPTION
         WHEN username_already_exists
         THEN
            g_error :=
                  'Create test user: Username '
               || lr_user_rec.hus_username
               || ' already exists';
         WHEN OTHERS
         THEN
            g_error := 'Create test user: ' || SUBSTR (SQLERRM, 1, 900);
      END create_test_user;
   --
   BEGIN
      nm_debug.debug_on;
      nm_debug.debug ('BUC Starting');

      nm_debug.debug ('BUC post Initialise');

      FOR i IN (  SELECT buc_name,
                         buc_initials,
                         buc_username,
                         buc_email_address,
                         buc_au1,
                         buc_au2,
                         buc_au3,
                         buc_au4,
                         buc_train_date
                    FROM bulk_user_creation
                   WHERE buc_actual_username IS NULL
                ORDER BY buc_username)
      LOOP
         BEGIN
            nm_debug.debug_on;
            initialise;
            g_error := '';
            --
            -- check for user with same email address first as that would indicate a duplicate
            --
            nm_debug.debug ('BUC Email address = ' || i.buc_email_address);
            validate_email (i.buc_email_address);

            IF g_error IS NOT NULL
            THEN
               RAISE e_data_issue;
            END IF;

            --
            -- check manually derived username and initials and amend if they already exist for another user
            --
            lv_username := generate_username (i.buc_username);

            IF g_error IS NOT NULL
            THEN
               RAISE e_data_issue;
            END IF;

            nm_debug.debug ('BUC ' || lv_username);

            --
            -- make a record of the actual username assigned for email generation
            --
            UPDATE bulk_user_creation
               SET buc_actual_username = lv_username
             WHERE buc_username = i.buc_username AND buc_name = i.buc_name;

            lv_initials := generate_initials (i.buc_initials); -- will be provided but need to ensure they're unique

            IF g_error IS NOT NULL
            THEN
               RAISE e_data_issue;
            END IF;

            nm_debug.debug ('BUC ' || lv_initials);

            UPDATE bulk_user_creation
               SET buc_actual_initials = lv_initials
             WHERE buc_username = i.buc_username AND buc_name = i.buc_name;

            --
            -- admin units are given as number or SWR in the spreadsheet so calculate actual admin unit from that
            --
            lr_admin_unit_rec := get_admin_unit (i.buc_au1);
            nm_debug.debug ('BUC ' || lr_admin_unit_rec.nau_unit_code);
            lv_admin_unit := lr_admin_unit_rec.nau_unit_code;
            --
            -- derive remaining user details
            --
            lr_user_rec.hus_user_id := hus_user_id_seq.NEXTVAL;
            lr_user_rec.hus_username := lv_username;
            lr_user_rec.hus_initials := lv_initials;
            lr_user_rec.hus_name := i.buc_name;
            lr_user_rec.hus_start_date := i.buc_train_date;
            lr_user_rec.hus_unrestricted := 'N';
            lr_user_rec.hus_is_hig_owner_flag := 'N';
            lr_user_rec.hus_admin_unit := lr_admin_unit_rec.nau_admin_unit;
            nm_debug.debug ('BUC here');
            --
            nm_debug.debug ('BUC ' || '-----------------------------------');
            nm_debug.debug (
                  'BUC '
               || '-  hus_user_id           :'
               || lr_user_rec.hus_user_id);
            nm_debug.debug (
                  'BUC '
               || '-  hus_username          :'
               || lr_user_rec.hus_username);
            nm_debug.debug (
                  'BUC '
               || '-  hus_initials          :'
               || lr_user_rec.hus_initials);
            nm_debug.debug (
               'BUC ' || '-  hus_name              :' || lr_user_rec.hus_name);
            nm_debug.debug (
                  'BUC '
               || '-  hus_job_title         :'
               || lr_user_rec.hus_job_title);
            nm_debug.debug (
                  'BUC '
               || '-  hus_start_date        :'
               || lr_user_rec.hus_start_date);
            nm_debug.debug (
                  'BUC '
               || '-  hus_unrestricted      :'
               || lr_user_rec.hus_unrestricted);
            nm_debug.debug (
                  'BUC '
               || '-  hus_is_hig_owner_flag :'
               || lr_user_rec.hus_is_hig_owner_flag);
            nm_debug.debug (
                  'BUC '
               || '-  hus_admin_unit        :'
               || lr_user_rec.hus_admin_unit);

            --
            /*
            || Create the user in the user table
            */
            nm_debug.debug ('BUC before create');

            nm_debug.debug ('BUC inside if');
            create_test_user (pi_user_rec         => lr_user_rec,
                              pi_user_roles_tab   => lt_role_tab);

            --
            -- Add admin units to the Users admin unit tab
            -- and derive admin unit based user option values
            --
            IF g_error IS NOT NULL
            THEN
               RAISE e_data_issue;
            END IF;

            g_admin_unit_tab.DELETE;

            IF lr_admin_unit_rec.nau_unit_code = 'SWR'
            THEN -- first AU fetched earlier.  If SWR then add A01 and A02 in AU tab
               lr_admin_unit_rec := get_admin_unit ('A01');
               nm_debug.debug (
                  'BUC A01 ' || lr_admin_unit_rec.nau_admin_unit);
               add_admin_unit (lr_admin_unit_rec.nau_admin_unit);

               IF g_error IS NOT NULL
               THEN
                  RAISE e_data_issue;
               END IF;

               add_user_option ('DEFDOCLOCN', 'JPG_FILES_A01');
               add_user_option ('GISGRPD', 'OP-A01');
               lr_admin_unit_rec := get_admin_unit ('A02');
               add_admin_unit (lr_admin_unit_rec.nau_admin_unit);

               IF g_error IS NOT NULL
               THEN
                  RAISE e_data_issue;
               END IF;
            ELSE
               add_admin_unit (lr_admin_unit_rec.nau_admin_unit);

               IF g_error IS NOT NULL
               THEN
                  RAISE e_data_issue;
               END IF;

               add_user_option (
                  'DEFDOCLOCN',
                  'JPG_FILES_' || lr_admin_unit_rec.nau_unit_code);
               add_user_option ('GISGRPD',
                                'OP-' || lr_admin_unit_rec.nau_unit_code);
            END IF;

            --
            --now add further AUs to the list if they're required
            --
            IF i.buc_au2 IS NOT NULL
            THEN
               lr_admin_unit_rec := get_admin_unit (i.buc_au2);
               add_admin_unit (lr_admin_unit_rec.nau_admin_unit);

               IF g_error IS NOT NULL
               THEN
                  RAISE e_data_issue;
               END IF;
            END IF;

            IF i.buc_au3 IS NOT NULL
            THEN
               lr_admin_unit_rec := get_admin_unit (i.buc_au3);
               add_admin_unit (lr_admin_unit_rec.nau_admin_unit);

               IF g_error IS NOT NULL
               THEN
                  RAISE e_data_issue;
               END IF;
            END IF;

            IF i.buc_au4 IS NOT NULL
            THEN
               lr_admin_unit_rec := get_admin_unit (i.buc_au4);
               add_admin_unit (lr_admin_unit_rec.nau_admin_unit);

               IF g_error IS NOT NULL
               THEN
                  RAISE e_data_issue;
               END IF;
            END IF;

            FOR j IN 1 .. g_admin_unit_tab.COUNT
            LOOP
               INSERT INTO nm_user_aus_all (nua_user_id,
                                            nua_admin_unit,
                                            nua_start_date,
                                            nua_mode)
                    VALUES (lr_user_rec.hus_user_id,
                            g_admin_unit_tab (j),
                            lr_user_rec.hus_start_date,
                            'NORMAL');
            END LOOP;

            --
            -- User Options
            --
            SELECT LOWER (db_unique_name) INTO lv_db_name FROM v$database;

            add_user_option ('DEFDOCTYPE', 'DEFP');
            add_user_option (
               'INTERPATH',
                  'E:\bentley_dir\'
               || lv_db_name
               || '\mai\asset_inspections_upload');
            add_user_option ('PREFUNITS', '1');
            add_user_option (
               'REPCLIPATH',
               'C:\bentley\Listeners\Output\' || lv_db_name || '\Reports\');
            add_user_option (
               'REPOUTPATH',
               'C:\bentley\Listeners\Output\' || lv_db_name || '\Reports\');
            add_user_option (
               'UTL_URLDIR',
                  'https://portal-iamis.bentley.com/app15repout/'
               || lv_db_name
               || '/reports/');
            add_user_option ('WORKFOLDER', 'C:\temp\');

            FOR l IN 1 .. g_user_options_tab.COUNT
            LOOP
               INSERT
                 INTO hig_user_options (huo_hus_user_id, huo_id, huo_value)
                  VALUES (
                            lr_user_rec.hus_user_id,
                            g_user_options_tab (l).huo_id,
                            g_user_options_tab (l).huo_value);
            END LOOP;

            --
            -- create mail user
            --
            INSERT INTO nm_mail_users (nmu_id,
                                       nmu_name,
                                       nmu_hus_user_id,
                                       nmu_email_address)
                 VALUES (nmu_id_seq.NEXTVAL,
                         lr_user_rec.hus_name,
                         lr_user_rec.hus_user_id,
                         i.buc_email_address);

            --
            COMMIT;
         --
         EXCEPTION
            WHEN e_data_issue
            THEN
               UPDATE bulk_user_creation
                  SET buc_error = g_error
                WHERE buc_username = i.buc_username AND buc_name = i.buc_name;
            WHEN OTHERS
            THEN
               g_error := 'Create users: ' || SUBSTR (SQLERRM, 1, 900);

               UPDATE bulk_user_creation
                  SET buc_error = g_error
                WHERE buc_username = i.buc_username AND buc_name = i.buc_name;
         END;
      END LOOP;
   --
   --nm_debug.debug_off;
   --
   EXCEPTION
      WHEN OTHERS
      THEN
         ROLLBACK;
         nm_debug.debug_off;
         RAISE;
   END create_users;

   --
   -----------------------------------------------------------------------------
   --
   PROCEDURE drop_user (pi_username hig_users.hus_username%TYPE)
   IS
   BEGIN
      --
      DELETE FROM im_user_pods
            WHERE iup_hus_username = pi_username;

      DELETE FROM im_user_tabs
            WHERE iut_hus_username = pi_username;

      DELETE FROM nm_mail_users
            WHERE nmu_hus_user_id = (SELECT hus_user_id
                                       FROM hig_users
                                      WHERE hus_username = pi_username);

      DELETE FROM hig_users
            WHERE hus_username = pi_username;

      EXECUTE IMMEDIATE 'DROP USER ' || pi_username || ' CASCADE';

      --
      COMMIT;
   --
   END drop_user;
--
-----------------------------------------------------------------------------
--

END generate_hestrusers;
/
