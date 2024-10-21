@echo off
setlocal

:: Define variables
set PATCH_DIR=%~dp0Patch
set FILE32_DIR=%PATCH_DIR%\32
set FILEWOW_DIR=%PATCH_DIR%\WOW

set DLL32=MCFT32.dll
set DLLWOW=MCFTWOW.dll

set TARGET32=C:\Windows\System32\Windows.ApplicationModel.Store.dll
set TARGETWOW=C:\Windows\SysWOW64\Windows.ApplicationModel.Store.dll

:: Step 1: Rename files
echo Renaming files...
ren "%FILE32_DIR%\%DLL32%" Windows.ApplicationModel.Store.dll
ren "%FILEWOW_DIR%\%DLLWOW%" Windows.ApplicationModel.Store.dll

:: Step 2: Copy and force replace
echo Copying and replacing files...
copy /y "%FILE32_DIR%\Windows.ApplicationModel.Store.dll" "%TARGET32%"
copy /y "%FILEWOW_DIR%\Windows.ApplicationModel.Store.dll" "%TARGETWOW%"

:: Step 3: Rename back to original
echo Renaming files back to original...
ren "%FILE32_DIR%\Windows.ApplicationModel.Store.dll" %DLL32%
ren "%FILEWOW_DIR%\Windows.ApplicationModel.Store.dll" %DLLWOW%

:: Step 4: Done message with ASCII art
echo Done patching!

pause
