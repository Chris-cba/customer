@echo off
set sfa_exe_dir=C:\Users\joe.mendoza\Documents\Visual Studio 2012\Projects\ODOT_Signs_Project\ODOT_Signs_Project\bin\Debug\

rem ----------------------------

call sfa_x_copy.bat

"%sfa_exe_dir%ODOT_Signs_Project.exe"


start notepad.exe "%sfa_exe_dir%config\current_sync_logfile.txt"

start sfa_after_commands.bat

exit