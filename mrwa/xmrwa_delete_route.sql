CREATE OR REPLACE PROCEDURE xmrwa_delete_route (p_route_ne_id NUMBER) IS
--   SCCS Identifiers :-
--
--       sccsid           : @(#)xmrwa_delete_route.sql	1.1 03/15/05
--       Module Name      : xmrwa_delete_route.sql
--       Date into SCCS   : 05/03/15 00:45:27
--       Date fetched Out : 07/06/06 14:38:14
--       SCCS Version     : 1.1
--
--
--   Author : Jonathan Mills
--
-----------------------------------------------------------------------------
--   Copyright (c) exor corporation ltd
-----------------------------------------------------------------------------
   l_rec_ne       nm_elements_all%ROWTYPE;
   l_rec_ne_child nm_elements_all%ROWTYPE;
--
   l_tab_ne_rowid  nm3type.tab_rowid;
   l_tab_ne_id     nm3type.tab_number;
   l_tab_nm_rowid  nm3type.tab_rowid;
   l_tab_iit_ne_id nm3type.tab_number;
--
   PROCEDURE add_ne_rowid (p_rowid ROWID, p_ne_id NUMBER) IS
   BEGIN
      l_tab_ne_rowid(l_tab_ne_rowid.COUNT+1) := p_rowid;
      l_tab_ne_id(l_tab_ne_id.COUNT+1)       := p_ne_id;
   END add_ne_rowid;
--
   PROCEDURE add_nm_rowid (p_rowid ROWID) IS
   BEGIN
      l_tab_nm_rowid(l_tab_nm_rowid.COUNT+1) := p_rowid;
   END add_nm_rowid;
--
BEGIN
--
   nm_debug.proc_start(Null,'xmrwa_delete_route');
--
   l_rec_ne := nm3get.get_ne_all (pi_ne_id => p_route_ne_id);
--
   IF l_rec_ne.ne_type != 'G'
    THEN
      hig.raise_ner (nm3type.c_hig,114,-20001);
   END IF;
--
   IF UPPER(l_rec_ne.ne_descr) != 'DELETE'
    THEN
      hig.raise_ner (pi_appl               => nm3type.c_net
                    ,pi_id                 => 28
                    ,pi_sqlcode            => -20001
                    ,pi_supplementary_info => 'Description "'||l_rec_ne.ne_descr||'" != "DELETE"'
                    );
   END IF;
--
   add_ne_rowid (nm3lock_gen.lock_ne_all (pi_ne_id => l_rec_ne.ne_id),l_rec_ne.ne_id);
--
   -- get all groups (of groups) that this is a member of
   SELECT nm.ROWID
    BULK  COLLECT
    INTO  l_tab_nm_rowid
    FROM  nm_members_all nm
   WHERE  nm_ne_id_of = l_rec_ne.ne_id
   FOR UPDATE NOWAIT;
--
   -- get all members where this is the _IN
   FOR cs_rec IN (SELECT nm.*, nm.ROWID nm_rowid
                   FROM  nm_members_all nm
                  WHERE  nm_ne_id_in = l_rec_ne.ne_id
                  FOR UPDATE NOWAIT
                 )
    LOOP
      add_nm_rowid (cs_rec.nm_rowid);
      l_rec_ne_child := nm3get.get_ne_all (pi_ne_id => cs_rec.nm_ne_id_of);
      IF nm3net.child_autoincluded_in_parent (l_rec_ne.ne_nt_type
                                             ,l_rec_ne_child.ne_nt_type
                                             ) = 'Y'
       THEN
         add_ne_rowid (nm3lock_gen.lock_ne_all (pi_ne_id => cs_rec.nm_ne_id_of),cs_rec.nm_ne_id_of);
         FOR cs_inner IN (SELECT nm.*, nm.ROWID nm_rowid
                           FROM  nm_members_all nm
                          WHERE  nm_ne_id_of = cs_rec.nm_ne_id_of
                           AND   ROWID != cs_rec.nm_rowid
                         )
          LOOP
            add_nm_rowid (cs_inner.nm_rowid);
            IF cs_inner.nm_type = 'I'
             AND nm3get.get_nit (pi_nit_inv_type => cs_inner.nm_obj_type).nit_end_loc_only = 'N'
             THEN
               l_tab_iit_ne_id(l_tab_iit_ne_id.COUNT+1) := cs_inner.nm_ne_id_in;
            END IF;
         END LOOP;
      END IF;
   END LOOP;
--
   FORALL i IN 1..l_tab_nm_rowid.COUNT
      DELETE FROM nm_members_all
      WHERE ROWID = l_tab_nm_rowid(i);
--
   FORALL i IN 1..l_tab_ne_id.COUNT
      DELETE FROM nm_element_history
      WHERE neh_ne_id_old = l_tab_ne_id(i)
       OR   neh_ne_id_new = l_tab_ne_id(i);
--
   FORALL i IN 1..l_tab_ne_rowid.COUNT
      DELETE FROM nm_elements_all
      WHERE ne_id = l_tab_ne_id(i);
--
   FORALL i IN 1..l_tab_iit_ne_id.COUNT
      DELETE FROM nm_inv_items_all
      WHERE  iit_ne_id = l_tab_iit_ne_id(i)
       AND   NOT EXISTS (SELECT 1
                          FROM  nm_members_all
                         WHERE  nm_ne_id_in = iit_ne_id
                        );
--
   nm_debug.proc_end(Null,'xmrwa_delete_route');
--
END xmrwa_delete_route;
/
