@echo off
set DEPLOY_DIR=C:\open-notebook
if not exist "%DEPLOY_DIR%" mkdir "%DEPLOY_DIR%"
cd /d "%DEPLOY_DIR%"

REM Copy files from Jenkins workspace
copy /Y "%WORKSPACE%\docker-compose.yml" .
copy /Y "%WORKSPACE%\nginx.conf" .
xcopy /E /I /Y "%WORKSPACE%\certs" certs

REM Create volume directories
if not exist "surreal_data" mkdir surreal_data
if not exist "notebook_data" mkdir notebook_data

REM Deploy using docker-compose (old syntax for older Docker)
docker-compose down
docker-compose pull
docker-compose up -d

REM Wait for containers to start
timeout /t 10 /nobreak

REM Show status
echo === Container Status ===
docker-compose ps

echo === Logs ===
docker-compose logs --tail=50
