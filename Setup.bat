
REM ##################################### Variables for Platform Installation ###################################
SET PF_Version=%~1
SET AppliationSetupPath_AMEX=E:\AMEX
SET AppliationSetupPath_Credit=E:\KB_DBBWEB
SET wwwrootPath=C:\inetpub\wwwroot

REM Current Installed
SET OLD_KMSTools=KMSTools%Old_PF_Version%
SET OLD_DBBIDE=DBBIDE%Old_PF_Version%
SET OLD_ScaleService=ScaleService%Old_PF_Version%

REM Installation path
SET dbbideInstallerPath=E:\PlatformInstaller\dbbide%PF_Version%.exe
SET ScaleServiceInstallerPath=E:\PlatformInstaller\ScaleService%PF_Version%.exe
SET KMSToolsInstallerPath=E:\PlatformInstaller\KMSTools%PF_Version%.exe
SET SinkDbbInstallerPath=E:\PlatformInstaller\SinkDbb%PF_Version%.exe

REM Installed path
SET ScaleserviceFolderPath=C:\ScaleServices
SET SinkPlatFormFolderPath=C:\Program Files (x86)\Corecard Software\SinkDbb%PF_Version%
SET BBBIDEFolderPath=C:\Program Files (x86)\Corecard Software\DBBIDE%PF_Version%
SET KMSToolsFolderPath=C:\Program Files (x86)\Corecard Software\KMSTools


