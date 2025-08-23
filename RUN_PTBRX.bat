@echo off
CHCP 65001 > NUL
setlocal enabledelayedexpansion

:: CONFIGURACOES
set "PYTHON_DIR=.\python-3.11.0rc1-embed-amd64"
set "SCRIPT_FILE=main_reloader.py"
set "REQUIREMENTS_FILE=requirements.txt"
set "PYTHON_EXE=%PYTHON_DIR%\python.exe"
set "PYTHON_SCRIPTS_DIR=%PYTHON_DIR%\Scripts"
set "PIP_EXE=%PYTHON_SCRIPTS_DIR%\pip.exe"
set "TARGET_URL=https://cults3d.com/pt/modelo-3d/arquitetura/metal-intercom-box"

:: DEBUG: Verificar Python
echo [DEBUG] Verificando caminho do Python: %PYTHON_EXE%
if not exist "%PYTHON_EXE%" (
    echo.
    echo [ERRO] Python embutido nao encontrado em: %PYTHON_EXE%
    echo Verifique se a pasta existe e se o arquivo 'python.exe' esta presente.
    pause
    exit /b 1
)

:: MENU PRINCIPAL
:MENU
cls
color 0B
echo =================================================
echo        MENU DE CONTROLE - PYTHON RELOAD v3.3
echo =================================================
echo.
color 0F
echo   URL Alvo Atual: %TARGET_URL%
echo.
echo   1. Recarregar pagina 100 vezes
echo   2. Recarregar pagina 500 vezes
echo   3. Recarregar pagina 1000 vezes
echo   4. Recarregar N vezes (personalizado)
echo.
echo   5. Executar Comando Python
echo   6. Definir nova URL
echo   7. Ferramentas Avancadas
echo.
echo   8. Sair
echo.
color 08
set /p "choice=Escolha uma opcao: "

if "%choice%"=="1" call :EXEC_RELOAD 100 & goto MENU
if "%choice%"=="2" call :EXEC_RELOAD 500 & goto MENU
if "%choice%"=="3" call :EXEC_RELOAD 1000 & goto MENU
if "%choice%"=="4" goto CUSTOM_RELOAD
if "%choice%"=="5" goto PY_SHELL
if "%choice%"=="6" goto SET_URL
if "%choice%"=="7" goto ADMIN
if "%choice%"=="8" exit

goto MENU

:EXEC_RELOAD
cls
echo Executando script Python...
echo Repeticoes: %1
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
    color 0C & echo. & echo ERRO: O script '%SCRIPT_FILE%' nao foi encontrado!
    pause
    exit /b
)

%PYTHON_EXE% "%SCRIPT_FILE%" -n %1 -u "%ESCAPED_TARGET_URL%"
if %ERRORLEVEL% NEQ 0 (
    color 0C & echo. & echo ERRO: O script falhou. Codigo de erro: %ERRORLEVEL%
) else (
    color 0A & echo. & echo Concluido com sucesso!
)
pause
exit /b

:CUSTOM_RELOAD
cls & color 0E
echo ================= RECARGA PERSONALIZADA =================
set /p "num_reloads=Digite o numero de vezes: "

set "num_reloads_valid="
for /f "delims=0123456789" %%i in ("%num_reloads%") do set "num_reloads_valid=invalid"
if defined num_reloads_valid (
    echo [ERRO] Digite apenas numeros inteiros.
    pause & goto CUSTOM_RELOAD
)
set /a "_tmp_num=%num_reloads%" >nul 2>&1
if errorlevel 1 (
    echo [ERRO] Valor invalido.
    pause & goto CUSTOM_RELOAD
)
if !_tmp_num! LEQ 0 (
    echo [ERRO] O numero deve ser maior que zero.
    pause & goto CUSTOM_RELOAD
)
call :EXEC_RELOAD !_tmp_num!
goto MENU

:PY_SHELL
:SHELL_LOOP
cls
color 0B
echo ================ SHELL PYTHON ==================
echo Digite um comando Python (ou 'exit' para sair)
echo.
color 0F
set /p "py_cmd=>>> "
if /i "!py_cmd!"=="exit" goto MENU
if not defined py_cmd goto SHELL_LOOP
%PYTHON_EXE% -c "!py_cmd!"
echo.
pause
goto SHELL_LOOP

:SET_URL
cls
echo URL Atual: %TARGET_URL%
set /p "TARGET_URL=Nova URL (com http/https): "
echo "%TARGET_URL%" | findstr /i "http://" >nul || echo "%TARGET_URL%" | findstr /i "https://" >nul
if %ERRORLEVEL% NEQ 0 (
    echo [ERRO] A URL deve comecar com http:// ou https://
    pause & goto SET_URL
)
echo Nova URL definida com sucesso!
timeout /t 2 >nul
goto MENU

:ADMIN
cls
echo ================== FERRAMENTAS ==================
echo 1. Instalar dependencias
echo 2. Atualizar dependencias
echo 3. Listar pacotes instalados
echo 4. Abrir script Python
echo 5. Abrir requirements.txt
echo 6. Voltar
echo 7. Instalar PIP manualmente (Python embutido)
set /p "adm_choice=Opcao: "
if "%adm_choice%"=="1" call :INSTALL_DEPS & goto ADMIN
if "%adm_choice%"=="2" call :UPDATE_DEPS & goto ADMIN
if "%adm_choice%"=="3" %PIP_EXE% list & pause & goto ADMIN
if "%adm_choice%"=="4" start "" "%SCRIPT_FILE%" & goto ADMIN
if "%adm_choice%"=="5" start "" "%REQUIREMENTS_FILE%" & goto ADMIN
if "%adm_choice%"=="6" goto MENU
if "%adm_choice%"=="7" call :INSTALL_PIP & goto ADMIN
goto ADMIN

:INSTALL_DEPS
call :INSTALL_PIP_IF_NEEDED
if not exist "%REQUIREMENTS_FILE%" (
    echo [ERRO] requirements.txt nao encontrado!
    pause & exit /b
)
%PIP_EXE% install -r "%REQUIREMENTS_FILE%"
exit /b

:UPDATE_DEPS
call :INSTALL_PIP_IF_NEEDED
%PIP_EXE% install --upgrade -r "%REQUIREMENTS_FILE%"
exit /b

:INSTALL_PIP_IF_NEEDED
if exist "%PIP_EXE%" exit /b 0
call :INSTALL_PIP
exit /b

:INSTALL_PIP
cls
echo ===========================================================
echo INSTALACAO DO PIP PARA PYTHON EMBUTIDO
echo ===========================================================
echo.
echo Verifique se a linha ^<import site^> esta DESCOMENTADA no
echo arquivo python311._pth localizado na pasta do Python.
echo.
pause

where powershell >nul 2>nul || (
    echo [ERRO] PowerShell nao encontrado no sistema.
    pause
    exit /b 1
)

if not exist get-pip.py (
    echo Baixando get-pip.py...
    powershell -command "Invoke-WebRequest -Uri https://bootstrap.pypa.io/get-pip.py -OutFile get-pip.py"
    if errorlevel 1 (
        echo [ERRO] Falha ao baixar get-pip.py
        pause
        exit /b 1
    )
)

echo Instalando pip usando Python embutido...
%PYTHON_EXE% get-pip.py --no-warn-script-location

if errorlevel 1 (
    echo [ERRO] Falha na instalacao do pip.
) else (
    echo PIP instalado com sucesso!
)

if exist get-pip.py del get-pip.py
pause
exit /b
