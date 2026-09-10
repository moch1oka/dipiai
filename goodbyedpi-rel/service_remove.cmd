@echo off
setlocal
title Go bo GoodbyeDPI Service

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

cls
echo =========================================================================
echo                   GO BO GOODBYEDPI VA CAC DRIVER LIEN QUAN
echo =========================================================================
echo.

echo [*] Dang dung va xoa dich vu GoodbyeDPI...
sc stop "GoodbyeDPI" >nul 2>&1
sc delete "GoodbyeDPI" >nul 2>&1

echo [*] Dang don dep cac driver WinDivert...
sc stop "WinDivert" >nul 2>&1
sc delete "WinDivert" >nul 2>&1
sc stop "WinDivert14" >nul 2>&1
sc delete "WinDivert14" >nul 2>&1

echo.
echo =========================================================================
echo [OK] DA GO BO HOAN TOAN DICH VU VA DRIVER!
echo      He thong mang da tro ve trang thai mac dinh.
echo =========================================================================
echo.
pause
