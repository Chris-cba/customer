/* Formatted on 09/09/2013 17:08:23 (QP5 v5.215.12089.38647) */
DECLARE
   CURSOR c1
   IS
      SELECT nit_inv_type
        FROM nm_inv_types
       WHERE     nit_category = 'I'
             AND nit_use_xy = 'N'
             AND nit_inv_type IN ('RSD','RSAM','RSDE','RSIC','RSIN','RSRE');

   l_vw_nm   user_views.view_name%TYPE;
BEGIN
   nm_debug.debug_on;

   FOR irec IN c1
   LOOP
      BEGIN
         l_vw_nm := nm3inv.work_out_inv_type_view_name (irec.nit_inv_type);

         IF NM3LAYER_TOOL.DOES_ASSET_LAYER_EXIST (irec.nit_inv_type)
         THEN
            DBMS_OUTPUT.PUT_LINE (
                  'Asset layer '
               || irec.nit_inv_type
               || ' already exists - refreshing.');

            --Refresh Asset layer
            NM3LAYER_TOOL.REFRESH_ASSET_LAYER (irec.nit_inv_type);
         ELSE
            NM3INV.CREATE_INV_VIEW (irec.nit_inv_type, FALSE, l_vw_nm);

            DBMS_OUTPUT.PUT_LINE (
               'Creating asset spatial layer - ' || irec.nit_inv_type || '.');


            NM3SDM.MAKE_INV_SPATIAL_LAYER (irec.nit_inv_type);
         END IF;
      EXCEPTION
         WHEN OTHERS
         THEN
            nm_debug.debug (irec.nit_inv_type || ' - ' || SQLERRM);
      END;
   END LOOP;
END;