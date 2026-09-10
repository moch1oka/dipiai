@echo off
setlocal
title Cap Nhat Danh Sach Blacklist Viet Nam

pushd "%~dp0"

echo =========================================================================
echo       CAP NHAT DANH SACH WEBSITE BI CHAN CHO GOODBYEDPI VIET NAM
echo =========================================================================
echo [*] Dang tai danh sach moi nhat tu GitHub...
echo.

set "URL=https://raw.githubusercontent.com/moch1oka/dipiai/main/goodbyedpi-rel/vietnam-blacklist.txt"
set "TEMP_FILE=vietnam-blacklist.tmp"

where curl >nul 2>&1
if %errorlevel% equ 0 (
    curl -sSL "%URL%" -o "%TEMP_FILE%"
) else (
    powershell -NoProfile -ExecutionPolicy Bypass -Command "[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; (New-Object System.Net.WebClient).DownloadFile('%URL%', '%TEMP_FILE%')"
)

if not exist "%TEMP_FILE%" (
    echo [LOI] Khong the tai danh sach tu internet. Vui long kiem tra ket noi mang.
    goto END
)

for %%A in ("%TEMP_FILE%") do set "SIZE=%%~zA"
if %SIZE% LSS 100 (
    echo [LOI] Du lieu tai ve khong hop le. Giu nguyen file blacklist cu.
    del "%TEMP_FILE%" >nul 2>&1
    goto END
)

move /y "%TEMP_FILE%" "vietnam-blacklist.txt" >nul
echo [OK] Da cap nhat thanh cong vietnam-blacklist.txt!
echo.

sc query "GoodbyeDPI" 2>nul | find /i "RUNNING" >nul
if %errorlevel% equ 0 (
    echo [*] Phat hien GoodbyeDPI Service dang chay. Dang khoi dong lai de ap dung...
    sc stop "GoodbyeDPI" >nul 2>&1
    timeout /t 2 /nobreak >nul
    sc start "GoodbyeDPI" >nul 2>&1
    echo [OK] Da khoi dong lai Service voi danh sach moi!
)

:END
echo =========================================================================
echo.
popd
pause
