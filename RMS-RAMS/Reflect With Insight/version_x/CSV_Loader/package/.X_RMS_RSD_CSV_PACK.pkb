CREATE OR REPLACE PACKAGE BODY RAMS.X_RMS_RSD_CSV_PACK
AS
   G_ADMIN_UNIT   NUMBER := 16;


   /*
   **  Converts a lat long to an XY sdo_geometyr
   **
   */

   FUNCTION convert_ll_to_xy (p_lat NUMBER, p_long NUMBER)
      RETURN MDSYS.SDO_GEOMETRY
   IS
      l_ret_lref   nm_lref;
      l_lat_long   MDSYS.SDO_GEOMETRY;
      l_xy         MDSYS.SDO_GEOMETRY;
      l_x          FLOAT;
      l_y          FLOAT;
   BEGIN
      --create sdo_geometry from lat long
      l_lat_long :=
         MDSYS.SDO_GEOMETRY (2001,
                             g_srid_geographic,
                             mdsys.sdo_point_type (p_long, p_lat, NULL),
                             NULL,
                             NULL);

      -----------------------------------------------------
      -- convert lat and long to x and y and return
      -----------------------------------------------------

      RETURN MDSYS.SDO_CS.TRANSFORM (l_lat_long, g_srid);
   END convert_ll_to_xy;

   FUNCTION latlong_to_lref (p_lat                IN NUMBER,
                             p_long               IN NUMBER,
                             p_buffer_tolerance   IN NUMBER,
                             p_where_sql          IN VARCHAR2)
      RETURN nm_lref
   IS
      l_xy          MDSYS.SDO_GEOMETRY;

      l_lref        nm_lref;
      l_ne_id       nm_elements_all.ne_id%TYPE;
      l_offset      nm_members_all.NM_BEGIN_MP%TYPE;

      l_unique      nm_elements_all.ne_unique%TYPE;



      -----------------------------------------------------
      -- variables for results
      -----------------------------------------------------


      l_cur_shape   MDSYS.SDO_GEOMETRY;
   BEGIN
      -----------------------------------------------------
      --  set lat,long to sdo geom
      -----------------------------------------------------

      l_xy := convert_ll_to_xy (p_lat, p_long);



      -----------------------------------------------------
      --  position array
      -----------------------------------------------------

      l_lref := nm3sdo.GET_PROJECTION_TO_NEAREST (g_theme_id, l_xy);

      --check buffer tolerance
      SELECT shape
        INTO l_cur_shape
        FROM v_network
       WHERE ne_id = nm_lref.get_ne_id (l_lref);


      IF SDO_GEOM.WITHIN_DISTANCE (l_xy,
                                   p_buffer_tolerance,
                                   l_cur_shape,
                                   0.005) = 'TRUE'
      THEN
         RETURN l_lref;
      ELSE
         --nm3dbg.putln('1 - ' || nm3sdo.GET_SHAPE_FROM_NE(nm_lref.get_ne_id(l_lref_1), p_effective_date));
         --nm3dbg.putln('2 - ' || SDO_GEOM.WITHIN_DISTANCE( l_xy_1,25,nm3sdo.GET_SHAPE_FROM_NE(nm_lref.get_ne_id(nm_lref_array.get_entry(l_location,1)), p_effective_date),0.005));
         --nm3dbg.PUTLN('pt_latlong_to_nearest_lref - Distance of '||nm3sdo.GET_SHAPE_FROM_NE(nm_lref.get_ne_id(nm_lref_array.get_entry(l_location,1)), p_effective_date), p_buffer_tolerance/1000)||' outside ' || p_buffer_tolerance || 'm tolerance');
         RAISE_APPLICATION_ERROR (
            -20000,
            'Distance outside ' || p_buffer_tolerance || 'm tolerance');
      END IF;
   END latlong_to_lref;



   --return the iit_ne_id of the RSD
   -- null if doesn't exist
   FUNCTION get_rsd (p_vendor_code    v_nm_rsd.vendor_code%TYPE,
                     p_ref_id         v_nm_rsd.reference_id%TYPE)
      RETURN NUMBER
   AS
      l_iit_ne_id   NUMBER;
   BEGIN
      SELECT iit_ne_id
        INTO l_iit_ne_id
        FROM v_nm_rsd
       WHERE vendor_code = p_vendor_code AND reference_id = p_ref_id;

      RETURN l_iit_ne_id;
   EXCEPTION
      WHEN NO_DATA_FOUND
      THEN
        NM3DBG.PUTLN('FAILED TO GET RSD ON : '|| L_IIT_NE_ID);
         RETURN NULL;
   END get_rsd;

   FUNCTION get_rsam (p_vendor_code    v_nm_rsam.vendor_code%TYPE,
                      p_ref_id         v_nm_rsam.reference_id%TYPE,
                      p_accomplishment_id V_NM_RSAM.ACCOMPLISHMENT_ID%TYPE )
      RETURN NUMBER
   AS
      l_iit_ne_id   NUMBER;
   BEGIN
      SELECT iit_ne_id
        INTO l_iit_ne_id
        FROM v_nm_rsam
       WHERE vendor_code = p_vendor_code AND reference_id = p_ref_id and accomplishment_id = p_accomplishment_id;

      RETURN l_iit_ne_id;
   EXCEPTION
      WHEN NO_DATA_FOUND
      THEN
         RETURN NULL;
   END get_rsam;

   FUNCTION get_rsde (p_vendor_code    v_nm_rsde.vendor_code%TYPE,
                      p_ref_id         v_nm_rsde.reference_id%TYPE,
                      p_defect_id V_NM_RSDE.DEFECT_ID%TYPE )
      RETURN NUMBER
   AS
      l_iit_ne_id   NUMBER;
   BEGIN
      SELECT iit_ne_id
        INTO l_iit_ne_id
        FROM v_nm_rsde
       WHERE vendor_code = p_vendor_code AND reference_id = p_ref_id and defect_id = p_defect_id;

      RETURN l_iit_ne_id;
   EXCEPTION
      WHEN NO_DATA_FOUND
      THEN
         RETURN NULL;
   END get_rsde;

   FUNCTION get_rsic (p_vendor_code    v_nm_rsic.vendor_code%TYPE,
                      p_ref_id         v_nm_rsic.reference_id%TYPE,
                      p_INCIDENT_ID     V_NM_RSIC.INCIDENT_ID%TYPE )
      RETURN NUMBER
   AS
      l_iit_ne_id   NUMBER;
   BEGIN
      SELECT iit_ne_id
        INTO l_iit_ne_id
        FROM v_nm_rsic
       WHERE vendor_code = p_vendor_code AND reference_id = p_ref_id and INCIDENT_ID = p_INCIDENT_ID;

      RETURN l_iit_ne_id;
   EXCEPTION
      WHEN NO_DATA_FOUND
      THEN
         RETURN NULL;
   END get_rsic;

   FUNCTION get_RSIN (p_vendor_code    v_nm_RSIN.vendor_code%TYPE,
                      p_ref_id         v_nm_RSIN.reference_id%TYPE,
                      p_INSPECTION_ID V_NM_RSIN.INSPECTION_ID%TYPE )
      RETURN NUMBER
   AS
      l_iit_ne_id   NUMBER;
   BEGIN
      SELECT iit_ne_id
        INTO l_iit_ne_id
        FROM v_nm_RSIN
       WHERE vendor_code = p_vendor_code AND reference_id = p_ref_id and INSPECTION_ID = p_INSPECTION_ID;

      RETURN l_iit_ne_id;
   EXCEPTION
      WHEN NO_DATA_FOUND
      THEN
         RETURN NULL;
   END get_RSIN;

   FUNCTION get_rsre (p_vendor_code    v_nm_rsre.vendor_code%TYPE,
                      p_ref_id         v_nm_rsre.reference_id%TYPE,
                      p_REQUEST_ID V_NM_RSRE.REQUEST_ID%TYPE )
      RETURN NUMBER
   AS
      l_iit_ne_id   NUMBER;
   BEGIN
      SELECT iit_ne_id
        INTO l_iit_ne_id
        FROM v_nm_rsre
       WHERE vendor_code = p_vendor_code AND reference_id = p_ref_id and REQUEST_ID = p_REQUEST_ID;

      RETURN l_iit_ne_id;
   EXCEPTION
      WHEN NO_DATA_FOUND
      THEN
         RETURN NULL;
   END get_rsre;



   FUNCTION get_lga_from_lat_long (p_lat NUMBER, p_long NUMBER)
      RETURN VARCHAR2
   AS
      ret_varchar      VARCHAR2 (30);

      l_xy             MDSYS.SDO_GEOMETRY;


      L_LGA_THEME_ID   NUMBER;
   BEGIN
      SELECT NTH_THEME_ID
        INTO L_LGA_THEME_ID
        FROM NM_THEMES_ALL
       WHERE NTH_FEATURE_TABLE = 'V_NM_NIT_LGA_SDO_DT';

      -----------------------------------------------------
      --  set lat,long to sdo geom
      -----------------------------------------------------

      l_xy := convert_ll_to_xy (p_lat, p_long);



      -----------------------------------------------------
      --  position array
      -----------------------------------------------------

      --l_lga_id := nm3sdo.GET_PROJECTION_TO_NEAREST_theme(L_LGA_THEME_ID,round(l_xy.sdo_point.x,3),round(l_xy.sdo_point.y,3));
      SELECT lga1
        INTO ret_varchar
        FROM v_nm_lga
       WHERE iit_ne_id =
                NM3SDO.GET_NEAREST_THEME_TO_XY (l_lga_theme_id,
                                                ROUND (l_xy.sdo_point.x, 3),
                                                ROUND (l_xy.sdo_point.y, 3));

      RETURN ret_varchar;
   END get_lga_FROM_LAT_LONG;

   FUNCTION get_rsd_lref_from_lat_long (p_lat NUMBER, p_long NUMBER)
      RETURN nm_lref
   AS
      ret_varchar   VARCHAR2 (30);
      l_lref        nm_lref;
      l_xy          MDSYS.SDO_GEOMETRY;


      L_THEME_ID    NUMBER;
   BEGIN
      SELECT NTH_THEME_ID
        INTO L_THEME_ID
        FROM NM_THEMES_ALL
       WHERE NTH_FEATURE_TABLE = 'V_NM_NIT_LGA_SDO_DT';

      -----------------------------------------------------
      --  set lat,long to sdo geom
      -----------------------------------------------------

      l_xy := convert_ll_to_xy (p_lat, p_long);



      -----------------------------------------------------
      --  position array
      -----------------------------------------------------

      --l_lga_id := nm3sdo.GET_PROJECTION_TO_NEAREST_theme(L_LGA_THEME_ID,round(l_xy.sdo_point.x,3),round(l_xy.sdo_point.y,3));
      SELECT lga1
        INTO ret_varchar
        FROM v_nm_lga
       WHERE iit_ne_id =
                NM3SDO.GET_NEAREST_THEME_TO_XY (l_theme_id,
                                                ROUND (l_xy.sdo_point.x, 3),
                                                ROUND (l_xy.sdo_point.y, 3));

      RETURN l_lref;
   END get_rsd_lref_FROM_LAT_LONG;



   FUNCTION get_asset_tolerance (p_asset_type VARCHAR2)
      RETURN NUMBER
   AS
      l_ret_num   NUMBER;
   BEGIN
      --query domain for asset tolerance

      SELECT hco_meaning
        INTO l_ret_num
        FROM hig_codes
       WHERE hco_domain = 'RWI_TOLERANCE' AND hco_code = p_asset_type;

      RETURN l_ret_num;
   EXCEPTION
      WHEN NO_DATA_FOUND
      THEN
         SELECT hco_meaning
           INTO l_ret_num
           FROM hig_codes
          WHERE hco_domain = 'RWI_TOLERANCE' AND hco_code = 'DEFAULT';

         RETURN l_ret_num;
   END get_asset_tolerance;



   FUNCTION get_asset_from_location (PI_asset_type    VARCHAR2,
                                     pi_lat           NUMBER,
                                     pi_long          NUMBER,
                                     pi_road          VARCHAR2,
                                     pi_tolerance     NUMBER DEFAULT 10)
      RETURN nm_inv_items_all%ROWTYPE
   AS
      l_asset_dt_theme_id   NUMBER;
      l_xy                  MDSYS.SDO_GEOMETRY;
      l_iit_ne_id           NUMBER;
   BEGIN
      --get sdo_dt theme for the asset

      SELECT nth_theme_id
        INTO l_asset_dt_theme_id
        FROM nm_themes_all
       WHERE nth_feature_table LIKE '%' || pi_asset_type || '_SDO_DT';

      l_xy := convert_ll_to_xy (pi_lat, pi_long);

      l_iit_ne_id :=
         nm3sdo.GET_NEAREST_THEME_TO_XY (l_asset_dt_theme_id,
                                         ROUND (l_xy.sdo_point.x, 3),
                                         ROUND (l_xy.sdo_point.y, 3));

      IF l_iit_ne_id IS NOT NULL
      THEN
         RETURN NM3GET.GET_IIT (pi_iit_ne_id => l_iit_ne_id);
      ELSE
         --need to log an error here
         raise_application_error (-20003,
                                  'No snaps to asset found at this lat/long');
      END IF;
   END get_asset_from_location;

   PROCEDURE P_INSERT (pi_row IN OUT X_RMS_RSD_CSV_HOLDING%ROWTYPE)
   AS
      l_rsd_iit_ne_id    NUMBER;
      l_rsam_iit_ne_id   NUMBER;
      l_rsde_iit_ne_id   NUMBER;
      l_rsic_iit_ne_id   NUMBER;
      l_rsin_iit_ne_id   NUMBER;
      l_rsRE_iit_ne_id   NUMBER;
      L_CURRENT_RSD      NM_INV_ITEMS_ALL%ROWTYPE;
	  L_CURRENT_SEG      NM_INV_ITEMS_ALL%ROWTYPE;
      l_current_rsam v_nm_rsam%rowtype;
      l_current_rsde v_nm_rsde%rowtype;
      l_current_rsic v_nm_rsic%rowtype;
      l_current_rsin v_nm_rsin%rowtype;
      l_current_rsre v_nm_rsre%rowtype;
	  
	  l_rsd_asset_loc_ne_id			number;
	  l_rsd_asset_loc_begin_mp		number;
	  l_rsd_asset_loc_end_mp		number;
	  
		procedure get_point_placement(n_iit_id in number) as
			/*This updates
					l_rsd_asset_loc_ne_id	
				  l_rsd_asset_loc_begin_mp		
				  l_rsd_asset_loc_end_mp		
			*/
		begin
			select nm_ne_id_of, nm_begin_mp, nm_end_mp into l_rsd_asset_loc_ne_id, l_rsd_asset_loc_begin_mp, l_rsd_asset_loc_end_mp from nm_members where nm_ne_id_in = n_iit_id and rownum < 2;  -- SHoudl only be one or it is not a point asset
			
			if l_rsd_asset_loc_end_mp + 0.001 > nm3net.GET_NE_LENGTH(l_rsd_asset_loc_ne_id) then
				-- subtract the metre, else add it
				l_rsd_asset_loc_begin_mp := l_rsd_asset_loc_begin_mp - 0.001;
			else
				l_rsd_asset_loc_end_mp := l_rsd_asset_loc_end_mp + 0.001;
			end if;
			
			exception when others then
				hig.raise_ner (pi_appl                 => 'RWI',
								pi_id                   => 6,
								pi_supplementary_info   => '' || n_iit_id );
		end get_point_placement;
	

	  
   BEGIN
    NM3DBG.DEBUG_ON;
    NM3DBG.PUTLN('X_RMS_RSD_CSV_PACK.P_INSERT');
      --validate the row
     -- P_VALIDATE (pi_row);
      --The CSV Loader checks to make sure that all the fields marked as required by the service provider (mandatory column in Appendix A) are supplied, if not an error is produced.  The errors produced by the CSV loader will be looked at by a RAMS administrator to determine if the error is a message that should be handled by a RAMS administrator or sent to the service provider.
      --
      --The CSV Loader then passes a line from the holding table that was defined in the File Definitions Table Form to the Procedure.   The procedure does the following:
      --?    Takes the Vendor Code and Reference ID and determines if this is a new RSD asset or an existing one.
      NM3DBG.PUTLN('CALLING GET_RSD');
      l_rsd_iit_ne_id :=  get_rsd (pi_row.RSD_VENDOR_CODE, pi_row.RSD_REFERENCE_ID);
        
      --o    If New then Create the RSD Asset and fill in the suppled attributes.
      IF l_rsd_iit_ne_id is NULL
      
      THEN
      NM3DBG.PUTLN('RSD NOT FOUND - CREATING NEW');
         --     If the provider did not include the Local Government Area, use the Latitude and longitude to determine it and fill it in.
         IF pi_row.RSD_LGA IS NULL
         THEN
         NM3DBG.PUTLN('LGA IS NULL');
            pi_row.RSD_LGA :=
               get_lga_from_lat_long (pi_row.RSD_LATITUDE,
                                      pi_row.RSD_LONGITUDE);
                                      NM3DBG.PUTLN('LGA = '||PI_ROW.RSD_LGA);
         END IF;

         --    Locate the RSD Asset in the same place as the asset described by: Asset type code, road number and the latitude and longitude.  If the asset does not exist then produce an error to add the asset to RAMS.
         /*****************************************************************************************
         *****************get location**************************************************************/
         nm3user.set_effective_date(pi_row.RSD_DATE_OF_CREATION);
		 
		 L_CURRENT_RSD :=			
            get_asset_from_location (
               PI_ROW.RSD_ASSET_TYPE_CODE,
               PI_ROW.RSD_LATITUDE,
               PI_ROW.RSD_LONGITUDE,
               PI_ROW.RSD_ROAD_NUMBER,
               get_asset_tolerance (PI_ROW.RSD_ASSET_TYPE_CODE));
			   
		L_CURRENT_SEG :=
			get_asset_from_location (
               'SEG',
               PI_ROW.RSD_LATITUDE,
               PI_ROW.RSD_LONGITUDE,
               PI_ROW.RSD_ROAD_NUMBER,
               get_asset_tolerance (PI_ROW.RSD_ASSET_TYPE_CODE));
		
		-- if a SEG was provided use that else change it
		
			--if pi_row.RSD_ROAD_MAINTENANCE_SEGMENT is null then 
				NM3DBG.PUTLN('RSD_ROAD_MAINTENANCE_SEGMENT IS NULL, Changing to ' || L_CURRENT_SEG.IIT_NE_ID || ', ' || L_CURRENT_SEG.IIT_CHR_ATTRIB34);
				pi_row.RSD_ROAD_MAINTENANCE_SEGMENT := L_CURRENT_SEG.IIT_CHR_ATTRIB34;
			--end if;
		
			-- Find out if this is a point asset, if it, locate RSD in a different way
			
			If NM3INV.GET_NIT_PNT_OR_CONT(pi_row.RSD_ASSET_TYPE_CODE) = 'C' then
				
				l_rsd_iit_ne_id := NM3API_INV_RSD.INS(P_EFFECTIVE_DATE=>pi_row.RSD_DATE_OF_CREATION
				, P_ADMIN_UNIT=>G_ADMIN_UNIT
				, PF_VENDOR_CODE => pi_row.RSD_VENDOR_CODE
				, PF_ASSET_TYPE_CODE => pi_row.RSD_ASSET_TYPE_CODE
				, PF_ROAD_MAINTENANCE_SEGMENT => pi_row.RSD_ROAD_MAINTENANCE_SEGMENT
				, PF_LGA => pi_row.RSD_LGA
				, PF_ROAD_NUMBER => pi_row.RSD_ROAD_NUMBER
				, PF_LINEAR_REFERENCE_NUMBER => null
				, PF_ASSET_DESCRIPTION => pi_row.RSD_ASSET_DESCRIPTION
				, PF_DATE_OF_CREATION => pi_row.RSD_DATE_OF_CREATION
				, PF_TIME_OF_CREATION => to_date(to_char(PI_ROW.RSD_DATE_OF_CREATION,'DDMMYYYY') || ' ' || PI_ROW.RSD_TIME_OF_CREATION, 'DDMMYYYY HH24:MI')
				--, PF_KEY_ID => pi_row.RSD_KEY_ID
				, PF_KEY_ID => l_current_rsd.iit_ne_id  -- Changed Per Share point ID=5
				, PF_LONGITUDE => pi_row.RSD_LONGITUDE
				, PF_LATITUDE => pi_row.RSD_LATITUDE
				, PF_REFERENCE_ID => pi_row.RSD_REFERENCE_ID
				,p_pl_arr => NM3PLA.GET_SUB_PLACEMENT(NM3API_INV.GET_GROUP_PLACEMENT_FOR_ITEM(p_iit_primary_key => l_current_rsd.iit_primary_key,p_iit_inv_type => l_current_rsd.iit_inv_type, P_EFFECTIVE_DATE=>pi_row.RSD_DATE_OF_CREATION).get_entry(1)));
				
				NM3DBG.PUTLN('NEW CONT RSD ASSET : ' || L_RSD_IIT_NE_ID);
            Else  -- Must be a point Asset
				-- need to get ne_id and offsets
				get_point_placement(l_current_rsd.iit_ne_id);
				
				
				l_rsd_iit_ne_id := NM3API_INV_RSD.INS(P_EFFECTIVE_DATE=>pi_row.RSD_DATE_OF_CREATION
				, P_ADMIN_UNIT=>G_ADMIN_UNIT
				, PF_VENDOR_CODE => pi_row.RSD_VENDOR_CODE
				, PF_ASSET_TYPE_CODE => pi_row.RSD_ASSET_TYPE_CODE
				, PF_ROAD_MAINTENANCE_SEGMENT => pi_row.RSD_ROAD_MAINTENANCE_SEGMENT
				, PF_LGA => pi_row.RSD_LGA
				, PF_ROAD_NUMBER => pi_row.RSD_ROAD_NUMBER
				, PF_LINEAR_REFERENCE_NUMBER => null
				, PF_ASSET_DESCRIPTION => pi_row.RSD_ASSET_DESCRIPTION
				, PF_DATE_OF_CREATION => pi_row.RSD_DATE_OF_CREATION
				, PF_TIME_OF_CREATION => to_date(to_char(PI_ROW.RSD_DATE_OF_CREATION,'DDMMYYYY') || ' ' || PI_ROW.RSD_TIME_OF_CREATION, 'DDMMYYYY HH24:MI')
				--, PF_KEY_ID => pi_row.RSD_KEY_ID
				, PF_KEY_ID => l_current_rsd.iit_primary_key  -- Changed Per Share point ID=5
				, PF_LONGITUDE => pi_row.RSD_LONGITUDE
				, PF_LATITUDE => pi_row.RSD_LATITUDE
				, PF_REFERENCE_ID => pi_row.RSD_REFERENCE_ID
				,p_element_ne_id  	=> l_rsd_asset_loc_ne_id
				,p_element_begin_mp => l_rsd_asset_loc_begin_mp
				,p_element_end_mp   => l_rsd_asset_loc_end_mp
				);
				NM3DBG.PUTLN('NEW POINT RSD ASSET : ' || L_RSD_IIT_NE_ID);
			end if;
        ELSE
         
         L_CURRENT_RSD := NM3GET.GET_IIT(pi_iit_ne_id=>l_rsd_iit_ne_id);
         if (PI_ROW.RSD_VENDOR_CODE <>  L_CURRENT_RSD.iit_chr_attrib26 OR
            PI_ROW.RSD_ASSET_TYPE_CODE <>  L_CURRENT_RSD.iit_chr_attrib27  OR
            PI_ROW.RSD_ROAD_MAINTENANCE_SEGMENT <>  L_CURRENT_RSD.iit_chr_attrib28  OR
            PI_ROW.RSD_LGA <>  L_CURRENT_RSD.iit_chr_attrib29  OR
            PI_ROW.RSD_ROAD_NUMBER <>  L_CURRENT_RSD.iit_chr_attrib56  OR
            PI_ROW.RSD_ASSET_DESCRIPTION <>  L_CURRENT_RSD.iit_chr_attrib58  OR
            PI_ROW.RSD_DATE_OF_CREATION <>  L_CURRENT_RSD.iit_date_attrib86  OR
            to_date(to_char(PI_ROW.RSD_DATE_OF_CREATION,'DDMMYYYY') || ' ' || PI_ROW.RSD_TIME_OF_CREATION, 'DDMMYYYY HH24:MI') <>  L_CURRENT_RSD.iit_date_attrib87  OR
            --(PI_ROW.RSD_KEY_ID <>  L_CURRENT_RSD.iit_num_attrib16 )  OR -- Changed Per Share point ID=5
			(PI_ROW.RSD_KEY_ID <>  L_CURRENT_RSD.iit_num_attrib16 and PI_ROW.RSD_KEY_ID is null)  OR -- Changed Per Share point ID=5
            PI_ROW.RSD_LONGITUDE <>  L_CURRENT_RSD.iit_num_attrib17  OR
            PI_ROW.RSD_LATITUDE <>  L_CURRENT_RSD.iit_num_attrib18  OR
            PI_ROW.RSD_REFERENCE_ID <>  L_CURRENT_RSD.iit_num_attrib25) then
         --o    If Existing then see if any Values in RSD have changed or have been added then update them.
         nm3api_inv_rsd.date_track_upd_attr (
		 --nm3api_inv_rsd.upd_attr (
            l_rsd_iit_ne_id,
            PI_ROW.RSD_DATE_OF_CREATION,
            PI_ROW.RSD_VENDOR_CODE,
            PI_ROW.RSD_ASSET_TYPE_CODE,
            PI_ROW.RSD_ROAD_MAINTENANCE_SEGMENT,
            PI_ROW.RSD_LGA,
            PI_ROW.RSD_ROAD_NUMBER,
            NULL,
            PI_ROW.RSD_ASSET_DESCRIPTION,
            PI_ROW.RSD_DATE_OF_CREATION,
            to_date(to_char(PI_ROW.RSD_DATE_OF_CREATION,'DDMMYYYY') || ' ' || PI_ROW.RSD_TIME_OF_CREATION, 'DDMMYYYY HH24:MI'),
            PI_ROW.RSD_KEY_ID,
            PI_ROW.RSD_LONGITUDE,
            PI_ROW.RSD_LATITUDE,
            PI_ROW.RSD_REFERENCE_ID);
            end if;
      END IF;

      --
      L_CURRENT_RSD := NM3GET.GET_IIT (L_RSD_IIT_NE_ID);

      --?    If Accomplishment ID is supplied then process accomplishments
      IF pi_row.RSAM_ACCOMPLISHMENT_ID IS NOT NULL
      THEN
         --o    If it is a new Accomplishment ID then Create the RSAM asset as a Child of the RSD asset associated with the Vendor Code  Reference ID and fill in the suppled attributes.
         l_rsam_iit_ne_id :=
            get_rsam (pi_row.RSD_VENDOR_CODE, pi_row.RSD_REFERENCE_ID, pi_row.RSAM_ACCOMPLISHMENT_ID);

         IF l_rsam_iit_ne_id IS NULL
         THEN
            l_rsam_iit_ne_id :=
               nm3api_inv_rsam.ins (
                  p_effective_date             => L_CURRENT_RSD.IIT_START_DATE,
                  p_admin_unit                 => G_ADMIN_UNIT-- <FLEXIBLE ATTRIBUTES>
                  ,
                  pf_vendor_code               => PI_ROW.RSD_VENDOR_CODE,
                  pf_accomplishment_number     => PI_ROW.RSAM_ACCOMPLISHMENT_NUMBER,
                  pf_activity_type             => PI_ROW.RSAM_ACTIVITY_TYPE,
                  pf_unit_of_measure           => PI_ROW.RSAM_UNIT_OF_MEASURE,
                  pf_second_unit_of_measure    => PI_ROW.RSAM_SECOND_UNIT_OF_MEASURE,
                  pf_completed                 => PI_ROW.RSAM_COMPLETED,
                  pf_activity_name             => PI_ROW.RSAM_ACTIVITY_NAME,
                  pf_accomplishment_comments   => PI_ROW.RSAM_ACCOMPLISHMENT_COMMENTS,
                  pf_accomplishment_date       => PI_ROW.RSAM_ACCOMPLISHMENT_DATE,
                  pf_iit_foreign_key           => L_CURRENT_RSD.IIT_PRIMARY_KEY,
                  pf_activity                  => PI_ROW.RSAM_ACTIVITY,
                  pf_quantity_accomplished     => PI_ROW.RSAM_QUANTITY_ACCOMPLISHED,
                  pf_second_quantity           => PI_ROW.RSAM_SECOND_QUANTITY,
                  pf_time_work                 => PI_ROW.RSAM_TIME_WORK,
                  pf_accomplishment_id         => PI_ROW.RSAM_ACCOMPLISHMENT_ID,
                  pf_reference_id              => PI_ROW.RSD_REFERENCE_ID-- </FLEXIBLE ATTRIBUTES>
                  );
         --o    If Existing then see if any Values in RSAM have changed or have been added then update them.
         ELSE
            select * into l_current_rsam from v_nm_rsam where iit_ne_id = l_rsam_iit_ne_id ;
            if (PI_ROW.RSD_VENDOR_CODE = l_current_rsam.VENDOR_CODE  OR
               PI_ROW.RSAM_ACCOMPLISHMENT_NUMBER = l_current_rsam.ACCOMPLISHMENT_NUMBER  OR
               PI_ROW.RSAM_ACTIVITY_TYPE = l_current_rsam.ACTIVITY_TYPE  OR
               PI_ROW.RSAM_UNIT_OF_MEASURE = l_current_rsam.UNIT_OF_MEASURE  OR
               PI_ROW.RSAM_SECOND_UNIT_OF_MEASURE = l_current_rsam.SECOND_UNIT_OF_MEASURE  OR
               PI_ROW.RSAM_COMPLETED = l_current_rsam.COMPLETED  OR
               PI_ROW.RSAM_ACTIVITY_NAME = l_current_rsam.ACTIVITY_NAME  OR
               PI_ROW.RSAM_ACCOMPLISHMENT_COMMENTS = l_current_rsam.ACCOMPLISHMENT_COMMENTS  OR
               PI_ROW.RSAM_ACCOMPLISHMENT_DATE = l_current_rsam.ACCOMPLISHMENT_DATE  OR
               PI_ROW.RSAM_ACTIVITY  = l_current_rsam.ACTIVITY  OR
               PI_ROW.RSAM_QUANTITY_ACCOMPLISHED = l_current_rsam.QUANTITY_ACCOMPLISHED  OR
               PI_ROW.RSAM_SECOND_QUANTITY = l_current_rsam.SECOND_QUANTITY  OR
               PI_ROW.RSAM_TIME_WORK = l_current_rsam.TIME_WORK OR
               PI_ROW.RSAM_ACCOMPLISHMENT_ID = l_current_rsam.ACCOMPLISHMENT_ID OR
               PI_ROW.RSD_REFERENCE_ID  = l_current_rsam.REFERENCE_ID ) then
                
            nm3api_inv_rsam.date_track_upd_attr (
			--nm3api_inv_rsam.upd_attr (
               p_iit_ne_id                  => l_rsam_iit_ne_id,
               p_effective_date             => L_CURRENT_RSD.IIT_START_DATE-- <FLEXIBLE ATTRIBUTES>
               ,
               pf_vendor_code               => PI_ROW.RSD_VENDOR_CODE,
               pf_accomplishment_number     => PI_ROW.RSAM_ACCOMPLISHMENT_NUMBER,
               pf_activity_type             => PI_ROW.RSAM_ACTIVITY_TYPE,
               pf_unit_of_measure           => PI_ROW.RSAM_UNIT_OF_MEASURE,
               pf_second_unit_of_measure    => PI_ROW.RSAM_SECOND_UNIT_OF_MEASURE,
               pf_completed                 => PI_ROW.RSAM_COMPLETED,
               pf_activity_name             => PI_ROW.RSAM_ACTIVITY_NAME,
               pf_accomplishment_comments   => PI_ROW.RSAM_ACCOMPLISHMENT_COMMENTS,
               pf_accomplishment_date       => PI_ROW.RSAM_ACCOMPLISHMENT_DATE,
               pf_iit_foreign_key           => L_CURRENT_RSD.IIT_PRIMARY_KEY,
               pf_activity                  => PI_ROW.RSAM_ACTIVITY,
               pf_quantity_accomplished     => PI_ROW.RSAM_QUANTITY_ACCOMPLISHED,
               pf_second_quantity           => PI_ROW.RSAM_SECOND_QUANTITY,
               pf_time_work                 => PI_ROW.RSAM_TIME_WORK,
               pf_accomplishment_id         => PI_ROW.RSAM_ACCOMPLISHMENT_ID,
               pf_reference_id              => PI_ROW.RSD_REFERENCE_ID-- </FLEXIBLE ATTRIBUTES>
               );
               end if;
         END IF;
      END IF;

      --?    If Defect ID is supplied then process Defects
      IF pi_row.RSDE_DEFECT_ID IS NOT NULL
      THEN
         --o    If it is a new Defect ID then Create the RSDE asset as a Child of the RSD asset associated with the Vendor Code  Reference ID and fill in the suppled attributes.
         l_rsde_iit_ne_id :=
            get_rsde (pi_row.RSD_VENDOR_CODE, pi_row.RSD_REFERENCE_ID, pi_row.RSDE_DEFECT_ID);

         IF l_rsde_iit_ne_id IS NULL
         THEN
            nm3api_inv_rsde.ins (
               p_iit_ne_id                      => l_rsde_iit_ne_id,
               p_admin_unit                     => G_ADMIN_UNIT,
               p_effective_date                 => L_CURRENT_RSD.IIT_START_DATE-- <FLEXIBLE ATTRIBUTES>
               ,
               pf_vendor_code                   => PI_ROW.RSD_VENDOR_CODE,
               pf_defect_number                 => PI_ROW.RSDE_DEFECT_NUMBER,
               pf_cause_of_defect               => PI_ROW.RSDE_CAUSE_OF_DEFECT,
               pf_reoccurring_defect            => PI_ROW.RSDE_REOCCURRING_DEFECT,
               pf_defect_type                   => PI_ROW.RSDE_DEFECT_TYPE,
               pf_unit_of_measure               => PI_ROW.RSDE_UNIT_OF_MEASURE,
               pf_second_unit_of_measure        => PI_ROW.RSDE_SECOND_UNIT_OF_MEASURE,
               pf_defect_comments               => PI_ROW.RSDE_DEFECT_COMMENTS,
               pf_date_raised                   => PI_ROW.RSDE_DATE_RAISED,
               pf_time_raised                   => to_date(to_char(PI_ROW.RSDE_DATE_RAISED,'DDMMYYYY') || ' ' || PI_ROW.RSDE_TIME_RAISED, 'DDMMYYYY HH24:MI'),
               pf_defect_completion_date        => PI_ROW.RSDE_DEFECT_COMPLETION_DATE,
               pf_defect_completion_time        => to_date(to_char(PI_ROW.RSDE_DEFECT_COMPLETION_DATE,'DDMMYYYY') || ' ' || PI_ROW.RSDE_DEFECT_COMPLETION_TIME, 'DDMMYYYY HH24:MI'),
               pf_iit_foreign_key               => L_CURRENT_RSD.IIT_PRIMARY_KEY,
               pf_position_within_location      => PI_ROW.RSDE_POSITION_WITHIN_LOCATION,
               pf_estimated_quantity_for_repa   => PI_ROW.RSDE_ESTIMATED_QTY_FOR_REPAIR,
               pf_estimated_second_quantity     => PI_ROW.RSDE_ESTIMATED_SECOND_QUANTITY,
               pf_defect_id                     => PI_ROW.RSDE_DEFECT_ID,
               pf_reference_id                  => PI_ROW.RSD_REFERENCE_ID-- </FLEXIBLE ATTRIBUTES>
               );
         --o    If Existing then see if any Values in RSDE have changed or have been added then update them.
         ELSE
            select * into l_current_rsde from v_nm_rsde where iit_ne_id = l_rsde_iit_ne_id;
            if (PI_ROW.RSD_VENDOR_CODE <> l_current_rsde.VENDOR_CODE  or 
               PI_ROW.RSDE_DEFECT_NUMBER <> l_current_rsde.DEFECT_NUMBER  or 
               PI_ROW.RSDE_CAUSE_OF_DEFECT <> l_current_rsde.CAUSE_OF_DEFECT  or 
               PI_ROW.RSDE_REOCCURRING_DEFECT <> l_current_rsde.REOCCURRING_DEFECT  or 
               PI_ROW.RSDE_DEFECT_TYPE <> l_current_rsde.DEFECT_TYPE  or 
               PI_ROW.RSDE_UNIT_OF_MEASURE <> l_current_rsde.UNIT_OF_MEASURE  or 
               PI_ROW.RSDE_SECOND_UNIT_OF_MEASURE <> l_current_rsde.SECOND_UNIT_OF_MEASURE  or 
               PI_ROW.RSDE_DEFECT_COMMENTS <> l_current_rsde.DEFECT_COMMENTS  or 
               PI_ROW.RSDE_DATE_RAISED <> l_current_rsde.DATE_RAISED  or 
               to_date(to_char(PI_ROW.RSDE_DATE_RAISED,'DDMMYYYY') || ' ' || PI_ROW.RSDE_TIME_RAISED, 'DDMMYYYY HH24:MI') <> l_current_rsde.TIME_RAISED   or 
               PI_ROW.RSDE_DEFECT_COMPLETION_DATE <> l_current_rsde.DEFECT_COMPLETION_DATE  or 
               to_date(to_char(PI_ROW.RSDE_DEFECT_COMPLETION_DATE,'DDMMYYYY') || ' ' || PI_ROW.RSDE_DEFECT_COMPLETION_TIME, 'DDMMYYYY HH24:MI') <> l_current_rsde.DEFECT_COMPLETION_TIME  or 
               PI_ROW.RSDE_POSITION_WITHIN_LOCATION <> l_current_rsde.POSITION_WITHIN_LOCATION  or 
               PI_ROW.RSDE_ESTIMATED_QTY_FOR_REPAIR <> l_current_rsde.ESTIMATED_QUANTITY_FOR_REPAIR  or 
               PI_ROW.RSDE_ESTIMATED_SECOND_QUANTITY <> l_current_rsde.ESTIMATED_SECOND_QUANTITY  or 
               PI_ROW.RSDE_DEFECT_ID <> l_current_rsde.DEFECT_ID  or 
               PI_ROW.RSD_REFERENCE_ID <> l_current_rsde.REFERENCE_ID) then 
            nm3api_inv_rsde.date_track_upd_attr (
			--nm3api_inv_rsde.upd_attr (
               p_iit_ne_id                      => l_rsde_iit_ne_id,
               p_effective_date                 => L_CURRENT_RSD.IIT_START_DATE-- <FLEXIBLE ATTRIBUTES>
               ,
               pf_vendor_code                   => PI_ROW.RSD_VENDOR_CODE,
               pf_defect_number                 => PI_ROW.RSDE_DEFECT_NUMBER,
               pf_cause_of_defect               => PI_ROW.RSDE_CAUSE_OF_DEFECT,
               pf_reoccurring_defect            => PI_ROW.RSDE_REOCCURRING_DEFECT,
               pf_defect_type                   => PI_ROW.RSDE_DEFECT_TYPE,
               pf_unit_of_measure               => PI_ROW.RSDE_UNIT_OF_MEASURE,
               pf_second_unit_of_measure        => PI_ROW.RSDE_SECOND_UNIT_OF_MEASURE,
               pf_defect_comments               => PI_ROW.RSDE_DEFECT_COMMENTS,
               pf_date_raised                   => PI_ROW.RSDE_DATE_RAISED,
               pf_time_raised                   => to_date(to_char(PI_ROW.RSDE_DATE_RAISED,'DDMMYYYY') || ' ' || PI_ROW.RSDE_TIME_RAISED, 'DDMMYYYY HH24:MI'),
               pf_defect_completion_date        => PI_ROW.RSDE_DEFECT_COMPLETION_DATE,
               pf_defect_completion_time        => to_date(to_char(PI_ROW.RSDE_DEFECT_COMPLETION_DATE,'DDMMYYYY') || ' ' || PI_ROW.RSDE_DEFECT_COMPLETION_TIME, 'DDMMYYYY HH24:MI'),
               pf_iit_foreign_key               => L_CURRENT_RSD.IIT_PRIMARY_KEY,
               pf_position_within_location      => PI_ROW.RSDE_POSITION_WITHIN_LOCATION,
               pf_estimated_quantity_for_repa   => PI_ROW.RSDE_ESTIMATED_QTY_FOR_REPAIR,
               pf_estimated_second_quantity     => PI_ROW.RSDE_ESTIMATED_SECOND_QUANTITY,
               pf_defect_id                     => PI_ROW.RSDE_DEFECT_ID,
               pf_reference_id                  => PI_ROW.RSD_REFERENCE_ID-- </FLEXIBLE ATTRIBUTES>
               );
            END IF;
         END IF;
      END IF;


      --?    If Incident ID is supplied then process Incidents
      IF pi_row.RSIC_INCIDENT_ID IS NOT NULL
      THEN
         --o    If it is a new Incident ID then Create the RSIC asset as a Child of the RSD asset associated with the Vendor Code  Reference ID and fill in the suppled attributes.
         l_rsic_iit_ne_id :=
            get_rsic (pi_row.RSD_VENDOR_CODE, pi_row.RSD_REFERENCE_ID, pi_row.RSIC_INCIDENT_ID);

         IF l_rsic_iit_ne_id IS NULL
         THEN
            nm3api_inv_rsic.ins (
               p_iit_ne_id                      => l_rsic_iit_ne_id,
               p_admin_unit                     => G_ADMIN_UNIT,
               p_effective_date                 => L_CURRENT_RSD.IIT_START_DATE-- <FLEXIBLE ATTRIBUTES>
               ,
               pf_vendor_code                   => PI_ROW.RSD_VENDOR_CODE,
               pf_incident_type                 => PI_ROW.RSIC_INCIDENT_TYPE,
               pf_advice_received_from          => PI_ROW.RSIC_ADVICE_RECEIVED_FROM,
               pf_condition_at_time_of_incide   => PI_ROW.RSIC_CONDITION_AT_INCIDENT,
               pf_action_required               => PI_ROW.RSIC_ACTION_REQUIRED,
               pf_damage_to_property            => PI_ROW.RSIC_DAMAGE_TO_PROPERTY,
               pf_incident_description          => PI_ROW.RSIC_INCIDENT_DESCRIPTION,
               pf_date_call_received            => PI_ROW.RSIC_DATE_CALL_RECEIVED,
               pf_time_call_received            => to_date(to_char(PI_ROW.RSIC_DATE_CALL_RECEIVED,'DDMMYYYY') || ' ' || PI_ROW.RSIC_TIME_CALL_RECEIVED, 'DDMMYYYY HH24:MI'),
               pf_incident_completion_date      => PI_ROW.RSIC_INCIDENT_COMPLETION_DATE,
               pf_incident_completion_time      => to_date(to_char(PI_ROW.RSIC_INCIDENT_COMPLETION_DATE,'DDMMYYYY') || ' ' || PI_ROW.RSIC_INCIDENT_COMPLETION_TIME, 'DDMMYYYY HH24:MI'),
               pf_iit_foreign_key               => L_CURRENT_RSD.IIT_PRIMARY_KEY,
               pf_incident_id                   => PI_ROW.RSIC_INCIDENT_ID,
               pf_reference_id                  => PI_ROW.RSD_REFERENCE_ID-- </FLEXIBLE ATTRIBUTES>
               );
         --?    Make sure that Items marked in mandatory column of Appendix A as: ?If Recording an Incident? are supplied, otherwise throw an exception.
         -- do this in p_validate.
         ELSE
            --o    If Existing then see if any Values in RSIC have changed or have been added then update them.
            select * into l_current_rsic from v_nm_rsic where iit_ne_id = l_rsic_iit_ne_id ;
            if (PI_ROW.RSD_VENDOR_CODE <> l_current_rsic.VENDOR_CODE or
               PI_ROW.RSIC_INCIDENT_TYPE <> l_current_rsic.INCIDENT_TYPE or
               PI_ROW.RSIC_ADVICE_RECEIVED_FROM <> l_current_rsic.ADVICE_RECEIVED_FROM or
               PI_ROW.RSIC_CONDITION_AT_INCIDENT <> l_current_rsic.CONDITION_AT_TIME_OF_INCIDENT or
               PI_ROW.RSIC_ACTION_REQUIRED <> l_current_rsic.ACTION_REQUIRED or
               PI_ROW.RSIC_DAMAGE_TO_PROPERTY <> l_current_rsic.DAMAGE_TO_PROPERTY or
               PI_ROW.RSIC_INCIDENT_DESCRIPTION <> l_current_rsic.INCIDENT_DESCRIPTION or
               PI_ROW.RSIC_DATE_CALL_RECEIVED <> l_current_rsic.DATE_CALL_RECEIVED or
               to_date(to_char(PI_ROW.RSIC_DATE_CALL_RECEIVED,'DDMMYYYY') || ' ' || PI_ROW.RSIC_TIME_CALL_RECEIVED, 'DDMMYYYY HH24:MI') <> l_current_rsic.TIME_CALL_RECEIVED or
               PI_ROW.RSIC_INCIDENT_COMPLETION_DATE <> l_current_rsic.INCIDENT_COMPLETION_DATE or
               to_date(to_char(PI_ROW.RSIC_INCIDENT_COMPLETION_DATE,'DDMMYYYY') || ' ' || PI_ROW.RSIC_INCIDENT_COMPLETION_TIME, 'DDMMYYYY HH24:MI') <> l_current_rsic.INCIDENT_COMPLETION_TIME or
               PI_ROW.RSIC_INCIDENT_ID <> l_current_rsic.INCIDENT_ID or
               PI_ROW.RSD_REFERENCE_ID <> l_current_rsic.REFERENCE_ID) then
            nm3api_inv_rsic.date_track_upd_attr (
			--nm3api_inv_rsic.upd_attr (
               p_iit_ne_id                      => l_rsic_iit_ne_id,
               p_effective_date                 => L_CURRENT_RSD.IIT_START_DATE-- <FLEXIBLE ATTRIBUTES>
               ,
               pf_vendor_code                   => PI_ROW.RSD_VENDOR_CODE,
               pf_incident_type                 => PI_ROW.RSIC_INCIDENT_TYPE,
               pf_advice_received_from          => PI_ROW.RSIC_ADVICE_RECEIVED_FROM,
               pf_condition_at_time_of_incide   => PI_ROW.RSIC_CONDITION_AT_INCIDENT,
               pf_action_required               => PI_ROW.RSIC_ACTION_REQUIRED,
               pf_damage_to_property            => PI_ROW.RSIC_DAMAGE_TO_PROPERTY,
               pf_incident_description          => PI_ROW.RSIC_INCIDENT_DESCRIPTION,
               pf_date_call_received            => PI_ROW.RSIC_DATE_CALL_RECEIVED,
               pf_time_call_received            => to_date(to_char(PI_ROW.RSIC_DATE_CALL_RECEIVED,'DDMMYYYY') || ' ' || PI_ROW.RSIC_TIME_CALL_RECEIVED, 'DDMMYYYY HH24:MI'),
               pf_incident_completion_date      => PI_ROW.RSIC_INCIDENT_COMPLETION_DATE,
               pf_incident_completion_time      => to_date(to_char(PI_ROW.RSIC_INCIDENT_COMPLETION_DATE,'DDMMYYYY') || ' ' || PI_ROW.RSIC_INCIDENT_COMPLETION_TIME, 'DDMMYYYY HH24:MI'),
               pf_iit_foreign_key               => L_CURRENT_RSD.IIT_PRIMARY_KEY,
               pf_incident_id                   => PI_ROW.RSIC_INCIDENT_ID,
               pf_reference_id                  => PI_ROW.RSD_REFERENCE_ID-- </FLEXIBLE ATTRIBUTES>
               );
               end if;
         END IF;
      END IF;
    
      --?    If Inspection ID is supplied then process Inspections
      IF pi_row.RSIN_INSPECTION_ID IS NOT NULL
      THEN
         --o    If it is a new Inspection ID then Create the RSIN asset as a Child of the RSD asset associated with the Vendor Code Reference ID and fill in the suppled attributes.
         l_RSIN_iit_ne_id :=
            get_RSIN (pi_row.RSD_VENDOR_CODE, pi_row.RSD_REFERENCE_ID, pi_row.RSIN_INSPECTION_ID);

         IF l_RSIN_iit_ne_id IS NULL
         THEN
            nm3api_inv_RSIN.ins (
               p_iit_ne_id                     => l_RSIN_iit_ne_id,
               p_admin_unit                    => G_ADMIN_UNIT,
               p_effective_date                => L_CURRENT_RSD.IIT_START_DATE-- <FLEXIBLE ATTRIBUTES>
               ,
               pf_vendor_code                  => PI_ROW.RSD_VENDOR_CODE,
               pf_inspection_number            => PI_ROW.RSIN_INSPECTION_NUMBER,
               pf_inspection_type              => PI_ROW.RSIN_INSPECTION_TYPE,
               pf_inspection_comments          => PI_ROW.RSIN_COMMENTS,
               pf_target_date                  => PI_ROW.RSIN_TARGET_DATE,
               pf_target_time                  => to_date(to_char(PI_ROW.RSIN_TARGET_DATE,'DDMMYYYY') || ' ' || PI_ROW.RSIN_TARGET_TIME, 'DDMMYYYY HH24:MI'),
               pf_inspection_completion_date   => PI_ROW.RSIN_COMPLETION_DATE,
               pf_inspection_completion_time   => to_date(to_char(PI_ROW.RSIN_COMPLETION_DATE,'DDMMYYYY') || ' ' || PI_ROW.RSIN_COMPLETION_TIME, 'DDMMYYYY HH24:MI'),
               pf_iit_foreign_key              => L_CURRENT_RSD.IIT_PRIMARY_KEY,
               pf_inspection_id                => PI_ROW.RSIN_INSPECTION_ID,
               pf_reference_id                 => PI_ROW.RSD_REFERENCE_ID-- </FLEXIBLE ATTRIBUTES>
               );
         --?    Make sure that Items marked in mandatory column of Appendix A as: ?If Recording an Inspection? are supplied, otherwise throw an exception.
         -- do this in p_validate.
         ELSE
            --o    If Existing then see if any Values in RSIN have changed or have been added then update them.
            select * into l_current_rsin from v_nm_rsin where iit_ne_id = l_rsin_iit_ne_id ;
            if (PI_ROW.RSD_VENDOR_CODE <> l_current_rsin.VENDOR_CODE  or
            PI_ROW.RSIN_INSPECTION_NUMBER <> l_current_rsin.INSPECTION_NUMBER  or
            PI_ROW.RSIN_INSPECTION_TYPE <> l_current_rsin.INSPECTION_TYPE  or
            PI_ROW.RSIN_COMMENTS <> l_current_rsin.INSPECTION_COMMENTS  or
            PI_ROW.RSIN_TARGET_DATE <> l_current_rsin.TARGET_DATE  or
            to_date(to_char(PI_ROW.RSIN_TARGET_DATE,'DDMMYYYY') || ' ' || PI_ROW.RSIN_TARGET_TIME, 'DDMMYYYY HH24:MI') <> l_current_rsin.TARGET_TIME  or
            PI_ROW.RSIN_COMPLETION_DATE <> l_current_rsin.INSPECTION_COMPLETION_DATE  or
               to_date(to_char(PI_ROW.RSIN_COMPLETION_DATE,'DDMMYYYY') || ' ' || PI_ROW.RSIN_COMPLETION_TIME, 'DDMMYYYY HH24:MI') <> l_current_rsin.INSPECTION_COMPLETION_TIME  or
               PI_ROW.RSIN_INSPECTION_ID <> l_current_rsin.INSPECTION_ID  or
               PI_ROW.RSD_REFERENCE_ID <> l_current_rsin.REFERENCE_ID) then
            nm3api_inv_RSIN.date_track_upd_attr (
			--nm3api_inv_RSIN.upd_attr (
               p_iit_ne_id                     => l_RSIN_iit_ne_id,
               p_effective_date                => L_CURRENT_RSD.IIT_START_DATE-- <FLEXIBLE ATTRIBUTES>
               ,
               pf_vendor_code                  => PI_ROW.RSD_VENDOR_CODE,
               pf_inspection_number            => PI_ROW.RSIN_INSPECTION_NUMBER,
               pf_inspection_type              => PI_ROW.RSIN_INSPECTION_TYPE,
               pf_inspection_comments          => PI_ROW.RSIN_COMMENTS,
               pf_target_date                  => PI_ROW.RSIN_TARGET_DATE,
               pf_target_time                  => to_date(to_char(PI_ROW.RSIN_TARGET_DATE,'DDMMYYYY') || ' ' || PI_ROW.RSIN_TARGET_TIME, 'DDMMYYYY HH24:MI'),
               pf_inspection_completion_date   => PI_ROW.RSIN_COMPLETION_DATE,
               pf_inspection_completion_time   => to_date(to_char(PI_ROW.RSIN_COMPLETION_DATE,'DDMMYYYY') || ' ' || PI_ROW.RSIN_COMPLETION_TIME, 'DDMMYYYY HH24:MI'),
               pf_iit_foreign_key              => L_CURRENT_RSD.IIT_PRIMARY_KEY,
               pf_inspection_id                => PI_ROW.RSIN_INSPECTION_ID,
               pf_reference_id                 => PI_ROW.RSD_REFERENCE_ID-- </FLEXIBLE ATTRIBUTES>
               );
            end if;
         END IF;
      END IF;


      --?    If Request ID is supplied then process Requests
      IF pi_row.RSRE_REQUEST_ID IS NOT NULL
      THEN
         --o    If it is a new Request ID then Create the RSRE asset as a Child of the RSD asset associated with the Vendor Code Reference ID and fill in the suppled attributes.
         l_rsre_iit_ne_id :=
            get_rsre (pi_row.RSD_VENDOR_CODE, pi_row.RSD_REFERENCE_ID, pi_row.RSRE_REQUEST_ID);

         IF l_rsre_iit_ne_id IS NULL
         THEN
            nm3api_inv_rsre.ins (
               p_iit_ne_id                  => l_RSRE_iit_ne_id,
               p_admin_unit                 => G_ADMIN_UNIT,
               p_effective_date             => L_CURRENT_RSD.IIT_START_DATE-- <FLEXIBLE ATTRIBUTES>
               ,
               pf_vendor_code               => PI_ROW.RSD_VENDOR_CODE,
               pf_request_type              => PI_ROW.RSRE_REQUEST_TYPE,
               pf_request_number            => PI_ROW.RSRE_REQUEST_NUMBER,
               pf_request_comments          => PI_ROW.RSRE_REQUEST_COMMENTS,
               pf_request_date_received     => PI_ROW.RSRE_REQUEST_DATE_RECEIVED,
               pf_request_time_received     => to_date(to_char(PI_ROW.RSRE_REQUEST_DATE_RECEIVED,'DDMMYYYY') || ' ' || PI_ROW.RSRE_REQUEST_TIME_RECEIVED, 'DDMMYYYY HH24:MI'),
               pf_request_completion_date   => PI_ROW.RSRE_REQUEST_COMPLETION_DATE,
               pf_request_completion_time   => to_date(to_char(PI_ROW.RSRE_REQUEST_COMPLETION_DATE,'DDMMYYYY') || ' ' || PI_ROW.RSRE_REQUEST_COMPLETION_TIME, 'DDMMYYYY HH24:MI'),
               pf_iit_foreign_key           => L_CURRENT_RSD.IIT_PRIMARY_KEY,
               pf_request_id                => PI_ROW.RSRE_REQUEST_ID,
               pf_reference_id              => PI_ROW.RSD_REFERENCE_ID-- </FLEXIBLE ATTRIBUTES>
               );
         --?    Make sure that Items marked in mandatory column of Appendix A as: ?If Recording a Request? are supplied, otherwise throw an exception.
         -- do this in p_validate.
         ELSE
            --o    If Existing then see if any Values in RSRE have changed or have been added then update them.
            select * into l_current_rsre from v_nm_rsre where iit_ne_id = l_rsre_iit_ne_id ;
            if (PI_ROW.RSD_VENDOR_CODE <> l_current_rsre.VENDOR_CODE  or
            PI_ROW.RSRE_REQUEST_TYPE <> l_current_rsre.REQUEST_TYPE  or
            PI_ROW.RSRE_REQUEST_NUMBER <> l_current_rsre.REQUEST_NUMBER  or
            PI_ROW.RSRE_REQUEST_COMMENTS <> l_current_rsre.REQUEST_COMMENTS  or
            PI_ROW.RSRE_REQUEST_DATE_RECEIVED <> l_current_rsre.REQUEST_DATE_RECEIVED  or
            to_date(to_char(PI_ROW.RSRE_REQUEST_DATE_RECEIVED,'DDMMYYYY') || ' ' || PI_ROW.RSRE_REQUEST_TIME_RECEIVED, 'DDMMYYYY HH24:MI') <> l_current_rsre.REQUEST_TIME_RECEIVED  or
            PI_ROW.RSRE_REQUEST_COMPLETION_DATE <> l_current_rsre.REQUEST_COMPLETION_DATE  or
            to_date(to_char(PI_ROW.RSRE_REQUEST_COMPLETION_DATE,'DDMMYYYY') || ' ' || PI_ROW.RSRE_REQUEST_COMPLETION_TIME, 'DDMMYYYY HH24:MI') <> l_current_rsre.REQUEST_COMPLETION_TIME  or
            PI_ROW.RSRE_REQUEST_ID <> l_current_rsre.REQUEST_ID  or
            PI_ROW.RSD_REFERENCE_ID  <> l_current_rsre.REFERENCE_ID  ) then
            nm3api_inv_rsRE.date_track_upd_attr (
			--nm3api_inv_rsRE.upd_attr (
               p_iit_ne_id                  => l_RSRE_iit_ne_id,
               p_effective_date             => L_CURRENT_RSD.IIT_START_DATE-- <FLEXIBLE ATTRIBUTES>
               ,
               pf_vendor_code               => PI_ROW.RSD_VENDOR_CODE,
               pf_request_type              => PI_ROW.RSRE_REQUEST_TYPE,
               pf_request_number            => PI_ROW.RSRE_REQUEST_NUMBER,
               pf_request_comments          => PI_ROW.RSRE_REQUEST_COMMENTS,
               pf_request_date_received     => PI_ROW.RSRE_REQUEST_DATE_RECEIVED,
               pf_request_time_received     => to_date(to_char(PI_ROW.RSRE_REQUEST_DATE_RECEIVED,'DDMMYYYY') || ' ' || PI_ROW.RSRE_REQUEST_TIME_RECEIVED, 'DDMMYYYY HH24:MI'),
               pf_request_completion_date   => PI_ROW.RSRE_REQUEST_COMPLETION_DATE,
               pf_request_completion_time   => to_date(to_char(PI_ROW.RSRE_REQUEST_COMPLETION_DATE,'DDMMYYYY') || ' ' || PI_ROW.RSRE_REQUEST_COMPLETION_TIME, 'DDMMYYYY HH24:MI'),
               pf_iit_foreign_key           => L_CURRENT_RSD.IIT_PRIMARY_KEY,
               pf_request_id                => PI_ROW.RSRE_REQUEST_ID,
               pf_reference_id              => PI_ROW.RSD_REFERENCE_ID-- </FLEXIBLE ATTRIBUTES>
               );
            end if;
         END IF;         
      END IF;
      NM3DBG.DEBUG_OFF;
   END P_INSERT;

   PROCEDURE P_VALIDATE (pi_row IN OUT X_RMS_RSD_CSV_HOLDING%ROWTYPE)
   AS
		l_col_null_err   VARCHAR2 (5000);
		v_code NUMBER;
		v_errm VARCHAR2(64);
		procedure check_time(s_time varchar2 default '00:00', s_calling_col varchar2 default null)  as
			t_date date;
			begin
			
				-- uses fixed date for input, just for force a check
				t_date := to_date('11012000' || ' ' || s_time, 'DDMMYYYY HH24:MI');				
			exception 
			when others then
				v_code := SQLCODE;
				v_errm := SUBSTR(SQLERRM, 1 , 64);
				Raise_Application_Error(-200200, SUBSTR('Col: ' || s_calling_col ||' ORA ERROR: '  || v_code || ' ' || v_errm,1,64));
		end check_time;
   BEGIN
   NM3DBG.PUTLN('X_RMS_RSD_CSV_PACK.P_VALIDATE');
      --check each asset for mandatory's if they are populated.
      IF pi_row.RSAM_ACCOMPLISHMENT_ID IS NOT NULL
      THEN

			
		
         IF    pi_row.RSAM_ACCOMPLISHMENT_NUMBER IS NULL
            OR pi_row.RSAM_ACCOMPLISHMENT_DATE IS NULL
            OR pi_row.RSAM_ACTIVITY IS NULL
            OR pi_row.RSAM_ACTIVITY_NAME IS NULL
            OR pi_row.RSAM_ACTIVITY_TYPE IS NULL
            OR pi_row.RSAM_QUANTITY_ACCOMPLISHED IS NULL
            OR pi_row.RSAM_UNIT_OF_MEASURE IS NULL
			OR pi_row.RSAM_COMPLETED IS NULL
			
         THEN
            l_col_null_err := NULL;

            IF pi_row.RSAM_ACCOMPLISHMENT_NUMBER IS NULL
            THEN
               l_col_null_err := 'ACCOMPLISHMENT_NUMBER';
            END IF;

            IF pi_row.RSAM_ACCOMPLISHMENT_DATE IS NULL
            THEN
               l_col_null_err :=
                  NVL (l_col_null_err,
                       l_col_null_err || ', ' || 'ACCOMPLISHMENT_DATE');
            END IF;

            IF pi_row.RSAM_ACTIVITY IS NULL
            THEN
               l_col_null_err :=
                  NVL (l_col_null_err, l_col_null_err || ', ' || 'ACTIVITY');
            END IF;

            IF pi_row.RSAM_ACTIVITY_NAME IS NULL
            THEN
               l_col_null_err :=
                  NVL (l_col_null_err,
                       l_col_null_err || ', ' || 'ACTIVITY_NAME');
            END IF;

            IF pi_row.RSAM_ACTIVITY_TYPE IS NULL
            THEN
               l_col_null_err :=
                  NVL (l_col_null_err,
                       l_col_null_err || ', ' || 'ACTIVITY_TYPE');
            END IF;

            IF pi_row.RSAM_QUANTITY_ACCOMPLISHED IS NULL
            THEN
               l_col_null_err :=
                  NVL (l_col_null_err,
                       l_col_null_err || ', ' || 'QUANTITY_ACCOMPLISHED');
            END IF;

            IF pi_row.RSAM_UNIT_OF_MEASURE IS NULL
            THEN
               l_col_null_err :=
                  NVL (l_col_null_err,
                       l_col_null_err || ', ' || 'UNIT_OF_MEASURE');
            END IF;

            IF pi_row.RSAM_ACCOMPLISHMENT_COMMENTS IS NULL
            THEN
               l_col_null_err :=
                  NVL (l_col_null_err,
                       l_col_null_err || ', ' || 'ACCOMPLISHMENT_COMMENTS');
            END IF;

            IF pi_row.RSAM_TIME_WORK IS NULL
            THEN
               l_col_null_err :=
                  NVL (l_col_null_err, l_col_null_err || ', ' || 'TIME_WORK');
            END IF;

            IF pi_row.RSAM_COMPLETED IS NULL
            THEN
               l_col_null_err :=
                  NVL (l_col_null_err, l_col_null_err || ', ' || 'COMPLETED');
            END IF;

            hig.raise_ner (pi_appl                 => 'RWI',
                           pi_id                   => 1,
                           pi_supplementary_info   => l_col_null_err);
         END IF;
      END IF;


      IF pi_row.RSDE_DEFECT_ID IS NOT NULL
      THEN
	  
	  		--Lets check the time formats then everything else
			check_time(pi_row.RSDE_TIME_RAISED,'RSDE_TIME_RAISED');			
			check_time(pi_row.RSDE_DEFECT_COMPLETION_TIME,'RSDE_DEFECT_COMPLETION_TIME');
	  
         IF    pi_row.RSDE_DEFECT_NUMBER IS NULL
            OR pi_row.RSDE_DATE_RAISED IS NULL
            OR pi_row.RSDE_CAUSE_OF_DEFECT IS NULL
            OR pi_row.RSDE_REOCCURRING_DEFECT IS NULL
            OR pi_row.RSDE_DEFECT_TYPE IS NULL
            OR pi_row.RSDE_POSITION_WITHIN_LOCATION IS NULL
            --OR pi_row.RSDE_DEFECT_COMPLETION_DATE IS NULL
            --OR pi_row.RSDE_ESTIMATED_QTY_FOR_REPAIR IS NULL
            --OR pi_row.RSDE_UNIT_OF_MEASURE IS NULL
            --OR pi_row.RSDE_ESTIMATED_SECOND_QUANTITY IS NULL
            --OR pi_row.RSDE_SECOND_UNIT_OF_MEASURE IS NULL
            --OR pi_row.RSDE_DEFECT_COMMENTS IS NULL
         THEN
            l_col_null_err := NULL;

            IF pi_row.RSDE_DEFECT_NUMBER IS NULL
            THEN
               l_col_null_err := 'DEFECT_NUMBER';
            END IF;

            IF pi_row.RSDE_DEFECT_ID IS NULL
            THEN
               l_col_null_err :=
                  NVL (l_col_null_err, l_col_null_err || ', ' || 'DEFECT_ID');
            END IF;

            IF pi_row.RSDE_DATE_RAISED IS NULL
            THEN
               l_col_null_err :=
                  NVL (l_col_null_err,
                       l_col_null_err || ', ' || 'DATE_RAISED');
            END IF;

            IF pi_row.RSDE_CAUSE_OF_DEFECT IS NULL
            THEN
               l_col_null_err :=
                  NVL (l_col_null_err,
                       l_col_null_err || ', ' || 'CAUSE_OF_DEFECT');
            END IF;

            IF pi_row.RSDE_REOCCURRING_DEFECT IS NULL
            THEN
               l_col_null_err :=
                  NVL (
                     l_col_null_err,
                     l_col_null_err || ', ' || 'REOCCURRING_DEFECT_(YES/NO)');
            END IF;

            IF pi_row.RSDE_DEFECT_TYPE IS NULL
            THEN
               l_col_null_err :=
                  NVL (l_col_null_err,
                       l_col_null_err || ', ' || 'DEFECT_TYPE');
            END IF;

            IF pi_row.RSDE_POSITION_WITHIN_LOCATION IS NULL
            THEN
               l_col_null_err :=
                  NVL (l_col_null_err,
                       l_col_null_err || ', ' || 'POSITION_WITHIN_LOCATION');
            END IF;
/*
            IF pi_row.RSDE_DEFECT_COMPLETION_DATE IS NULL
            THEN
               l_col_null_err :=
                  NVL (l_col_null_err,
                       l_col_null_err || ', ' || 'DEFECT_COMPLETION_DATE');
            END IF;

            IF pi_row.RSDE_ESTIMATED_QTY_FOR_REPAIR IS NULL
            THEN
               l_col_null_err :=
                  NVL (l_col_null_err,
                       l_col_null_err || ', ' || 'ESTIMATED_QUANTITY');
            END IF;

            IF pi_row.RSDE_UNIT_OF_MEASURE IS NULL
            THEN
               l_col_null_err :=
                  NVL (l_col_null_err,
                       l_col_null_err || ', ' || 'UNIT_OF_MEASURE');
            END IF;

            IF pi_row.RSDE_ESTIMATED_SECOND_QUANTITY IS NULL
            THEN
               l_col_null_err :=
                  NVL (l_col_null_err,
                       l_col_null_err || ', ' || 'ESTIMATED_SECOND_QUANTITY');
            END IF;

            IF pi_row.RSDE_SECOND_UNIT_OF_MEASURE IS NULL
            THEN
               l_col_null_err :=
                  NVL (l_col_null_err,
                       l_col_null_err || ', ' || 'SECOND_UNIT_OF_MEASURE');
            END IF;

            IF pi_row.RSDE_DEFECT_COMMENTS IS NULL
            THEN
               l_col_null_err :=
                  NVL (l_col_null_err,
                       l_col_null_err || ', ' || 'DEFECT_COMMENTS');
            END IF;


            hig.raise_ner (pi_appl                 => 'RWI',
                           pi_id                   => 2,
                           pi_supplementary_info   => l_col_null_err);
			*/
		hig.raise_ner (pi_appl                 => 'RWI',
		   pi_id                   => 2,
		   pi_supplementary_info   => l_col_null_err);
         END IF;
      END IF;

	  
	  --raise_application_error(-20007, pi_row.RSD_REFERENCE_ID);
	  
      IF pi_row.RSIC_INCIDENT_ID IS NOT NULL
		--Lets check the time formats then everything else
      THEN
	  
	  		check_time(pi_row.RSIC_TIME_CALL_RECEIVED, 'RSIC_TIME_CALL_RECEIVED');
			check_time(pi_row.RSIC_INCIDENT_COMPLETION_TIME,'RSIC_INCIDENT_COMPLETION_TIME');
			
			
			
         IF    pi_row.RSIC_DATE_CALL_RECEIVED IS NULL
            OR pi_row.RSIC_INCIDENT_DESCRIPTION IS NULL
            OR pi_row.RSIC_DAMAGE_TO_PROPERTY IS NULL
            OR pi_row.RSIC_INCIDENT_COMPLETION_DATE IS NULL
            OR pi_row.RSIC_DATE_CALL_RECEIVED IS NULL
         THEN
            l_col_null_err := NULL;

            IF pi_row.RSIC_DATE_CALL_RECEIVED IS NULL
            THEN
               l_col_null_err := 'RSIC_DATE_CALL_RECEIVED';
            END IF;

            IF pi_row.RSIC_INCIDENT_DESCRIPTION IS NULL
            THEN
               l_col_null_err :=
                  NVL (l_col_null_err,
                       l_col_null_err || ', ' || 'RSIC_INCIDENT_DESCRIPTION');
            END IF;

            IF pi_row.RSIC_DAMAGE_TO_PROPERTY IS NULL
            THEN
               l_col_null_err :=
                  NVL (l_col_null_err,
                       l_col_null_err || ', ' || 'RSIC_DAMAGE_TO_PROPERTY');
            END IF;

            IF pi_row.RSIC_INCIDENT_COMPLETION_DATE IS NULL
            THEN
               l_col_null_err :=
                  NVL (
                     l_col_null_err,
                        l_col_null_err
                     || ', '
                     || 'RSIC_INCIDENT_COMPLETION_DATE');
            END IF;

            IF pi_row.RSIC_DATE_CALL_RECEIVED IS NULL
            THEN
               l_col_null_err :=
                  NVL (
                     l_col_null_err,
                        l_col_null_err
                     || ', '
                     || 'RSIC_DATE_CALL_RECEIVED');
            END IF;



            hig.raise_ner (pi_appl                 => 'RWI',
                           pi_id                   => 3,
                           pi_supplementary_info   => l_col_null_err);
         END IF;
      END IF;
	  
      IF pi_row.RSIN_INSPECTION_ID IS NOT NULL
      THEN  -- Inspection Number, Inspection Type, Inspection Completion Date
         IF    pi_row.RSIN_INSPECTION_NUMBER IS NULL
            OR pi_row.RSIN_INSPECTION_TYPE IS NULL
            OR pi_row.RSIN_COMPLETION_DATE IS NULL
            
         THEN
		 
			--Lets check the time formats then everything else
			check_time(pi_row.RSIN_TARGET_TIME,'RSIN_TARGET_TIME');
			check_time(pi_row.RSIN_COMPLETION_TIME,'RSIN_COMPLETION_TIME');

		 
            l_col_null_err := NULL;

            IF pi_row.RSIN_INSPECTION_NUMBER IS NULL
            THEN
               l_col_null_err := 'INSPECTION_NUMBER';
            END IF;

            IF pi_row.RSIN_INSPECTION_TYPE IS NULL
            THEN
               l_col_null_err :=
                  NVL (l_col_null_err, l_col_null_err || ', ' || 'INSPECTION_TYPE');
            END IF;

            IF pi_row.RSIN_COMPLETION_DATE IS NULL
            THEN
               l_col_null_err :=
                  NVL (l_col_null_err,
                       l_col_null_err || ', ' || 'INSPECTION_COMPLETION_DATE');
            END IF;

            
            hig.raise_ner (pi_appl                 => 'RWI',
                           pi_id                   => 4,
                           pi_supplementary_info   => l_col_null_err);
         END IF;
      END IF;
	  
	  IF pi_row.RSRE_REQUEST_ID IS NOT NULL
      THEN  -- Request Date Received,  Request Number, Request Completion Date

         IF    pi_row.RSRE_REQUEST_DATE_RECEIVED IS NULL
            OR pi_row.RSRE_REQUEST_NUMBER IS NULL
            OR pi_row.RSRE_REQUEST_COMPLETION_DATE IS NULL
            
         THEN
		 
			--Lets check the time formats then everything else
			check_time(pi_row.RSRE_REQUEST_TIME_RECEIVED,'RSRE_REQUEST_TIME_RECEIVED');
			check_time(pi_row.RSRE_REQUEST_COMPLETION_TIME,'RSRE_REQUEST_COMPLETION_TIME');
		 
            l_col_null_err := NULL;

            IF pi_row.RSRE_REQUEST_DATE_RECEIVED IS NULL
            THEN
               l_col_null_err := 'REQUEST_DATE_RECEIVED';
            END IF;

            IF pi_row.RSRE_REQUEST_NUMBER IS NULL
            THEN
               l_col_null_err :=
                  NVL (l_col_null_err, l_col_null_err || ', ' || 'REQUEST_NUMBER');
            END IF;

            IF pi_row.RSRE_REQUEST_COMPLETION_DATE IS NULL
            THEN
               l_col_null_err :=
                  NVL (l_col_null_err,
                       l_col_null_err || ', ' || 'REQUEST_COMPLETION_DATE');
            END IF;

            
            hig.raise_ner (pi_appl                 => 'RWI',
                           pi_id                   => 5,
                           pi_supplementary_info   => l_col_null_err);
         END IF;
      END IF;
   END P_VALIDATE;
END X_RMS_RSD_CSV_PACK;
/