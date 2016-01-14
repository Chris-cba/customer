select 
--ne_id
ne_unique Route
,ne_descr Description
--,ne_no_start
--,ne_no_end
--,ne_nt_type 
--,ne_type
--
,'<a href="javascript:doDrillDown(''IM90232'','''  || ne_id || ''',''' || null || ''',''' || null  || ''');"><img width=24 height=24 src="'||(select imagedir || filename from xim_icons where item = 'SREPORT')||'" alt="Report Card"></a>' "Report Card"  --sample_report.gif
,'<a href="javascript:doDrillDown(''IM90233'','''  || ne_id || ''',''' || null || ''',''' || null  || ''');"><img width=24 height=24 src="'||(select imagedir || filename from xim_icons where item = 'AMBULANCE')||'" alt="Accident Summary"></a>'  "Accident Summary" -- ambulance-24x24x8b.png
,'<a href="javascript:doDrillDown(''IM90234'','''  || ne_id || ''',''' || null || ''',''' || null  || ''');"><img width=24 height=24 src="'||(select imagedir || filename from xim_icons where item = 'CALC')||'" alt="Traffic Count"></a>' "Traffic Count" --calculator_go.png
--
, decode(im_framework.has_doc(ne_id,'ROAD_SEGMENTS_ALL'),0,
'<img width=24 height=24 src="'||(select imagedir || filename from xim_icons where item = 'MFCLOSED')||'" alt="No Documents">'
,'<a href="javascript:showDocAssocsWT('||ne_id||',&APP_ID.,&APP_SESSION.,''ROAD_SEGMENTS_ALL'')" ><img width=24 height=24 src="'||(select imagedir || filename from xim_icons where item = 'MFOPEN')||'" alt="Show Documents"></a>') DOCS
,decode(road_network_sdo_id,null,
'<img width=24 height=24 src="'||(select imagedir || filename from xim_icons where item = 'GG')||'" alt="No Location">'
,'<a href="javascript:showLarimerNetonMap('''||ne_unique||''');" ><img width=24 height=24 src="'||(select imagedir || filename from xim_icons where item = 'G64')||'" alt="Find on Map"></a>') map
from nm_elements, road_network_sdo_table
where ne_id = road_network_sdo_id(+)
and ne_type='S'
and ne_group= :P6_PARAM1
order by ne_unique