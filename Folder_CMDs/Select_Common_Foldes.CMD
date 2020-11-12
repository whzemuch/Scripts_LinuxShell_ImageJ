ECHO OFF
CLS
Title  "Select a folder to go"
COLOR 0a  
REM refer to: https://ss64.com/nt/color.html

:MENU
ECHO.
ECHO ..........................................................
ECHO.
ECHO PRESS 1, 2 OR 3 to select your task, or 4 to EXIT.
ECHO ..........................................................
ECHO.
ECHO 	1 - Go to the folder  for Yeh Lab
ECHO.
ECHO 	2 - Go to the folder  for Chen Lab  
ECHO.
ECHO 	3 - Go to the folder  for Kamat Lab
ECHO.
ECHO 	4 - EXIT
ECHO.

set /p choice=Type 1, 2, 3, or 4 then press ENTER:  

if not '%choice%'=='' set choice=%choice:~0,1%
if %CHOICE%==1 GOTO Yeh_Lab
if %CHOICE%==2 GOTO Chen_Lab
if %CHOICE%==3 GOTO Kamat_Lab
if %CHOICE%==4 GOTO EOF

ECHO "%CHOICE%" is not valid, try again
ECHO.


:Yeh_Lab
start \\comp-srvr147142\tranfer\Zhang_Research
GOTO MENU

:Kamat_Lab
rem cd %windir%\system32\cmd.exe
start  \\mcfs.win.uthscsa.edu\LINKS\Geriatrics\Projects\KamatLab  
GOTO MENU

:Chen_Lab
rem cd %windir%\system32\cmd.exe
start \\comp-srvr147142\tranfer\Chen_ECM\Experiments
GOTO MENU






REM:             K:        \\mcfs.win.uthscsa.edu\LINKS\Geriatrics\Projects\KamatLab 
                                                
REM:             T:        \\comp-srvr147142\tranfer Microsoft Windows Network
