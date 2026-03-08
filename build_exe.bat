@echo off
title Build EXE - Red Alert Monitor v4

echo.
echo  =============================================
echo   Build EXE - Red Alert Monitor v4.0
echo  =============================================
echo.

REM Find Python
set PYTHON_CMD=
py --version >nul 2>&1
if %errorlevel%==0 set PYTHON_CMD=py
if defined PYTHON_CMD goto found_python

python --version >nul 2>&1
if %errorlevel%==0 set PYTHON_CMD=python
if defined PYTHON_CMD goto found_python

echo ERROR: Python not found.
pause
exit /b 1

:found_python
echo Python: %PYTHON_CMD%
echo.

REM Install build tools
echo [1/4] Installing PyInstaller and dependencies...
%PYTHON_CMD% -m pip install --upgrade pyinstaller PyQt5 PyQtWebEngine requests

REM Move to script directory
cd /d "%~dp0"

REM Run PyInstaller (all on one line to avoid ^ continuation encoding issues)
echo [2/4] Running PyInstaller...
%PYTHON_CMD% -m PyInstaller --noconfirm --onefile --windowed --name "RedAlertMonitor" --add-data "requirements.txt;." --hidden-import PyQt5.sip --hidden-import PyQt5.QtWebEngineWidgets --hidden-import PyQt5.QtWebEngine --hidden-import PyQt5.QtWebEngineCore --collect-all PyQt5 red_alert.py

if %errorlevel% neq 0 (
    echo.
    echo [!] Build FAILED. Check errors above.
    pause
    exit /b 1
)

echo.
echo [3/4] Copying EXE to main folder...
if exist dist\RedAlertMonitor.exe (
    copy /Y dist\RedAlertMonitor.exe "%~dp0RedAlertMonitor.exe" >nul
    echo Copied: RedAlertMonitor.exe
) else (
    echo [!] EXE not found in dist folder
)

echo [4/4] Cleaning up temp build files...
if exist build rmdir /s /q build
if exist dist rmdir /s /q dist
if exist RedAlertMonitor.spec del /f /q RedAlertMonitor.spec

echo.
echo  =============================================
echo   Build complete!
echo   File: %~dp0RedAlertMonitor.exe
echo  =============================================
echo.
pause
