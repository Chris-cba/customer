-----Install-----

Complete the following steps to install the error tracker.

1. Unzip the folder onto your C drive using extraction software.
The rest of the example will assume the folder is C:/XRTA_LOG_708593

2.Open Command Prompt 
Start>>All Programs>>Accessories>>Command Prompt

3. Got to the folder
C:\Documents and Settings\USERNAME>cd..
C:\Documents and Settings>cd..
C:\>cd XRTA_LOG_708593
C:\XRTA_LOG_708593>

4.Start SQLPLUS
C:\XRTA_LOG_708593>sqlplus

SQL*Plus: Release 10.2.0.1.0 - Production on Mon Mar 9 17:01:39 2009
Copyright (c) 1982, 2005, Oracle.  All rights reserved.
Enter user-name: username/password@database

5 (create). Run the Create Script
SQL> @C:\XRTA_LOG_708593\XRTA_CREATE_LOG_708593.sql

The error trapping packages are now on your database. Any caught errors can be viewed in the XRTA_ERRORS table.

-----Remove-------

One you have completed the test and wish to remove the files from you database follow steps 2 to 4 again and the extra step below.

5 (remove). Run the removal script.
SQL> @C:\XRTA_LOG_708593\XRTA_DROP_LOG_708593.sql

All data and files have been removed.





