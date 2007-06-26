CREATE OR REPLACE PROCEDURE xact_delete_acc (p_acc_id NUMBER) IS
--   SCCS Identifiers :-
--
--       sccsid           : @(#)xact_delete_acc.sql	1.1 03/14/05
--       Module Name      : xact_delete_acc.sql
--       Date into SCCS   : 05/03/14 23:10:54
--       Date fetched Out : 07/06/06 14:33:44
--       SCCS Version     : 1.1
--
--
--   Author : Jonathan Mills
--
--   procedure to DELETE an accident
--
-----------------------------------------------------------------------------
--   Copyright (c) exor corporation ltd, 2005
-----------------------------------------------------------------------------
   CURSOR cs_rowid (c_acc_id NUMBER) IS
   SELECT acc.ROWID, ait.ait_level
    FROM  acc_items_all_all acc
         ,acc_item_types    ait
   WHERE  acc.acc_id = c_acc_id
    AND   acc.acc_ait_id = ait.ait_id
   FOR UPDATE OF acc.acc_id NOWAIT;
--
   l_rowid      ROWID;
   l_ait_level  acc_item_types.ait_level%TYPE;
   l_found      BOOLEAN;
   l_tab_acc_id nm3type.tab_number;
--
BEGIN
--
   OPEN  cs_rowid (p_acc_id);
   FETCH cs_rowid INTO l_rowid, l_ait_level;
   l_found := cs_rowid%FOUND;
   CLOSE cs_rowid;
   IF NOT l_found
    THEN
      hig.raise_ner (pi_appl               => nm3type.c_hig
                    ,pi_id                 => 67
                    ,pi_supplementary_info => 'ACC_ITEMS_ALL_ALL.ACC_ID='||p_acc_id
                    );
   END IF;
--
   SELECT acc_id
    BULK  COLLECT
    INTO  l_tab_acc_id
    FROM  acc_items_all_all
   WHERE  acc_parent_id = p_acc_id;
--
   FOR i IN 1..l_tab_acc_id.COUNT
    LOOP
      xact_delete_acc (p_acc_id => l_tab_acc_id(i));
   END LOOP;
--
   DELETE FROM acc_item_attr
   WHERE aia_acc_id = p_acc_id;
--
   IF l_ait_level = 1
    THEN
      DELETE FROM acc_locations_all
      WHERE  alo_acc_id = p_acc_id;
--
      DELETE FROM acc_group_accidents
      WHERE  aga_acc_id = p_acc_id;
   END IF;
--
   DELETE FROM acc_items_all_all
   WHERE ROWID = l_rowid;
--
END;
/

