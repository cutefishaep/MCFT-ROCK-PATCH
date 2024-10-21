@echo off
setlocal

:: Check if the script is running with administrator privileges
:: If not, request elevated privileges
openfiles >nul 2>&1
if '%errorlevel%' NEQ '0' (
    echo.
    echo ==================================================
    echo   Requesting administrator privileges...
    echo ==================================================
    echo.
    :: Relaunch the script as an administrator
    powershell -Command "Start-Process '%~0' -Verb runAs"
    exit /b
)

:: Define variables
set PATCH_DIR=%~dp0Patch
set FILE32_DIR=%PATCH_DIR%\32
set FILEWOW_DIR=%PATCH_DIR%\WOW
set UNLOCKER_PATH=%PATCH_DIR%\unlocker\IObitUnlocker.exe
set DLL32=MCFT32.dll
set DLLWOW=MCFTWOW.dll
set TARGET32=C:\Windows\System32\Windows.ApplicationModel.Store.dll
set TARGETWOW=C:\Windows\SysWOW64\Windows.ApplicationModel.Store.dll

:: Step 1: Take ownership of the target files
echo Taking ownership of target files...
takeown /f "%TARGET32%" >nul 2>&1
takeown /f "%TARGETWOW%" >nul 2>&1

:: Step 2: Grant full control permissions
echo Granting full control permissions to target files...
icacls "%TARGET32%" /grant administrators:F >nul 2>&1
icacls "%TARGETWOW%" /grant administrators:F >nul 2>&1

:: Step 3: Wait for processes to close completely
echo Waiting for processes to close...
timeout /t 5 /nobreak >nul

:: Step 4: Unlock the existing DLLs using IObit Unlocker
echo Unlocking existing DLLs...
"%UNLOCKER_PATH%" /Delete /Normal "%TARGET32%" >nul 2>&1
"%UNLOCKER_PATH%" /Delete /Normal "%TARGETWOW%" >nul 2>&1

:: Step 5: Forcefully remove existing DLLs (if not removed)
echo Removing existing DLLs...
del /f "%TARGET32%" >nul 2>&1
del /f "%TARGETWOW%" >nul 2>&1

:: Step 6: Rename files
echo Renaming files...
ren "%FILE32_DIR%\%DLL32%" Windows.ApplicationModel.Store.dll
ren "%FILEWOW_DIR%\%DLLWOW%" Windows.ApplicationModel.Store.dll

:: Step 7: Copy and force replace
echo Copying and replacing files...
copy /y "%FILE32_DIR%\Windows.ApplicationModel.Store.dll" "%TARGET32%"
copy /y "%FILEWOW_DIR%\Windows.ApplicationModel.Store.dll" "%TARGETWOW%"

:: Step 8: Rename back to original
echo Renaming files back to original...
ren "%FILE32_DIR%\Windows.ApplicationModel.Store.dll" %DLL32%
ren "%FILEWOW_DIR%\Windows.ApplicationModel.Store.dll" %DLLWOW%

:: Step 9: Done message
echo Done patching!

pause
