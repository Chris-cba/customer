Select
--NE_ID,
Ne_Unique "Road",
Avg_Pvin_Cond "Condition",
Condition_Grade "Condition Grade",
Acc_Rate "Accident Rate",
Acc_Count "Accident Count",
Accident_Grade "Accident Grade",
Surf_Type "Surface Type",
Average_Road_Width "Surface Width",
--Ne_Length_Ft "Length In Feet",
Ne_Length_Miles "Length In Miles",
Adt_Adj "Average Daily Traffic Count",
Count_Year "Count Year",
Capacity_Ratio  "Capacity Ratio",
Capacity_Grade "Capacity Grade",
Condition "Condition",
Capacity  "Capacity",
Safety "Safety"
from xlar_im_report_card_Decode1
where ne_id = :P6_PARAM1
