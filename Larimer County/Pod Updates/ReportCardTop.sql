Select 
"Scored Area"
,"Condition Index"
,"Condition Grade"
,"Accident Rate"
,"Accident Grade"
,"Length in Miles"
from (
--
select 
SCORED_AREA"Scored Area"
,CONDITION_INDEX"Condition Index"
,CONDITION_GRADE "Condition Grade"
,ACC_RATE "Accident Rate"
,ACC_GRADE "Accident Grade"
,LENGTH_IN_MILES "Length in Miles"
, 0 as sorter
from LARIMER_COUNTY.xlar_county_scores_gaz
--
UNION
--
select 
null "Scored Area"
, null "Condition Index"
, null "Condition Grade"
, null "Accident Rate"
, null "Accident Grade"
, null "Length in Miles" 
, 1 as sorter from dual
--
UNION
--
select 
'<a href="javascript:doDrillDown(''IM90231a'')">Select Route</a>' "Scored Area"
, null "Condition Index"
, null "Condition Grade"
, null "Accident Rate"
, null "Accident Grade"
, null "Length in Miles" 
, 2 as sorter from dual
) order by sorter