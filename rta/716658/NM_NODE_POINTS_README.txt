-----Install-----

1. Unzip the folder onto your C drive using extraction software.
The rest of the example will assume the folder is C:/NODE_POINTS_716658

2.Start SQLPLUS in NODE_POINTS_716658 directory.
C:\ NODE_POINTS_716658>sqlplus

SQL*Plus: Release 10.2.0.1.0 - Production on Mon Mar 9 17:01:39 2009
Copyright (c) 1982, 2005, Oracle.  All rights reserved.

3. Enter user-name: username/password@database

4. Run the Create Script
SQL> @C:\NODE_POINTS_716658\CREATE_NM_NODE_POINTS_716658.sql;

5. Drop the attached FMX (nm0101.fmx) into your bin directory.




