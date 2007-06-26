--
-----------------------------------------------------------------------------
--
--   SCCS Identifiers :-
--
--       sccsid           : %W% %G%
--       Module Name      : %M%
--       Date into SCCS   : %E% %U%
--       Date fetched Out : %D% %T%
--       SCCS Version     : %I%
--
--
--   Author : Ian Turnbull
--
-----------------------------------------------------------------------------
--	Copyright (c) exor corporation ltd, 2007
-----------------------------------------------------------------------------
--
Work Extract

Exor 16 April 2007

Ian Turnbull

Files
wo_extract_read_me.txt - This file
wo_extract.bat - This is the file calls sqlplus
wo_extract.sql - This file does the extract

Assumptions
Runinng the database in a Microsoft Windows environment.
The Contractor used for Work Order extract is 'RAY'


Installation
1) Copy the additional files to directory on the database server.
    e.g. c:\exor\wo_extract

2) Edit the wo_extract.sql file and change the following line so that it will connect to your highways database.
   connect username/password@database
   e.g.
   connect highways/highways@hwlv

3) create a scheduled task from the control panel and schedule the wo_extract.bat file to run at the required interval


What it does

The wo_extract.bat file calls sqlplus and executes the  wo_extract.sql file.
The wo_extract file run the work order extract for the specified contractor.
Work order extract files are written to the directory indeicated by the INTERPATH user option.
A log file wo_extract.log is created giving details of when it has been run and the name of the file produced.


   