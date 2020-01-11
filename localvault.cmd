@echo off
rem @ECHO OFF
set VAULT_DIR=%USERPROFILE%\localvault
set CONTAINER=localvault
REM set VOLUME=-v vault-config:/vault/config -v vault-file:/vault/file -v vault-logs:/vault/logs
set VOLUME=-v vault-file:/vault/file -v vault-logs:/vault/logs
set HELPER=localvault-helper
set HELPER_CREATE=docker create %VOLUME% --name=%HELPER% vault
set HELPER_DELETE=docker rm %HELPER%
set HELPER_RUN=docker run -it --rm %VOLUME% vault 
set VAULT=docker exec %CONTAINER% 
GOTO :%1 
IF %ERRORLEVEL% neq 0 goto :error
:error
echo Unknown command: %1
:help
echo. 
echo Usage:  %~n0 COMMAND
echo.
echo  Where COMMAND is: 
echo    create                 create new vault
echo    init                   initialize vault, generating keys and root token
echo    destroy                delete all localvault data
echo    start                  start vault container
echo    stop                   stop and seal vault container
echo    status                 output vault status
echo    unseal KEY             unseal vault with key (3 keys required to unseal)
echo    vault ARG [...]        run vault CLI command
echo    exec 'CMDLINE'         execute shell command in the vault container
echo    shell                  interactive shell session in vault container
echo    seal                   seal vault
echo.
goto :eof

:echo
echo %*
goto :eof

:datestamp
for /F "tokens=2" %%i in ("%DATE%") do (for /f "tokens=1,2,3 delims=/" %%a in ("%%i") do set D=%%c%%a%%b)
for /f "tokens=1 delims=." %%t in ("%TIME%") do for /f "tokens=1,2,3 delims=:" %%e in ("%%t") do set %1=%D%-%%e%%f%%g
goto :eof

:create
docker volume inspect vault-file 2>NUL >NUL
if ERRORLEVEL 1 goto :_create
echo create failed: localvault already exists
goto :eof

:_create
docker volume create vault-file
docker volume create vault-logs
goto :eof

:init
%VAULT% vault operator init
goto :eof

:destroy
echo.
choice /m "Are you sure you want to *DESTROY* the localvault?"
echo.
if %ERRORLEVEL% == 1 goto :_destroy_without_warning
echo Okay, not destroying.
goto :eof

:_destroy_without_warning
docker stop localvault
docker rm -f localvault
docker volume rm vault-file
docker volume rm vault-logs
goto :eof

:start
pushd %VAULT_DIR%
docker-compose up -d
docker-compose start
popd
goto :eof

:stop
pushd %VAULT_DIR%
docker-compose down
popd
goto :eof

:status
%VAULT% vault status
goto :eof

:seal
%VAULT% vault operator seal
goto :eof

:unseal
%VAULT% vault operator unseal %2
goto :eof

:vault
%VAULT% %*
goto :eof

:exec
docker exec -i %CONTAINER% /bin/sh -l -c %2
goto :eof

:shell
docker exec -it  %CONTAINER% /bin/sh -l
goto :eof

:backup
call :datestamp DATESTAMP
set FILENAME=backup-%DATESTAMP%.tgz
echo Writing vault data to %FILENAME%...
docker exec -i %CONTAINER% /bin/sh -l -c "tar zc -C /vault -p ." >%FILENAME%
echo Done
goto :eof

:restore
set FILENAME=%2
echo Restoring vault data from %FILENAME%...
docker exec -i %CONTAINER% /bin/sh -l -c "tar zx -C /vault" <%FILENAME%
echo Done
goto :eof
