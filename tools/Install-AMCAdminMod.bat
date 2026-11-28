@echo off
powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp0Install-AMCAdminMod.ps1"
exit /b %errorlevel%
