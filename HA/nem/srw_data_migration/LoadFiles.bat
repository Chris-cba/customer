rem-------------------------------------------------------------------------
rem--   PVCS Identifiers :-
rem--
rem--       PVCS id          : $Header:   //new_vm_latest/archives/customer/HA/nem/srw_data_migration/LoadFiles.bat-arc   3.0   Apr 22 2015 13:54:34   Mike.Huitson  $
rem--       Module Name      : $Workfile:   LoadFiles.bat  $
rem--       Date into PVCS   : $Date:   Apr 22 2015 13:54:34  $
rem--       Date fetched Out : $Modtime:   Apr 22 2015 14:55:30  $
rem--       Version          : $Revision:   3.0  $
rem--       Based on SCCS version :
rem------------------------------------------------------------------
rem--   Copyright (c) 2015 Bentley Systems Incorporated. All rights reserved.
rem------------------------------------------------------------------
rem--
for /f %%a IN ('dir /b SRW*_CF_*.csv') do call sqlldr control=load_srw_data.ctl userid=<username>/<password>@<sid> data='%%a' log='log\%%a.log' bad='bad\%%a.bad' discard='bad\%%a.dsc'

pause