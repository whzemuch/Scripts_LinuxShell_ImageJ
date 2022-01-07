:: zerolgt.bat Usage: zerolgt Folder_Name (http://www.computing.net/answers/programming/how-to-change-all-files-to-zerobyte/20763.html, ALL THE FILES: *, ONE TYPE FILE: *.PDF)


@echo off
pushd %*
for %%j in (*.PDF) do if /I not "%%j"=="%~nx0" type nul > "%%j"
popd
:: End_Of_Batch