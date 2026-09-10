@echo off
setlocal
title Cong Cu Doi DNS Nhanh (Cloudflare / Google / Reset)

:: Kiem tra quyen Administrator
net session >nul 2>&1
if %errorlevel% neq 0 (
    echo [THONG BAO] Script nay can quyen Administrator!
    echo Vui long chuot phai vao file va chon: "Run as administrator"
    echo.
    echo Dang thu tu dong yeu cau quyen Admin qua UAC...
    powershell -NoProfile -ExecutionPolicy Bypass -Command "Start-Process cmd.exe -ArgumentList '/k \"\"\"%~f0\"\"\"' -Verb RunAs"
    exit /b
)

:MENU
cls
echo =========================================================================
echo              CONG CU THIET LAP DNS NHANH CHO MAY TINH
echo =========================================================================
echo [1] Doi sang Cloudflare DNS (1.1.1.1 va 1.0.0.1) - [Khuyen dung]
echo [2] Doi sang Google DNS (8.8.8.8 va 8.8.4.4)
echo [3] Khoi phuc DNS ve Tu dong (DHCP mac dinh cua nha mang)
echo [4] Xoa bo nho dem DNS (ipconfig /flushdns)
echo [0] Thoat
echo =========================================================================
set /p choice="Nhap lua chon cua ban (0-4): "

if "%choice%"=="1" goto CLOUDFLARE
if "%choice%"=="2" goto GOOGLE
if "%choice%"=="3" goto DHCP
if "%choice%"=="4" goto FLUSH
if "%choice%"=="0" exit /b
goto MENU

:CLOUDFLARE
cls
echo [*] Dang thiet lap Cloudflare DNS (1.1.1.1 va 1.0.0.1)...
powershell -Command "Get-NetAdapter | Where-Object {$_.Status -eq 'Up'} | ForEach-Object { Set-DnsClientServerAddress -InterfaceIndex $_.ifIndex -ServerAddresses ('1.1.1.1','1.0.0.1') }"
ipconfig /flushdns >nul
echo [OK] Da doi sang Cloudflare DNS va xoa cache DNS thanh cong!
echo.
pause
goto MENU

:GOOGLE
cls
echo [*] Dang thiet lap Google DNS (8.8.8.8 va 8.8.4.4)...
powershell -Command "Get-NetAdapter | Where-Object {$_.Status -eq 'Up'} | ForEach-Object { Set-DnsClientServerAddress -InterfaceIndex $_.ifIndex -ServerAddresses ('8.8.8.8','8.8.4.4') }"
ipconfig /flushdns >nul
echo [OK] Da doi sang Google DNS va xoa cache DNS thanh cong!
echo.
pause
goto MENU

:DHCP
cls
echo [*] Dang khoi phuc DNS ve tu dong (DHCP)...
powershell -Command "Get-NetAdapter | Where-Object {$_.Status -eq 'Up'} | ForEach-Object { Set-DnsClientServerAddress -InterfaceIndex $_.ifIndex -ResetServerAddresses }"
ipconfig /flushdns >nul
echo [OK] Da khoi phuc DNS tu dong thanh cong!
echo.
pause
goto MENU

:FLUSH
cls
echo [*] Dang xoa bo nho dem DNS...
ipconfig /flushdns
echo [OK] Da xoa cache DNS!
echo.
pause
goto MENU
