DECLARE
--   SCCS Identifiers :-
--
--       sccsid           : @(#)xact_acc_reports_delete_gri_metadata.sql	1.1 03/15/05
--       Module Name      : xact_acc_reports_delete_gri_metadata.sql
--       Date into SCCS   : 05/03/15 03:47:21
--       Date fetched Out : 07/06/06 14:33:38
--       SCCS Version     : 1.1
--
--
--   Author : Jonathan Mills
--
-----------------------------------------------------------------------------
--   Copyright (c) exor corporation ltd
-----------------------------------------------------------------------------
   PROCEDURE delete_each (c_module VARCHAR2) IS
      l_rowid nm3type.tab_rowid;
   BEGIN
   --
      SELECT ROWID
       BULK  COLLECT
       INTO  l_rowid
       FROM  gri_params
      WHERE  EXISTS (SELECT 1
                      FROM  gri_module_params
                     WHERE  gmp_module = c_module
                      AND   gmp_param  = gp_param
                    );
   --
      DELETE FROM gri_module_params
      WHERE  gmp_module = c_module;
   --
      FORALL i IN 1..l_rowid.COUNT
         DELETE FROM gri_params
         WHERE ROWID = l_rowid(i)
          AND  NOT EXISTS (SELECT 1
                            FROM  gri_module_params
                           WHERE  gmp_param  = gp_param
                          );
   --
      DELETE FROM gri_modules
      WHERE grm_module = c_module;
   --
      DELETE FROM hig_module_roles
      WHERE hmr_module = c_module;
   --
      DELETE FROM hig_modules
      WHERE hmo_module = c_module;
   --
      DELETE FROM hig_system_favourites
      WHERE hsf_child = c_module
       AND  hsf_type  = 'M';
   --
      COMMIT;
   --
   END;
BEGIN
   delete_each('XACT010');
   delete_each('XACT020');
   delete_each('XACT021');
   delete_each('XACT022');
END;
/
