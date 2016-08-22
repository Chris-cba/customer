CREATE OR REPLACE PACKAGE BODY nem_custom_validation_rules
AS
  -------------------------------------------------------------------------
  --   PVCS Identifiers :-
  --
  --       pvcsid           : \$Header:   //new_vm_latest/archives/customer/HA/nem/validation_rules/nem_custom_validation_rules.pkb-arc   1.0   22 Aug 2016 01:04:42   Mike.Huitson  $
  --       Module Name      : \$Workfile:   nem_custom_validation_rules.pkb  $
  --       Date into PVCS   : \$Date:   22 Aug 2016 01:04:42  $
  --       Date fetched Out : \$Modtime:   21 Aug 2016 23:57:32  $
  --       PVCS Version     : \$Revision:   1.0  $
  ------------------------------------------------------------------
  --   Copyright (c) 2016 Bentley Systems Incorporated. All rights reserved.
  ------------------------------------------------------------------
  --
  --
  --g_body_sccsid is the SCCS ID for the package body
  g_body_sccsid  CONSTANT VARCHAR2 (2000) := '\$Revision:   1.0  $';

  g_package_name  CONSTANT VARCHAR2 (30) := 'nem_custom_validation_rules';
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
  PROCEDURE all_available_lanes_closed(po_error_flag OUT VARCHAR2
                                      ,po_error_tab  OUT nem_validation_api.error_tab)
    IS
    --
    lv_lane_impact      PLS_INTEGER;
    lv_number_of_lanes  NUMBER;
    --
    lt_error_tab      nem_validation_api.error_tab;
    lt_impact_groups  nem_api.impact_groups_tab;
    --
    TYPE nigx_tab IS TABLE OF nem_impact_group_xsps%ROWTYPE;
    lt_nigx  nigx_tab;
    --
    TYPE section_rec IS RECORD(ne_unique          nm_elements_all.ne_unique%TYPE
                              ,section_class_ind  nm_elements_all.ne_sub_type%TYPE
                              ,number_of_lanes    nm_inv_items_all.iit_num_attrib22%TYPE);
    TYPE section_tab IS TABLE OF section_rec;
    lt_sections  section_tab;
    --
  BEGIN
    /*
    ||Get Impact Groups
    */
    lt_impact_groups := nem_validation_api.get_impact_groups(pi_nevt_id => nem_validation_api.gr_event.event_id);
    --
    FOR i IN 1..lt_impact_groups.COUNT LOOP
      /*
      ||If the Carriageway Closure flag is not Y check to see if it should be.
      */
      IF lt_impact_groups(i).nig_carriageway_closure = 'N'
       THEN
          /*
          ||Get the impact change records.
          */
          SELECT *
            BULK COLLECT
            INTO lt_nigx
            FROM nem_impact_group_xsps
           WHERE nigx_nig_id = lt_impact_groups(i).nig_id
               ;
          IF lt_nigx.COUNT > 0
           THEN
              /*
              ||Calculate the impact on the number of lanes.
              */
              lv_lane_impact := 0;
              --
              FOR j IN 1..lt_nigx.COUNT LOOP
                --
                CASE 
                  WHEN lt_nigx(j).nigx_reason IN('CLOSED','LOANED')
                   THEN
                      lv_lane_impact := lv_lane_impact - 1;
                  WHEN lt_nigx(j).nigx_reason IN('OPENED','BORROWED','TEMPORARY')
                   THEN
                      lv_lane_impact := lv_lane_impact + 1;
                  ELSE
                      /*
                      ||default to no impact on the number of lanes.
                      */
                      NULL;
                END CASE;
                --
              END LOOP;
              /*
              ||Get the locations as Sections.
              */
              SELECT DISTINCT ne_unique
                    ,ne_sub_type section_class_ind
                    ,iit_num_attrib22 number_of_lanes
                BULK COLLECT
                INTO lt_sections
                FROM nm_inv_items
                    ,nm_elements
               WHERE ne_id IN(SELECT rm.nm_ne_id_in
                                FROM nm_members rm
                               WHERE nm_obj_type = 'SECT'
                                 AND rm.nm_ne_id_of IN(SELECT im.nm_ne_id_of
                                                         FROM nm_members im
                                                        WHERE im.nm_ne_id_in = lt_impact_groups(i).nig_id))
                 AND iit_ne_id IN(SELECT nad_iit_ne_id
                                    FROM nm_nw_ad_link
                                   WHERE nad_ne_id = ne_id
                                     AND nad_primary_ad = 'Y')
                   ;
              /*
              ||Check to see if all available lanes are closed on any of the Sections.
              */
              FOR j IN 1..lt_sections.COUNT LOOP
                --
                lv_number_of_lanes := lt_sections(j).number_of_lanes;
                /*
                ||If this is a motorway add a lane for the hard shoulder.
                */
                IF lt_sections(j).section_class_ind = 'M'
                 THEN
                    lv_number_of_lanes := lv_number_of_lanes + 1;
                END IF;
                /*
                ||Check to see if all lanes are closed.
                */
                IF lv_number_of_lanes + lv_lane_impact <= 0
                 THEN
                    lt_error_tab(lt_error_tab.count+1) := 'The whole carriageway for at least one Section on Impact Group ['||lt_impact_groups(i).nig_name||'] would be closed by the indicated Impact Changes.';
                    EXIT;
                END IF;
                --
              END LOOP;
          END IF;
      END IF;
    END LOOP;
    --
    IF lt_error_tab.count > 0
     THEN
        po_error_flag := 'Y';
    ELSE
        po_error_flag := 'N';
    END IF;
    --
    po_error_tab := lt_error_tab;
    --
  EXCEPTION
   WHEN others
    THEN
       po_error_flag := 'Y';
       lt_error_tab(lt_error_tab.count+1) := SQLERRM;
       po_error_tab := lt_error_tab;
  END all_available_lanes_closed;
  --  
END nem_custom_validation_rules;
/
