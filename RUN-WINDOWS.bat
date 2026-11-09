@echo off
setlocal
cd /d "%~dp0"
title THREADLINE Store - Website Launcher
where node >nul 2>nul
if errorlevel 1 (
  echo.
  echo [ERROR] Node.js was not found.
  echo Install Node.js 22.13 or newer from https://nodejs.org/
  echo Then close and reopen this launcher.
  echo.
  pause
  exit /b 1
)
node tools\start-local.js
if errorlevel 1 (
  echo.
  echo Website did not start. Read the error shown above.
  echo.
  pause
  exit /b 1
)
pause
