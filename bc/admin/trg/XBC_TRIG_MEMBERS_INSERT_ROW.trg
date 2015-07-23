create or replace
TRIGGER XBC_TRIG_MEMBERS_INSERT_ROW
BEFORE INSERT
ON NM_MEMBERS_ALL
FOR EACH ROW
follows ins_nm_members
DECLARE
/*
	This trigger will capture the info regarding the RFI linear group and the SUB group
	it is being added to.

	This trigger will check to see if an RFI with the same number already exists for the
	SUB.  If so, the trigger will raise an application error.

	No data changes are made by this trigger.

*/

CURSOR cur_rfi(cp_rfi_neid IN NUMBER) IS
	SELECT ne_nt_type, ne_nsg_ref, ne_name_2, ne_prefix
	FROM NM_ELEMENTS_ALL
	WHERE ne_id = cp_rfi_neid;

CURSOR cur_sub(cp_sub_neid IN NUMBER, cp_htype IN VARCHAR2, cp_hno IN VARCHAR2, cp_halpha IN VARCHAR2, cp_of in number) IS
	SELECT trim(nvl(a.ne_unique,'-1')) sub_name
	FROM nm_elements_all a
		, nm_members_all b
		, nm_elements_all c
	WHERE a.ne_id = cp_sub_neid
		AND a.ne_id = b.nm_ne_id_in
		AND b.nm_ne_id_of = c.ne_id
		AND b.nm_obj_type = 'SUB'
		AND nvl(c.ne_nsg_ref,'-1') = nvl(cp_htype,'-1')
		AND nvl(c.ne_name_2,'-1') = nvl(cp_hno,'-1')
		AND nvl(c.ne_prefix,'-1') = nvl(cp_halpha,'-1')
		AND c.ne_end_date IS NULL
		AND c.ne_nt_type = 'RFI'
-- dh July 1, 2015
    and c.ne_id <> cp_of
    and trim(a.ne_unique) = substr(c.ne_unique,1,length(trim(a.ne_unique)));


t_type			VARCHAR2(4);
t_rfi			NM_ELEMENTS_ALL.NE_ID%TYPE;
t_htype			NM_ELEMENTS_ALL.NE_NSG_REF%TYPE;
t_hno			NM_ELEMENTS_ALL.NE_NAME_2%TYPE;
t_halpha		NM_ELEMENTS_ALL.NE_PREFIX%TYPE;
t_sub			VARCHAR2(80);

t_error			VARCHAR2(80);
t_of  number;
BEGIN
	IF :NEW.NM_OBJ_TYPE = 'SUB' THEN
		OPEN cur_rfi(:NEW.NM_NE_ID_OF);
		FETCH cur_rfi INTO t_type, t_htype, t_hno, t_halpha;
		CLOSE cur_rfi;

		IF t_type = 'RFI' THEN
			t_rfi	:= :NEW.nm_ne_id_in;
      t_of := :new.nm_ne_id_of;
			OPEN cur_sub(t_rfi, t_htype, t_hno, t_halpha, t_of);
			FETCH cur_sub INTO t_sub;
			CLOSE cur_sub;

			IF t_sub <> '-1' THEN
				t_error		:= 'RFI #' || t_htype || '-' ||
					t_hno || '-' ||
					t_halpha || 
					' already exists for SUB ' || t_sub;

				RAISE_APPLICATION_ERROR(-20000,t_error);
			END IF;
		END IF;
	END IF;
END; 
/
