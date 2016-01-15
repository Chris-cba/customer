delete from  im_pod_sql where IPS_IP_ID = 333;

COMMIT;

SET DEFINE OFF;
MERGE INTO HIGHWAYS.IM_POD_SQL A USING
 (SELECT
  249 as IPS_ID,
  333 as IPS_IP_ID,
  10 as IPS_SEQ,
  'Select Link, item, cnt from (
--
 Select 0 Sorter,
         ''javascript:doDrillDown( ''''IM41041'''', ''''''||b.c||'''''', ''''N/A'''');'' as link
         , b.c item
         ,nvl(cnt,0) cnt
         from
         (
         select "WO EXTENSION OF TIME STATUS" eot
         ,count("WO EXTENSION OF TIME STATUS") cnt
         from c_pod_eot_updated
         group by "WO EXTENSION OF TIME STATUS"
         order by "WO EXTENSION OF TIME STATUS"
         ) a,
         (Select ''Conditional'' c from dual union Select ''Rejected'' c from dual union Select ''Approved'' c from dual) b
         where 1=1
         and eot(+) = b.c
--
UNION
--EOP
Select  1 sorter, ''javascript:doDrillDown( ''''IM41041a'''', ''''''||eop||'''''', ''''EOP'''');'' as link, EOP item, cnt
From (
--
         Select  ''EOP'' EOP, count("REQUESTS") cnt
         from( select * from c_pod_eoP_updated)         
         group by "REQUESTS" 
         union
         select ''EOP''  EOP, 0 count from dual where not exists (select 1 from c_pod_eop_updated)
         ) sq
--
UNION         
--EOP, NO bud
Select  2 sorter, ''javascript:doDrillDown( ''''IM41041b'''', ''''''||eop||'''''', ''''TOR'''');'' as link, EOP item, cnt
From (
--
         Select  ''TOR'' EOP, count("REQUESTS") cnt
         from( select * from c_pod_eoP_updated_nobud)         
         group by "REQUESTS" 
         union
         select ''TOR''  EOP, 0 count from dual where not exists (select 1 from c_pod_eop_updated_nobud)
         ) sq
 --
) order by sorter' as IPS_SOURCE_CODE,
  'Everything' as IPS_NAME,
  'Bar' as IPS_TYPE,
  'Box' as IPS_SHAPE_TYPE,
  NULL as IPS_NE_ID_COLUMN
  FROM DUAL) B
ON (A.IPS_ID = B.IPS_ID)
WHEN NOT MATCHED THEN 
INSERT (
  IPS_ID, IPS_IP_ID, IPS_SEQ, IPS_SOURCE_CODE, IPS_NAME, 
  IPS_TYPE, IPS_SHAPE_TYPE, IPS_NE_ID_COLUMN)
VALUES (
  B.IPS_ID, B.IPS_IP_ID, B.IPS_SEQ, B.IPS_SOURCE_CODE, B.IPS_NAME, 
  B.IPS_TYPE, B.IPS_SHAPE_TYPE, B.IPS_NE_ID_COLUMN)
WHEN MATCHED THEN
UPDATE SET 
  A.IPS_IP_ID = B.IPS_IP_ID,
  A.IPS_SEQ = B.IPS_SEQ,
  A.IPS_SOURCE_CODE = B.IPS_SOURCE_CODE,
  A.IPS_NAME = B.IPS_NAME,
  A.IPS_TYPE = B.IPS_TYPE,
  A.IPS_SHAPE_TYPE = B.IPS_SHAPE_TYPE,
  A.IPS_NE_ID_COLUMN = B.IPS_NE_ID_COLUMN;

COMMIT;

SET DEFINE OFF;
MERGE INTO HIGHWAYS.IM_POD_CHART_COLOURS A USING
 (SELECT
  333 as IPCC_IP_ID,
  249 as IPCC_IPS_ID,
  10 as IPCC_IPS_SEQ,
  '#009999:#6666ff:#66ccff:#99cc33:#cc3300:#990099' as IPCC_COLOUR
  FROM DUAL) B
ON (A.IPCC_IP_ID = B.IPCC_IP_ID and A.IPCC_IPS_ID = B.IPCC_IPS_ID and A.IPCC_IPS_SEQ = B.IPCC_IPS_SEQ)
WHEN NOT MATCHED THEN 
INSERT (
  IPCC_IP_ID, IPCC_IPS_ID, IPCC_IPS_SEQ, IPCC_COLOUR)
VALUES (
  B.IPCC_IP_ID, B.IPCC_IPS_ID, B.IPCC_IPS_SEQ, B.IPCC_COLOUR)
WHEN MATCHED THEN
UPDATE SET 
  A.IPCC_COLOUR = B.IPCC_COLOUR;

COMMIT;

SET DEFINE OFF;
MERGE INTO HIGHWAYS.IM_POD_CHART A USING
 (SELECT
  333 as IP_ID,
  'CategorizedVertical' as CHART_TYPE,
  NULL as CHART_TITLE,
  '99%' as CHART_WIDTH,
  '300' as CHART_HEIGHT,
  'Appear' as CHART_ANIMATION,
  'None' as MARKER_TYPE,
  'Y::Y::Y:Y::::::V:T:N:B:' as DISPLAY_ATTR,
  NULL as DIAL_TICK_ATTR,
  ':::' as MARGINS,
  NULL as OMIT_LABEL_INTERVAL,
  NULL as COLOR_SCHEME,
  'Y:Y:Y:Y' as CUSTOM_COLORS,
  'T' as BGTYPE,
  NULL as BGCOLOR1,
  NULL as BGCOLOR2,
  NULL as GRADIENT_ROTATION,
  NULL as X_AXIS_TITLE,
  NULL as X_AXIS_MIN,
  NULL as X_AXIS_MAX,
  NULL as X_AXIS_GRID_SPACING,
  NULL as X_AXIS_PREFIX,
  NULL as X_AXIS_POSTFIX,
  'Y' as X_AXIS_GROUP_SEP,
  NULL as X_AXIS_DECIMAL_PLACE,
  NULL as Y_AXIS_TITLE,
  NULL as Y_AXIS_MIN,
  NULL as Y_AXIS_MAX,
  NULL as Y_AXIS_GRID_SPACING,
  NULL as Y_AXIS_PREFIX,
  NULL as Y_AXIS_POSTFIX,
  'Y' as Y_AXIS_GROUP_SEP,
  NULL as Y_AXIS_DECIMAL_PLACE,
  NULL as ASYNC_UPDATE,
  NULL as ASYNC_TIME,
  'Arial:10:#000033' as NAMES_FONT,
  90 as NAMES_ROTATION,
  'Arial:10:#000000' as VALUES_FONT,
  0 as VALUES_ROTATION,
  'Arial:10:' as HINTS_FONT,
  'Arial:10:#000000' as LEGEND_FONT,
  NULL as GRID_LABELS_FONT,
  'Arial:15:' as CHART_TITLE_FONT,
  'Arial:10:#000000' as X_AXIS_TITLE_FONT,
  'Arial:10:#00v0000' as Y_AXIS_TITLE_FONT,
  'N' as SHOW_LEGEND,
  NULL as LEGEND_TITLE,
  'V' as LEGEND_LAYOUT,
  'Normal' as CMODE,
  'True' as ENABLE_3D
  FROM DUAL) B
ON (A.IP_ID = B.IP_ID)
WHEN NOT MATCHED THEN 
INSERT (
  IP_ID, CHART_TYPE, CHART_TITLE, CHART_WIDTH, CHART_HEIGHT, 
  CHART_ANIMATION, MARKER_TYPE, DISPLAY_ATTR, DIAL_TICK_ATTR, MARGINS, 
  OMIT_LABEL_INTERVAL, COLOR_SCHEME, CUSTOM_COLORS, BGTYPE, BGCOLOR1, 
  BGCOLOR2, GRADIENT_ROTATION, X_AXIS_TITLE, X_AXIS_MIN, X_AXIS_MAX, 
  X_AXIS_GRID_SPACING, X_AXIS_PREFIX, X_AXIS_POSTFIX, X_AXIS_GROUP_SEP, X_AXIS_DECIMAL_PLACE, 
  Y_AXIS_TITLE, Y_AXIS_MIN, Y_AXIS_MAX, Y_AXIS_GRID_SPACING, Y_AXIS_PREFIX, 
  Y_AXIS_POSTFIX, Y_AXIS_GROUP_SEP, Y_AXIS_DECIMAL_PLACE, ASYNC_UPDATE, ASYNC_TIME, 
  NAMES_FONT, NAMES_ROTATION, VALUES_FONT, VALUES_ROTATION, HINTS_FONT, 
  LEGEND_FONT, GRID_LABELS_FONT, CHART_TITLE_FONT, X_AXIS_TITLE_FONT, Y_AXIS_TITLE_FONT, 
  SHOW_LEGEND, LEGEND_TITLE, LEGEND_LAYOUT, CMODE, ENABLE_3D)
VALUES (
  B.IP_ID, B.CHART_TYPE, B.CHART_TITLE, B.CHART_WIDTH, B.CHART_HEIGHT, 
  B.CHART_ANIMATION, B.MARKER_TYPE, B.DISPLAY_ATTR, B.DIAL_TICK_ATTR, B.MARGINS, 
  B.OMIT_LABEL_INTERVAL, B.COLOR_SCHEME, B.CUSTOM_COLORS, B.BGTYPE, B.BGCOLOR1, 
  B.BGCOLOR2, B.GRADIENT_ROTATION, B.X_AXIS_TITLE, B.X_AXIS_MIN, B.X_AXIS_MAX, 
  B.X_AXIS_GRID_SPACING, B.X_AXIS_PREFIX, B.X_AXIS_POSTFIX, B.X_AXIS_GROUP_SEP, B.X_AXIS_DECIMAL_PLACE, 
  B.Y_AXIS_TITLE, B.Y_AXIS_MIN, B.Y_AXIS_MAX, B.Y_AXIS_GRID_SPACING, B.Y_AXIS_PREFIX, 
  B.Y_AXIS_POSTFIX, B.Y_AXIS_GROUP_SEP, B.Y_AXIS_DECIMAL_PLACE, B.ASYNC_UPDATE, B.ASYNC_TIME, 
  B.NAMES_FONT, B.NAMES_ROTATION, B.VALUES_FONT, B.VALUES_ROTATION, B.HINTS_FONT, 
  B.LEGEND_FONT, B.GRID_LABELS_FONT, B.CHART_TITLE_FONT, B.X_AXIS_TITLE_FONT, B.Y_AXIS_TITLE_FONT, 
  B.SHOW_LEGEND, B.LEGEND_TITLE, B.LEGEND_LAYOUT, B.CMODE, B.ENABLE_3D)
WHEN MATCHED THEN
UPDATE SET 
  A.CHART_TYPE = B.CHART_TYPE,
  A.CHART_TITLE = B.CHART_TITLE,
  A.CHART_WIDTH = B.CHART_WIDTH,
  A.CHART_HEIGHT = B.CHART_HEIGHT,
  A.CHART_ANIMATION = B.CHART_ANIMATION,
  A.MARKER_TYPE = B.MARKER_TYPE,
  A.DISPLAY_ATTR = B.DISPLAY_ATTR,
  A.DIAL_TICK_ATTR = B.DIAL_TICK_ATTR,
  A.MARGINS = B.MARGINS,
  A.OMIT_LABEL_INTERVAL = B.OMIT_LABEL_INTERVAL,
  A.COLOR_SCHEME = B.COLOR_SCHEME,
  A.CUSTOM_COLORS = B.CUSTOM_COLORS,
  A.BGTYPE = B.BGTYPE,
  A.BGCOLOR1 = B.BGCOLOR1,
  A.BGCOLOR2 = B.BGCOLOR2,
  A.GRADIENT_ROTATION = B.GRADIENT_ROTATION,
  A.X_AXIS_TITLE = B.X_AXIS_TITLE,
  A.X_AXIS_MIN = B.X_AXIS_MIN,
  A.X_AXIS_MAX = B.X_AXIS_MAX,
  A.X_AXIS_GRID_SPACING = B.X_AXIS_GRID_SPACING,
  A.X_AXIS_PREFIX = B.X_AXIS_PREFIX,
  A.X_AXIS_POSTFIX = B.X_AXIS_POSTFIX,
  A.X_AXIS_GROUP_SEP = B.X_AXIS_GROUP_SEP,
  A.X_AXIS_DECIMAL_PLACE = B.X_AXIS_DECIMAL_PLACE,
  A.Y_AXIS_TITLE = B.Y_AXIS_TITLE,
  A.Y_AXIS_MIN = B.Y_AXIS_MIN,
  A.Y_AXIS_MAX = B.Y_AXIS_MAX,
  A.Y_AXIS_GRID_SPACING = B.Y_AXIS_GRID_SPACING,
  A.Y_AXIS_PREFIX = B.Y_AXIS_PREFIX,
  A.Y_AXIS_POSTFIX = B.Y_AXIS_POSTFIX,
  A.Y_AXIS_GROUP_SEP = B.Y_AXIS_GROUP_SEP,
  A.Y_AXIS_DECIMAL_PLACE = B.Y_AXIS_DECIMAL_PLACE,
  A.ASYNC_UPDATE = B.ASYNC_UPDATE,
  A.ASYNC_TIME = B.ASYNC_TIME,
  A.NAMES_FONT = B.NAMES_FONT,
  A.NAMES_ROTATION = B.NAMES_ROTATION,
  A.VALUES_FONT = B.VALUES_FONT,
  A.VALUES_ROTATION = B.VALUES_ROTATION,
  A.HINTS_FONT = B.HINTS_FONT,
  A.LEGEND_FONT = B.LEGEND_FONT,
  A.GRID_LABELS_FONT = B.GRID_LABELS_FONT,
  A.CHART_TITLE_FONT = B.CHART_TITLE_FONT,
  A.X_AXIS_TITLE_FONT = B.X_AXIS_TITLE_FONT,
  A.Y_AXIS_TITLE_FONT = B.Y_AXIS_TITLE_FONT,
  A.SHOW_LEGEND = B.SHOW_LEGEND,
  A.LEGEND_TITLE = B.LEGEND_TITLE,
  A.LEGEND_LAYOUT = B.LEGEND_LAYOUT,
  A.CMODE = B.CMODE,
  A.ENABLE_3D = B.ENABLE_3D;

COMMIT;
