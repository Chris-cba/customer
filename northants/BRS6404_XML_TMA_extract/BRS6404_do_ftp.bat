REM -----------------------------------------------------------------------------
REM --
REM --   PVCS Identifiers :-
REM --
REM --   pvcsid           : $Header:   //vm_latest/archives/customer/northants/BRS6404_XML_TMA_extract/BRS6404_do_ftp.bat-arc   1.0   Oct 12 2011 15:29:46   Ian.Turnbull  $
REM --   Module Name      : $Workfile:   BRS6404_do_ftp.bat  $
REM --   Date into PVCS   : $Date:   Oct 12 2011 15:29:46  $
REM --   Date fetched Out : $Modtime:   Oct 10 2011 15:35:46  $
REM --   PVCS Version     : $Revision:   1.0  $
REM --  Author : Aileen Heal
-----------------------------------------------------------------------------
--    Copyright: (c) 2011 Bentley Systems, Incorporated. All rights reserved.
-----------------------------------------------------------------------------

set sd=%date%
set st=%time%
set LogFile=.\log\%sd:~0,2%%sd:~3,2%%sd:~6,4%%st:~0,2%%st:~3,2%%st:~6,2%.log
D:
cd D:\databases\NHSWM\NHSWMTMAEXTRACT
brs6404_ftp_data_2_nhcc.bat >%logfile%