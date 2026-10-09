@echo off
setlocal
title Cai dat GoodbyeDPI Service - Che do Toan bo Luu luong

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
echo              CAI DAT GOODBYEDPI SERVICE (ALL TRAFFIC)
echo =========================================================================
echo [*] Che do: Chay ngam tu dong cung Windows (toan bo luu luong)
echo =========================================================================
echo.

echo [*] Dang dung va don dep service cu (neu co)...
sc stop "GoodbyeDPI" >nul 2>&1
sc delete "GoodbyeDPI" >nul 2>&1

echo [*] Dang dang ky Service moi...
sc create "GoodbyeDPI" binPath= "\"%CD%\%_arch%\goodbyedpi.exe\" -p -r -s -f 2 -e 2 --reverse-frag --max-payload 1200 -q" start= "auto"
sc description "GoodbyeDPI" "GoodbyeDPI Windows Service (All Traffic)"

echo [*] Dang khoi dong Service...
sc start "GoodbyeDPI"

echo.
echo =========================================================================
echo [OK] Cai dat va khoi dong service thanh cong.
echo      Go bo service: chay service_remove.cmd
echo =========================================================================
echo.
popd
pause
