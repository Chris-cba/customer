-----------------------------------------------------------------------------
--
--	UNICLASS.PKB
--
-----------------------------------------------------------------------------
--	Copyright (c) exor corporation ltd, 2004
-----------------------------------------------------------------------------
--   SCCS Identifiers :-
--
--       sccsid           : @(#)uniclass.pkb	1.3 09/06/05
--       Module Name      : uniclass.pkb
--       Date into SCCS   : 05/09/06 16:38:55
--       Date fetched Out : 07/06/06 14:38:56
--       SCCS Version     : 1.3
--
-----------------------------------------------------------------------------
CREATE OR REPLACE PACKAGE BODY UNICLASS AS
  --
  debug              BOOLEAN:=false;
  --
  File_Handle        utl_file.file_type;   -- File handle
  Output_File        utl_file.file_type;   -- File handle
  --
  FFile              VARCHAR2(80);         -- Input file name
  FDest              VARCHAR2(80);         -- Input directory name
  Ftype              VARCHAR2(1);          -- File type
  FSuffix            VARCHAR2(3);          -- Entered file suffix
  FSeq               NUMBER;               -- Sequence number
  FFileext           VARCHAR2(3);          -- Output file extension
  --
  G_Authority          road_segs.rse_agency%TYPE;
  G_Call_Categories    varchar2(200);
  G_Date_From          date;
  G_Date_To            date;
  G_Output_Location    varchar2(1000);
  G_Passed_Status      docs.doc_status_code%TYPE;
  G_Job_ID             gri_report_runs.grr_job_id%TYPE;
  G_Module             hig_modules.hmo_module%TYPE := 'UNICLASS';
  G_Contractor_Id      NUMBER:=0;
  G_Wol_id             NUMBER:=0;
  G_Gang_Code          work_order_lines.wol_gang%TYPE;
  G_wor_date_confirmed work_orders.wor_date_confirmed%TYPE;

  --
  FRead              CHAR:='R';          -- Read Character
  FWrite             CHAR:='W';          -- Write character
  v_filename         VARCHAR2(80);       -- Compound filename
  i                  INTEGER;            -- Counter
  --
  null_authority     exception;
  null_location      exception;
  null_passed_status exception;
  invalid_dates      exception;
-- *****************************************************************************
-- Procedure Create File
-- *****************************************************************************
PROCEDURE  Create_File(loc_in IN VARCHAR2
                      ,file_in IN VARCHAR2) IS
BEGIN
  -- Open the specified file for writing
  IF debug THEN
    nm_debug.debug('{ Function - Create File }');
    nm_debug.debug('Location : '||loc_in);
    nm_debug.debug('File     : '||file_in);
  END IF;
  file_handle:=utl_file.fopen(loc_in,file_in,FWrite);
  --
EXCEPTION
  WHEN OTHERS THEN
    nm_debug.debug('Error: An unknown error occured - {Create_File}');
  RAISE;
END;
-- *****************************************************************************
-- Check for the existence of a specified file
-- *****************************************************************************
FUNCTION FileExists(loc_in   IN VARCHAR2
                   ,file_in  IN VARCHAR2) RETURN BOOLEAN IS
BEGIN
  -- Open the file
  IF debug THEN
    nm_debug.debug('Path   : '||loc_in);
    nm_debug.debug('File   : '||file_in);
  END IF;
  --
  IF NOT is_open(file_handle) THEN
    IF NOT Close_File(File_handle) THEN
      nm_debug.debug('Info: Unable to close open file.');
    END IF;
    file_handle:=utl_file.fopen(loc_in,file_in,FRead);
  END IF;
  --
  IF debug THEN
    nm_debug.debug('Info: Handle Obtained - {FileExists}');
  END IF;
  --
  -- Return the result of a check with IS_OPEN
  utl_file.fclose(file_handle);
  --
  RETURN TRUE;
  --
EXCEPTION
  WHEN OTHERS THEN
    RETURN FALSE;
END;
-- *****************************************************************************
-- Check to see whether a specified file is open
-- *****************************************************************************
FUNCTION Is_Open(file_in IN utl_file.file_type) RETURN BOOLEAN IS
BEGIN
  IF utl_file.is_open(file_in) THEN
    RETURN TRUE;
  ELSE
    RETURN FALSE;
  END IF;
END;
-- *****************************************************************************
-- Closes an open file.
-- *****************************************************************************
FUNCTION Close_File(file_in IN utl_file.file_type) RETURN BOOLEAN IS
BEGIN
  utl_file.fclose(File_Handle);
  IF is_open(File_Handle) THEN
    RETURN FALSE;
  ELSE
    RETURN TRUE;
  END IF;
END;
--
-- *****************************************************************************
-- Write an output line to a file
-- *****************************************************************************
FUNCTION Writeln(File_Handle IN utl_file.File_Type, line_in IN VARCHAR2) RETURN BOOLEAN IS
BEGIN
  --
  -- Force a ^M on the end of the line
  utl_file.put_line(File_Handle,line_in || chr(13));
  utl_file.fflush(File_Handle);
  --
  RETURN TRUE;
EXCEPTION
  WHEN OTHERS THEN
    RETURN FALSE;
END;
--
-- *****************************************************************************
-- This procedure checks if the interface is being run from the gri or via the
-- command line.  If the gri is being used, the parameters entered are assigned
-- to the appropriate global variables.  If the command line is used, entries
-- in gri_report_runs and gri_run_parameters are made and the default gri values
-- used so they can be picked up for any parameters left null at the command line.
-- Also does validation on parameters to make sure all mandatory values have
-- been supplied.
-- *****************************************************************************
PROCEDURE fetch_params(p_job_id IN NUMBER) IS
  cursor c_default_value(p_gri_param IN varchar2) is
    select grp_value
    from   gri_run_parameters
    where  grp_param = p_gri_param
    and    grp_job_id = g_job_id;
  cursor c_interpath is
    select huo.huo_value
    from   hig_user_options huo
    ,      hig_users        hus
    where  huo.huo_id = 'INTERPATH'
    and    huo.huo_hus_user_id = hus.hus_user_id
    and    hus.hus_username = user;
  cursor c_parameter_sequence is
    select max(grp_seq)
    from   gri_run_parameters
    where  grp_job_id = g_job_id;
  l_default_value    gri_run_parameters.grp_value%TYPE := null;
  l_sequence         number;
  l_job_id           number;
  l_error_code       number;
  l_error_message    varchar2(240);
  l_category         doc_types.dtp_code%TYPE;
BEGIN
  IF debug THEN
    nm_debug.debug('{ in fetch params }');
  END IF;
  if p_job_id is not null then

  -- Interface called from GRI - pick up GRI parameter entries

    g_output_location := higgrirp.get_parameter_value(p_job_id,'TEXT');
    g_contractor_id := higgrirp.get_parameter_value(p_job_id,'CONTRACTOR_ID');
    g_job_id := p_job_id;
  else

  -- Interface called from command line - insert GRI entries and pick up gri default values.
  IF debug THEN
    nm_debug.debug('{ Where I expect to be }');
  END IF;
    higgri.get_params(g_module,l_job_id);
    higgri.get_defaults(l_job_id,g_module);
    insert into gri_report_runs
               (grr_job_id
               ,grr_module
               ,grr_username
               ,grr_submit_date
               ,grr_act_start_date
               ,grr_report_dest)
    values (    l_job_id
               ,g_module
               ,user
               ,sysdate
               ,null
               ,g_module||'.sql');
    g_job_id := l_job_id;
  end if;

  if g_output_location is null then
    open c_default_value('TEXT');
    fetch c_default_value into g_output_location;
    close c_default_value;
    if g_output_location is null then
      nm_debug.debug('Warning: no parameter entry and no default found for FILE LOCATION, trying INTERPATH user option instead');
      open c_interpath;
      fetch c_interpath into g_output_location;
      if c_interpath%NOTFOUND then
        raise null_location;
      end if;
      close c_interpath;
    end if;
  end if;

  -- Make sure there are no null parameter entries left as they are all required for this module
  if g_output_location is null then
    raise null_location;
  else
  -- Print all parameter selections out to log file
    nm_debug.debug('.');
    nm_debug.debug('Parameter Selections');
    nm_debug.debug('--------------------');
    nm_debug.debug('Output Location : '||g_output_location);
    nm_debug.debug('.');
  end if;


EXCEPTION
  when null_location then
    raise_application_error(-20003,'No output file location parameter supplied');
  when others then
    l_error_code := SQLCODE;
    l_error_message := substr(SQLERRM(l_error_code),1,80)||'{ Fetch_params }';
    nm_debug.debug(l_error_message);
    raise;
END;
-- *****************************************************************************
-- This procedure should provide Norfolk with the facility to download
-- data required by the Uniclass Income Interface file format.
-- *****************************************************************************
FUNCTION ProcessUniclass RETURN BOOLEAN IS
  fn         VARCHAR2(20):='{ ProcessUniclass }';
  rec_count  INTEGER:=1; -- number of records loaded allow for header
  j          INTEGER:=0; -- count INSTRUCTED
  -- table type to store buffer output before outputting contents to a file
  TYPE t1 IS TABLE OF VARCHAR2(2000) INDEX BY BINARY_INTEGER;
  cursor_recs t1;

  /* cursor definitions */

   cursor c_wol_income is
  --
  -- MI Measured Income |  AI Actual Income
  -- actuals to date    |  Final cumulative when fully PAID
  -- Stage 1 of interface - does not deal with INTERIMS
  -- Stage 2 will need a rethink as needs to include VALUATION INTERIMS solution.
  --
    select
      decode(wol_status_code,'PAID','AI','MI')
    ||rpad(nvl(nm3flx.validate_domain_value('GANG', wol_gang),'NULL'),8)
    ||lpad(to_char(wol_id),12)
    ||decode(wol_status_code,'PAID',to_char(wol_date_complete,'DDMONRRRR'),to_char(wor_date_confirmed,'DDMONRRRR'))
    ||to_char(nvl(wol_act_cost,0)*100,'S099999999')
    ||' '
    ||rpad(wol_works_order_no,20)
    ||rpad(wol_status_code,10)
    ||rtrim(to_char(nvl(wol_act_cost,0)*100,'S099999999'))
    rec,
    wol_status_code,
    wol_gang,
    wol_id
--    ,lpad(to_char(wol_id),12) rec1
    from work_order_lines w,work_orders,contracts
    where wor_works_order_no=wol_works_order_no
    and wor_con_id = con_id
    and con_contr_org_id = g_contractor_id
    and wor_act_cost is not null
--    and (wol_works_order_no like '04/MAIN/%'
--    or wol_works_order_no like '7469/17373%')
    and not exists ( select u.wol_id from uniclass_sent u
                     where u.wol_id = w.wol_id )
    and 0 < ( select nvl(sum( nvl( boq_act_cost, 0 ) ),0)
              from   boq_items bql
              where  bql.boq_wol_id = wol_id )
    --and rownum < 5
    order by wol_gang ;

    cursor c_boq_est is
    select
     'ES'
    ||g_wol_id ||boq_id
    ||g_gang_code
    ||lpad(to_char(g_wol_id),12)
    ||rpad(boq_sta_item_code,10)
    ||to_char(nvl(boq_est_quantity,0)*100,'S099999999')
    ||rpad(boq_id,20)
    ||'          '
    ||to_char(nvl(boq_act_cost,0)*100,'S099999999') rec
    from boq_items
    where boq_wol_id = g_wol_id;

    cursor c_boq_measured_income is
    select
     'CS'
    ||rpad(nvl(nm3flx.validate_domain_value('GANG', g_gang_code),'NULL'),8)
    ||lpad(to_char(g_wol_id),12)
    ||rpad(boq_sta_item_code,10)
    ||to_char(nvl(boq_act_quantity,0)*100,'S099999999')
    ||rpad(boq_id,20)
    ||'          '
    ||to_char(nvl(boq_act_cost,0)*100,'S099999999')
    rec
    from boq_items
    where boq_wol_id = g_wol_id
    and  nvl(boq_act_quantity,0) > 0
    ;

    cursor c_boq_actual_income is
    select
     'IS'
    ||rpad(nvl(nm3flx.validate_domain_value('GANG', g_gang_code),'NULL'),8)
    ||lpad(to_char(g_wol_id),12)
    ||rpad(boq_sta_item_code,10)
    ||to_char(nvl(boq_act_quantity,0)*100,'S099999999')
    ||rpad(boq_id,20)
    ||'          '
    ||to_char(nvl(boq_act_cost,0)*100,'S099999999')
    rec
    from boq_items
    where boq_wol_id = g_wol_id
    and  nvl(boq_act_quantity,0) > 0
    ;

BEGIN
  IF debug THEN
    nm_debug.debug('{ in process uniclass }');
  END IF;
  -- Derive filename from parameter entries
  v_filename := 'INCOME'||to_char(sysdate,'YYYYMMDDHH24MI')||'.TXT';

  IF NOT FileExists(g_output_location,v_Filename) THEN
    create_file(g_output_location,v_filename);
  ELSE
    create_file(g_output_location,v_filename);  -- Overwrite the file anyway
  END IF;

  for i_rec in c_wol_income loop
    rec_count := rec_count+1;
    cursor_recs(rec_count) := i_rec.rec;
--    g_wol_id:=to_number(i_rec.rec1);
    g_wol_id:=i_rec.wol_id;
    g_gang_code:=rpad(nvl(i_rec.wol_gang,-1),8);
    -- if i_rec.wol_status_code = 'INSTRUCTED'
    -- then
    -- dont forget to write to a table
    -- to prevent being sent again
    --    for j_rec in c_boq_est loop
    --    rec_count:=rec_count+1;
    --    cursor_recs(rec_count):= j_rec.rec;
    --    end loop;
    -- j:=j+1;
    -- end if;
    nm_debug.debug('Here 2');
    if i_rec.wol_status_code <> 'PAID'
    then
        for j_rec in c_boq_measured_income loop
          rec_count:=rec_count+1;
          cursor_recs(rec_count):= j_rec.rec;
        end loop;
    end if;
    if i_rec.wol_status_code='PAID'
    then
        -- write to table to prevent sending info again
        --
        nm_debug.debug('Here 3');
        insert into uniclass_sent values(g_wol_id,g_job_id,sysdate);
        --
        nm_debug.debug('Here 4');
        for j_rec in c_boq_actual_income loop
          rec_count:=rec_count+1;
          cursor_recs(rec_count):= j_rec.rec;
        end loop;
    --   j:=j+1;
    end if;
  end loop;

  rec_count := rec_count+1;
  cursor_recs(rec_count) := 'TR'||to_char(sysdate,'YYYYMMDD')||replace(to_char(rec_count,'099999'),' ');
  /* all records in the table now write them out to the file */
  IF (debug) THEN
    nm_debug.debug(rec_count||' record(s) loaded');
  END IF;
  IF (debug) THEN
    nm_debug.debug(g_contractor_id||' contractor_id');
  END IF;
  cursor_recs(1):='HR'||to_char(sysdate,'YYYYMMDD')||replace(to_char(rec_count,'099999'),' ');
  FOR i IN 1..rec_count LOOP
    nm_debug.debug('Here 5');
    insert into uniclass_files values (nvl(g_job_id,-1),cursor_recs(i));
--  remove additional information stored in table
--  record format will now match the specification
    cursor_recs(i):=rtrim(substr(cursor_recs(i),1,42));
    IF NOT writeln(File_Handle,cursor_recs(i)) THEN
      nm_debug.debug('Info: Problem writing to output file.');
    END IF;
  END LOOP;

  RETURN TRUE;
  EXCEPTION
    WHEN utl_file.invalid_operation THEN
      nm_debug.debug('Error: An invalid operation occured - '||fn);
      RETURN FALSE;
    WHEN utl_file.invalid_path THEN
      nm_debug.debug('Error: An invalid path error occured - '||fn);
      RETURN FALSE;
    WHEN utl_file.read_error THEN
      nm_debug.debug('Error: A read error occured on the specified file - '||fn);
      RETURN FALSE;
    WHEN utl_file.write_error THEN
      nm_debug.debug('Error: Cannot write to the specified file - '||fn);
      RETURN FALSE;
    WHEN utl_file.internal_error THEN
      nm_debug.debug('Error: An internal error was found - '||fn);
      RETURN FALSE;
    WHEN utl_file.invalid_filehandle THEN
      nm_debug.debug('Error: The specified file handle does not identify a valid file - {ProcessWorkRecords}');
      RETURN FALSE;
    WHEN utl_file.invalid_mode THEN
      nm_debug.debug('Error: Invalid mode - '||fn);
      RETURN FALSE;
    WHEN INVALID_NUMBER THEN
      nm_debug.debug('Error: Invalid number exception raised - '||fn);
      RETURN FALSE;
    WHEN VALUE_ERROR THEN
      nm_debug.debug('Error: Value error exception raised - '||fn);
      RETURN FALSE;
    WHEN OTHERS THEN
      nm_debug.debug(SQLERRM||' '||fn);
      IF is_open(Output_File) THEN
        utl_file.fclose(Output_File);
      END IF;
      IF is_open(File_Handle) THEN
        utl_file.fclose(File_Handle);
      END IF;
      RAISE;
      RETURN FALSE;
END;
-- *****************************************************************************
-- This is where the real processing starts
-- *****************************************************************************
PROCEDURE Main(p_job_id IN NUMBER) IS
  start_time   BINARY_INTEGER;
  end_time     BINARY_INTEGER;
  tot_time     BINARY_INTEGER;
  l_error_code number;
  l_error_message varchar2(240);
BEGIN
  IF debug THEN
    nm_debug.debug_on;
  END IF;
  nm_debug.debug('p_job_id is '||p_job_id);
  IF debug THEN
    start_time:=dbms_utility.get_time;
    higgrirp.write_gri_spool(p_job_id,'Start Time : '||TO_CHAR(start_time));
  END IF;
  nm_debug.debug('Here');
  fetch_params(p_job_id);

  IF NOT ProcessUniclass THEN
    nm_debug.debug('Error: RMMS file generation failed - {Main}');
  ELSE
    nm_debug.debug('Info : The following file has been generated : ');
    nm_debug.debug('.');
    nm_debug.debug('Directory : '||FDest);
    nm_debug.debug('File      : '||v_filename);
  END IF;
  -- close the file if it is still open
  IF (is_open(File_handle)) THEN
    utl_file.fclose(File_Handle);
  END IF;

EXCEPTION
  when others then
    l_error_code := SQLCODE;
    l_error_message := substr(SQLERRM(l_error_code),1,80)||' { Main }';
    nm_debug.debug(l_error_message);
    raise;
END;
END UNICLASS;
/
