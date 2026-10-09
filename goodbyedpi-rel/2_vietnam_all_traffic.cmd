@echo off
setlocal
title GoodbyeDPI - Che do Toan bo Luu luong (All Traffic)

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

pushd "%~dp0"
set _arch=x86
if "%PROCESSOR_ARCHITECTURE%"=="AMD64" (set _arch=x86_64)
if defined PROCESSOR_ARCHITEW6432 (set _arch=x86_64)

cls
echo =========================================================================
echo       GOODBYEDPI - CHE DO TOAN BO LUU LUONG (ALL TRAFFIC)
echo =========================================================================
echo [*] Che do         : Toan bo luu luong (khong can blacklist)
echo [*] Tham so        : -p -r -s -f 2 -e 2 --reverse-frag --max-payload 1200 -q
echo [*] Luu y          : Bat Secure DNS (DoH) tren trinh duyet neu can
echo [*] Giu cua so nay mo trong suot qua trinh su dung
echo =========================================================================
echo.

pushd "%_arch%"
goodbyedpi.exe -p -r -s -f 2 -e 2 --reverse-frag --max-payload 1200 -q

popd
popd
echo.
echo GoodbyeDPI da dung lai.
pause
