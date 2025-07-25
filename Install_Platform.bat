@ECHO OFF

SET /p Old_PF_Version= Enter Old Platform version in the system(Example:- 4.2.43.14): 
ECHO Old_PF_Version: %Old_PF_Version%
PAUSE

SET /p PF_Version= Enter Platform version to be installed(Example:- 4.3.2.19): 
ECHO Platform version to be installed: %PF_Version%
PAUSE

Call "%~dp0Setup.bat" %PF_Version% %Old_PF_Version%

REM Uninstall Old PF  ----------------------------------------------------------------------------

ECHO Uninstall OLD_DBBIDE
PAUSE
ECHO Searching for .....%OLD_DBBIDE%......
wmic product where "name='%OLD_DBBIDE%'" call uninstall /nointeractive
PAUSE

ECHO Uninstall OLD_KMSTools
PAUSE
ECHO Searching for .....%OLD_KMSTools%......
wmic product where "name='%OLD_KMSTools%'" call uninstall /nointeractive
PAUSE

ECHO Uninstall OLD_ScaleService
PAUSE
ECHO Searching for ....%OLD_ScaleService%......
wmic product where "name='%OLD_ScaleService%'" call uninstall /nointeractive
PAUSE

REM ####################### Copy Platform files to local ##############################################

ECHO Copy DBBIDE installer file
xcopy /s/y "\\fs1\install\Platform\%PF_Version%\DBBIDE%PF_Version%.exe" "E:\PlatformInstaller"

ECHO Copy ScaleService installer file
xcopy /s/y "\\fs1\install\Platform\%PF_Version%\ScaleService%PF_Version%.exe" "E:\PlatformInstaller"

ECHO Copy KMSTools installer file
xcopy /s/y "\\fs1\install\Platform\%PF_Version%\KMSTools%PF_Version%.exe" "E:\PlatformInstaller"

ECHO Copy SinkDbb installer file
xcopy /s/y "\\fs1\install\Platform\%PF_Version%\SinkDbb%PF_Version%.exe" "E:\PlatformInstaller"


PAUSE

REM ####################### Install DBBIDE Platform ##############################################

rem %dbbideInstallerPath% /install /quiet /norestart /log DBBIDE_log.txt
ECHO Install DBBIDE
CALL "%dbbideInstallerPath%"

rem timeout /t 120 /nobreak


REM ####################### Install Sink Platform ##############################################

rem %SinkDbbInstallerPath% /install /quiet /norestart /log Sink_log.txt
ECHO Install SinkDbb
call "%SinkDbbInstallerPath%"
rem timeout /t 60 /nobreak

REM ####################### Install Scale Service ########################################

rem %ScaleServiceInstallerPath% /install /quiet /norestart /log Scale_log.txt
ECHO Install ScaleService
call "%ScaleServiceInstallerPath%"
rem timeout /t 60 /nobreak

PAUSE

REM ####################### Install KMSTools ########################################

ECHO Install KMSTools
call "%KMSToolsInstallerPath%"
rem timeout /t 60 /nobreak

PAUSE

REM ####################### Copy DBBIDE files to PlatformCode folder#########################################
xcopy /s/y "%BBBIDEFolderPath%" "%AppliationSetupPath_AMEX%\PlatformCode"
ECHO Platform copied to AMEX
PAUSE

xcopy /s/y "%BBBIDEFolderPath%" "%AppliationSetupPath_Credit%\PlatformCode"
ECHO Platform copied to Credit
PAUSE

REM ####################### Copy DBBIDE files to cc_runtime folder#########################################
xcopy /s/y "%BBBIDEFolderPath%" "C:\cc_runtime"

REM ####################### Copy KMSTools files to PlatformCode folder#########################################
xcopy /s/y "%KMSToolsFolderPath%" "%AppliationSetupPath_AMEX%\PlatformCode"
xcopy /s/y "%KMSToolsFolderPath%" "%AppliationSetupPath_Credit%\PlatformCode"


REM ####################### Copy sinkDBB files to wwwroot #########################################

xcopy /s/y "%SinkPlatFormFolderPath%\WebServerFiles\bin" "%wwwrootPath%\bin"
xcopy /s/y "%SinkPlatFormFolderPath%\WebServerFiles\dbbImages" "%wwwrootPath%\dbbImages"
xcopy /s/y "%SinkPlatFormFolderPath%\WebServerFiles\dlls" "%wwwrootPath%\dlls"

Pause


ECHO Uninstall SinkDbb
PAUSE
ECHO Searching for SinkDbb%PF_Version%....
wmic product where "name='SinkDbb%PF_Version%'" call uninstall /nointeractive
PAUSE


ECHO ===========================
ECHO Start ScaleServices
Pause
REM Generate a temporary VBScript to elevate privileges
echo Set UAC = CreateObject^("Shell.Application"^) > "%temp%\elevate.vbs"
echo UAC.ShellExecute "StartService.bat", "", "", "runas", 1 >> "%temp%\elevate.vbs"

REM Run the VBScript to launch SecondBatch.bat as admin
cscript //nologo "%temp%\elevate.vbs"

REM Clean up the temporary VBScript
del "%temp%\elevate.vbs"

REM -----------------------------------------------------------------------------------------------

ECHO ===========DELETE .exe files from E:\PlatformInstaller=====================================
DEL E:\PlatformInstaller\*.exe
PAUSE

ECHO Platform Successfully changed
PAUSE