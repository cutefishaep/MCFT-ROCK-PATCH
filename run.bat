@echo off
setlocal
openfiles >nul 2>&1
if '%errorlevel%' NEQ '0' (
    echo.
    echo ==================================================
    echo   Requesting administrator privileges...
    echo ==================================================
    echo.
	
    powershell -Command "Start-Process '%~0' -Verb runAs"
    exit /b
)

:: Define variables
set PATCH_DIR=%~dp0Patch
set FILE32_DIR=%PATCH_DIR%\32
set FILEWOW_DIR=%PATCH_DIR%\WOW

set DLL32=MCFT32.dll
set DLLWOW=MCFTWOW.dll

set TARGET32=C:\Windows\System32\Windows.ApplicationModel.Store.dll
set TARGETWOW=C:\Windows\SysWOW64\Windows.ApplicationModel.Store.dll


echo Taking ownership of target files...
takeown /f "%TARGET32%" >nul 2>&1
takeown /f "%TARGETWOW%" >nul 2>&1


echo Granting full control permissions to target files...
icacls "%TARGET32%" /grant administrators:F >nul 2>&1
icacls "%TARGETWOW%" /grant administrators:F >nul 2>&1


echo Renaming files...
ren "%FILE32_DIR%\%DLL32%" Windows.ApplicationModel.Store.dll
ren "%FILEWOW_DIR%\%DLLWOW%" Windows.ApplicationModel.Store.dll


echo Copying and replacing files...
del /f /q "%TARGET32%" >nul 2>&1
del /f /q "%TARGETWOW%" >nul 2>&1
copy /y "%FILE32_DIR%\Windows.ApplicationModel.Store.dll" "%TARGET32%"
copy /y "%FILEWOW_DIR%\Windows.ApplicationModel.Store.dll" "%TARGETWOW%"


echo Renaming files back to original...
ren "%FILE32_DIR%\Windows.ApplicationModel.Store.dll" %DLL32%
ren "%FILEWOW_DIR%\Windows.ApplicationModel.Store.dll" %DLLWOW%


echo.
echo Done patching!

pause
