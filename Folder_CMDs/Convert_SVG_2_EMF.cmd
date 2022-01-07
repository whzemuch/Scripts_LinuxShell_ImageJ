:: Using inkscape command line to convert svg to emf [http://blog.sina.com.cn/s/blog_903af8d60102va6w.html]

@echo off
CLS
Title  "Convet SVG to EMF & PDF"
COLOR 0a 

:MENU
echo. 
echo -------------------------------------------------------------------
echo Convert SVG format images to EMF and PDF format by  using inkscape
echo -------------------------------------------------------------------

echo * 1. About
echo * 2. Start to convert...
echo * 3. Quit

echo ------------------------------------------------------------------
set /p choice=Type 1, 2, or 3, then press ENTER:  

if not '%choice%'=='' set choice=%choice:~0,1%
if %CHOICE%==1 GOTO ABOUT
if %CHOICE%==2 GOTO START
if %CHOICE%==3 GOTO QUIT


:ABOUT

echo ***************************************
echo.
echo This batch file use inkscape to convert 
echo svg images to EMF and PDF format
echo.
echo ***************************************
echo Writen by Hanzhou Wang
GOTO MENU

:START
@echo off 
IF  EXIST *.svg (GOTO CONVERT) ELSE (
echo.
echo ***********************************************
echo  Alert: There is no svg file in the current folder
echo  Please confirm if a svg file exists!
echo **********************************************
echo.
)
GOTO MENU

:CONVERT
for %%i in (*.svg) do (  
    
   echo %%i
   
   inkscape -f %%i -M %%~ni.emf
   
   inkscape -f %%i -A %%~ni.pdf
   
)
  
@echo 
echo "Done!" 
GOTO MENUE

:QUIT
exit /b

