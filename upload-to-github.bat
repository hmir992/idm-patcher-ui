@echo off
setlocal
REM Force-uploads everything in this folder to https://github.com/hmir992/idm-patcher-ui
REM WARNING: overwrites the remote branch with the local state.
REM Usage: double-click, or run: upload-to-github.bat "optional commit message"

cd /d "%~dp0"

set "REPO_URL=https://github.com/hmir992/idm-patcher-ui.git"
set "BRANCH=main"

where git >nul 2>&1
if errorlevel 1 (
    echo Git is not installed or not in PATH. Install from https://git-scm.com
    pause
    exit /b 1
)

if not exist ".git" git init
git branch -M %BRANCH%

git remote get-url origin >nul 2>&1
if errorlevel 1 (
    git remote add origin %REPO_URL%
) else (
    git remote set-url origin %REPO_URL%
)

set "MSG=%~1"
if "%MSG%"=="" set "MSG=Update %date% %time%"

git add -A
git commit -m "%MSG%"

git push --force -u origin %BRANCH%
if errorlevel 1 (
    echo.
    echo Force push failed. Check your GitHub login or token.
    pause
    exit /b 1
)

echo.
echo Done. Force-updated %REPO_URL%
pause
endlocal
