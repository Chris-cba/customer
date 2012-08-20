create or replace procedure x_lbth_export_tma_as_xml( pi_file_dir IN varchar2, pi_file_name IN varchar2, pi_URL IN VARCHAR2 )
--
-----------------------------------------------------------------------------
--
--   PVCS Identifiers :-
--
--       pvcsid           : $Header:   //vm_latest/archives/customer/lbth/tma extract/x_lbth_export_tma_as_xml.prc-arc   1.0   Aug 20 2012 09:09:46   Ian.Turnbull  $
--       Module Name      : $Workfile:   x_lbth_export_tma_as_xml.prc  $
--       Date into PVCS   : $Date:   Aug 20 2012 09:09:46  $
--       Date fetched Out : $Modtime:   Aug 13 2012 09:40:48  $
--       PVCS Version     : $Revision:   1.0  $
--
--   Author : Aileen Heal
--
-----------------------------------------------------------------------------
--    Copyright: (c) 2012 Bentley Systems, Incorporated. All rights reserved.
-----------------------------------------------------------------------------
-- this procedure will create the TMA XML export file for LBTH
-- it require a view called V_X_LBTH_TMA_EXTRACT.
-- the output directory must exist otherwise an error is thrown
--
as
 fHandler UTL_FILE.FILE_TYPE;
 v_org_ref  NSG_ORGANISATIONS.ORG_REF%TYPE;
 v_org_name NSG_ORGANISATIONS.ORG_NAME%TYPE;
 v_notice_id TMA_NOTICES.TNOT_NOTICE_ID%TYPE;
 CURSOR cur_noticeID (ref VARCHAR2, no NUMBER ) IS
          select TNOT_NOTICE_ID
            from tma_notices
         where TNOT_WORKS_REF = ref 
             and TNOT_PHASE_NO = no
             and tnot_notice_type in ('0200', '0210' )
     order by  tnot_notice_seq desc;
BEGIN
  select nud_org_ref 
      into v_org_ref
    from nsg_user_districts 
  where nud_username = 'TMAWS'
     and NUD_DEFAULT = 'Y';
--     
  select org_name 
     into v_org_name
    from nsg_organisations 
 where org_ref = v_org_ref;
--  
  nm_debug.debug( 'XXXAH TMA EXTRACT: directory: ' || pi_file_dir );
  nm_debug.debug( 'XXXAH TMA EXTRACT: XML file_name: ' || pi_file_dir );
  begin
      fHandler := UTL_FILE.FOPEN(pi_file_dir, pi_file_name, 'w', 30000);
  EXCEPTION
  WHEN utl_file.invalid_path THEN
     nm_debug.debug( 'XXXAH TMA EXTRACT: Invalid path for file name'  ||  pi_file_name );
     raise_application_error(-20000, 'Invalid path. Create directory or set UTL_FILE_DIR.');
  WHEN OTHERS THEN
    nm_debug.debug( 'XXXAH TMA EXTRACT: Unexpected error opening file: ' ||SQLERRM||' -ERROR- '||SQLERRM);
    RAISE;
  END; 
  -- write the header to the file
  UTL_FILE.PUT_LINE(fHandler, '<?xml version="1.0" encoding="utf-8" ?>' );
  UTL_FILE.PUT_LINE(fHandler, '<n1:RoadEventList xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:sch="http://www.ascc.net/xml/schematron" xmlns:bs7666="http://www.govtalk.gov.uk/people/bs7666" xmlns:osgb="http://www.ordnancesurvey.co.uk/xml/namespaces/osgb" xmlns:n2="http://www.govtalk.gov.uk/CM/gms-xs" xmlns:q1="http://www.w3.org/2001/XMLSchema" xmlns:gml="http://www.opengis.net/gml" xmlns:xlink="http://www.w3.org/1999/xlink" xmlns:apd="http://www.govtalk.gov.uk/people/AddressAndPersonalDetails" xmlns:core="http://www.govtalk.gov.uk/core" xmlns:pdt="http://www.govtalk.gov.uk/people/PersonDescriptives" xmlns:gms="http://www.govtalk.gov.uk/CM/gms" xmlns:n1="http://schemas.elgin.gov.uk/sdep/roadevents" ' );
  UTL_FILE.PUT_LINE( fHandler, 'DateTimeGenerated="' || TO_CHAR(sysdate,'YYYY-MM-DD') || 'T' ||TO_CHAR(sysdate,'HH24:MI:SS') || '" IsChangeOnly="false" OrganisationID="' || v_org_ref ||'" ServiceURL="' || pi_URL || '">');

  for rec in (select * from V_X_LBTH_TMA_EXTRACT )
  loop
    open cur_noticeID (rec.OrgEventReference, rec.PhaseNumber);
    --
    UTL_FILE.PUT_LINE( fHandler, '<RoadEvent LastModified="' || TO_CHAR(rec.LastModified,'YYYY-MM-DD') || 'T' ||TO_CHAR(rec.LastModified,'HH24:MI:SS')   ||'">' );
    UTL_FILE.PUT_LINE( fHandler, '<Description>' ||X_LBTH_XML_SPECIAL_CHARS(rec.Description) || '</Description>' ); -- description
    UTL_FILE.PUT_LINE( fHandler, '<Cause><Roadworks> Roadworks </Roadworks></Cause>'); -- aways roadwork
    --
    -- ResponsibleAuthority
    -- need to find out the responsible authority. Can only do this from the notice receiptient of type 1 of the 0200 or 0201 notices
    FETCH cur_noticeID into v_notice_id;
    if cur_noticeID%NOTFOUND THEN
       nm_debug.debug( 'XXXAH TMA EXTRACT error - Could not find notice for ' || rec.OrgEventReference || ' phase no ' || rec.PhaseNumber );
    end if;
    close cur_noticeID;  
    --   
    -- now get org_ref for recipient_type = 1 for notice
       select ttre_org_ref 
          into v_org_ref
        from TMA_TRANSACTION_RECIPIENTS 
     where ttre_notice_id = v_notice_id 
         and ttre_recipient_type = 1; 
    --
    -- now get org_name       
     select org_name 
        into v_org_name
       from nsg_organisations 
    where org_ref = v_org_ref;
    -- 
    UTL_FILE.PUT_LINE( fHandler, '<ResponsibleAuthority> ' ); 
    UTL_FILE.PUT_LINE( fHandler, '<OrganisationName>' || v_org_name || '</OrganisationName>' ); 
    UTL_FILE.PUT_LINE( fHandler, '<OrganisationID>' || v_org_ref || '</OrganisationID>'); 
    UTL_FILE.PUT_LINE( fHandler, '</ResponsibleAuthority>');
    --
    -- Originator
    UTL_FILE.PUT_LINE( fHandler, '<Originator>' ); 
    UTL_FILE.PUT_LINE( fHandler, '<OrganisationName>' || rec.PromoterName ||  '</OrganisationName>' );
    UTL_FILE.PUT_LINE( fHandler, '<OrganisationID>' ||rec.OrgRef  ||'</OrganisationID>');
    UTL_FILE.PUT_LINE( fHandler, '<OrganisationSectionName>' || X_LBTH_XML_SPECIAL_CHARS(rec.OrgDistName) || '</OrganisationSectionName>');
    UTL_FILE.PUT_LINE( fHandler, '<OrganisationSectionID>' || rec.OrgDistRef  || '</OrganisationSectionID>');
    UTL_FILE.PUT_LINE( fHandler, '<Contact>');
    UTL_FILE.PUT_LINE( fHandler, '<Name>' );
    UTL_FILE.PUT_LINE( fHandler, '<CitizenNameSurname>' || rec.PromoterName || '</CitizenNameSurname>' );
    UTL_FILE.PUT_LINE( fHandler, '<CitizenNameRequestedName /> ' );
    UTL_FILE.PUT_LINE( fHandler, '</Name> ' );
    UTL_FILE.PUT_LINE( fHandler, '<ContactDetails> ' );
    UTL_FILE.PUT_LINE( fHandler, '<Telephone TelUse="work" TelMobile="yes" TelPreferred="yes">' );
    UTL_FILE.PUT_LINE( fHandler, '<apd:TelNationalNumber>' || rec.PromoterTelNo ||'</apd:TelNationalNumber>' );
    UTL_FILE.PUT_LINE( fHandler, '</Telephone> ' );
    UTL_FILE.PUT_LINE( fHandler, '</ContactDetails>' );
    UTL_FILE.PUT_LINE( fHandler, '</Contact>' );
    UTL_FILE.PUT_LINE( fHandler, '</Originator>' );
    -- OriginatorEventReference
    UTL_FILE.PUT_LINE( fHandler, '<OriginatorEventReference>' || rec.OrgEventReference || '</OriginatorEventReference>' );
    -- Location
    UTL_FILE.PUT_LINE( fHandler, '<Location> ' ); 
    UTL_FILE.PUT_LINE( fHandler, '<LocationDescription>' ||X_LBTH_XML_SPECIAL_CHARS(rec.LocationDescription) || '</LocationDescription> ' );
    UTL_FILE.PUT_LINE( fHandler, rec.START_DATIM );
    UTL_FILE.PUT_LINE( fHandler, rec.END_DATIM );
    UTL_FILE.PUT_LINE( fHandler,  '<TrafficManagementCode>' || rec.TrafficManagementCode || '</TrafficManagementCode>' ); -- extra for NHCC
    UTL_FILE.PUT_LINE( fHandler,  '<CarriagewayRestriction>' || rec.CarriagewayRestriction || '</CarriagewayRestriction>' );
    UTL_FILE.PUT_LINE( fHandler,  '<FootwayClosure>' || rec.FootwayClosure  || '</FootwayClosure>' );
    UTL_FILE.PUT_LINE( fHandler,  '<ParkingSuspensions>' ||  rec.ParkingSuspensions || '</ParkingSuspensions>' );
    UTL_FILE.PUT_LINE( fHandler, replace (rec.GeometryAsGML, 'xmlns:gml="http://www.opengis.net/gml"') ); -- remove gml name space as in header
    UTL_FILE.PUT_LINE( fHandler,'<USRN>' || rec.USRN || '</USRN>' );
    UTL_FILE.PUT_LINE( fHandler,'<StreetName>' || rec.StreetName || '</StreetName>' ); -- extra for NHCC
    UTL_FILE.PUT_LINE( fHandler,'<Town>' || rec.Town || '</Town>' ); -- extra for NHCC
    UTL_FILE.PUT_LINE( fHandler,'<OutOfHours>' || rec.OutOfHours || '</OutOfHours>' );
    UTL_FILE.PUT_LINE( fHandler, '<Diversion>false</Diversion>' );  -- don't hold in exor so default is false
    UTL_FILE.PUT_LINE( fHandler, '</Location> ' );  
    -- end location
    UTL_FILE.PUT_LINE( fHandler, '<Cancelled>False</Cancelled>' ); -- never cancelled
    UTL_FILE.PUT_LINE( fHandler, '<PlannedStatus>Scheduled</PlannedStatus>' ); -- always scheduled
    UTL_FILE.PUT_LINE( fHandler, '<WorksStatus>' || rec.WorksStatus || '</WorksStatus>' ); -- extra for NHCC
    UTL_FILE.PUT_LINE( fHandler, '<WorksCategory>' || rec.WorksCategory || '</WorksCategory>' ); -- extra for NHCC
    UTL_FILE.PUT_LINE( fHandler, '</RoadEvent>' );    
  end loop;
  -- end of list
  UTL_FILE.PUT_LINE( fHandler,  '</n1:RoadEventList>' );
  -- close file
  UTL_FILE.FCLOSE(fHandler); 
  nm_debug.debug( 'XXXAH TMA EXTRACT: XML finished ' );
END;
/ 