@echo off
CHCP 65001 > NUL
setlocal EnableDelayedExpansion

:: SETTINGS
set "PYTHON_DIR=.\python-3.11.0rc1-embed-amd64"
set "SCRIPT_FILE=main_reloader.py"
set "REQUIREMENTS_FILE=requirements.txt"
set "PYTHON_EXE=%PYTHON_DIR%\python.exe"
set "PYTHON_SCRIPTS_DIR=%PYTHON_DIR%\Scripts"
set "PIP_EXE=%PYTHON_SCRIPTS_DIR%\pip.exe"
set "TARGET_URL=https://cults3d.com/pt/modelo-3d/arquitetura/metal-intercom-box"

:: DEBUG: Check Python
echo [DEBUG] Checking Python path: %PYTHON_EXE%
if not exist "%PYTHON_EXE%" (
    echo.
    echo [ERROR] Embedded Python not found at: %PYTHON_EXE%
    echo Make sure the folder exists and the file 'python.exe' is present.
    pause
    exit /b 1
)

:: MAIN MENU
:MENU
cls
color 0B
echo =================================================
echo        CONTROL MENU - PYTHON RELOAD v3.3
echo =================================================
echo.
color 0F
echo   Current Target URL: %TARGET_URL%
echo.
echo   1. Reload page 100 times
echo   2. Reload page 500 times
echo   3. Reload page 1000 times
echo   4. Reload page 2000 times
echo   5. Reload N times (custom)
echo.
echo   6. Execute Python Command
echo   7. Set new URL
echo   8. Advanced Tools
echo.
echo   9. Exit
echo.
color 08
set /p "choice=Choose an option: "

if "%choice%"=="1" call :EXEC_RELOAD 100 & goto MENU
if "%choice%"=="2" call :EXEC_RELOAD 500 & goto MENU
if "%choice%"=="3" call :EXEC_RELOAD 1000 & goto MENU
if "%choice%"=="4" call :EXEC_RELOAD 2000 & goto MENU
if "%choice%"=="5" goto CUSTOM_RELOAD
if "%choice%"=="6" goto PY_SHELL
if "%choice%"=="7" goto SET_URL
if "%choice%"=="8" goto ADMIN
if "%choice%"=="9" exit /b

goto MENU

:EXEC_RELOAD
cls
echo Executing Python script...
echo Repetitions: %1
echo URL: %TARGET_URL%
echo.

set "ESCAPED_TARGET_URL=%TARGET_URL:^=^^%"
set "ESCAPED_TARGET_URL=%ESCAPED_TARGET_URL:&=^&%"
set "ESCAPED_TARGET_URL=%ESCAPED_TARGET_URL:<=^<%"
set "ESCAPED_TARGET_URL=%ESCAPED_TARGET_URL:>=^>%"
set "ESCAPED_TARGET_URL=%ESCAPED_TARGET_URL:|=^|%"
set "ESCAPED_TARGET_URL=%ESCAPED_TARGET_URL:(=^(%"
set "ESCAPED_TARGET_URL=%ESCAPED_TARGET_URL:)=^)%"

if not exist "%SCRIPT_FILE%" (
    color 0C & echo. & echo ERROR: Script '%SCRIPT_FILE%' not found!
    pause
    exit /b
)

"%PYTHON_EXE%" "%SCRIPT_FILE%" -n %1 -u "%ESCAPED_TARGET_URL%"
if errorlevel 1 (
    color 0C & echo. & echo ERROR: The script failed. Error code: !ERRORLEVEL!
) else (
    color 0A & echo. & echo Completed successfully!
)
pause
exit /b

:CUSTOM_RELOAD
cls & color 0E
echo ================= CUSTOM RELOAD =================
set /p "num_reloads=Enter the number of times: "

set "num_reloads_valid="
for /f "delims=0123456789" %%i in ("%num_reloads%") do set "num_reloads_valid=invalid"
if defined num_reloads_valid (
    echo [ERROR] Please enter integers only.
    pause & goto CUSTOM_RELOAD
)
set /a "_tmp_num=%num_reloads%" >nul 2>&1
if errorlevel 1 (
    echo [ERROR] Invalid value.
    pause & goto CUSTOM_RELOAD
)
if !_tmp_num! LEQ 0 (
    echo [ERROR] The number must be greater than zero.
    pause & goto CUSTOM_RELOAD
)
call :EXEC_RELOAD !_tmp_num!
goto MENU

:PY_SHELL
:SHELL_LOOP
cls
color 0B
echo ================ PYTHON SHELL ==================
echo Type a Python command (or 'exit' to quit)
echo.
color 0F
set /p "py_cmd=>>> "
if /i "!py_cmd!"=="exit" goto MENU
if not defined py_cmd goto SHELL_LOOP
"%PYTHON_EXE%" -c "!py_cmd!"
echo.
pause
goto SHELL_LOOP

:SET_URL
cls
echo Current URL: %TARGET_URL%
set /p "TARGET_URL=New URL (with http/https): "
echo "%TARGET_URL%" | findstr /i "http://" >nul || echo "%TARGET_URL%" | findstr /i "https://" >nul
if errorlevel 1 (
    echo [ERROR] The URL must start with http:// or https://
    pause & goto SET_URL
)
echo New URL set successfully!
timeout /t 2 >nul
goto MENU

:ADMIN
cls
echo ================== TOOLS ==================
echo 1. Install dependencies
echo 2. Update dependencies
echo 3. List installed packages
echo 4. Open Python script
echo 5. Open requirements.txt
echo 6. Back
echo 7. Install PIP manually (embedded Python)
set /p "adm_choice=Option: "
if "%adm_choice%"=="1" call :INSTALL_DEPS & goto ADMIN
if "%adm_choice%"=="2" call :UPDATE_DEPS & goto ADMIN
if "%adm_choice%"=="3" "%PIP_EXE%" list & pause & goto ADMIN
if "%adm_choice%"=="4" start "" "%SCRIPT_FILE%" & goto ADMIN
if "%adm_choice%"=="5" start "" "%REQUIREMENTS_FILE%" & goto ADMIN
if "%adm_choice%"=="6" goto MENU
if "%adm_choice%"=="7" call :INSTALL_PIP & goto ADMIN
goto ADMIN

:INSTALL_DEPS
call :INSTALL_PIP_IF_NEEDED
if not exist "%REQUIREMENTS_FILE%" (
    echo [ERROR] requirements.txt not found!
    pause & exit /b
)
"%PIP_EXE%" install -r "%REQUIREMENTS_FILE%"
exit /b

:UPDATE_DEPS
call :INSTALL_PIP_IF_NEEDED
"%PIP_EXE%" install --upgrade -r "%REQUIREMENTS_FILE%"
exit /b

:INSTALL_PIP_IF_NEEDED
if exist "%PIP_EXE%" exit /b 0
call :INSTALL_PIP
exit /b

:INSTALL_PIP
cls
echo ===========================================================
echo PIP INSTALLATION FOR EMBEDDED PYTHON
echo ===========================================================
echo.
echo Make sure the ^<import site^> line is UNCOMMENTED in
echo the python311._pth file in the Python folder.
echo.
pause

where powershell >nul 2>nul || (
    echo [ERROR] PowerShell not found.
    pause
    exit /b 1
)

if not exist get-pip.py (
    echo Downloading get-pip.py...
    powershell -NoProfile -ExecutionPolicy Bypass -Command "Invoke-WebRequest -UseBasicParsing -Uri https://bootstrap.pypa.io/get-pip.py -OutFile get-pip.py"
    if errorlevel 1 (
        echo [ERROR] Failed to download get-pip.py
        pause
        exit /b 1
    )
)

echo Installing pip using embedded Python...
"%PYTHON_EXE%" get-pip.py --no-warn-script-location

if errorlevel 1 (
    echo [ERROR] Pip installation failed.
) else (
    echo PIP installed successfully!
)

if exist get-pip.py del get-pip.py
pause
exit /b


