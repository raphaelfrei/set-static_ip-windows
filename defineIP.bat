:: Defines static IP on Windows 10

@echo off

:: BatchGotAdmin
:-------------------------------------
>nul 2>&1 "%SYSTEMROOT%\system32\cacls.exe" "%SYSTEMROOT%\system32\config\system"

if '%errorlevel%' NEQ '0' (
    echo Requiring admin access...
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

set /p IP="IPV4 Address: "
echo The IP is: %IP%

echo.
set /p GW="Gateway: "
echo The Gateway is: %GW%

echo.
echo DEFAULT: 192.168.0.0
set /p DNS="DNS: "
IF NOT DEFINED DNS SET "DNS=192.168.0.0"
echo The DNS is: %DNS%

echo.
echo.
echo Defining IP Address...
timeout 5

:: Set this ADAPTER to Network Adapter name according to ipconfig
netsh interface ipv4 set address "ADAPTER" static %IP% 255.255.255.0 %GW%
netsh interface ipv4 set dns name="ADAPTER" static %DNS%

cls

echo IP Address defined!

pause
