@echo off
cd /d "%~dp0"
title THREADLINE - Set up Owner Admin Account
powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp0SETUP-ADMIN-WINDOWS.ps1"
echo.
pause
