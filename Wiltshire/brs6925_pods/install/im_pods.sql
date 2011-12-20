SET DEFINE OFF;
Insert into IM_PODS
   (IP_ID, IP_HMO_MODULE, IP_TITLE, IP_DESCR, IP_DRILL_DOWN, IP_TYPE, IP_GROUP, IP_CACHE_TIME)
 Values
   (242, 'XWILTS001', 'Contract name and Financial year', 'List of Active Contracts by Financial Year', 
    'Y', 'Table', 'Wiltshire Bespoke', 0);
Insert into IM_PODS
   (IP_ID, IP_HMO_MODULE, IP_TITLE, IP_DESCR, IP_PARENT_POD_ID, IP_DRILL_DOWN, IP_TYPE, IP_GROUP, IP_CACHE_TIME)
 Values
   (248, 'XWILTS001A', 'Work Order Listing: &P6_PARAM3.', 'List of Work Orders for the selected Contract.  On selecting the WO No, it will drill down to the Expenditure by Month Bar Chart.  On selecting the BOQ Items link under Breakdown, it will drill down to the Staff Grade Breakdown Pie Chart.', 'XWILTS001', 
    'Y', 'Interactive', 'Wiltshire Bespoke', 0);
Insert into IM_PODS
   (IP_ID, IP_HMO_MODULE, IP_TITLE, IP_DESCR, IP_PARENT_POD_ID, IP_DRILL_DOWN, IP_TYPE, IP_GROUP, IP_FOOTER, IP_CACHE_TIME)
 Values
   (249, 'XWILTS001B', 'WO &P6_PARAM1. Expenditure by Month', 'This is a bar chart of the Total Expenditure by Month for the selected Works Order', 'XWILTS001A', 
    'N', 'Chart', 'Wiltshire Bespoke', 'Total Spent &#163; &P6_PARAM2. Percentage Spent &P6_PARAM3.%', 0);
Insert into IM_PODS
   (IP_ID, IP_HMO_MODULE, IP_TITLE, IP_DESCR, IP_PARENT_POD_ID, IP_DRILL_DOWN, IP_TYPE, IP_GROUP, IP_CACHE_TIME)
 Values
   (253, 'XWILTS001B2', 'WO &P6_PARAM1. Staff Grade Breakdown', 'This is a pie chart of the percentage of spend to date, for each BOQ item (grouped)', 'XWILTS001A', 
    'N', 'Chart', 'Wiltshire Bespoke', 0);
Insert into IM_PODS
   (IP_ID, IP_HMO_MODULE, IP_TITLE, IP_DESCR, IP_DRILL_DOWN, IP_TYPE, IP_GROUP, IP_CACHE_TIME)
 Values
   (254, 'XWILTS002', 'Contractor name and Financial year', 'List of Active Contractors by Financial Year', 
    'Y', 'Table', 'Wiltshire Bespoke', 0);
Insert into IM_PODS
   (IP_ID, IP_HMO_MODULE, IP_TITLE, IP_DESCR, IP_PARENT_POD_ID, IP_DRILL_DOWN, IP_TYPE, IP_GROUP, IP_CACHE_TIME)
 Values
   (255, 'XWILTS002A', 'Work Order Listing: &P6_PARAM3.', 'List of Work Orders for the selected Contractor.  On selecting the Expenditure, it will drill down to the Expenditure by Month Bar Chart. ', 'XWILTS002', 
    'Y', 'Table', 'Wiltshire Bespoke', 0);
Insert into IM_PODS
   (IP_ID, IP_HMO_MODULE, IP_TITLE, IP_DESCR, IP_PARENT_POD_ID, IP_DRILL_DOWN, IP_TYPE, IP_GROUP, IP_FOOTER, IP_CACHE_TIME)
 Values
   (256, 'XWILTS002B', 'Contractor &P6_PARAM1. Expenditure by Month', 'This is a bar chart of the Total Expenditure by Month for the selected Contractor', 'XWILTS002A', 
    'N', 'Chart', 'Wiltshire Bespoke', 'Total Spent &#163;&P6_PARAM2. Percentage Spent &P6_PARAM3.%', 0);
Insert into IM_PODS
   (IP_ID, IP_HMO_MODULE, IP_TITLE, IP_DESCR, IP_PARENT_POD_ID, IP_DRILL_DOWN, IP_TYPE, IP_GROUP, IP_CACHE_TIME)
 Values
   (257, 'XWILTS002B2', 'Contractor &P6_PARAM1. Staff Grade Breakdown', 'This is a pie chart of the percentage of spend to date, for each BOQ item (grouped)', 'XWILTS002A', 
    'N', 'Chart', 'Wiltshire Bespoke', 0);
Insert into IM_PODS
   (IP_ID, IP_HMO_MODULE, IP_TITLE, IP_DESCR, IP_PARENT_POD_ID, IP_DRILL_DOWN, IP_TYPE, IP_GROUP, IP_FOOTER, IP_CACHE_TIME)
 Values
   (258, 'XWILTS002B3', 'Scheme Type &P6_PARAM4. &P6_PARAM5. Expenditure by Month', 'This is a bar chart of the Total Expenditure by Month for the selected Contractor and Scheme Type', 'XWILTS002A', 
    'N', 'Chart', 'Wiltshire Bespoke', 'Total Spent &#163;&P6_PARAM2. Percentage Spent &P6_PARAM3.%', 0);
Insert into IM_PODS
   (IP_ID, IP_HMO_MODULE, IP_TITLE, IP_DESCR, IP_PARENT_POD_ID, IP_DRILL_DOWN, IP_TYPE, IP_GROUP, IP_CACHE_TIME)
 Values
   (259, 'XWILTS002B4', 'Scheme Type &P6_PARAM3. &P6_PARAM4. Staff Grade Breakdown', 'This is a pie chart of the percentage of spend to date, for each BOQ item (grouped), for the selected Contractor and Scheme Type', 'XWILTS002A', 
    'N', 'Chart', 'Wiltshire Bespoke', 0);
Insert into IM_PODS
   (IP_ID, IP_HMO_MODULE, IP_TITLE, IP_DESCR, IP_DRILL_DOWN, IP_TYPE, IP_GROUP, IP_CACHE_TIME)
 Values
   (260, 'XWILTSDISCO', 'Discoverer Reports', 'This is a list of current Discoverer Reports', 
    'N', 'Table', 'Wiltshire Bespoke', 0);
Insert into IM_PODS
   (IP_ID, IP_HMO_MODULE, IP_TITLE, IP_DESCR, IP_PARENT_POD_ID, IP_DRILL_DOWN, IP_TYPE, IP_GROUP, IP_CACHE_TIME)
 Values
   (261, 'XWILTS002B5', 'MJR Project Monitoring for Work Order: &P6_PARAM1.', 'This POD shows the costing breakdown for the selected Work Order ', 'XWILTS002A', 
    'N', 'Table', 'Wiltshire Bespoke', 0);
Insert into IM_PODS
   (IP_ID, IP_HMO_MODULE, IP_TITLE, IP_DESCR, IP_PARENT_POD_ID, IP_DRILL_DOWN, IP_TYPE, IP_GROUP, IP_CACHE_TIME)
 Values
   (262, 'XWILTS002B6', 'Cumulative Actual for &P6_PARAM1.', 'This is a line char, displaying the Cumulative Actual for &P6_PARAM1.', 'XWILTS002A', 
    'N', 'Chart', 'Wiltshire Bespoke', 0);
COMMIT;
