CREATE OR REPLACE FUNCTION nem_ntis_get_road(pi_nevt_id IN nem_events.nevt_id%TYPE)
  RETURN VARCHAR2 AS
  -------------------------------------------------------------------------
  --   PVCS Identifiers :-
  --
  --       PVCS id          : $Header:   //new_vm_latest/archives/customer/HA/nem/ntis_interface/nem_ntis_get_road.fnc-arc   1.1   26 Jan 2016 18:05:32   Mike.Huitson  $
  --       Module Name      : $Workfile:   nem_ntis_get_road.fnc  $
  --       Date into PVCS   : $Date:   26 Jan 2016 18:05:32  $
  --       Date fetched Out : $Modtime:   26 Jan 2016 17:59:16  $
  --       Version          : $Revision:   1.1  $
  --       Based on SCCS version :
  ------------------------------------------------------------------
  --   Copyright (c) 2013 Bentley Systems Incorporated. All rights reserved.
  ------------------------------------------------------------------
  --
  lv_road   nm3type.max_varchar2;
  lv_length NUMBER;
  --
  CURSOR get_road(cp_nevt_id IN nem_events.nevt_id%TYPE)
      IS
  SELECT road
        ,SUM(mem_length) road_length
    FROM (SELECT iit_chr_attrib30||' ('||(SELECT ial_meaning
                                            FROM nm_inv_attri_lookup
                                           WHERE ial_domain = 'NETW_NET_DIR'
                                             AND ial_value = iit_chr_attrib35)||')' road
                ,locs.mem_length
            FROM nm_inv_items
                ,nm_nw_ad_link lnk
                ,nm_members rm 
                ,(SELECT im.nm_ne_id_of
                        ,CASE
                           WHEN im.nm_end_mp > im.nm_begin_mp
                            THEN
                               im.nm_end_mp - im.nm_begin_mp
                           ELSE
                               im.nm_begin_mp - im.nm_end_mp
                         END mem_length
                    FROM nm_members im
                   WHERE im.nm_ne_id_in = cp_nevt_id) locs
           WHERE locs.nm_ne_id_of = rm.nm_ne_id_of
             AND rm.nm_obj_type = 'SECT'
             AND rm.nm_ne_id_in = lnk.nad_ne_id
             AND lnk.nad_primary_ad = 'Y'
             AND lnk.nad_iit_ne_id = iit_ne_id)
   GROUP BY road
   ORDER BY road_length desc
       ;
  --
BEGIN
  --
  OPEN  get_road(pi_nevt_id);
  FETCH get_road
   INTO lv_road
       ,lv_length;
  CLOSE get_road;
  --
  RETURN lv_road;
  --
EXCEPTION
  WHEN others
   THEN
      RETURN NULL;
END nem_ntis_get_road;
/
