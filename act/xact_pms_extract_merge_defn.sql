PROMPT Creating Merge Query - PMS_EXTRACT
DECLARE
--
-----------------------------------------------------------------------------
--
--   SCCS Identifiers :-
--
--       sccsid           : @(#)xact_pms_extract_merge_defn.sql	1.1 03/14/05
--       Module Name      : xact_pms_extract_merge_defn.sql
--       Date into SCCS   : 05/03/14 23:10:57
--       Date fetched Out : 07/06/06 14:33:46
--       SCCS Version     : 1.1
--
--  PMS_EXTRACT
--
--  Generated from instance iamsdev@ATHENA - DB ver : 9.2.0.4.0
--
--  05-Oct-2004 15:53:18
--
--  nm3mrg_output header : "@(#)nm3mrg_output.pkh	1.7 09/08/03"
--  nm3mrg_output body   : "@(#)nm3mrg_output.pkb	1.17 09/08/03"
--
-----------------------------------------------------------------------------
--	Copyright (c) exor corporation ltd, 2001
-----------------------------------------------------------------------------
--
   g_nmq_id      CONSTANT nm_mrg_query.nmq_id%TYPE     := nm3mrg.get_nmq_id;
   c_nmq_unique  CONSTANT nm_mrg_query.nmq_unique%TYPE := 'PMS_EXTRACT';
--
   c_hig         CONSTANT VARCHAR2(6) := 'HIG';
--
   g_nqt_seq_no           NUMBER;
   g_inv_type             nm_inv_type_attribs.ita_inv_type%TYPE;
   g_attrib_name          nm_inv_type_attribs.ita_attrib_name%TYPE;
--
   l_rec_nmf              nm_mrg_output_file%ROWTYPE;
   l_rec_nmc              nm_mrg_output_cols%ROWTYPE;
   l_rec_nmcd             nm_mrg_output_col_decode%ROWTYPE;
--
   PROCEDURE insert_nqro (p_role VARCHAR2
                         ,p_mode VARCHAR2
                         ) IS
   BEGIN
      INSERT INTO nm_mrg_query_roles
             (nqro_nmq_id
             ,nqro_role
             ,nqro_mode
             )
      VALUES (g_nmq_id
             ,p_role
             ,p_mode
             );
   EXCEPTION
      WHEN others THEN Null;
   END insert_nqro;
--
   PROCEDURE insert_nqt (p_inv_type VARCHAR2
                        ,p_x_sect   VARCHAR2
                        ,p_default  VARCHAR2 DEFAULT 'N'
                        ) IS
   BEGIN
      g_inv_type   := p_inv_type;
      INSERT INTO nm_mrg_query_types
             (nqt_nmq_id
             ,nqt_seq_no
             ,nqt_inv_type
             ,nqt_x_sect
             ,nqt_default
             )
      VALUES (g_nmq_id
             ,nqt_seq_no_seq.NEXTVAL
             ,g_inv_type
             ,p_x_sect
             ,p_default
             )
      RETURNING nqt_seq_no INTO g_nqt_seq_no;
   END insert_nqt;
--
   PROCEDURE insert_nqa (p_view_col  VARCHAR2
                        ,p_condition VARCHAR2
                        ) IS
      CURSOR cs_ita (c_inv_type VARCHAR2
                    ,c_view_col VARCHAR2
                    ) IS
      SELECT ita_attrib_name
       FROM  nm_inv_type_attribs
      WHERE  ita_inv_type      = c_inv_type
       AND   ita_view_col_name = c_view_col;
      l_found BOOLEAN;
   BEGIN
      OPEN  cs_ita (g_inv_type,p_view_col);
      FETCH cs_ita INTO g_attrib_name;
      l_found := cs_ita%FOUND;
      CLOSE cs_ita;
      IF NOT l_found
       THEN
         g_attrib_name := nm3get.get_hco (pi_hco_domain      => 'GAZ_QRY_FIXED_COLS_I'
                                         ,pi_hco_code        => p_view_col
                                         ,pi_raise_not_found => FALSE
                                         ).hco_code;
         IF g_attrib_name IS NULL
          THEN
            hig.raise_ner(c_hig,67,null,'NM_INV_TYPE_ATTRIBS :'||g_inv_type||':'||p_view_col);
         END IF;
      END IF;
      INSERT INTO nm_mrg_query_attribs
             (nqa_nmq_id
             ,nqa_nqt_seq_no
             ,nqa_attrib_name
             ,nqa_condition
             ,nqa_itb_banding_id
             )
      VALUES (g_nmq_id
             ,g_nqt_seq_no
             ,g_attrib_name
             ,p_condition
             ,Null
             );
   END insert_nqa;
--
   PROCEDURE lock_and_del_nmq (p_nmq_unique VARCHAR2) IS
      CURSOR cs_lock (c_nmq_unique VARCHAR2) IS
      SELECT nmq.ROWID
       FROM  nm_mrg_query_all nmq
      WHERE  nmq.nmq_unique = c_nmq_unique
      FOR UPDATE NOWAIT;
      l_locked EXCEPTION;
      PRAGMA EXCEPTION_INIT(l_locked,-54);
      l_nmq_rowid ROWID;
   BEGIN
      OPEN  cs_lock (p_nmq_unique);
      FETCH cs_lock INTO l_nmq_rowid;
      CLOSE cs_lock;
      DELETE FROM nm_mrg_query_all
      WHERE  ROWID = l_nmq_rowid;
   EXCEPTION
      WHEN l_locked
       THEN
         hig.raise_ner(c_hig,33,null,'NM_MRG_QUERY');
   END lock_and_del_nmq;
--
   PROCEDURE insert_nqv (p_seq   NUMBER
                        ,p_value VARCHAR2
                        ) IS
   BEGIN
      INSERT INTO nm_mrg_query_values
             (nqv_nmq_id
             ,nqv_nqt_seq_no
             ,nqv_attrib_name
             ,nqv_sequence
             ,nqv_value
             )
      VALUES (g_nmq_id
             ,g_nqt_seq_no
             ,g_attrib_name
             ,p_seq
             ,p_value
             );
   END insert_nqv;
--
BEGIN
--
   lock_and_del_nmq (c_nmq_unique);
--
   INSERT INTO nm_mrg_query
          (nmq_id
          ,nmq_unique
          ,nmq_descr
          ,nmq_inner_outer_join
          ,nmq_transient_query
          )
   VALUES (g_nmq_id
          ,c_nmq_unique
          ,'PMS Extract'
          ,'O'
          ,'N'
          );
--
   insert_nqro ('HIG_ADMIN','NORMAL');
--
   insert_nqt ('SEGT','','N');
--
      insert_nqa ('IIT_START_DATE','');
--
      insert_nqa ('SEGT_TREATMENT_TYPE','');
--
--      insert_nqa ('SEGT_X_SECT','=');
----
--         insert_nqv ('1','DPK');
--
--
   insert_nqt ('SEG','DPK','N');
--
      insert_nqa ('NAASRA_CLASS','IN');
--
         insert_nqv ('1','1');
--
         insert_nqv ('2','2');
--
         insert_nqv ('3','3');
--
         insert_nqv ('4','6');
--
         insert_nqv ('5','7');
--
      insert_nqa ('PAVEMENT_TYPE','');
--
--
   insert_nqt ('LASR','DPK','N');
--
      insert_nqa ('LASR_NAASRA','');
--
--
-- Build the merge view for this one
   nm3mrg_view.build_view(g_nmq_id);
END;
/
