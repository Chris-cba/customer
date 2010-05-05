--
-----------------------------------------------------------------------------
--
--   PVCS Identifiers :-
--
--       pvcsid           : $Header:   //vm_latest/archives/customer/General Scripts/tma_traffic_themes/README.TXT-arc   1.0   May 05 2010 15:57:36   iturnbull  $
--       Module Name      : $Workfile:   README.TXT  $
--       Date into PVCS   : $Date:   May 05 2010 15:57:36  $
--       Date fetched Out : $Modtime:   May 05 2010 12:22:50  $
--       PVCS Version     : $Revision:   1.0  $
--       Based on SCCS version :
--
--   Author : Aileen Heal
--
-----------------------------------------------------------------------------
--    Copyright (c) exor corporation ltd, 2010
-----------------------------------------------------------------------------
--
These scripts create the 3 TMA point themes 'TMA FWD PLAN', 'TMA PROP IN PROGRESS' & 'TMA WORKS COMPLETE'

1. load the styles (TMA_traffic_restriction.dat) using MapBuilder
2. Create the 4 views V_X_TMA_WORKS_ACTIVE_PHASE, V_X_TMAPHS_FWD_PLAN_SDOPT, V_X_TMAPHS_PROPINPROG_SDOPT and V_X_TMAPHS_WKS_COMPLETE_SDOPT by running the appropriate scripts.
3. Create the themes by running the scripts TMA_FWD_PLAN.sql, TMA_PROP_IN_PROGRESS.sql and TMA_WORKS_COMPLETE.SQL.

