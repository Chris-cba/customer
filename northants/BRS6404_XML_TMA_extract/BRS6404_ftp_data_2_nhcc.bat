REM -----------------------------------------------------------------------------
REM --
REM --   PVCS Identifiers :-
REM --
REM --   pvcsid       : $Header:   //vm_latest/archives/customer/northants/BRS6404_XML_TMA_extract/BRS6404_ftp_data_2_nhcc.bat-arc   1.0   Oct 12 2011 15:29:48   Ian.Turnbull  $
REM --   Module Name      : $Workfile:   BRS6404_ftp_data_2_nhcc.bat  $
REM --   Date into PVCS   : $Date:   Oct 12 2011 15:29:48  $
REM --   Date fetched Out : $Modtime:   Oct 10 2011 15:34:54  $
REM --   PVCS Version     : $Revision:   1.0  $
REM --   Author : Aileen Heal
REM -----------------------------------------------------------------------------
REM --    Copyright: (c) 2011 Bentley Systems, Incorporated. All rights reserved.
REM -----------------------------------------------------------------------------
ftp -i -s:send_data_2_nhcc.run
move *.xml SENT
exit
