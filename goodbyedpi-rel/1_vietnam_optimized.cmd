@echo off
setlocal
title GoodbyeDPI - Che do Toi uu cho mang Viet Nam

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
echo       GOODBYEDPI - PHIEN BAN TOI UU CHO VIET NAM (VIETNAM OPTIMIZED)
echo =========================================================================
echo [*] Nha mang ho tro : Viettel, VNPT, FPT, MobiFone, CMC
echo [*] Cau hinh toi uu : -p -r -s -f 2 -e 2 --reverse-frag --max-payload 1200 -q
echo [*] Danh sach chan  : vietnam-blacklist.txt (Chi can thiep web trong list)
echo [*] An toan         : Khong anh huong Game, App Ngan Hang, Momo, Zalo
echo =========================================================================
echo [!] LUU Y: Hay bat "Secure DNS" tren trinh duyet (Cloudflare 1.1.1.1)
echo     de tranh bi nha mang chan DNS truoc khi vao web.
echo [!] Giu cua so nay mo trong suot qua trinh duyet web/choi game.
echo =========================================================================
echo.

pushd "%_arch%"
goodbyedpi.exe -p -r -s -f 2 -e 2 --reverse-frag --max-payload 1200 -q --blacklist "%~dp0vietnam-blacklist.txt"

popd
popd
echo.
echo GoodbyeDPI da dung lai.
pause
