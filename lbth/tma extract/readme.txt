--
-----------------------------------------------------------------------------
--
--   PVCS Identifiers :-
--
--       pvcsid           : $Header:   //vm_latest/archives/customer/lbth/tma extract/readme.txt-arc   1.0   Aug 20 2012 09:09:42   Ian.Turnbull  $
--       Module Name      : $Workfile:   readme.txt  $
--       Date into PVCS   : $Date:   Aug 20 2012 09:09:42  $
--       Date fetched Out : $Modtime:   Aug 13 2012 10:10:14  $
--       PVCS Version     : $Revision:   1.0  $
--
--   Author : Aileen Heal
--
-----------------------------------------------------------------------------
--    Copyright: (c) 2012 Bentley Systems, Incorporated. All rights reserved.
-----------------------------------------------------------------------------
This collection of functions, view and procedure are uses to create the TMA XML extract file for London Borough of Tower Hamlets.

To install the code run the script install.sql

To generate the file call the procedure x_lbth_export_tma_as_xml.
1: location to put the resultant xml file
2: name for the xml file
3: URL to be used in XML file

e.g.
begin
nm_debug.debug_on;
x_lbth_export_tma_as_xml('c:\temp\lbth','roadworks.xml', 'http://www.towerhamlets.gov.uk/');
nm_debug.debug_off;
end;
