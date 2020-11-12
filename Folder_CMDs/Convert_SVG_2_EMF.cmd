:: Using inkscape command line to convert svg to emf [http://blog.sina.com.cn/s/blog_903af8d60102va6w.html]

echo off
CLS
Title  "Convet SVG to EMF & PDF"
COLOR 0a 

echo 
echo "-------------------------------------------------------------------"
echo "Convert SVG format images to EMF and PDF format by  using inkscape."
echo "-------------------------------------------------------------------"

@echo off 

for %%i in (*.svg) do (  
    
   echo %%i
   
   inkscape -f %%i -M %%~ni.emf
   
   inkscape -f %%i -A %%~ni.pdf
   
)
  
@echo 
echo "Done!" 

