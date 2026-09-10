@echo off
setlocal
title Cai dat GoodbyeDPI Service - Che do Viet Nam

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
echo       CAI DAT GOODBYEDPI CHAY NGAM VINH VIEN (WINDOWS SERVICE)
echo =========================================================================
echo [*] Sau khi cai dat: GoodbyeDPI se tu dong chay ngam moi khi bat may.
echo [*] Khong con cua so CMD mau den, chiem duoi 4MB RAM, CPU ~ 0%%.
echo [*] Tu dong bo chan cac trang trong file: vietnam-blacklist.txt
echo =========================================================================
echo.

echo [*] Dang dung va don dep service cu (neu co)...
sc stop "GoodbyeDPI" >nul 2>&1
sc delete "GoodbyeDPI" >nul 2>&1

echo [*] Dang dang ky Service moi...
sc create "GoodbyeDPI" binPath= "\"%CD%\%_arch%\goodbyedpi.exe\" -p -r -s -f 2 -e 2 --reverse-frag --max-payload 1200 -q --blacklist \"%CD%\vietnam-blacklist.txt\"" start= "auto"
sc description "GoodbyeDPI" "Tien ich vuot chan DPI cho mang Viet Nam (Steam, Medium, Discord...)"

echo [*] Dang khoi dong Service...
sc start "GoodbyeDPI"

echo.
echo =========================================================================
echo [OK] DA CAI DAT VA KHOI DONG THANH CONG!
echo      Tu bay gio may tinh cua ban da tu dong vuot chan DPI.
echo      (Neu muon go bo, chi can chay file service_remove.cmd)
echo =========================================================================
echo.
popd
pause
