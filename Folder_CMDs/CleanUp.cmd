
REM https://www.instructables.com/DIY-Small-Tool-to-Clean-Your-Pc/

@echo off
CLS
Title  "Clean up  temp files"
COLOR 0a  

:mainmenu 
cls 

echo ********************* 
echo * CleanUp Menu*
echo ********************* 
echo.
echo * 1. Start CleanUp * 
echo * 2. About CleanUp* 
echo * 3. Quit * 
echo.
echo ********************* 

set /p choice=Type 1, 2, or 3, then press ENTER:  

if not '%choice%'=='' set choice=%choice:~0,1%
if %CHOICE%==1 GOTO start
if %CHOICE%==2 GOTO about
if %CHOICE%==3 GOTO quit


ECHO "%CHOICE%" is not valid, try again
ECHO.

REM choice /C:123 >nul
REM if %errorlevel% equ 1 goto start if %errorlevel% equ 2 goto about if %errorlevel% equ 3 goto exit



REM closes the program
:quit 
exit /b

REM starts the clean up
:start

echo Cleaning system junk files, please wait…
REM displays a line of text

del /f /s /q %systemdrive%\*.tmp
del /f /s /q %systemdrive%\*._mp
del /f /s /q %systemdrive%\*.log
del /f /s /q %systemdrive%\*.gid
del /f /s /q %systemdrive%\*.chk
del /f /s /q %systemdrive%\*.old
del /f /s /q %systemdrive%\recycled\*.*
del /f /s /q %windir%\*.bak
del /f /s /q %windir%\prefetch\*.*
rd /s /q %windir%\temp & md %windir%\temp
del /f /q %userprofile%\cookies\*.*
del /f /q %userprofile%\recent\*.*
del /f /s /q “%userprofile%\Local Settings\Temporary Internet Files\*.*”
del /f /s /q “%userprofile%\Local Settings\Temp\*.*”
del /f /s /q “%userprofile%\recent\*.*”

REM /f: force deleting of read-only files
REM /s: Delete specified files from all subdirectories.
REM /q: Quiet mode, do not ask if ok to delete on global wildcard
REM %systemdrive%: drive upon which the system folder was placed
REM %windir%: a regular variable and is defined in the variable store as %SystemRoot%. 
REM %userprofile%: variable to find the directory structure owned by the user running the process

echo Cleaning of junk files is finished!
REM displays a line of text

echo. & pause
REM echo.: Displays a single blank line on the screen.
REM pause: This will stop execution of the batch file until someone presses "any key"

pause 
GOTO mainmenu 

REM shows info
:about
echo.
echo ************************************
echo * This batch file deletes most* 
echo * commen temp files stored on* 
echo * the windows install directory*
echo *
echo * Written by Kevin Tipker 28/02/2016*
echo * modified by Hanzhou Wang 01/05/2022

echo.
echo ***************************************
echo The list of files to be deleted
echo %systemdrive%\*.tmp
echo %systemdrive%\*._mp
echo %systemdrive%\*.log
echo %systemdrive%\*.gid
echo %systemdrive%\*.chk
echo %systemdrive%\*.old
echo %systemdrive%\recycled\*.*
echo %windir%\*.bak
echo %windir%\prefetch\*.*
echo %windir%\temp & md %windir%\temp
echo %userprofile%\cookies\*.*
echo %userprofile%\recent\*.*
echo “%userprofile%\Local Settings\Temporary Internet Files\*.*”
echo “%userprofile%\Local Settings\Temp\*.*”
echo “%userprofile%\recent\*.*”
echo ************************************
echo.
pause
GOTO mainmenu

