-- BACK UP STYLES 
create table user_sdo_STYLES_bkup_41_ah as select * from user_sdo_themes;

COMMENT ON TABLE user_sdo_STYLES_bkup_41_ah IS 
   'This is a backup up of user_sdo_styles before running script TFL_post_4_1.sql.';
 
-- redefine all the necessary themes
@X_RESTRICT_PROPORINFORCE_SDOPT.VW
@X_S50_LICENCES_SD0PT.vw
@X_S66_NOTICES_SD0PT.vw
@X_V_TMA_INSPECTIONS_SDOPT.vw
@X_V_TMA_WORKS_POINT.vw
@X_WORKS_BY_NOTICING_AUTH_SDOPT.vw
@X_WORKS_BY_STREET_GROUP_SDOPT.vw

-- drop bespoke point themes
delete 
   from user_sdo_themes 
  where base_table in ('X_V_TMA_PHASES_POINTS', 'X_V_TMA_SITES_POINTS', 'X_V_TMA_RESTRICTIONS_POINTS');

begin  
   for rec in (select nth_theme_id from nm_themes_all where nth_feature_table in 
               ('X_V_TMA_PHASES_POINTS', 'X_V_TMA_SITES_POINTS', 'X_V_TMA_RESTRICTIONS_POINTS'))
   loop
      begin
         nm3sde.DROP_LAYER(rec.nth_theme_id);
      exception
         when others then
           null;
      end;
              
      delete from nm_themes_all where nth_theme_id = rec.nth_theme_id;
   end loop;          
end;
/

DELETE FROM USER_SDO_GEOM_METADATA 
WHERE COLUMN_NAME IN ( 'SWM.X_TFL_GET_TMA_MID_POINT(TPHS_GEOMETRY)',
                       'SWM.X_TFL_GET_TMA_MID_POINT(TRES_GEOMETRY)',
                       'SWM.X_TFL_GET_TMA_MID_POINT(TSIT_GEOMETRY)' );

DROP VIEW X_V_TMA_SITES_POINTS;

DROP VIEW X_V_TMA_RESTRICTIONS_POINTS;

DROP VIEW X_V_TMA_PHASES_POINTS;

DROP PUBLIC SYNONYM X_V_TMA_PHASES_POINTS;

DROP PUBLIC SYNONYM X_V_TMA_SITES_POINTS;

DROP PUBLIC SYNONYM X_V_TMA_RESTRICTIONS_POINTS;

DELETE 
 FROM USER_SDO_GEOM_METADATA 
WHERE TABLE_NAME IN ('X_V_TMA_PHASES_POINTS', 
                     'X_V_TMA_RESTRICTIONS_POINTS',
                     'X_V_TMA_SITES_POINTS' );

-- drop function
DROP FUNCTION X_TFL_GET_TMA_MID_POINT;

drop INDEX X_TFL_TMA_PHASES_FINX;

drop INDEX X_TFL_TMA_RESTRICTIONS_FINX;

drop INDEX X_TFL_TMA_SITES_FINX;

UPDATE NM_THEMES_ALL 
   SET NTH_THEME_NAME = 'TMA REGISTERED WORKS POINT' 
 WHERE NTH_FEATURE_TABLE = 'V_TMA_SITES_PT_SDO';

COMMIT;

-- DO STYLES AND THEMES --

-- REGISTERED WORKS
INSERT INTO USER_SDO_THEMES 
   SELECT 'TMA REGISTERED WORKS OLD', DESCRIPTION, BASE_TABLE, GEOMETRY_COLUMN, STYLING_RULES 
     FROM USER_SDO_THEMES 
    WHERE NAME = 'TMA REGISTERED WORKS';
    
DELETE FROM USER_SDO_THEMES 
    WHERE NAME = 'TMA REGISTERED WORKS';
 
DELETE FROM USER_SDO_STYLES WHERE NAME = 'M.TFL.TMA REGISTERED WORKS';

Insert into USER_SDO_STYLES
   (NAME, TYPE, DEFINITION)
 Values
   ('M.TFL.TMA REGISTERED WORKS', 'MARKER', 
   '<?xml version="1.0" standalone="yes"?> <svg width="1in" height="1in"> <desc></desc> ' ||
   '<g class="marker" style="stroke:#00CC00;fill:#66FF66;width:5;height:5;font-family:Dialog;font-size:12;font-fill:#FF0000"> ' ||
   '<circle cx="0" cy="0" r="5.0" /> </g> </svg>');

DELETE FROM USER_SDO_STYLES WHERE NAME = 'C.TFL.TMA REGISTERED WORKS';

Insert into USER_SDO_STYLES
   (NAME, TYPE, DEFINITION)
 Values
   ('C.TFL.TMA REGISTERED WORKS', 'COLOR', 
    '<?xml version="1.0" standalone="yes"?> <svg width="1in" height="1in"> ' ||
    '<desc/> <g class="color" style="stroke:#66FF67;stroke-width:2.0;fill:#66FF67;fill-opacity:89"> ' ||
    '<rect width="50" height="50"/> </g> </svg>');

DELETE FROM USER_SDO_STYLES WHERE NAME = 'V.TFL.REGISTERED WORKS';

Insert into USER_SDO_STYLES
   (NAME, TYPE, DEFINITION)
 Values
   ('V.TFL.REGISTERED WORKS', 'ADVANCED', 
    '<?xml version="1.0" ?> <AdvancedStyle>  <CollectionStyle> ' ||
    '<style name="C.TFL.TMA REGISTERED WORKS" shape="polygon" /> ' ||
    '<style name="L.TFL.TMA REGISTERED WORKS" shape="line" /> ' ||
    '<style name="M.TFL.TMA REGISTERED WORKS" shape="point" /> ' ||
    '</CollectionStyle> </AdvancedStyle>');

Insert into USER_SDO_THEMES
   (NAME, BASE_TABLE, GEOMETRY_COLUMN, STYLING_RULES)
 Values
   ('TMA REGISTERED WORKS', 'V_TMA_SITES_SDO', 'TSIT_GEOMETRY', 
    '<?xml version="1.0" standalone="yes"?> ' ||
    '<styling_rules key_column="TSIT_ID" table_alias="A"> ' ||
    '<rule column="A.TSIT_GEOMETRY.SDO_GTYPE"> ' ||
    '<features style="V.TFL.REGISTERED WORKS"> </features> ' ||
    '</rule> </styling_rules>');
    
-- TMA ACTIVE WORKS - SHAPE
INSERT INTO USER_SDO_THEMES 
   SELECT 'TMA ACTIVE WORKS - SHAPE OLD', DESCRIPTION, BASE_TABLE, GEOMETRY_COLUMN, STYLING_RULES 
     FROM USER_SDO_THEMES 
    WHERE NAME = 'TMA ACTIVE WORKS - SHAPE';
    
DELETE from user_sdo_styles where name = 'M.TFL.TMA PHASES';

Insert into USER_SDO_STYLES
   (NAME, TYPE, DEFINITION)
 Values
   ('M.TFL.TMA PHASES', 'MARKER', 
    '<?xml version="1.0" standalone="yes"?> <svg width="1in" height="1in">  <desc></desc> ' ||
    '<g class="marker" style="stroke:#000000;fill:#FF0033;width:5;height:5;font-family:Dialog;font-size:12;font-fill:#FF0000"> ' ||
    '<circle cx="0" cy="0" r="5.0" /> </g> </svg>');

DELETE from user_sdo_styles where name = 'C.TFL.TMA PHASES';

Insert into USER_SDO_STYLES
   (NAME, TYPE, DEFINITION)
 Values
   ('C.TFL.TMA PHASES', 'COLOR', 
    '<?xml version="1.0" standalone="yes"?> ' ||
    '<svg width="1in" height="1in"> <desc/> ' ||
    '<g class="color" style="stroke:#FF3366;stroke-width:2.0;fill:#FF0033;fill-opacity:89"> ' ||
    '<rect width="50" height="50"/> </g> </svg>');

DELETE from user_sdo_styles where name = 'V.TFL.ACTIVE WORKS SHAPE';

Insert into USER_SDO_STYLES
   (NAME, TYPE, DEFINITION)
 Values
   ('V.TFL.ACTIVE WORKS SHAPE', 'ADVANCED', 
    '<?xml version="1.0" ?> <AdvancedStyle>  <CollectionStyle> ' ||
    '<style name="C.TFL.TMA PHASES" shape="polygon" /> ' ||
    '<style name="L.TFL.TMA PHASES" shape="line" /> ' ||
    '<style name="M.TFL.TMA PHASES" shape="point" /> ' ||
    '</CollectionStyle> </AdvancedStyle>' );

DELETE FROM USER_SDO_THEMES 
    WHERE NAME = 'TMA ACTIVE WORKS - SHAPE';

Insert into USER_SDO_THEMES
   (NAME, BASE_TABLE, GEOMETRY_COLUMN, STYLING_RULES)
 Values
   ('TMA ACTIVE WORKS - SHAPE', 'X_V_TMA_WORKS_SHAPE', 'TPHS_GEOMETRY', 
    '<?xml version="1.0" standalone="yes"?> ' ||
    '<styling_rules key_column="TPHS_PHASE_ID" table_alias="A"> ' ||
    '<rule column="A.TPHS_GEOMETRY.SDO_GTYPE"> ' ||
    '<features style="V.TFL.ACTIVE WORKS SHAPE"> </features> ' ||
    '</rule> </styling_rules>');

-- S50 SHAPE

DELETE FROM USER_SDO_STYLES WHERE NAME = 'C.TFL.S50';

Insert into USER_SDO_STYLES
   (NAME, TYPE, DEFINITION )
 Values
   ('C.TFL.S50', 'COLOR', 
    '<?xml version="1.0" standalone="yes"?> ' ||
    '<svg width="1in" height="1in"> <desc/> ' ||
    '<g class="color" style="stroke:#FF0033;stroke-width:2.0;fill:#FF0033;fill-opacity:89"> ' ||
    '<rect width="50" height="50"/> </g> </svg>');
    
DELETE FROM USER_SDO_STYLES WHERE NAME = 'M.TFL.S50 SHAPE';
    
Insert into USER_SDO_STYLES
   (NAME, TYPE, DEFINITION)
 Values
   ('M.TFL.S50 SHAPE', 'MARKER', 
    '<?xml version="1.0" standalone="yes"?> ' ||
    '<svg width="1in" height="1in"> <desc></desc> '||
    '<g class="marker" style="stroke:#000000;fill:#FF0033;width:5;height:5;font-family:Dialog;font-size:12;font-fill:#FF0000"> ' ||
    '<circle cx="0" cy="0" r="5.0" /> </g> </svg>');

DELETE FROM USER_SDO_STYLES WHERE NAME = 'V.TFL.S50';

Insert into USER_SDO_STYLES
   (NAME, TYPE, DEFINITION)
 Values
   ('V.TFL.S50', 'ADVANCED', 
    '<?xml version="1.0" ?> <AdvancedStyle> <CollectionStyle> ' ||
    '<style name="C.TFL.S50" shape="polygon" /> ' ||
    '<style name="L.TFL.S50" shape="line" /> ' ||
    '<style name="M.TFL.S50 SHAPE" shape="point" /> ' ||
    '</CollectionStyle> ' ||
    '</AdvancedStyle>');


INSERT INTO USER_SDO_THEMES
SELECT 'SECTION 50 LICENCES - SHAPE OLD', DESCRIPTION, BASE_TABLE, GEOMETRY_COLUMN, STYLING_RULES 
  FROM USER_SDO_THEMES WHERE NAME = 'SECTION 50 LICENCES - SHAPE';

delete FROM USER_SDO_THEMES WHERE NAME = 'SECTION 50 LICENCES - SHAPE';

Insert into USER_SDO_THEMES
   (NAME, BASE_TABLE, GEOMETRY_COLUMN, STYLING_RULES)
 Values
   ('SECTION 50 LICENCES - SHAPE', 'X_S50_LICENCES_SD0', 'TPHS_GEOMETRY', 
    '<?xml version="1.0" standalone="yes"?> ' ||
    '<styling_rules key_column="TPHS_ID" table_alias="A"> ' ||
    '<rule column="A.TPHS_GEOMETRY.SDO_GTYPE"> ' ||
    '<features style="V.TFL.S50"> </features> ' ||
    '</rule> </styling_rules>');

-- S66 NOTICES SHAPE
Insert into USER_SDO_STYLES
   (NAME, TYPE, DEFINITION)
 Values
   ('C.TFL.S66', 'COLOR', 
    '<?xml version="1.0" standalone="yes"?> ' ||
    '<svg width="1in" height="1in"> <desc/> ' ||
    '<g class="color" style="stroke:#33FF33;stroke-width:2.0;fill:#33FF33;fill-opacity:89"> ' ||
    '<rect width="50" height="50"/> </g> </svg>');

Insert into USER_SDO_STYLES
   (NAME, TYPE, DEFINITION)
 Values
   ('M.TFL.S66 SHAPE', 'MARKER', 
    '<?xml version="1.0" standalone="yes"?> ' ||
    '<svg width="1in" height="1in"> <desc></desc> ' ||
    '<g class="marker" style="stroke:#000000;fill:#33FF33;width:5;height:5;font-family:Dialog;font-size:12;font-fill:#FF0000"> ' ||
    '<circle cx="0" cy="0" r="5.0" /> </g> </svg>');

Insert into USER_SDO_STYLES
   (NAME, TYPE, DEFINITION)
 Values
   ('V.TFL.S66', 'ADVANCED', 
    '<?xml version="1.0" ?> <AdvancedStyle> <CollectionStyle> ' ||
    '<style name="C.TFL.S66" shape="polygon" /> ' ||
    '<style name="L.TFL.S66" shape="line" /> ' ||
    '<style name="M.TFL.S66 SHAPE" shape="point" /> ' ||
    '</CollectionStyle> </AdvancedStyle>');

SELECT * FROM USER_SDO_THEMES WHERE NAME = 'S66 NOTICES - SHAPE'

INSERT INTO USER_SDO_THEMES (NAME, BASE_TABLE, GEOMETRY_COLUMN, STYLING_RULES)
    SELECT 'S66 NOTICES - SHAPE OLD', BASE_TABLE, GEOMETRY_COLUMN, STYLING_RULES
      FROM USER_SDO_THEMES
     WHERE NAME = 'S66 NOTICES - SHAPE';
     
DELETE FROM USER_SDO_THEMES WHERE NAME = 'S66 NOTICES - SHAPE';
     
Insert into USER_SDO_THEMES
   (NAME, BASE_TABLE, GEOMETRY_COLUMN, STYLING_RULES)
 Values
   ('S66 NOTICES - SHAPE', 'X_S66_NOTICES_SD0', 'TPHS_GEOMETRY', 
    '<?xml version="1.0" standalone="yes"?> ' ||
    '<styling_rules key_column="TPHS_ID" table_alias="A"> ' ||
    '<rule column="A.TPHS_GEOMETRY.SDO_GTYPE"> ' ||
    '<features style="V.TFL.S66"> </features> ' ||
    '</rule> </styling_rules>');

-- WORKS BY AUTHORITY - SHAPE

delete from user_sdo_styles where name = 'C.TFL.WORKS_BY_AUTH_NOT_TFL_SHAP';

Insert into USER_SDO_STYLES
   (NAME, TYPE, DEFINITION)
 Values
   ('C.TFL.WORKS_BY_AUTH_NOT_TFL_SHAP', 'COLOR', 
    '<?xml version="1.0" standalone="yes"?> ' ||
    '<svg width="1in" height="1in"> <desc/> ' ||
    '<g class="color" style="stroke:#33CC67;stroke-width:2.0;fill:#33CC67;fill-opacity:89"> ' ||
    '<rect width="50" height="50"/> </g> </svg>');

delete from user_sdo_styles where name = 'C.TFL.WORKS_BY_AUTH_TFL_SHAPE';

Insert into USER_SDO_STYLES
   (NAME, TYPE, DEFINITION)
 Values
   ('C.TFL.WORKS_BY_AUTH_TFL_SHAPE', 'COLOR', 
    '<?xml version="1.0" standalone="yes"?> <svg width="1in" height="1in"> <desc/> ' ||
    '<g class="color" style="stroke:#FFCC33;stroke-width:2.0;fill:#FFCC33;fill-opacity:89"> ' ||
    '<rect width="50" height="50"/> </g> </svg>');

delete from user_sdo_styles where name = 'M.TFL.WORKS_BY_AUTH_NOT_TFL_SHAP';

Insert into USER_SDO_STYLES
   (NAME, TYPE, DEFINITION)
 Values
   ('M.TFL.WORKS_BY_AUTH_NOT_TFL_SHAP', 'MARKER', 
    '<?xml version="1.0" standalone="yes"?> <svg width="1in" height="1in"> <desc></desc> ' ||
    '<g class="marker" style="stroke:#00CC00;fill:#33CC00;width:5;height:5;font-family:Dialog;font-size:12;font-fill:#FF0000"> ' ||
    '<circle cx="0" cy="0" r="5.0" /> </g> </svg>');

delete from user_sdo_styles where name = 'M.TFL.WORKS_BY_AUTH_TFL_SHAPE';

Insert into USER_SDO_STYLES
   (NAME, TYPE, DEFINITION)
 Values
   ('M.TFL.WORKS_BY_AUTH_TFL_SHAPE', 'MARKER', 
    '<?xml version="1.0" standalone="yes"?> <svg width="1in" height="1in"> <desc></desc> ' ||
    '<g class="marker" style="stroke:#00CC00;fill:#FFCC33;width:5;height:5;font-family:Dialog;font-size:12;font-fill:#FF0000"> ' ||
    '<circle cx="0" cy="0" r="5.0" /> </g> </svg>' );

delete from user_sdo_styles where name = 'V.TFL.WORKS BY AUTHORITY LINE';

Insert into USER_SDO_STYLES
   (NAME, TYPE, DEFINITION )
 Values
   ('V.TFL.WORKS BY AUTHORITY LINE', 'ADVANCED', 
    '<?xml version="1.0" ?> <AdvancedStyle> <BucketStyle> <Buckets default_style="L.TFL.WORKS_BY_AUTHORITY_NOT_TFL"> ' ||
    '<CollectionBucket seq="0" label="TfL" keep_white_space="true" type="string" style="L.TFL.WORKS_BY_AUTHORITY_TFL">0020</CollectionBucket> ' ||
    '<CollectionBucket seq="1" label="Not TFL" keep_white_space="true" type="string" style="L.TFL.WORKS_BY_AUTHORITY_NOT_TFL">#DEFAULT#</CollectionBucket> ' ||
    '</Buckets> </BucketStyle> </AdvancedStyle> ');

delete from user_sdo_styles where name = 'V.TFL.WORKS BY AUTHORITY POINT';

Insert into USER_SDO_STYLES
   (NAME, TYPE, DEFINITION)
 Values
   ('V.TFL.WORKS BY AUTHORITY POINT', 'ADVANCED', 
    '<?xml version="1.0" ?> <AdvancedStyle> <BucketStyle> ' ||
    '<Buckets default_style="M.TFL.WORKS_BY_AUTH_NOT_TFL_SHAP"> ' ||
    '<CollectionBucket seq="0" label="TfL" keep_white_space="true" type="string" style="M.TFL.WORKS_BY_AUTH_TFL_SHAPE">0020</CollectionBucket> ' ||
    '<CollectionBucket seq="1" label="Not TFL" keep_white_space="true" type="string" style="M.TFL.WORKS_BY_AUTH_NOT_TFL_SHAP">#DEFAULT#</CollectionBucket> ' ||
    '</Buckets> </BucketStyle> </AdvancedStyle> ');

delete from user_sdo_styles where name = 'V.TFL.WORKS BY AUTHORITY POLY';

Insert into USER_SDO_STYLES
   (NAME, TYPE, DEFINITION)
 Values
   ('V.TFL.WORKS BY AUTHORITY POLY', 'ADVANCED', 
    '<?xml version="1.0" ?> <AdvancedStyle> <BucketStyle> <Buckets default_style="C.TFL.WORKS_BY_AUTH_NOT_TFL_SHAP"> ' ||
    '<CollectionBucket seq="0" label="TfL" keep_white_space="true" type="string" style="C.TFL.WORKS_BY_AUTH_TFL_SHAPE">0020</CollectionBucket> ' ||
    '<CollectionBucket seq="1" label="Not TFL" keep_white_space="true" type="string" style="C.TFL.WORKS_BY_AUTH_NOT_TFL_SHAP">#DEFAULT#</CollectionBucket> ' ||
    '</Buckets> </BucketStyle> </AdvancedStyle> ' );


INSERT INTO USER_SDO_THEMES (NAME, BASE_TABLE, GEOMETRY_COLUMN, STYLING_RULES)
   SELECT 'WORKS BY AUTHORITY - SHAPE OLD', BASE_TABLE, GEOMETRY_COLUMN, STYLING_RULES
     FROM USER_SDO_THEMES WHERE NAME = 'WORKS BY AUTHORITY - SHAPE';
        
DELETE FROM USER_SDO_THEMES WHERE NAME = 'WORKS BY AUTHORITY - SHAPE';

Insert into USER_SDO_THEMES
   (NAME, BASE_TABLE, GEOMETRY_COLUMN, STYLING_RULES)
 Values
   ('WORKS BY AUTHORITY - SHAPE', 'X_WORKS_BY_NOTICING_AUTH_SDO', 'TPHS_GEOMETRY', 
    '<?xml version="1.0" standalone="yes"?> ' ||
    '<styling_rules key_column="TPHS_ID" table_alias="A"> ' ||
    '<rule column="ORGANISATION_REFERENCE"> ' ||
    '<features style="V.TFL.WORKS BY AUTHORITY LINE"> A.TPHS_GEOMETRY.SDO_GTYPE = 2002 </features> </rule> ' ||
    '<rule column="ORGANISATION_REFERENCE"> ' ||
    '<features style="V.TFL.WORKS BY AUTHORITY POINT"> A.TPHS_GEOMETRY.SDO_GTYPE = 2001 </features> </rule> ' ||
    '<rule column="ORGANISATION_REFERENCE"> ' ||
    '<features style="V.TFL.WORKS BY AUTHORITY POLY"> A.TPHS_GEOMETRY.SDO_GTYPE = 2003 </features> </rule> ' ||
    '</styling_rules>');


-- S58 AND S58A NOTICES - SHAPE
DELETE FROM USER_SDO_STYLES WHERE NAME = 'C.TFL.RESTRICTIONS.IN FORCE';

Insert into USER_SDO_STYLES
   (NAME, TYPE, DEFINITION)
 Values
   ('C.TFL.RESTRICTIONS.IN FORCE', 'COLOR', 
    '<?xml version="1.0" standalone="yes"?> <svg width="1in" height="1in"> <desc/> ' ||
    '<g class="color" style="stroke:#000000;stroke-width:2.0;fill:#FF33FF;fill-opacity:89"> ' ||
    '<rect width="50" height="50"/> </g> </svg>');

DELETE FROM USER_SDO_STYLES WHERE NAME = 'C.TFL.RESTRICTIONS.PROPOSED';

Insert into USER_SDO_STYLES
   (NAME, TYPE, DEFINITION)
 Values
   ('C.TFL.RESTRICTIONS.PROPOSED', 'COLOR', 
    '<?xml version="1.0" standalone="yes"?> <svg width="1in" height="1in"> <desc/> ' ||
    '<g class="color" style="stroke:#333333;stroke-width:2.0;fill:#FFFF00;fill-opacity:89"> ' ||
    '<rect width="50" height="50"/> </g> </svg>');

DELETE FROM USER_SDO_STYLES WHERE NAME = 'M.TFL.RESTRICTIONS.IN FORCE.PT';

Insert into USER_SDO_STYLES
   (NAME, TYPE, DEFINITION)
 Values
   ('M.TFL.RESTRICTIONS.IN FORCE.PT', 'MARKER', 
    '<?xml version="1.0" standalone="yes"?> <svg width="1in" height="1in"> <desc></desc> ' ||
    '<g class="marker" style="stroke:#000000;fill:#FF33FF;width:5;height:5;font-family:Dialog;font-size:12;font-fill:#FF0000"> ' ||
    '<circle cx="0" cy="0" r="5.0" /> </g> </svg>' );

DELETE FROM USER_SDO_STYLES WHERE NAME = 'M.TFL.RESTRICTIONS.PROPOSED.PT';

Insert into USER_SDO_STYLES
   (NAME, TYPE, DEFINITION)
 Values
   ('M.TFL.RESTRICTIONS.PROPOSED.PT', 'MARKER', 
    '<?xml version="1.0" standalone="yes"?> <svg width="1in" height="1in"> <desc></desc> ' ||
    '<g class="marker" style="stroke:#000000;fill:#FFFF00;width:5;height:5;font-family:Dialog;font-size:12;font-fill:#FF0000"> ' ||
    '<circle cx="0" cy="0" r="5.0" /> </g> </svg>');

DELETE FROM USER_SDO_STYLES WHERE NAME = 'V.TFL.RESTRICTIONS LINES'; 

Insert into USER_SDO_STYLES
   (NAME, TYPE, DEFINITION)
 Values
   ('V.TFL.RESTRICTIONS LINES', 'ADVANCED', 
    '<?xml version="1.0" ?> <AdvancedStyle> <BucketStyle> <Buckets> ' ||
    '<CollectionBucket seq="0" label="PROPOSED" type="string" style="L.TFL.RESTRICTIONS.PROPOSED">PROPOSED</CollectionBucket> ' ||
    '<CollectionBucket seq="1" label="IN FORCE" type="string" style="L.TFL.RESTRICTIONS.IN FORCE">IN_FORCE</CollectionBucket> ' ||
    '</Buckets> </BucketStyle> </AdvancedStyle>');

DELETE FROM USER_SDO_STYLES WHERE NAME = 'V.TFL.RESTRICTIONS POLY'; 

Insert into USER_SDO_STYLES
   (NAME, TYPE, DEFINITION )
 Values
   ('V.TFL.RESTRICTIONS POLY', 'ADVANCED', 
    '<?xml version="1.0" ?> <AdvancedStyle> <BucketStyle> <Buckets> ' ||
    '<CollectionBucket seq="0" label="PROPOSED" type="string" style="C.TFL.RESTRICTIONS.PROPOSED">PROPOSED</CollectionBucket> ' ||
    '<CollectionBucket seq="1" label="IN FORCE" type="string" style="C.TFL.RESTRICTIONS.IN FORCE">IN_FORCE</CollectionBucket> ' ||
    '</Buckets> </BucketStyle> </AdvancedStyle>');
    
DELETE FROM USER_SDO_STYLES WHERE NAME = 'V.TFL.RESTRICTIONS SHAPE POINT';

Insert into USER_SDO_STYLES
   (NAME, TYPE, DEFINITION)
 Values
   ('V.TFL.RESTRICTIONS SHAPE POINT', 'ADVANCED', 
    '<?xml version="1.0" ?> <AdvancedStyle> <BucketStyle> <Buckets> ' ||
    '<CollectionBucket seq="0" label="PROPOSED" type="string" style="M.TFL.RESTRICTIONS.PROPOSED.PT">PROPOSED</CollectionBucket> ' ||
    '<CollectionBucket seq="1" label="IN FORCE" type="string" style="M.TFL.RESTRICTIONS.IN FORCE.PT">IN_FORCE</CollectionBucket> ' ||
    '</Buckets> </BucketStyle> </AdvancedStyle>');
    
INSERT INTO USER_SDO_THEMES (NAME,DESCRIPTION,BASE_TABLE,GEOMETRY_COLUMN,STYLING_RULES)
SELECT 'S58 AND S58A NOTICES - SHAPE OLD', DESCRIPTION,BASE_TABLE,GEOMETRY_COLUMN,STYLING_RULES
  FROM USER_SDO_THEMES
 WHERE NAME = 'S58 AND S58A NOTICES - SHAPE';
 
DELETE  FROM USER_SDO_THEMES
 WHERE NAME = 'S58 AND S58A NOTICES - SHAPE';
 
Insert into USER_SDO_THEMES
   (NAME, BASE_TABLE, GEOMETRY_COLUMN, STYLING_RULES)
 Values
   ('S58 AND S58A NOTICES - SHAPE', 'X_RESTRICT_PROPORINFORCE_SDO', 'TRES_GEOMETRY', 
    '<?xml version="1.0" standalone="yes"?> <styling_rules key_column="TRES_RESTRICTION_ID" table_alias="A"> ' ||
    '<rule column="RESTRICTION_STATUS"> ' ||
    '<features style="V.TFL.RESTRICTIONS LINES"> (A.TRES_GEOMETRY.SDO_GTYPE = 2002) </features> ' ||
    '</rule> ' ||
    '<rule column="RESTRICTION_STATUS"> ' ||
    '<features style="V.TFL.RESTRICTIONS SHAPE POINT"> (A.TRES_GEOMETRY.SDO_GTYPE = 2001) </features> ' ||
    '</rule> ' ||
    '<rule column="RESTRICTION_STATUS"> ' ||
    '<features style="V.TFL.RESTRICTIONS POLY"> (A.TRES_GEOMETRY.SDO_GTYPE = 2003) </features> ' ||
    '</rule> ' ||
    '</styling_rules>');
 

-- works BY STREET GROUP SHAPE
DELETE FROM USER_SDO_STYLES 
WHERE NAME IN ('C.TFL.WORKS BY ST GROUP 1',
               'C.TFL.WORKS BY ST GROUP 2', 
               'C.TFL.WORKS BY ST GROUP 3', 
               'C.TFL.WORKS BY ST GROUP 4', 
               'C.TFL.WORKS BY ST GROUP 5', 
               'C.TFL.WORKS BY ST GROUP 6', 
               'C.TFL.WORKS BY ST GROUP 7', 
               'C.TFL.WORKS BY ST GROUP 8', 
               'C.TFL.WORKS BY ST GROUP 9', 
               'C.TFL.WORKS BY ST GROUP 10', 
               'C.TFL.WORKS BY ST GROUP 11', 
               'C.TFL.WORKS BY ST GROUP 12', 
               'C.TFL.WORKS BY ST GROUP 13');

Insert into USER_SDO_STYLES
   (NAME, TYPE, DEFINITION)
 Values
   ('C.TFL.WORKS BY ST GROUP 1', 'COLOR', 
    '<?xml version="1.0" standalone="yes"?> <svg width="1in" height="1in"> <desc/> ' ||
    '<g class="color" style="stroke:#000000;stroke-width:2.0;fill:#000000;fill-opacity:89"> ' ||
    '<rect width="50" height="50"/> </g> </svg>');
               
Insert into USER_SDO_STYLES
   (NAME, TYPE, DEFINITION)
 Values
   ('C.TFL.WORKS BY ST GROUP 10', 'COLOR', 
    '<?xml version="1.0" standalone="yes"?> <svg width="1in" height="1in"> <desc/> ' ||
    '<g class="color" style="stroke:#99FFFF;stroke-width:2.0;fill:#99FFFF;fill-opacity:89"> ' ||
    '<rect width="50" height="50"/> </g> </svg>');

Insert into USER_SDO_STYLES
   (NAME, TYPE, DEFINITION)
 Values
   ('C.TFL.WORKS BY ST GROUP 11', 'COLOR', 
    '<?xml version="1.0" standalone="yes"?> <svg width="1in" height="1in"> <desc/> ' ||
    '<g class="color" style="stroke:#CCCCFF;stroke-width:2.0;fill:#CCCCFF;fill-opacity:89"> ' ||
    '<rect width="50" height="50"/> </g> </svg>');

Insert into USER_SDO_STYLES
   (NAME, TYPE, DEFINITION)
 Values
   ('C.TFL.WORKS BY ST GROUP 12', 'COLOR', 
    '<?xml version="1.0" standalone="yes"?> <svg width="1in" height="1in"> <desc/> ' ||
    '<g class="color" style="stroke:#999900;stroke-width:2.0;fill:#999900;fill-opacity:89"> ' ||
    '<rect width="50" height="50"/> </g> </svg>' );

Insert into USER_SDO_STYLES
   (NAME, TYPE, DEFINITION )
 Values
   ('C.TFL.WORKS BY ST GROUP 13', 'COLOR', 
    '<?xml version="1.0" standalone="yes"?> <svg width="1in" height="1in"> <desc/> ' ||
    '<g class="color" style="stroke:#CC0000;stroke-width:2.0;fill:#CC0000;fill-opacity:89"> ' ||
    '<rect width="50" height="50"/> </g> </svg>');

Insert into USER_SDO_STYLES
   (NAME, TYPE, DEFINITION)
 Values
   ('C.TFL.WORKS BY ST GROUP 2', 'COLOR', 
    '<?xml version="1.0" standalone="yes"?> <svg width="1in" height="1in"> <desc/> ' ||
    '<g class="color" style="stroke:#FF3366;stroke-width:2.0;fill:#FF3366;fill-opacity:89"> ' ||
    '<rect width="50" height="50"/> </g> </svg>');

Insert into USER_SDO_STYLES
   (NAME, TYPE, DEFINITION)
 Values
   ('C.TFL.WORKS BY ST GROUP 3', 'COLOR', 
    '<?xml version="1.0" standalone="yes"?> <svg width="1in" height="1in"> <desc/> ' ||
    '<g class="color" style="stroke:#6666FF;stroke-width:2.0;fill:#6666FF;fill-opacity:89"> ' ||
    '<rect width="50" height="50"/> </g> </svg>');
    
Insert into USER_SDO_STYLES
   (NAME, TYPE, DEFINITION)
 Values
   ('C.TFL.WORKS BY ST GROUP 4', 'COLOR', 
    '<?xml version="1.0" standalone="yes"?> <svg width="1in" height="1in"> <desc/> ' ||
    '<g class="color" style="stroke:#FFFF66;stroke-width:2.0;fill:#FFFF66;fill-opacity:89"> ' ||
    '<rect width="50" height="50"/> </g> </svg>');

Insert into USER_SDO_STYLES
   (NAME, TYPE, DEFINITION)
 Values
   ('C.TFL.WORKS BY ST GROUP 5', 'COLOR', 
    '<?xml version="1.0" standalone="yes"?> <svg width="1in" height="1in"> <desc/> ' ||
    '<g class="color" style="stroke:#33CC00;stroke-width:2.0;fill:#33CC00;fill-opacity:89"> ' ||
    '<rect width="50" height="50"/> </g> </svg>');

Insert into USER_SDO_STYLES
   (NAME, TYPE, DEFINITION)
 Values
   ('C.TFL.WORKS BY ST GROUP 6', 'COLOR', 
     '<?xml version="1.0" standalone="yes"?> <svg width="1in" height="1in"> <desc/> ' ||
     '<g class="color" style="stroke:#66FF66;stroke-width:2.0;fill:#66FF66;fill-opacity:89"> ' ||
     '<rect width="50" height="50"/> </g> </svg>');

Insert into USER_SDO_STYLES
   (NAME, TYPE, DEFINITION)
 Values
   ('C.TFL.WORKS BY ST GROUP 7', 'COLOR', 
    '<?xml version="1.0" standalone="yes"?> <svg width="1in" height="1in"> <desc/> ' ||
    '<g class="color" style="stroke:#FFCC66;stroke-width:2.0;fill:#FFCC66;fill-opacity:89"> '||
    '<rect width="50" height="50"/> </g> </svg>');

Insert into USER_SDO_STYLES
   (NAME, TYPE, DEFINITION)
 Values
   ('C.TFL.WORKS BY ST GROUP 8', 'COLOR', 
    '<?xml version="1.0" standalone="yes"?> <svg width="1in" height="1in"> <desc/> ' ||
    '<g class="color" style="stroke:#CC00CC;stroke-width:2.0;fill:#CC00CC;fill-opacity:89"> ' ||
    '<rect width="50" height="50"/> </g> </svg>');

Insert into USER_SDO_STYLES
   (NAME, TYPE, DEFINITION)
 Values
   ('C.TFL.WORKS BY ST GROUP 9', 'COLOR', 
    '<?xml version="1.0" standalone="yes"?> <svg width="1in" height="1in"> <desc/> ' ||
    '<g class="color" style="stroke:#FF99FF;stroke-width:2.0;fill:#FF99FF;fill-opacity:89"> ' ||
    '<rect width="50" height="50"/> </g> </svg>');

DELETE FROM USER_SDO_STYLES 
WHERE NAME IN ('M.TFL.WORKS BY ST GROUP PT 1',
               'M.TFL.WORKS BY ST GROUP PT 2', 
               'M.TFL.WORKS BY ST GROUP PT 3', 
               'M.TFL.WORKS BY ST GROUP PT 4', 
               'M.TFL.WORKS BY ST GROUP PT 5', 
               'M.TFL.WORKS BY ST GROUP PT 6', 
               'M.TFL.WORKS BY ST GROUP PT 7', 
               'M.TFL.WORKS BY ST GROUP PT 8', 
               'M.TFL.WORKS BY ST GROUP PT 9', 
               'M.TFL.WORKS BY ST GROUP PT 10', 
               'M.TFL.WORKS BY ST GROUP PT 11', 
               'M.TFL.WORKS BY ST GROUP PT 12', 
               'M.TFL.WORKS BY ST GROUP PT 13');
    
Insert into USER_SDO_STYLES
   (NAME, TYPE, DEFINITION)
 Values
   ('M.TFL.WORKS BY ST GROUP PT 1', 'MARKER', 
    '<?xml version="1.0" standalone="yes"?> <svg width="1in" height="1in"> <desc></desc> ' ||
    '<g class="marker" style="stroke:#000000;fill:#000000;width:5;height:5;font-family:Dialog;font-size:12;font-fill:#FF0000"> ' ||
    '<circle cx="0" cy="0" r="5.0" /> </g> </svg>');

Insert into USER_SDO_STYLES
   (NAME, TYPE, DEFINITION)
 Values
   ('M.TFL.WORKS BY ST GROUP PT 10', 'MARKER', 
    '<?xml version="1.0" standalone="yes"?> <svg width="1in" height="1in"> <desc></desc> ' ||
    '<g class="marker" style="stroke:#000000;fill:#99FFFF;width:5;height:5;font-family:Dialog;font-size:12;font-fill:#FF0000"> ' ||
    '<circle cx="0" cy="0" r="5.0" /> </g> </svg>');

Insert into USER_SDO_STYLES
   (NAME, TYPE, DEFINITION)
 Values
   ('M.TFL.WORKS BY ST GROUP PT 11', 'MARKER', 
    '<?xml version="1.0" standalone="yes"?> <svg width="1in" height="1in"> <desc></desc> ' ||
    '<g class="marker" style="stroke:#000000;fill:#CCCCFF;width:5;height:5;font-family:Dialog;font-size:12;font-fill:#FF0000"> ' ||
    '<circle cx="0" cy="0" r="5.0" /> </g> </svg>');

Insert into USER_SDO_STYLES
   (NAME, TYPE, DEFINITION)
 Values
   ('M.TFL.WORKS BY ST GROUP PT 12', 'MARKER', 
    '<?xml version="1.0" standalone="yes"?> <svg width="1in" height="1in"> <desc></desc> ' ||
    '<g class="marker" style="stroke:#000000;fill:#999900;width:5;height:5;font-family:Dialog;font-size:12;font-fill:#FF0000"> ' ||
    '<circle cx="0" cy="0" r="5.0" /> </g> </svg>');

Insert into USER_SDO_STYLES
   (NAME, TYPE, DEFINITION)
 Values
   ('M.TFL.WORKS BY ST GROUP PT 13', 'MARKER', 
    '<?xml version="1.0" standalone="yes"?> <svg width="1in" height="1in"> <desc></desc> ' ||
    '<g class="marker" style="stroke:#000000;fill:#CC0000;width:5;height:5;font-family:Dialog;font-size:12;font-fill:#FF0000"> ' ||
    '<circle cx="0" cy="0" r="5.0" /> </g> </svg>');

Insert into USER_SDO_STYLES
   (NAME, TYPE, DEFINITION)
 Values
   ('M.TFL.WORKS BY ST GROUP PT 2', 'MARKER', 
    '<?xml version="1.0" standalone="yes"?> <svg width="1in" height="1in"> <desc></desc> ' ||
    '<g class="marker" style="stroke:#000000;fill:#FF3366;width:5;height:5;font-family:Dialog;font-size:12;font-fill:#FF0000"> ' ||
    '<circle cx="0" cy="0" r="5.0" /> </g> </svg>');

Insert into USER_SDO_STYLES
   (NAME, TYPE, DEFINITION)
 Values
   ('M.TFL.WORKS BY ST GROUP PT 3', 'MARKER', 
    '<?xml version="1.0" standalone="yes"?> <svg width="1in" height="1in"> <desc></desc> ' ||
    '<g class="marker" style="stroke:#000000;fill:#6666FF;width:5;height:5;font-family:Dialog;font-size:12;font-fill:#FF0000"> ' ||
    '<circle cx="0" cy="0" r="5.0" /> </g> </svg>');
    
Insert into USER_SDO_STYLES
   (NAME, TYPE, DEFINITION)
 Values
   ('M.TFL.WORKS BY ST GROUP PT 4', 'MARKER', 
    '<?xml version="1.0" standalone="yes"?> <svg width="1in" height="1in"> <desc></desc> ' ||
    '<g class="marker" style="stroke:#000000;fill:#FFFF66;width:5;height:5;font-family:Dialog;font-size:12;font-fill:#FF0000"> ' ||
    '<circle cx="0" cy="0" r="5.0" /> </g> </svg>');
    
Insert into USER_SDO_STYLES
   (NAME, TYPE, DEFINITION)
 Values
   ('M.TFL.WORKS BY ST GROUP PT 5', 'MARKER', 
    '<?xml version="1.0" standalone="yes"?> <svg width="1in" height="1in">  <desc></desc> ' ||
    '<g class="marker" style="stroke:#000000;fill:#33CC00;width:5;height:5;font-family:Dialog;font-size:12;font-fill:#FF0000"> ' ||
    '<circle cx="0" cy="0" r="5.0" /> </g> </svg>');
    
Insert into USER_SDO_STYLES
   (NAME, TYPE, DEFINITION)
 Values
   ('M.TFL.WORKS BY ST GROUP PT 6', 'MARKER', 
    '<?xml version="1.0" standalone="yes"?> <svg width="1in" height="1in"> <desc></desc> ' ||
    '<g class="marker" style="stroke:#000000;fill:#66FF66;width:5;height:5;font-family:Dialog;font-size:12;font-fill:#FF0000"> ' ||
    ' <circle cx="0" cy="0" r="5.0" /> </g> </svg>');
    
Insert into USER_SDO_STYLES
   (NAME, TYPE, DEFINITION)
 Values
   ('M.TFL.WORKS BY ST GROUP PT 7', 'MARKER', 
    '<?xml version="1.0" standalone="yes"?> <svg width="1in" height="1in"> <desc></desc> ' ||
    '<g class="marker" style="stroke:#000000;fill:#FFCC66;width:5;height:5;font-family:Dialog;font-size:12;font-fill:#FF0000"> ' ||
    '<circle cx="0" cy="0" r="5.0" /> </g> </svg>');
    
Insert into USER_SDO_STYLES
   (NAME, TYPE, DEFINITION)
 Values
   ('M.TFL.WORKS BY ST GROUP PT 8', 'MARKER', 
    '<?xml version="1.0" standalone="yes"?> <svg width="1in" height="1in"> <desc></desc> '||
    '<g class="marker" style="stroke:#000000;fill:#CC00CC;width:5;height:5;font-family:Dialog;font-size:12;font-fill:#FF0000"> ' ||
    '<circle cx="0" cy="0" r="5.0" /> </g> </svg>');
    
Insert into USER_SDO_STYLES
   (NAME, TYPE, DEFINITION)
 Values
   ('M.TFL.WORKS BY ST GROUP PT 9', 'MARKER', 
    '<?xml version="1.0" standalone="yes"?> <svg width="1in" height="1in"> <desc></desc> ' ||
    '<g class="marker" style="stroke:#000000;fill:#FF99FF;width:5;height:5;font-family:Dialog;font-size:12;font-fill:#FF0000"> ' ||
    '<circle cx="0" cy="0" r="5.0" /> </g> </svg>');


DELETE FROM USER_SDO_STYLES WHERE NAME = 'V.TFL.WORKS BY ST GRP LINE';

Insert into USER_SDO_STYLES
   (NAME, TYPE, DEFINITION)
 select 'V.TFL.WORKS BY ST GRP LINE', TYPE, DEFINITION
   FROM USER_SDO_STYLES
   WHERE NAME = 'V.TFL.WORKS BY ST GRP SHAPE';
      
-- COPY ADVANCE STYLES FROM amh FOR V.TFL.WORKS BY ST GRP SHAPE PT and V.TFL.WORKS BY ST GRP POLY

insert into user_sdo_themes 
select 'WORKS BY STREET GROUP-SHAPE OLD', DESCRIPTION, BASE_TABLE, GEOMETRY_COLUMN, STYLING_RULES
 from user_sdo_themes where name = 'WORKS BY STREET GROUP - SHAPE';

delete from USER_SDO_THEMES where name = 'WORKS BY STREET GROUP - SHAPE';

Insert into USER_SDO_THEMES
   (NAME, BASE_TABLE, GEOMETRY_COLUMN, STYLING_RULES)
 Values
   ('WORKS BY STREET GROUP - SHAPE', 'X_WORKS_BY_STREET_GROUP_SDO', 'TPHS_GEOMETRY', 
    '<?xml version="1.0" standalone="yes"?> ' ||
    '<styling_rules key_column="TPHS_ID" table_alias="A"> ' ||
    '<rule column="TSG_NAME"> '||
    '<features style="V.TFL.WORKS BY ST GRP LINE"> (A.TPHS_GEOMETRY.SDO_GTYPE = 2002) </features> '||
    '</rule> '||
    '<rule column="TSG_NAME"> '||
    '<features style="V.TFL.WORKS BY ST GRP SHAPE PT"> (A.TPHS_GEOMETRY.SDO_GTYPE = 2001) </features> '||
    '</rule> '||
    '<rule column="TSG_NAME"> '||
    '<features style="V.TFL.WORKS BY ST GRP POLY"> (A.TPHS_GEOMETRY.SDO_GTYPE = 2003) </features> '||
    '</rule> </styling_rules>');
/