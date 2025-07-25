REM ===========================
REM Start ScaleServices
Pause
REM Generate a temporary VBScript to elevate privileges
echo Set UAC = CreateObject^("Shell.Application"^) > "%temp%\elevate.vbs"
echo UAC.ShellExecute "StartService.bat", "", "", "runas", 1 >> "%temp%\elevate.vbs"

REM Run the VBScript to launch SecondBatch.bat as admin
cscript //nologo "%temp%\elevate.vbs"

REM Clean up the temporary VBScript
del "%temp%\elevate.vbs"