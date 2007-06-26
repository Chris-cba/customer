--   SCCS Identifiers :-
--
--       sccsid           : @(#)xrta_roadloc_interface_grants.sql	1.1 03/15/05
--       Module Name      : xrta_roadloc_interface_grants.sql
--       Date into SCCS   : 05/03/15 23:05:29
--       Date fetched Out : 07/06/06 14:39:32
--       SCCS Version     : 1.1
--
--   ROADLOC audit interface code
--
-----------------------------------------------------------------------------
--   Copyright (c) exor corporation ltd, 2002
-----------------------------------------------------------------------------
grant select on RRL_LA_AUD to nm3query;

grant select on RRL_LA_REL_AUD to nm3query;

grant select on RRL_LCWY_AUD to nm3query;

grant select on RRL_LCWY_IN_LA_AUD to nm3query;

grant select on RRL_LCWY_LC_CLASS_AUD to nm3query;

grant select on RRL_RF_ON_LCWY_AUD to nm3query;

grant select on RRL_RF_TYPE_AUD to nm3query;

grant select on RRL_ROAD_AUD to nm3query;

grant select on RRL_SECT_AUD to nm3query;

grant delete on RRL_LA_AUD to nm3query;

grant delete on RRL_LA_REL_AUD to nm3query;

grant delete on RRL_LCWY_AUD to nm3query;

grant delete on RRL_LCWY_IN_LA_AUD to nm3query;

grant delete on RRL_LCWY_LC_CLASS_AUD to nm3query;

grant delete on RRL_RF_ON_LCWY_AUD to nm3query;

grant delete on RRL_RF_TYPE_AUD to nm3query;

grant delete on RRL_ROAD_AUD to nm3query;

grant delete on RRL_SECT_AUD to nm3query;

