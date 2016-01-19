drop view xodot_barr_by_ea_v;

create view xodot_barr_by_ea_v as

select 
       hwy
     , min (beg_mp_no) begin_mp
     , max (end_mp_no) end_mp
    , section_ea
    , iit_x_sect
    , highway_number
    , SUFFIX
    , ROADWAY_ID
    , MILEAGE_TYPE
    , OVERLAP_MILEAGE_CODE
    , ROAD_DIRECTION
    , ROAD_TYPE
    , PRIMARY_KEY
    , SECTION_CREW
    , DISTRICT
    , REGION
    , BARR_TYP, CONC_CNSTRC_TYP, CONC_CON_DESC,RAIL_POST_SPACING_TYP, RAIL_POST_TYP, BARR_HT_CD, BARR_COND_CD, BEG_TRMNL_TYP, BEG_TRMNL_HT_CD, BEG_TRMNL_COND_CD, SHR_BEG_TRMNL_FLG, END_TRMNL_TYP, END_TRMNL_HT_CD, END_TRMNL_COND_CD, SHR_END_TRMNL_FLG, BARR_DESC
, INV_COMNT
, NOTE
, BARR_LAST_INV_DT

              
	       from (
   select 
        hwy
      , beg_mp_no
      , end_mp_no
      , section_ea
      , iit_x_sect
      , highway_number
      , SUFFIX
      , ROADWAY_ID
      , MILEAGE_TYPE
      , OVERLAP_MILEAGE_CODE
      , ROAD_DIRECTION
      , ROAD_TYPE
      , PRIMARY_KEY
      , SECTION_CREW
      , DISTRICT
      , REGION
      , BARR_TYP, CONC_CNSTRC_TYP, CONC_CON_DESC,RAIL_POST_SPACING_TYP, RAIL_POST_TYP, BARR_HT_CD, BARR_COND_CD, BEG_TRMNL_TYP, BEG_TRMNL_HT_CD, BEG_TRMNL_COND_CD, SHR_BEG_TRMNL_FLG, END_TRMNL_TYP, END_TRMNL_HT_CD, END_TRMNL_COND_CD, SHR_END_TRMNL_FLG, BARR_DESC
, INV_COMNT
, NOTE
, BARR_LAST_INV_DT

      
            
      
      , sum (span_group) over (partition by hwy
                                     order by beg_mp_no
                               ) span_grps
    from (
          select 
             hwy
             , beg_mp_no
             , end_mp_no
              , section_ea
              , iit_x_sect
              , highway_number
              , SUFFIX
              , ROADWAY_ID
              , MILEAGE_TYPE
              , OVERLAP_MILEAGE_CODE
              , ROAD_DIRECTION
              , ROAD_TYPE
              , PRIMARY_KEY
              , SECTION_CREW
              , DISTRICT
              , REGION
            , BARR_TYP, CONC_CNSTRC_TYP, CONC_CON_DESC,RAIL_POST_SPACING_TYP, RAIL_POST_TYP, BARR_HT_CD, BARR_COND_CD, BEG_TRMNL_TYP, BEG_TRMNL_HT_CD, BEG_TRMNL_COND_CD, SHR_BEG_TRMNL_FLG, END_TRMNL_TYP, END_TRMNL_HT_CD, END_TRMNL_COND_CD, SHR_END_TRMNL_FLG, BARR_DESC
, INV_COMNT
, NOTE
, BARR_LAST_INV_DT 




              
             , case
                when beg_mp_no -
                   lag (end_mp_no) over (partition by hwy
                                              order by beg_mp_no
                                        ) = 0
                then 0
                else 1
                end span_group
          from xodot_barr_ea
          ---  for testing
  	  ---- where primary_key in (1442645,1440783) 

          )
    )
 group by hwy, section_ea, iit_x_sect, highway_number, SUFFIX
, ROADWAY_ID
, MILEAGE_TYPE
, OVERLAP_MILEAGE_CODE, ROAD_DIRECTION
, ROAD_TYPE
, PRIMARY_KEY, SECTION_CREW
, DISTRICT
, REGION
, BARR_TYP, CONC_CNSTRC_TYP, CONC_CON_DESC,RAIL_POST_SPACING_TYP, RAIL_POST_TYP, BARR_HT_CD, BARR_COND_CD, BEG_TRMNL_TYP, BEG_TRMNL_HT_CD, BEG_TRMNL_COND_CD, SHR_BEG_TRMNL_FLG, END_TRMNL_TYP, END_TRMNL_HT_CD, END_TRMNL_COND_CD, SHR_END_TRMNL_FLG, BARR_DESC
, INV_COMNT
, NOTE
, BARR_LAST_INV_DT  

 order by begin_mp, end_mp
;