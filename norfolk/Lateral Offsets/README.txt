-------------------------------------------------------------------------
--   PVCS Identifiers :-
--
--       PVCS id          : $Header:   //vm_latest/archives/customer/norfolk/Lateral Offsets/README.txt-arc   3.0   Dec 20 2010 10:44:16   Ade.Edwards  $
--       Module Name      : $Workfile:   README.txt  $
--       Date into PVCS   : $Date:   Dec 20 2010 10:44:16  $
--       Date fetched Out : $Modtime:   Dec 20 2010 10:26:06  $
--       Version          : $Revision:   3.0  $
--
--       Author : Chris Strettle
--
-----------------------------------------------------------------------------
--  Copyright (c) Bentley Systems, 2010
-----------------------------------------------------------------------------
--
README File

The zip folder contains the following for you to run.

=== install_metadata.sql ===
This file creates the temp metadata tables. 
Run First.

=== evaluation_views.sql ===
This file creates the tables and views that show the invalid subclass/xsp combinations on your database.

It will create the following.

 The following show all invalid XSP/SUBCLASS combinations.
 xsp_invalid_temp -- With ids
 xsp_invalid_summary_temp -- a summary with counts
 
Run Second. 

You will then need to fix the incorrect data.

=== add_data.sql ===
This will transfer the new XSP/Subclass logic into the EXOR tables

=== subclass_update.sql ===
This will update the subclass information in nm_elements_all and clear then out of nm_inv_items_all.
Run Third

=== remove_metadata.sql ===
This is an optional script that will remove the HERM attribute and attribute data.
Optionally run Fourth

=== clean_up.sql ===
This will remove the temp objects created and enable triggers disabled by the above scripts.
Run Last

If you have any issues with these scripts then please contact me @ chris.strettle@bentley.com