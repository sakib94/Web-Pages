@echo off
REM Replace "YourServiceName" with the actual service name
sc start "DbbScaleService"
if %errorlevel% equ 0 (
    echo Service started successfully.
) else (
    echo Failed to start service. Run as Administrator?
)
pause