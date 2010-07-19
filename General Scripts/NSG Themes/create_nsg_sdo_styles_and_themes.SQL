---------------------------------------------------------------------------------------------------
--
--   PVCS Identifiers :-
--
--       pvcsid           : $Header:   //vm_latest/archives/customer/General Scripts/NSG Themes/create_nsg_sdo_styles_and_themes.SQL-arc   1.0   Jul 19 2010 09:33:20   Ian.Turnbull  $
--       Module Name      : $Workfile:   create_nsg_sdo_styles_and_themes.SQL  $
--       Date into PVCS   : $Date:   Jul 19 2010 09:33:20  $
--       Date fetched Out : $Modtime:   Jul 19 2010 09:32:34  $
--       PVCS Version     : $Revision:   1.0  $
--       Based on SCCS version :
--
--   Author : Aileen Heal
--
---------------------------------------------------------------------------------------------------
--	Copyright (c) exor corporation ltd, 2010
---------------------------------------------------------------------------------------------------
--
-- Written by Aileen Heal to create the standard USER_SDO_STYLES and USER_SDO_THEMES for the standard NSG Themes. 
--
-- Please read the readme.rtf document in the zip file before running this script.
--
---------------------------------------------------------------------------------------------------
--
col     log_extension new_value log_extension noprint
select  TO_CHAR(sysdate,'DDMONYYYY_HH24MISS') || '.LOG' log_extension from dual;

---------------------------------------------------------------------------------------------------
-- Spool to Logfile

define logfile1='create_nsg_sdo_styles_n_themes_&log_extension'
set pages 0
set lines 200

spool &logfile1

set echo on
set time on

-- T.EXOR.NSG.ROAD_NAME
delete from user_sdo_styles 
 where name = 'T.EXOR.NSG.ROAD_NAME.V.1.1' || '.OLD'
/
 
Insert into USER_SDO_STYLES (NAME,TYPE,DESCRIPTION,DEFINITION) 
select name  || '.OLD', TYPE, DESCRIPTION, DEFINITION
    from USER_SDO_STYLES
  where  name = 'T.EXOR.NSG.ROAD_NAME.V.1.1'
/

delete from user_sdo_styles 
 where name = 'T.EXOR.NSG.ROAD_NAME.V.1.1'
/

Insert into USER_SDO_STYLES (NAME,TYPE,DESCRIPTION,DEFINITION) 
values ('T.EXOR.NSG.ROAD_NAME.V.1.1','TEXT',
        'DO NOT EDIT - If you wish to change a style please edit a duplicate and use that',
        '<?xml version="1.0" standalone="yes"?> <svg width="1in" height="1in"> <desc></desc> ' ||
        '<g class="text" style="font-style:plain;font-family:Serif;font-size:11pt;font-weight:bold;fill:#000000"> ' ||
        'Hello World! </g> </svg>');

-- L.EXOR.NSG.ESU

delete from user_sdo_styles 
 where name = 'L.EXOR.NSG.ESU.V.1.1' || '.OLD'
/
 
Insert into USER_SDO_STYLES (NAME,TYPE,DESCRIPTION,DEFINITION) 
select name  || '.OLD', TYPE, DESCRIPTION, DEFINITION
    from USER_SDO_STYLES
  where  name = 'L.EXOR.NSG.ESU.V.1.1'
/

delete from user_sdo_styles 
 where name = 'L.EXOR.NSG.ESU.V.1.1'
/
 
Insert into USER_SDO_STYLES (NAME,TYPE,DESCRIPTION,DEFINITION) 
values ('L.EXOR.NSG.ESU.V.1.1','LINE',
        'DO NOT EDIT - If you wish to change a style please edit a duplicate and use that',
        '<?xml version="1.0" standalone="yes"?> <svg width="1in" height="1in"> <desc></desc> ' ||
        '<g class="line" style="fill:#3333FF;stroke-width:1"> <line class="base" /></g> </svg>')
/

-- L.EXOR.NSG.OFFN
delete from user_sdo_styles 
 where name = 'L.EXOR.NSG.OFFN.V.1.1' || '.OLD'
/
 
Insert into USER_SDO_STYLES (NAME,TYPE,DESCRIPTION,DEFINITION) 
select name  || '.OLD', TYPE, DESCRIPTION, DEFINITION
    from USER_SDO_STYLES
  where  name = 'L.EXOR.NSG.OFFN.V.1.1' 
/

delete from user_sdo_styles 
 where name = 'L.EXOR.NSG.OFFN.V.1.1'
/

Insert into USER_SDO_STYLES (NAME,TYPE,DESCRIPTION,DEFINITION) 
values ('L.EXOR.NSG.OFFN.V.1.1','LINE',
        'DO NOT EDIT - If you wish to change a style please edit a duplicate and use that',
        '<?xml version="1.0" standalone="yes"?> <svg width="1in" height="1in"> <desc></desc> ' ||
        '<g class="line" style="fill:#000000;stroke-width:2.0"> <line class="base" /> </g> </svg>')
/

-- L.EXOR.NSG.RDNM

delete from user_sdo_styles 
 where name = 'L.EXOR.NSG.RDNM.V.1.1' || '.OLD'
/
 
Insert into USER_SDO_STYLES (NAME,TYPE,DESCRIPTION,DEFINITION) 
select name  || '.OLD', TYPE, DESCRIPTION, DEFINITION
    from USER_SDO_STYLES
  where  name = 'L.EXOR.NSG.RDNM.V.1.1' 
/

delete from user_sdo_styles 
 where name = 'L.EXOR.NSG.RDNM.V.1.1'
/

Insert into USER_SDO_STYLES (NAME,TYPE,DESCRIPTION,DEFINITION) 
values ('L.EXOR.NSG.RDNM.V.1.1','LINE',
        'DO NOT EDIT - If you wish to change a style please edit a duplicate and use that',
        '<?xml version="1.0" standalone="yes"?> <svg width="1in" height="1in"> <desc></desc> ' ||
        '<g class="line" style="fill:#999999;stroke-width:2.0"> <line class="base" /> </g> </svg>')
/

-- L.EXOR.NSG.UOFF

delete from user_sdo_styles 
 where name = 'L.EXOR.NSG.UOFF.V.1.1' || '.OLD'
/
 
Insert into USER_SDO_STYLES (NAME,TYPE,DESCRIPTION,DEFINITION) 
select name  || '.OLD', TYPE, DESCRIPTION, DEFINITION
    from USER_SDO_STYLES
  where  name = 'L.EXOR.NSG.UOFF.V.1.1' 
/

delete from user_sdo_styles 
 where name = 'L.EXOR.NSG.UOFF.V.1.1'
/

Insert into USER_SDO_STYLES (NAME,TYPE,DESCRIPTION,DEFINITION) 
values ('L.EXOR.NSG.UOFF.V.1.1','LINE',
        'DO NOT EDIT - If you wish to change a style please edit a duplicate and use that',
        '<?xml version="1.0" standalone="yes"?> <svg width="1in" height="1in"> <desc></desc> ' ||
        '<g class="line" style="fill:#CCCCFF;stroke-width:2.0"> <line class="base" /></g> </svg>')
/

-- L.EXOR.NSG.TP61.*

delete from user_sdo_styles 
 where name = 'L.EXOR.NSG.TP61.1.V1.1' || '.OLD'
/
 
Insert into USER_SDO_STYLES (NAME,TYPE,DESCRIPTION,DEFINITION) 
select name  || '.OLD', TYPE, DESCRIPTION, DEFINITION
    from USER_SDO_STYLES
  where  name = 'L.EXOR.NSG.TP61.1.V1.1'
/

delete from user_sdo_styles 
 where name = 'L.EXOR.NSG.TP61.1.V1.1'
/

Insert into USER_SDO_STYLES (NAME,TYPE,DESCRIPTION,DEFINITION) 
values ('L.EXOR.NSG.TP61.1.V1.1','LINE',
        'DO NOT EDIT - If you wish to change a style please edit a duplicate and use that',
        '<?xml version="1.0" standalone="yes"?> <svg width="1in" height="1in"> <desc></desc> ' ||
        '<g class="line" style="fill:#99FF99;stroke-width:5.0;stroke-linecap:BUTT"> <line class="base" /></g> </svg>')
/

delete from user_sdo_styles 
 where name = 'L.EXOR.NSG.TP61.2.V1.1' || '.OLD'
/
 
Insert into USER_SDO_STYLES (NAME,TYPE,DESCRIPTION,DEFINITION) 
select name  || '.OLD', TYPE, DESCRIPTION, DEFINITION
    from USER_SDO_STYLES
  where  name = 'L.EXOR.NSG.TP61.2.V1.1'
/

delete from user_sdo_styles 
 where name = 'L.EXOR.NSG.TP61.2.V1.1'
/

Insert into USER_SDO_STYLES (NAME,TYPE,DESCRIPTION,DEFINITION) 
values ('L.EXOR.NSG.TP61.2.V1.1','LINE',
        'DO NOT EDIT - If you wish to change a style please edit a duplicate and use that',
        '<?xml version="1.0" standalone="yes"?> <svg width="1in" height="1in"> <desc></desc> ' ||
        '<g class="line" style="fill:#3333FF;stroke-width:5.0;stroke-linecap:BUTT"> <line class="base" /></g> </svg>')
/

delete from user_sdo_styles 
 where name = 'L.EXOR.NSG.TP61.3.V1.1' || '.OLD'
/
 
Insert into USER_SDO_STYLES (NAME,TYPE,DESCRIPTION,DEFINITION) 
select name  || '.OLD', TYPE, DESCRIPTION, DEFINITION
    from USER_SDO_STYLES
  where  name = 'L.EXOR.NSG.TP61.3.V1.1'
/

delete from user_sdo_styles 
 where name = 'L.EXOR.NSG.TP61.3.V1.1'
/

Insert into USER_SDO_STYLES (NAME,TYPE,DESCRIPTION,DEFINITION) 
values ('L.EXOR.NSG.TP61.3.V1.1','LINE',
        'DO NOT EDIT - If you wish to change a style please edit a duplicate and use that',
        '<?xml version="1.0" standalone="yes"?> <svg width="1in" height="1in"> <desc></desc> ' ||
        '<g class="line" style="fill:#FFCC00;stroke-width:5.0;stroke-linecap:BUTT"> <line class="base" /></g> </svg>')
/

delete from user_sdo_styles 
 where name = 'V.EXOR.NSG.TYPE 61.V.1.1' || '.OLD'
/
 
Insert into USER_SDO_STYLES (NAME,TYPE,DESCRIPTION,DEFINITION) 
select name  || '.OLD', TYPE, DESCRIPTION, DEFINITION
    from USER_SDO_STYLES
  where  name = 'V.EXOR.NSG.TYPE 61.V.1.1'
/

delete from user_sdo_styles 
 where name = 'V.EXOR.NSG.TYPE 61.V.1.1'
/
Insert into USER_SDO_STYLES (NAME,TYPE,DESCRIPTION,DEFINITION) 
values ('V.EXOR.NSG.TYPE 61.V.1.1','ADVANCED',
        'DO NOT EDIT - If you wish to change a style please edit a duplicate and use that',
        '<?xml version="1.0" ?> <AdvancedStyle> <BucketStyle> <Buckets> ' ||
        '<CollectionBucket seq="0" label="Publicly Maintainable" type="string" style="L.EXOR.NSG.TP61.1.V1.1">1</CollectionBucket> ' ||
        '<CollectionBucket seq="1" label="Prospectively Maintainable" type="string" style="L.EXOR.NSG.TP61.2.V1.1">2</CollectionBucket> ' ||
        '<CollectionBucket seq="2" label="Private" type="string" style="L.EXOR.NSG.TP61.3.V1.1">3</CollectionBucket> ' ||
        '</Buckets> </BucketStyle> </AdvancedStyle>')
/

-- L.EXOR.NSG.TP62.*

delete from user_sdo_styles 
 where name = 'L.EXOR.NSG.TP62.1.V.1.1' || '.OLD'
/
 
Insert into USER_SDO_STYLES (NAME,TYPE,DESCRIPTION,DEFINITION) 
select name  || '.OLD', TYPE, DESCRIPTION, DEFINITION
    from USER_SDO_STYLES
  where  name = 'L.EXOR.NSG.TP62.1.V.1.1' 
/

delete from user_sdo_styles 
 where name = 'L.EXOR.NSG.TP62.1.V.1.1'
/

Insert into USER_SDO_STYLES (NAME,TYPE,DESCRIPTION,DEFINITION) 
values ('L.EXOR.NSG.TP62.1.V.1.1','LINE',
        'DO NOT EDIT - If you wish to change a style please edit a duplicate and use that',
        '<?xml version="1.0" standalone="yes"?> <svg width="1in" height="1in"> <desc></desc> ' ||
        '<g class="line" style="fill:#FF3333;stroke-width:9.0;stroke-linecap:BUTT"> <line class="base" /></g> </svg>')
/

delete from user_sdo_styles 
 where name = 'L.EXOR.NSG.TP62.2.V.1.1' || '.OLD'
/
 
Insert into USER_SDO_STYLES (NAME,TYPE,DESCRIPTION,DEFINITION) 
select name  || '.OLD', TYPE, DESCRIPTION, DEFINITION
    from USER_SDO_STYLES
  where  name = 'L.EXOR.NSG.TP62.2.V.1.1' 
/

delete from user_sdo_styles 
 where name = 'L.EXOR.NSG.TP62.2.V.1.1'
/

Insert into USER_SDO_STYLES (NAME,TYPE,DESCRIPTION,DEFINITION) 
values ('L.EXOR.NSG.TP62.2.V.1.1','LINE',
        'DO NOT EDIT - If you wish to change a style please edit a duplicate and use that',
        '<?xml version="1.0" standalone="yes"?> <svg width="1in" height="1in"> <desc></desc> ' ||
        '<g class="line" style="fill:#FF9933;stroke-width:9.0;stroke-linecap:BUTT"> <line class="base" /></g> </svg>')
/

delete from user_sdo_styles 
 where name = 'L.EXOR.NSG.TP62.3.V.1.1' || '.OLD'
/
 
Insert into USER_SDO_STYLES (NAME,TYPE,DESCRIPTION,DEFINITION) 
select name  || '.OLD', TYPE, DESCRIPTION, DEFINITION
    from USER_SDO_STYLES
  where  name = 'L.EXOR.NSG.TP62.3.V.1.1' 
/

delete from user_sdo_styles 
 where name = 'L.EXOR.NSG.TP62.3.V.1.1'
/

Insert into USER_SDO_STYLES (NAME,TYPE,DESCRIPTION,DEFINITION) 
values ('L.EXOR.NSG.TP62.3.V.1.1','LINE',
        'DO NOT EDIT - If you wish to change a style please edit a duplicate and use that',
        '<?xml version="1.0" standalone="yes"?> <svg width="1in" height="1in"> <desc></desc> ' ||
        '<g class="line" style="fill:#FF66FF;stroke-width:9.0;stroke-linecap:BUTT"> <line class="base" /></g> </svg>')
/

delete from user_sdo_styles 
 where name = 'L.EXOR.NSG.TP62.4.V.1.1' || '.OLD'
/
 
Insert into USER_SDO_STYLES (NAME,TYPE,DESCRIPTION,DEFINITION) 
select name  || '.OLD', TYPE, DESCRIPTION, DEFINITION
    from USER_SDO_STYLES
  where  name = 'L.EXOR.NSG.TP62.4.V.1.1' 
/

delete from user_sdo_styles 
 where name = 'L.EXOR.NSG.TP62.4.V.1.1'
/

Insert into USER_SDO_STYLES (NAME,TYPE,DESCRIPTION,DEFINITION) 
values ('L.EXOR.NSG.TP62.4.V.1.1','LINE',
        'DO NOT EDIT - If you wish to change a style please edit a duplicate and use that',
        '<?xml version="1.0" standalone="yes"?> <svg width="1in" height="1in"> <desc></desc> ' ||
        '<g class="line" style="fill:#33CC00;stroke-width:9.0;stroke-linecap:BUTT"> <line class="base" /></g> </svg>')
/

delete from user_sdo_styles 
 where name = 'L.EXOR.NSG.TP62.5.V.1.1' || '.OLD'
/
 
Insert into USER_SDO_STYLES (NAME,TYPE,DESCRIPTION,DEFINITION) 
select name  || '.OLD', TYPE, DESCRIPTION, DEFINITION
    from USER_SDO_STYLES
  where  name = 'L.EXOR.NSG.TP62.5.V.1.1' 
/

delete from user_sdo_styles 
 where name = 'L.EXOR.NSG.TP62.5.V.1.1'
/

Insert into USER_SDO_STYLES (NAME,TYPE,DESCRIPTION,DEFINITION) 
values ('L.EXOR.NSG.TP62.5.V.1.1','LINE',
        'DO NOT EDIT - If you wish to change a style please edit a duplicate and use that',
        '<?xml version="1.0" standalone="yes"?> <svg width="1in" height="1in"> <desc></desc> ' ||
        '<g class="line" style="fill:#FFFF66;stroke-width:9.0;stroke-linecap:BUTT"> <line class="base" /></g> </svg>')
/

delete from user_sdo_styles 
 where name = 'L.EXOR.NSG.TP62.6.V.1.1' || '.OLD'
/
 
Insert into USER_SDO_STYLES (NAME,TYPE,DESCRIPTION,DEFINITION) 
select name  || '.OLD', TYPE, DESCRIPTION, DEFINITION
    from USER_SDO_STYLES
  where  name = 'L.EXOR.NSG.TP62.6.V.1.1' 
/

delete from user_sdo_styles 
 where name = 'L.EXOR.NSG.TP62.6.V.1.1'
/

Insert into USER_SDO_STYLES (NAME,TYPE,DESCRIPTION,DEFINITION) 
values ('L.EXOR.NSG.TP62.6.V.1.1','LINE',
        'DO NOT EDIT - If you wish to change a style please edit a duplicate and use that',
        '<?xml version="1.0" standalone="yes"?> <svg width="1in" height="1in"> <desc></desc> ' ||
        '<g class="line" style="fill:#000099;stroke-width:9.0;stroke-linecap:BUTT"> <line class="base" /></g> </svg>')
/

delete from user_sdo_styles 
 where name = 'L.EXOR.NSG.TP62.7.V.1.1' || '.OLD'
/
 
Insert into USER_SDO_STYLES (NAME,TYPE,DESCRIPTION,DEFINITION) 
select name  || '.OLD', TYPE, DESCRIPTION, DEFINITION
    from USER_SDO_STYLES
  where  name = 'L.EXOR.NSG.TP62.7.V.1.1' 
/

delete from user_sdo_styles 
 where name = 'L.EXOR.NSG.TP62.7.V.1.1'
/

Insert into USER_SDO_STYLES (NAME,TYPE,DESCRIPTION,DEFINITION) 
values ('L.EXOR.NSG.TP62.7.V.1.1','LINE',
        'DO NOT EDIT - If you wish to change a style please edit a duplicate and use that',
        '<?xml version="1.0" standalone="yes"?> <svg width="1in" height="1in"> <desc></desc> ' ||
        '<g class="line" style="fill:#9999FF;stroke-width:9.0;stroke-linecap:BUTT"> <line class="base" /></g> </svg>')
/

delete from user_sdo_styles 
 where name = 'L.EXOR.NSG.TP62.8.V.1.1' || '.OLD'
/
 
Insert into USER_SDO_STYLES (NAME,TYPE,DESCRIPTION,DEFINITION) 
select name  || '.OLD', TYPE, DESCRIPTION, DEFINITION
    from USER_SDO_STYLES
  where  name = 'L.EXOR.NSG.TP62.8.V.1.1' 
/

delete from user_sdo_styles 
 where name = 'L.EXOR.NSG.TP62.8.V.1.1'
/

Insert into USER_SDO_STYLES (NAME,TYPE,DESCRIPTION,DEFINITION) 
values ('L.EXOR.NSG.TP62.8.V.1.1','LINE',
        'DO NOT EDIT - If you wish to change a style please edit a duplicate and use that',
        '<?xml version="1.0" standalone="yes"?> <svg width="1in" height="1in"> <desc></desc> ' ||
        '<g class="line" style="fill:#66FFFF;stroke-width:9.0;stroke-linecap:BUTT"> <line class="base" /></g> </svg>')
/

delete from user_sdo_styles 
 where name = 'L.EXOR.NSG.TP62.9.V.1.1' || '.OLD'
/
 
Insert into USER_SDO_STYLES (NAME,TYPE,DESCRIPTION,DEFINITION) 
select name  || '.OLD', TYPE, DESCRIPTION, DEFINITION
    from USER_SDO_STYLES
  where  name = 'L.EXOR.NSG.TP62.9.V.1.1' 
/

delete from user_sdo_styles 
 where name = 'L.EXOR.NSG.TP62.9.V.1.1'
/

Insert into USER_SDO_STYLES (NAME,TYPE,DESCRIPTION,DEFINITION) 
values ('L.EXOR.NSG.TP62.9.V.1.1','LINE',
        'DO NOT EDIT - If you wish to change a style please edit a duplicate and use that',
        '<?xml version="1.0" standalone="yes"?> <svg width="1in" height="1in"> <desc></desc> ' ||
        '<g class="line" style="fill:#CC00CC;stroke-width:9.0;stroke-linecap:BUTT"> <line class="base" /></g> </svg>')
/

delete from user_sdo_styles 
 where name = 'L.EXOR.NSG.TP62.10.V.1.1' || '.OLD'
/
 
Insert into USER_SDO_STYLES (NAME,TYPE,DESCRIPTION,DEFINITION) 
select name  || '.OLD', TYPE, DESCRIPTION, DEFINITION
    from USER_SDO_STYLES
  where  name = 'L.EXOR.NSG.TP62.10.V.1.1'
/

delete from user_sdo_styles 
 where name = 'L.EXOR.NSG.TP62.10.V.1.1'
/

Insert into USER_SDO_STYLES (NAME,TYPE,DESCRIPTION,DEFINITION) 
values ('L.EXOR.NSG.TP62.10.V.1.1','LINE',
        'DO NOT EDIT - If you wish to change a style please edit a duplicate and use that',
        '<?xml version="1.0" standalone="yes"?> <svg width="1in" height="1in"> <desc></desc> ' ||
        '<g class="line" style="fill:#003333;stroke-width:9.0;stroke-linecap:BUTT"> <line class="base" /></g> </svg>')
/

delete from user_sdo_styles 
 where name = 'V.EXOR.NSG.TYPE 62.V.1.1' || '.OLD'
/
 
Insert into USER_SDO_STYLES (NAME,TYPE,DESCRIPTION,DEFINITION) 
select name  || '.OLD', TYPE, DESCRIPTION, DEFINITION
    from USER_SDO_STYLES
  where  name = 'V.EXOR.NSG.TYPE 62.V.1.1'
/

delete from user_sdo_styles 
 where name = 'V.EXOR.NSG.TYPE 62.V.1.1'
/

Insert into USER_SDO_STYLES (NAME,TYPE,DESCRIPTION,DEFINITION) 
values ('V.EXOR.NSG.TYPE 62.V.1.1','ADVANCED',
        'DO NOT EDIT - If you wish to change a style please edit a duplicate and use that',
        '<?xml version="1.0" ?> <AdvancedStyle> <BucketStyle> <Buckets> ' ||
        '<CollectionBucket seq="0" label="Carriageway Type 1 - 10 to 30 MSA" type="string" style="L.EXOR.NSG.TP62.1.V.1.1">1</CollectionBucket> ' ||
        '<CollectionBucket seq="1" label="Carriageway Type 2 - 2.5 to 10 MSA" type="string" style="L.EXOR.NSG.TP62.2.V.1.1">2</CollectionBucket> ' ||
        '<CollectionBucket seq="2" label="Carriageway Type 3 - .5 to 2.5 MSA" type="string" style="L.EXOR.NSG.TP62.3.V.1.1">3</CollectionBucket> ' ||
        '<CollectionBucket seq="3" label="Carriageway Type 4 - Upto .5 MSA" type="string" style="L.EXOR.NSG.TP62.4.V.1.1">4</CollectionBucket> ' ||
        '<CollectionBucket seq="4" label="Special Type - Over 30 MSA" type="string" style="L.EXOR.NSG.TP62.5.V.1.1">5</CollectionBucket> ' ||
        '<CollectionBucket seq="5" label="High Duty Footway" type="string" style="L.EXOR.NSG.TP62.6.V.1.1">6</CollectionBucket> ' ||
        '<CollectionBucket seq="6" label="High Amenity Footway" type="string" style="L.EXOR.NSG.TP62.7.V.1.1">7</CollectionBucket> ' ||
        '<CollectionBucket seq="7" label="Other Footway" type="string" style="L.EXOR.NSG.TP62.8.V.1.1">8</CollectionBucket> ' ||
        '<CollectionBucket seq="8" label="Private Street (no designation information)" type="string" style="L.EXOR.NSG.TP62.9.V.1.1">9</CollectionBucket> ' ||
        '<CollectionBucket seq="9" label="Carriageway type 6 (over 125 MSA)" type="string" style="L.EXOR.NSG.TP62.10.V.1.1">10</CollectionBucket> ' ||
        '</Buckets> </BucketStyle> </AdvancedStyle>')
/        

-- L.EXOR.NSG.TP63.*
delete from user_sdo_styles 
 where name = 'L.EXOR.NSG.TP63.1.V.1.1' || '.OLD'
/
 
Insert into USER_SDO_STYLES (NAME,TYPE,DESCRIPTION,DEFINITION) 
select name  || '.OLD', TYPE, DESCRIPTION, DEFINITION
    from USER_SDO_STYLES
  where  name = 'L.EXOR.NSG.TP63.1.V.1.1' 
/

delete from user_sdo_styles 
 where name = 'L.EXOR.NSG.TP63.1.V.1.1'
/

Insert into USER_SDO_STYLES (NAME,TYPE,DESCRIPTION,DEFINITION) 
values ('L.EXOR.NSG.TP63.1.V.1.1','LINE',
        'DO NOT EDIT - If you wish to change a style please edit a duplicate and use that',
        '<?xml version="1.0" standalone="yes"?> <svg width="1in" height="1in"> <desc></desc> ' ||
        '<g class="line" style="fill:#FFCCFF;stroke-width:14.0;stroke-linecap:BUTT;stroke-linejoin:MITER"> <line class="base" /></g> </svg>')
/

delete from user_sdo_styles 
 where name = 'L.EXOR.NSG.TP63.2.V.1.1' || '.OLD'
/
 
Insert into USER_SDO_STYLES (NAME,TYPE,DESCRIPTION,DEFINITION) 
select name  || '.OLD', TYPE, DESCRIPTION, DEFINITION
    from USER_SDO_STYLES
  where  name = 'L.EXOR.NSG.TP63.2.V.1.1' 
/

delete from user_sdo_styles 
 where name = 'L.EXOR.NSG.TP63.2.V.1.1'
/

Insert into USER_SDO_STYLES (NAME,TYPE,DESCRIPTION,DEFINITION) 
values ('L.EXOR.NSG.TP63.2.V.1.1','LINE',
        'DO NOT EDIT - If you wish to change a style please edit a duplicate and use that',
        '<?xml version="1.0" standalone="yes"?> <svg width="1in" height="1in"> <desc></desc> ' ||
        '<g class="line" style="fill:#FF0033;stroke-width:14.0;stroke-linecap:BUTT"> <line class="base" /></g> </svg>')
/

delete from user_sdo_styles 
 where name = 'L.EXOR.NSG.TP63.3.V.1.1' || '.OLD'
/
 
Insert into USER_SDO_STYLES (NAME,TYPE,DESCRIPTION,DEFINITION) 
select name  || '.OLD', TYPE, DESCRIPTION, DEFINITION
    from USER_SDO_STYLES
  where  name = 'L.EXOR.NSG.TP63.3.V.1.1' 
/

delete from user_sdo_styles 
 where name = 'L.EXOR.NSG.TP63.3.V.1.1'
/

Insert into USER_SDO_STYLES (NAME,TYPE,DESCRIPTION,DEFINITION) 
values ('L.EXOR.NSG.TP63.3.V.1.1','LINE',
        'DO NOT EDIT - If you wish to change a style please edit a duplicate and use that',
        '<?xml version="1.0" standalone="yes"?> <svg width="1in" height="1in"> <desc></desc> ' ||
        '<g class="line" style="fill:#0033FF;stroke-width:14.0;stroke-linecap:BUTT"> <line class="base" /></g> </svg>')
/

delete from user_sdo_styles 
 where name = 'L.EXOR.NSG.TP63.4.V.1.1' || '.OLD'
/
 
Insert into USER_SDO_STYLES (NAME,TYPE,DESCRIPTION,DEFINITION) 
select name  || '.OLD', TYPE, DESCRIPTION, DEFINITION
    from USER_SDO_STYLES
  where  name = 'L.EXOR.NSG.TP63.4.V.1.1' 
/

delete from user_sdo_styles 
 where name = 'L.EXOR.NSG.TP63.4.V.1.1'
/

Insert into USER_SDO_STYLES (NAME,TYPE,DESCRIPTION,DEFINITION) 
values ('L.EXOR.NSG.TP63.4.V.1.1','LINE',
        'DO NOT EDIT - If you wish to change a style please edit a duplicate and use that',
        '<?xml version="1.0" standalone="yes"?> <svg width="1in" height="1in"> <desc></desc> ' ||
        '<g class="line" style="fill:#CCFFCC;stroke-width:14.0;stroke-linecap:BUTT;stroke-linejoin:MITER"> <line class="base" /></g> </svg>')
/

delete from user_sdo_styles 
 where name = 'L.EXOR.NSG.TP63.5.V.1.1' || '.OLD'
/
 
Insert into USER_SDO_STYLES (NAME,TYPE,DESCRIPTION,DEFINITION) 
select name  || '.OLD', TYPE, DESCRIPTION, DEFINITION
    from USER_SDO_STYLES
  where  name = 'L.EXOR.NSG.TP63.5.V.1.1' 
/

delete from user_sdo_styles 
 where name = 'L.EXOR.NSG.TP63.5.V.1.1'
/

Insert into USER_SDO_STYLES (NAME,TYPE,DESCRIPTION,DEFINITION) 
values ('L.EXOR.NSG.TP63.5.V.1.1','LINE',
        'DO NOT EDIT - If you wish to change a style please edit a duplicate and use that',
        '<?xml version="1.0" standalone="yes"?> <svg width="1in" height="1in"> <desc></desc> ' ||
        '<g class="line" style="fill:#FFFF00;stroke-width:14.0;stroke-linecap:BUTT"> <line class="base" /></g> </svg>')
/

delete from user_sdo_styles 
 where name = 'L.EXOR.NSG.TP63.6.V.1.1' || '.OLD'
/
 
Insert into USER_SDO_STYLES (NAME,TYPE,DESCRIPTION,DEFINITION) 
select name  || '.OLD', TYPE, DESCRIPTION, DEFINITION
    from USER_SDO_STYLES
  where  name = 'L.EXOR.NSG.TP63.6.V.1.1' 
/

delete from user_sdo_styles 
 where name = 'L.EXOR.NSG.TP63.6.V.1.1'
/
Insert into USER_SDO_STYLES (NAME,TYPE,DESCRIPTION,DEFINITION) 
values ('L.EXOR.NSG.TP63.6.V.1.1','LINE',
        'DO NOT EDIT - If you wish to change a style please edit a duplicate and use that',
        '<?xml version="1.0" standalone="yes"?> <svg width="1in" height="1in"> <desc></desc> ' ||
        '<g class="line" style="fill:#0033FF;stroke-width:14.0;stroke-linecap:BUTT"> ' ||
        '<line class="base" style="fill:#FFFFFF;stroke-width:14.0" dash="7.0,7.0" /> </g> </svg>')
/

delete from user_sdo_styles 
 where name = 'L.EXOR.NSG.TP63.8.V.1.1' || '.OLD'
/
 
Insert into USER_SDO_STYLES (NAME,TYPE,DESCRIPTION,DEFINITION) 
select name  || '.OLD', TYPE, DESCRIPTION, DEFINITION
    from USER_SDO_STYLES
  where  name = 'L.EXOR.NSG.TP63.8.V.1.1' 
/

delete from user_sdo_styles 
 where name = 'L.EXOR.NSG.TP63.8.V.1.1'
/

Insert into USER_SDO_STYLES (NAME,TYPE,DESCRIPTION,DEFINITION) 
values ('L.EXOR.NSG.TP63.8.V.1.1','LINE',
        'DO NOT EDIT - If you wish to change a style please edit a duplicate and use that',
        '<?xml version="1.0" standalone="yes"?> <svg width="1in" height="1in"> <desc></desc> ' ||
        '<g class="line" style="fill:#FFFFFF;stroke-width:14.0;stroke-linecap:BUTT;stroke-linejoin:MITER"> ' ||
        '<line class="parallel" style="fill:#000000;stroke-width:2.0" /> ' ||
        '<line class="base" style="fill:#000000;stroke-width:2.0" /> ' ||
        '<line class="hashmark" style="fill:#000000"  dash="5.0,10.0" /> </g> </svg>')
/
        
delete from user_sdo_styles 
 where name = 'L.EXOR.NSG.TP63.9.V.1.1' || '.OLD'
/
 
Insert into USER_SDO_STYLES (NAME,TYPE,DESCRIPTION,DEFINITION) 
select name  || '.OLD', TYPE, DESCRIPTION, DEFINITION
    from USER_SDO_STYLES
  where  name = 'L.EXOR.NSG.TP63.9.V.1.1' 
/

delete from user_sdo_styles 
 where name = 'L.EXOR.NSG.TP63.9.V.1.1'
/

Insert into USER_SDO_STYLES (NAME,TYPE,DESCRIPTION,DEFINITION) 
values ('L.EXOR.NSG.TP63.9.V.1.1','LINE',
        'DO NOT EDIT - If you wish to change a style please edit a duplicate and use that',
        '<?xml version="1.0" standalone="yes"?> <svg width="1in" height="1in"> <desc></desc> ' ||
        '<g class="line" style="fill:#00CC00;stroke-width:14.0;stroke-linecap:BUTT"> <line class="base" /></g> </svg>')
/
        
delete from user_sdo_styles 
 where name = 'L.EXOR.NSG.TP63.10.V.1.1' || '.OLD'
/
 
Insert into USER_SDO_STYLES (NAME,TYPE,DESCRIPTION,DEFINITION) 
select name  || '.OLD', TYPE, DESCRIPTION, DEFINITION
    from USER_SDO_STYLES
  where  name = 'L.EXOR.NSG.TP63.10.V.1.1'
/

delete from user_sdo_styles 
 where name = 'L.EXOR.NSG.TP63.10.V.1.1'
/

Insert into USER_SDO_STYLES (NAME,TYPE,DESCRIPTION,DEFINITION) 
values ('L.EXOR.NSG.TP63.10.V.1.1','LINE',
        'DO NOT EDIT - If you wish to change a style please edit a duplicate and use that',
        '<?xml version="1.0" standalone="yes"?> <svg width="1in" height="1in"> <desc></desc> ' ||
        '<g class="line" style="fill:#000099;stroke-width:14.0;stroke-linecap:BUTT"> <line class="base" /></g> </svg>')
/

delete from user_sdo_styles 
 where name = 'L.EXOR.NSG.TP63.11.V.1.1' || '.OLD'
/
 
Insert into USER_SDO_STYLES (NAME,TYPE,DESCRIPTION,DEFINITION) 
select name  || '.OLD', TYPE, DESCRIPTION, DEFINITION
    from USER_SDO_STYLES
  where  name = 'L.EXOR.NSG.TP63.11.V.1.1'
/

delete from user_sdo_styles 
 where name = 'L.EXOR.NSG.TP63.11.V.1.1'
/

Insert into USER_SDO_STYLES (NAME,TYPE,DESCRIPTION,DEFINITION) 
values ('L.EXOR.NSG.TP63.11.V.1.1','LINE',
        'DO NOT EDIT - If you wish to change a style please edit a duplicate and use that',
        '<?xml version="1.0" standalone="yes"?> <svg width="1in" height="1in"> <desc></desc> ' ||
        '<g class="line" style="fill:#FFCC33;stroke-width:14.0;stroke-linecap:BUTT"> <line class="base" /></g> </svg>')
/

delete from user_sdo_styles 
 where name = 'L.EXOR.NSG.TP63.12.V.1.1' || '.OLD'
/
 
Insert into USER_SDO_STYLES (NAME,TYPE,DESCRIPTION,DEFINITION) 
select name  || '.OLD', TYPE, DESCRIPTION, DEFINITION
    from USER_SDO_STYLES
  where  name = 'L.EXOR.NSG.TP63.12.V.1.1'
/

delete from user_sdo_styles 
 where name = 'L.EXOR.NSG.TP63.12.V.1.1'
/

Insert into USER_SDO_STYLES (NAME,TYPE,DESCRIPTION,DEFINITION) 
values ('L.EXOR.NSG.TP63.12.V.1.1','LINE',
        'DO NOT EDIT - If you wish to change a style please edit a duplicate and use that',
        '<?xml version="1.0" standalone="yes"?> <svg width="1in" height="1in"> <desc></desc> ' ||
        '<g class="line" style="fill:#999999;stroke-width:14.0;stroke-linecap:BUTT"> <line class="base" /></g> </svg>')
/

delete from user_sdo_styles 
 where name = 'L.EXOR.NSG.TP63.13.V.1.1' || '.OLD'
/
 
Insert into USER_SDO_STYLES (NAME,TYPE,DESCRIPTION,DEFINITION) 
select name  || '.OLD', TYPE, DESCRIPTION, DEFINITION
    from USER_SDO_STYLES
  where  name = 'L.EXOR.NSG.TP63.13.V.1.1'
/

delete from user_sdo_styles 
 where name = 'L.EXOR.NSG.TP63.13.V.1.1'
/

Insert into USER_SDO_STYLES (NAME,TYPE,DESCRIPTION,DEFINITION) 
values ('L.EXOR.NSG.TP63.13.V.1.1','LINE',
        'DO NOT EDIT - If you wish to change a style please edit a duplicate and use that',
        '<?xml version="1.0" standalone="yes"?> <svg width="1in" height="1in"> <desc></desc> ' ||
        '<g class="line" style="fill:#CCCCCC;stroke-width:14.0;stroke-linecap:BUTT"> <line class="base" /></g> </svg>')
/

delete from user_sdo_styles 
 where name = 'L.EXOR.NSG.TP63.14.V.1.1' || '.OLD'
/
 
Insert into USER_SDO_STYLES (NAME,TYPE,DESCRIPTION,DEFINITION) 
select name  || '.OLD', TYPE, DESCRIPTION, DEFINITION
    from USER_SDO_STYLES
  where  name = 'L.EXOR.NSG.TP63.14.V.1.1'
/

delete from user_sdo_styles 
 where name = 'L.EXOR.NSG.TP63.14.V.1.1'
/

Insert into USER_SDO_STYLES (NAME,TYPE,DESCRIPTION,DEFINITION) 
values ('L.EXOR.NSG.TP63.14.V.1.1','LINE', 
        'DO NOT EDIT - If you wish to change a style please edit a duplicate and use that',
        '<?xml version="1.0" standalone="yes"?> <svg width="1in" height="1in"> <desc></desc> ' ||
        '<g class="line" style="fill:#CCCC00;stroke-width:14.0;stroke-linecap:BUTT"> <line class="base" /></g> </svg>')
/

delete from user_sdo_styles 
 where name = 'L.EXOR.NSG.TP63.15.V.1.1' || '.OLD'
/
 
Insert into USER_SDO_STYLES (NAME,TYPE,DESCRIPTION,DEFINITION) 
select name  || '.OLD', TYPE, DESCRIPTION, DEFINITION
    from USER_SDO_STYLES
  where  name = 'L.EXOR.NSG.TP63.15.V.1.1'
/

delete from user_sdo_styles 
 where name = 'L.EXOR.NSG.TP63.15.V.1.1'
/

Insert into USER_SDO_STYLES (NAME,TYPE,DESCRIPTION,DEFINITION) 
values ('L.EXOR.NSG.TP63.15.V.1.1','LINE',
        'DO NOT EDIT - If you wish to change a style please edit a duplicate and use that',
        '<?xml version="1.0" standalone="yes"?> <svg width="1in" height="1in"> <desc></desc> ' ||
        '<g class="line" style="fill:#CCFF66;stroke-width:14.0;stroke-linecap:BUTT"> <line class="base" /></g> </svg>')
/

delete from user_sdo_styles 
 where name = 'L.EXOR.NSG.TP63.16.V.1.1' || '.OLD'
/
 
Insert into USER_SDO_STYLES (NAME,TYPE,DESCRIPTION,DEFINITION) 
select name  || '.OLD', TYPE, DESCRIPTION, DEFINITION
    from USER_SDO_STYLES
  where  name = 'L.EXOR.NSG.TP63.16.V.1.1'
/

delete from user_sdo_styles 
 where name = 'L.EXOR.NSG.TP63.16.V.1.1'
/

Insert into USER_SDO_STYLES (NAME,TYPE,DESCRIPTION,DEFINITION) 
values ('L.EXOR.NSG.TP63.16.V.1.1','LINE',
        'DO NOT EDIT - If you wish to change a style please edit a duplicate and use that',
        '<?xml version="1.0" standalone="yes"?> <svg width="1in" height="1in"> <desc></desc> ' ||
        '<g class="line" style="fill:#FF00CC;stroke-width:14.0;stroke-linecap:BUTT"> <line class="base" /></g> </svg>')
/

delete from user_sdo_styles 
 where name = 'L.EXOR.NSG.TP63.17.V.1.1' || '.OLD'
/
 
Insert into USER_SDO_STYLES (NAME,TYPE,DESCRIPTION,DEFINITION) 
select name  || '.OLD', TYPE, DESCRIPTION, DEFINITION
    from USER_SDO_STYLES
  where  name = 'L.EXOR.NSG.TP63.17.V.1.1'
/

delete from user_sdo_styles 
 where name = 'L.EXOR.NSG.TP63.17.V.1.1'
/

Insert into USER_SDO_STYLES (NAME,TYPE,DESCRIPTION,DEFINITION) 
values ('L.EXOR.NSG.TP63.17.V.1.1','LINE',
        'DO NOT EDIT - If you wish to change a style please edit a duplicate and use that',
        '<?xml version="1.0" standalone="yes"?> <svg width="1in" height="1in"> <desc></desc> ' ||
        '<g class="line" style="fill:#FF0000;stroke-width:14.0;stroke-linecap:BUTT"> ' ||
        '<line class="base" style="fill:#FFFF33;stroke-width:1.0" /> ' ||
        '<line class="hashmark" style="fill:#FFFF33"  dash="5.0,7.0" /> </g> </svg>')
/

delete from user_sdo_styles 
 where name = 'L.EXOR.NSG.TP63.18.V.1.1' || '.OLD'
/
 
Insert into USER_SDO_STYLES (NAME,TYPE,DESCRIPTION,DEFINITION) 
select name  || '.OLD', TYPE, DESCRIPTION, DEFINITION
    from USER_SDO_STYLES
  where  name = 'L.EXOR.NSG.TP63.18.V.1.1'
/

delete from user_sdo_styles 
 where name = 'L.EXOR.NSG.TP63.18.V.1.1'
/

Insert into USER_SDO_STYLES (NAME,TYPE,DESCRIPTION,DEFINITION) 
values ('L.EXOR.NSG.TP63.18.V.1.1','LINE',
        'DO NOT EDIT - If you wish to change a style please edit a duplicate and use that',
        '<?xml version="1.0" standalone="yes"?> <svg width="1in" height="1in"> <desc></desc> ' ||
        '<g class="line" style="fill:#FFFFFF;stroke-width:14.0;stroke-linecap:BUTT"> ' ||
        '<line class="parallel" style="fill:#FFCCFF;stroke-width:1.0" /> ' ||
        ' <line class="base" style="fill:#FF00CC;stroke-width:12.0" dash="4.0,4.0" /> </g> </svg>')
/

delete from user_sdo_styles 
 where name = 'L.EXOR.NSG.TP63.19.V.1.1' || '.OLD'
/
 
Insert into USER_SDO_STYLES (NAME,TYPE,DESCRIPTION,DEFINITION) 
select name  || '.OLD', TYPE, DESCRIPTION, DEFINITION
    from USER_SDO_STYLES
  where  name = 'L.EXOR.NSG.TP63.19.V.1.1'
/

delete from user_sdo_styles 
 where name = 'L.EXOR.NSG.TP63.19.V.1.1'
/

Insert into USER_SDO_STYLES (NAME,TYPE,DESCRIPTION,DEFINITION) 
values ('L.EXOR.NSG.TP63.19.V.1.1','LINE',
        'DO NOT EDIT - If you wish to change a style please edit a duplicate and use that',
        '<?xml version="1.0" standalone="yes"?> <svg width="1in" height="1in"> <desc></desc> ' ||
        '<g class="line" style="fill:#FF9933;stroke-width:14.0;stroke-linecap:BUTT"> ' ||
        '<line class="base" style="fill:#FFFF33;stroke-width:12.0" dash="4.0,4.0" /> </g> </svg>')
/


delete from user_sdo_styles 
 where name = 'L.EXOR.NSG.TP63.20.V.1.1' || '.OLD'
/
 
Insert into USER_SDO_STYLES (NAME,TYPE,DESCRIPTION,DEFINITION) 
select name  || '.OLD', TYPE, DESCRIPTION, DEFINITION
    from USER_SDO_STYLES
  where  name = 'L.EXOR.NSG.TP63.20.V.1.1'
/

delete from user_sdo_styles 
 where name = 'L.EXOR.NSG.TP63.20.V.1.1'
/

Insert into USER_SDO_STYLES (NAME,TYPE,DESCRIPTION,DEFINITION) 
values ('L.EXOR.NSG.TP63.20.V.1.1','LINE',
        'DO NOT EDIT - If you wish to change a style please edit a duplicate and use that',
        '<?xml version="1.0" standalone="yes"?> <svg width="1in" height="1in"> <desc></desc> ' ||
        '<g class="line" style="fill:#000000;stroke-width:14.0;stroke-linecap:BUTT"> ' ||
        '<line class="base" style="fill:#FFFFFF;stroke-width:14.0" dash="4.0,4.0" /> </g> </svg>')
/

delete from user_sdo_styles 
 where name = 'L.EXOR.NSG.TP63.21.V.1.1' || '.OLD'
/
 
Insert into USER_SDO_STYLES (NAME,TYPE,DESCRIPTION,DEFINITION) 
select name  || '.OLD', TYPE, DESCRIPTION, DEFINITION
    from USER_SDO_STYLES
  where  name = 'L.EXOR.NSG.TP63.21.V.1.1'
/

delete from user_sdo_styles 
 where name = 'L.EXOR.NSG.TP63.21.V.1.1'
/

Insert into USER_SDO_STYLES (NAME,TYPE,DESCRIPTION,DEFINITION) 
values ('L.EXOR.NSG.TP63.21.V.1.1','LINE',
        'DO NOT EDIT - If you wish to change a style please edit a duplicate and use that',
        '<?xml version="1.0" standalone="yes"?> <svg width="1in" height="1in"> <desc></desc> ' ||
        '<g class="line" style="fill:#990099;stroke-width:14.0;stroke-linecap:BUTT">  ' ||
        '<line class="base" style="fill:#FF00CC;stroke-width:12.0" dash="4.0,4.0" /> </g> </svg>')
/        

delete from user_sdo_styles 
 where name = 'L.EXOR.NSG.TP63.22.V.1.1' || '.OLD'
/
 
Insert into USER_SDO_STYLES (NAME,TYPE,DESCRIPTION,DEFINITION) 
select name  || '.OLD', TYPE, DESCRIPTION, DEFINITION
    from USER_SDO_STYLES
  where  name = 'L.EXOR.NSG.TP63.22.V.1.1'
/

delete from user_sdo_styles 
 where name = 'L.EXOR.NSG.TP63.22.V.1.1'
/

Insert into USER_SDO_STYLES (NAME,TYPE,DESCRIPTION,DEFINITION) 
values ('L.EXOR.NSG.TP63.22.V.1.1','LINE',
        'DO NOT EDIT - If you wish to change a style please edit a duplicate and use that', 
        '<?xml version="1.0" standalone="yes"?> <svg width="1in" height="1in"> <desc></desc> ' ||
        '<g class="line" style="fill:#999999;stroke-width:14.0;stroke-linecap:BUTT"> ' ||
        '<line class="base" style="fill:#FFFF33;stroke-width:14.0" dash="4.0,4.0" /> </g> </svg>')
/


delete from user_sdo_styles 
 where name = 'V.EXOR.NSG.TYPE 63.V.1.1' || '.OLD'
/
 
Insert into USER_SDO_STYLES (NAME,TYPE,DESCRIPTION,DEFINITION) 
select name  || '.OLD', TYPE, DESCRIPTION, DEFINITION
    from USER_SDO_STYLES
  where  name = 'V.EXOR.NSG.TYPE 63.V.1.1'
/

delete from user_sdo_styles 
 where name = 'V.EXOR.NSG.TYPE 63.V.1.1'
/

Insert into USER_SDO_STYLES (NAME,TYPE,DESCRIPTION,DEFINITION) 
values ('V.EXOR.NSG.TYPE 63.V.1.1','ADVANCED',
        'DO NOT EDIT - If you wish to change a style please edit a duplicate and use that',
        '<?xml version="1.0" ?> <AdvancedStyle> <BucketStyle> <Buckets> ' ||
        '<CollectionBucket seq="0" label="Protected Street" type="string" style="L.EXOR.NSG.TP63.1.V.1.1">1</CollectionBucket> ' ||
        '<CollectionBucket seq="1" label="Traffic Sensitivity" type="string" style="L.EXOR.NSG.TP63.2.V.1.1">2</CollectionBucket> ' ||
        '<CollectionBucket seq="2" label="Special Engineering Difficulty" type="string" style="L.EXOR.NSG.TP63.3.V.1.1">3</CollectionBucket> ' ||
        '<CollectionBucket seq="3" label="Street designations do not apply to works" type="string" style="L.EXOR.NSG.TP63.4.V.1.1">4</CollectionBucket> ' ||
        '<CollectionBucket seq="4" label="Proposed Special Engineering Difficulty" type="string" style="L.EXOR.NSG.TP63.6.V.1.1">6</CollectionBucket> ' ||
        '<CollectionBucket seq="5" label="Level Crossing Safety Zone" type="string" style="L.EXOR.NSG.TP63.8.V.1.1">8</CollectionBucket> ' ||
        '<CollectionBucket seq="6" label="Environmentally Sensitve Areas" type="string" style="L.EXOR.NSG.TP63.9.V.1.1">9</CollectionBucket> ' ||
        '<CollectionBucket seq="7" label="Structures (not SED)" type="string" style="L.EXOR.NSG.TP63.10.V.1.1">10</CollectionBucket> ' ||
        '<CollectionBucket seq="8" label="Special Surfaces" type="string" style="L.EXOR.NSG.TP63.11.V.1.1">11</CollectionBucket> ' ||
        '<CollectionBucket seq="9" label="Pipelines" type="string" style="L.EXOR.NSG.TP63.12.V.1.1">12</CollectionBucket> ' ||
        '<CollectionBucket seq="10" label="Priority Lanes" type="string" style="L.EXOR.NSG.TP63.13.V.1.1">13</CollectionBucket> ' ||
        '<CollectionBucket seq="11" label="Special Contruction Needs" type="string" style="L.EXOR.NSG.TP63.14.V.1.1">14</CollectionBucket> ' ||
        '<CollectionBucket seq="12" label="Section 85" type="string" style="L.EXOR.NSG.TP63.15.V.1.1">15</CollectionBucket> ' ||
        '<CollectionBucket seq="13" label="Strategic Route" type="string" style="L.EXOR.NSG.TP63.16.V.1.1">16</CollectionBucket> ' ||
        '<CollectionBucket seq="14" label="Streets Subject to Early Notification of Immediate Activities" type="string" style="L.EXOR.NSG.TP63.17.V.1.1">17</CollectionBucket> ' ||
        '<CollectionBucket seq="15" label="Special Events" type="string" style="L.EXOR.NSG.TP63.18.V.1.1">18</CollectionBucket> ' ||
        '<CollectionBucket seq="16" label="Parking Bays and Restrictions" type="string" style="L.EXOR.NSG.TP63.19.V.1.1">19</CollectionBucket> ' ||
        '<CollectionBucket seq="17" label="Pedestrian Crossings and Traffic Signals" type="string" style="L.EXOR.NSG.TP63.20.V.1.1">20</CollectionBucket> ' ||
        '<CollectionBucket seq="18" label="Speed Limits" type="string" style="L.EXOR.NSG.TP63.21.V.1.1">21</CollectionBucket> ' ||
        '<CollectionBucket seq="19" label="Transport Authority Critical Apparatus" type="string" style="L.EXOR.NSG.TP63.22.V.1.1">22</CollectionBucket> ' ||
        '</Buckets> </BucketStyle> </AdvancedStyle>')
/        

-- L.EXOR.NSG.TP64

delete from user_sdo_styles 
 where name = 'L.EXOR.NSG.TYPE 64.V.1.1' || '.OLD'
/
 
Insert into USER_SDO_STYLES (NAME,TYPE,DESCRIPTION,DEFINITION) 
select name  || '.OLD', TYPE, DESCRIPTION, DEFINITION
    from USER_SDO_STYLES
  where  name = 'L.EXOR.NSG.TYPE 64.V.1.1'
/

delete from user_sdo_styles 
 where name = 'L.EXOR.NSG.TYPE 64.V.1.1'
/

Insert into USER_SDO_STYLES (NAME,TYPE,DESCRIPTION,DEFINITION) 
values ('L.EXOR.NSG.TYPE 64.V.1.1','LINE',
        'DO NOT EDIT - If you wish to change a style please edit a duplicate and use that',
        '<?xml version="1.0" standalone="yes"?> <svg width="1in" height="1in"> <desc></desc> <g class="line" ' ||
        'style="fill:#FF00FF;fill-opacity:247;stroke-width:3.0"> <line class="base" /></g> </svg>')
/

--   DOING THEMES

-- ESU
delete 
   from USER_SDO_THEMES 
  where name = 'ESU_OLD'
/  
   
Insert into USER_SDO_THEMES (NAME,DESCRIPTION,BASE_TABLE,GEOMETRY_COLUMN,STYLING_RULES) 
   select name || '_OLD', DESCRIPTION, BASE_TABLE, GEOMETRY_COLUMN, STYLING_RULES
     from USER_SDO_THEMES 
    where name = 'ESU'
/    
delete 
   from USER_SDO_THEMES 
  where name = 'ESU'
/  

Insert into USER_SDO_THEMES (NAME,DESCRIPTION,BASE_TABLE,GEOMETRY_COLUMN,STYLING_RULES) 
values ('ESU',null,'NM_NSG_ESU_SHAPES','SHAPE',
        '<?xml version="1.0" standalone="yes"?> <styling_rules key_column="NE_ID"> ' ||
        '<rule> <features style="L.EXOR.NSG.ESU.V.1.1"> </features> </rule> </styling_rules>')
/        

-- TYPE 1 AND 2 STREETS
delete 
   from USER_SDO_THEMES 
  where name = 'TYPE 1 AND 2 STREETS_OLD'
/  
   
Insert into USER_SDO_THEMES (NAME,DESCRIPTION,BASE_TABLE,GEOMETRY_COLUMN,STYLING_RULES) 
   select name || '_OLD', DESCRIPTION, BASE_TABLE, GEOMETRY_COLUMN, STYLING_RULES
     from USER_SDO_THEMES 
    where name = 'TYPE 1 AND 2 STREETS';
/    
delete 
   from USER_SDO_THEMES 
  where name = 'TYPE 1 AND 2 STREETS'
/  

Insert into USER_SDO_THEMES (NAME,DESCRIPTION,BASE_TABLE,GEOMETRY_COLUMN,STYLING_RULES) 
values ('TYPE 1 AND 2 STREETS','OFFN STREETS' ,'V_NM_NAT_NSGN_OFFN_SDO_DT','GEOLOC',
        '<?xml version="1.0" standalone="yes"?> <styling_rules key_column="OBJECTID"> <rule> ' ||
        '<features style="L.EXOR.NSG.OFFN.V.1.1"> </features> ' ||
        '<label column="NE_DESCR" style="T.EXOR.NSG.ROAD_NAME.V.1.1"> 1 </label> </rule> </styling_rules>')
/

-- TYPE 3 STREETS
delete 
   from USER_SDO_THEMES 
  where name = 'TYPE 3 STREETS_OLD'
/  
   
Insert into USER_SDO_THEMES (NAME,DESCRIPTION,BASE_TABLE,GEOMETRY_COLUMN,STYLING_RULES) 
   select name || '_OLD', DESCRIPTION, BASE_TABLE, GEOMETRY_COLUMN, STYLING_RULES
     from USER_SDO_THEMES 
    where name = 'TYPE 3 STREETS';
/    
delete 
   from USER_SDO_THEMES 
  where name = 'TYPE 3 STREETS'
/  

Insert into USER_SDO_THEMES (NAME,DESCRIPTION,BASE_TABLE,GEOMETRY_COLUMN,STYLING_RULES) 
values ('TYPE 3 STREETS','RDNM STREETS','V_NM_NAT_NSGN_RDNM_SDO_DT','GEOLOC',
        '<?xml version="1.0" standalone="yes"?> <styling_rules key_column="OBJECTID"> <rule> ' ||
        '<features style="L.EXOR.NSG.RDNM.V.1.1"> </features> </rule> </styling_rules>')
/

-- TYPE 4 STREETS
delete 
   from USER_SDO_THEMES 
  where name = 'TYPE 4 STREETS_OLD'
/  
   
Insert into USER_SDO_THEMES (NAME,DESCRIPTION,BASE_TABLE,GEOMETRY_COLUMN,STYLING_RULES) 
   select name || '_OLD', DESCRIPTION, BASE_TABLE, GEOMETRY_COLUMN, STYLING_RULES
     from USER_SDO_THEMES 
    where name = 'TYPE 4 STREETS';
/    
delete 
   from USER_SDO_THEMES 
  where name = 'TYPE 4 STREETS'
/  

Insert into USER_SDO_THEMES (NAME,DESCRIPTION,BASE_TABLE,GEOMETRY_COLUMN,STYLING_RULES) 
values ('TYPE 4 STREETS','UOFF STREETS','V_NM_NAT_NSGN_UOFF_SDO_DT','GEOLOC',
        '<?xml version="1.0" standalone="yes"?> <styling_rules key_column="OBJECTID"> <rule> ' ||
        '<features style="L.EXOR.NSG.UOFF.V.1.1"> </features> </rule> </styling_rules>')
/

delete 
   from USER_SDO_THEMES 
  where name in ('TYPE 61_OLD', 'TYPE 62_OLD', 'TYPE 63_OLD', 'TYPE 64_OLD')
/  

Insert into USER_SDO_THEMES (NAME,DESCRIPTION,BASE_TABLE,GEOMETRY_COLUMN,STYLING_RULES) 
   select name || '_OLD', DESCRIPTION, BASE_TABLE, GEOMETRY_COLUMN, STYLING_RULES
     from USER_SDO_THEMES 
    where name in ('TYPE 61','TYPE 62','TYPE 63','TYPE 64')
/    

delete 
   from USER_SDO_THEMES 
  where name in ('TYPE 61','TYPE 62','TYPE 63','TYPE 64')
/  

-- TYPE 61,62,63 and 64

Insert into USER_SDO_THEMES (NAME,DESCRIPTION,BASE_TABLE,GEOMETRY_COLUMN,STYLING_RULES) 
   values ('TYPE 61',null,'V_NM_NIT_TP21_SDO_DT','GEOLOC',
           '<?xml version="1.0" standalone="yes"?> ' ||
           '<styling_rules key_column="OBJECTID"> ' ||
           '<rule column="TP21_ROAD_STATUS"> ' ||
           '<features style="V.EXOR.NSG.TYPE 61.V.1.1"> </features> ' ||
           '</rule> </styling_rules>')
/          

Insert into USER_SDO_THEMES (NAME,DESCRIPTION,BASE_TABLE,GEOMETRY_COLUMN,STYLING_RULES) 
   values ('TYPE 62',null,'V_NM_NIT_TP22_SDO_DT','GEOLOC',
           '<?xml version="1.0" standalone="yes"?> ' ||
           '<styling_rules key_column="OBJECTID"> ' ||
           '<rule column="TP22_REINSTATEMENT"> ' ||
           '<features style="V.EXOR.NSG.TYPE 62.V.1.1"> </features> ' ||
           '</rule> </styling_rules>')
/

Insert into USER_SDO_THEMES (NAME,DESCRIPTION,BASE_TABLE,GEOMETRY_COLUMN,STYLING_RULES) 
   values ('TYPE 63',null,'V_NM_NIT_TP23_SDO_DT','GEOLOC',
           '<?xml version="1.0" standalone="yes"?> ' ||
           '<styling_rules key_column="OBJECTID"> ' ||
           '<rule column="TP23_DESIG_CODE"> ' ||
           '<features style="V.EXOR.NSG.TYPE 63.V.1.1"> </features> ' ||
           '</rule> </styling_rules>')
/           

           
Insert into USER_SDO_THEMES (NAME,DESCRIPTION,BASE_TABLE,GEOMETRY_COLUMN,STYLING_RULES) 
   values ('TYPE 64',null,'V_NM_NIT_TP64_SDO_DT','GEOLOC',
           '<?xml version="1.0" standalone="yes"?> ' ||
           '<styling_rules key_column="TP64_IIT_NE_ID"> ' ||
           '<rule> <features style="L.EXOR.NSG.TYPE 64.V.1.1"> ' ||
           '</features> </rule> </styling_rules>')
/
           
commit
/
           
spool off
           