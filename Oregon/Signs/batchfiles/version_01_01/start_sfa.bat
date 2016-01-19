@echo off
rem ---------------------------- Set the variables here
set sfa_exe_dir=C:\Users\joe.mendoza\Documents\Visual Studio 2012\Projects\ODOT_Signs_Project\ODOT_Signs_Project\bin\batchtest
set sfa_network_files=C:\Users\joe.mendoza\Documents\Visual Studio 2012\Projects\ODOT_Signs_Project\ODOT_Signs_Project\bin\Debug

rem ----------------------------

call sfa_x_copy.bat  "%sfa_network_files%" "%sfa_exe_dir%"

"%sfa_exe_dir%\Sign_Broker.exe" /s


start notepad.exe "%sfa_exe_dir%\config\current_sync_logfile.txt"

start sfa_after_commands.bat

exit