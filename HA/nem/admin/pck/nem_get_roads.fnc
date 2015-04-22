CREATE OR REPLACE FUNCTION nem_get_roads(pi_rec_id IN nem_roads.nerd_rec_id%TYPE)
  RETURN nem_util.roads_tab AS
  -------------------------------------------------------------------------
  --   PVCS Identifiers :-
  --
  --       PVCS id          : $Header:   //new_vm_latest/archives/customer/HA/nem/admin/pck/nem_get_roads.fnc-arc   3.0   Apr 22 2015 12:51:10   Mike.Huitson  $
  --       Module Name      : $Workfile:   nem_get_roads.fnc  $
  --       Date into PVCS   : $Date:   Apr 22 2015 12:51:10  $
  --       Date fetched Out : $Modtime:   Apr 22 2015 13:56:42  $
  --       Version          : $Revision:   3.0  $
  --       Based on SCCS version :
  ------------------------------------------------------------------
  --   Copyright (c) 2013 Bentley Systems Incorporated. All rights reserved.
  ------------------------------------------------------------------
  --
  lt_retval  nem_util.roads_tab;
  --
BEGIN
  --
  SELECT DISTINCT pi_rec_id
        ,iit_chr_attrib30||' ('||(SELECT ial_meaning
                                    FROM nm_inv_attri_lookup
                                   WHERE ial_domain = 'NETW_NET_DIR'
                                     AND ial_value = iit_chr_attrib35)||')' road
    BULK COLLECT
    INTO lt_retval
    FROM nm_inv_items
   WHERE iit_ne_id IN(SELECT nad_iit_ne_id
                        FROM nm_nw_ad_link
                       WHERE nad_ne_id IN(SELECT rm.nm_ne_id_in
                                            FROM nm_members rm
                                           WHERE nm_obj_type = 'SECT'
                                             AND rm.nm_ne_id_of IN(SELECT im.nm_ne_id_of
                                                                     FROM nm_members im
                                                                    WHERE im.nm_ne_id_in = pi_rec_id))
                         AND nad_primary_ad = 'Y')
       ;
  --
  RETURN lt_retval;
  --
END;
/
