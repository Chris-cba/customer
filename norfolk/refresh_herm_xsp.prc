create or replace procedure refresh_herm_xsp as
--
-------------------------------------------------------------------------
--   PVCS Identifiers :-
--
--       PVCS id          : $Header:   //vm_latest/archives/customer/norfolk/refresh_herm_xsp.prc-arc   1.0   Nov 26 2013 16:19:42   Rob.Coupe  $
--       Module Name      : $Workfile:   refresh_herm_xsp.prc  $
--       Date into PVCS   : $Date:   Nov 26 2013 16:19:42  $
--       Date fetched Out : $Modtime:   Nov 26 2013 16:18:42  $
--       Version          : $Revision:   1.0  $
--
-------------------------------------------------------------------------
--
cursor c1 is
select nm_ne_id_of, nwx_x_sect, nm_start_date, offset, nm_end_date, herm_x_sect, nm_cardinality, nwx_descr  from (
      WITH datum_xsp
              AS (SELECT nm_ne_id_of,
                         nwx_x_sect,
                         NVL (nwx_offset, 0) * nm_cardinality herm_x_sect,
                         nwx_descr,
                         NVL (nwx_offset, 0) offset,
                         nm_cardinality,
                         nm_start_date nm_start_date,
                         nm_end_date,
                         ROW_NUMBER ()
                         OVER (
                            PARTITION BY nm_ne_id_of,
                                         nwx_x_sect,
                                         nm_start_date
                            ORDER BY nm_start_date, nm_end_date DESC)
                            rn
                    FROM nm_members_all, nm_elements_all, nm_nw_xsp
where ne_id = nm_ne_id_in
and nm_obj_type = 'SECT'
and nwx_nw_type = 'HERM'
and nwx_nsc_sub_class = ne_sub_class
and nm_start_date != nvl(nm_end_date, nm_start_date+1)
and not exists ( select 1 from herm_xsp
                 where hxo_ne_id_of = nm_ne_id_of
                 and hxo_nwx_x_sect = nwx_x_sect
                 and hxo_start_date = nm_start_date
                 and nvl(hxo_end_date, to_date('31-dec-2090')) = nvl( nm_end_date, to_date('31-dec-2090'))
 )
)
      SELECT DISTINCT
             nm_ne_id_of,
             nwx_x_sect,
             -- nm_start_date, nm_end_date,
             FIRST_VALUE (
                nm_start_date)
             OVER (PARTITION BY nm_ne_id_of, nwx_x_sect, herm_x_sect, offset
                   ORDER BY nm_start_date
                   ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING)
                nm_start_date,
             FIRST_VALUE (
                nm_end_date)
             OVER (PARTITION BY nm_ne_id_of, nwx_x_sect, herm_x_sect, offset
                   ORDER BY nm_end_date DESC NULLS FIRST
                   ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING)
                nm_end_date,
             LAST_VALUE (
                herm_x_sect)
             OVER (PARTITION BY nm_ne_id_of, nwx_x_sect, herm_x_sect, offset
                   ORDER BY nm_start_date ASC, nm_end_date DESC
                   ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING)
                herm_x_sect,
             LAST_VALUE (
                offset)
             OVER (PARTITION BY nm_ne_id_of, nwx_x_sect, herm_x_sect, offset
                   ORDER BY nm_start_date ASC, nm_end_date DESC
                   ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING)
                offset,
             LAST_VALUE (
                nm_cardinality)
             OVER (PARTITION BY nm_ne_id_of, nwx_x_sect, herm_x_sect, offset
                   ORDER BY nm_start_date ASC, nm_end_date DESC
                   ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING)
                nm_cardinality,
             LAST_VALUE (
                nwx_descr)
             OVER (PARTITION BY nm_ne_id_of, nwx_x_sect, herm_x_sect, offset
                   ORDER BY nm_start_date ASC, nm_end_date DESC
                   ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING)
                nwx_descr
        FROM datum_xsp  )       
        where not exists ( select 1 from herm_xsp where hxo_ne_id_of = nm_ne_id_of 
                           and hxo_nwx_x_sect = nwx_x_sect
                           and hxo_start_date = nm_start_date
                           and hxo_start_date = nm_start_date
                           and nvl(hxo_end_date, to_date('31-dec-2090'))   = nvl( nm_end_date, to_date('30-dec-2090')) );
begin                           
   for irec in c1 loop
     begin
       insert into herm_xsp (
         hxo_ne_id_of, hxo_nwx_x_sect, hxo_start_date, hxo_offset, hxo_end_date, hxo_xsp_offset,hxo_herm_dir_flag, hxo_xsp_descr )
       values
         (irec.nm_ne_id_of, irec.nwx_x_sect, irec.nm_start_date, irec.offset, irec.nm_end_date, irec.herm_x_sect, irec.nm_cardinality, irec.nwx_descr );
     exception
        when dup_val_on_index then
          update herm_xsp 
          set hxo_end_date = irec.nm_end_date
          where hxo_ne_id_of = irec.nm_ne_id_of
          and   hxo_nwx_x_sect = irec.nwx_x_sect
          and   hxo_start_date = irec.nm_start_date;
     end;
   end loop;
end;


begin
refresh_herm_xsp;
end;