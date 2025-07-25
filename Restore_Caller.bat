@ECHO OFF
rem==================================================================================================================

set labelOption=%~1
set Label=%~2 %~3
set Date=%~4
set database=%~5
set dbLocation=%~6

echo labelOption: %labelOption%
echo Label: %Label%
echo Date: %Date%
echo Database: %database%
echo dbLocation: %dbLocation%

echo %Date% %Time% is going to set in Tview
echo ==================================================================================================================
ECHO "Update status  = 1 in  't_user_details' table for your login name and DB name"
sqlcmd -S BPLQADB01 -i "SQL\update_T_user_details.sql"
timeout 05

if /I "%database%"=="Shrunk" goto :ShrunkDB
if /I "%database%"=="Master" goto :MasterDB
if /I "%database%"=="Users" goto :USER
if /I "%database%"=="Random" goto :Random


REM =======================VMCPLABELS=======================
Rem ====ShrunkDB
:ShrunkDB
SQLCMD -S BPLQADB01 -d "Master" -Q"exec SP_RESTOREDB_ENHANCED_V4 @DB_NAME = 'sakib_ci', @BACKUP_FILE = '%Label%\Application\DB\AMEXShrunkDB\AMEXCoreIssue.bak',@MDF_LOCATION = '\\BPLQADB01\Sakib_Ahmad\MDF',@LDF_LOCATION = '\\BPLQADB01\Sakib_Ahmad\LDF',@vLogin_Name = 'NEWVISIONSOFT\Testing_Users'"
SQLCMD -S BPLQADB01 -d "Master" -Q"exec SP_RESTOREDB_ENHANCED_V4 @DB_NAME = 'sakib_cl', @BACKUP_FILE = '%Label%\Application\DB\AMEXShrunkDB\AMEXCoreLibrary.bak',@MDF_LOCATION = '\\BPLQADB01\Sakib_Ahmad\MDF',@LDF_LOCATION = '\\BPLQADB01\Sakib_Ahmad\LDF',@vLogin_Name = 'NEWVISIONSOFT\Testing_Users'"
SQLCMD -S BPLQADB01 -d "Master" -Q"exec SP_RESTOREDB_ENHANCED_V4 @DB_NAME = 'sakib_cauth', @BACKUP_FILE = '%Label%\Application\DB\AMEXShrunkDB\AMEXCoreAuth.bak',@MDF_LOCATION = '\\BPLQADB01\Sakib_Ahmad\MDF',@LDF_LOCATION = '\\BPLQADB01\Sakib_Ahmad\LDF',@vLogin_Name = 'NEWVISIONSOFT\Testing_Users'"
SQLCMD -S BPLQADB01 -d "Master" -Q"exec SP_RESTOREDB_ENHANCED_V4 @DB_NAME = 'sakib_cc', @BACKUP_FILE = '%Label%\Application\DB\AMEXShrunkDB\AMEXCoreCollect.bak',@MDF_LOCATION = '\\BPLQADB01\Sakib_Ahmad\MDF',@LDF_LOCATION = '\\BPLQADB01\Sakib_Ahmad\LDF',@vLogin_Name = 'NEWVISIONSOFT\Testing_Users'"

goto :LabelOption

Rem ====MasterDB
:MasterDB
SQLCMD -S BPLQADB01 -d "Master" -Q"exec SP_RESTOREDB_ENHANCED_V4 @DB_NAME = 'sakib_ci', @BACKUP_FILE = '%Label%\Application\DB\AMEXMasterDB\AMEXCoreIssue.bak',@MDF_LOCATION = '\\BPLQADB01\Sakib_Ahmad\MDF',@LDF_LOCATION = '\\BPLQADB01\Sakib_Ahmad\LDF',@vLogin_Name = 'NEWVISIONSOFT\Testing_Users'"
SQLCMD -S BPLQADB01 -d "Master" -Q"exec SP_RESTOREDB_ENHANCED_V4 @DB_NAME = 'sakib_cl', @BACKUP_FILE = '%Label%\Application\DB\AMEXMasterDB\AMEXCoreLibrary.bak',@MDF_LOCATION = '\\BPLQADB01\Sakib_Ahmad\MDF',@LDF_LOCATION = '\\BPLQADB01\Sakib_Ahmad\LDF',@vLogin_Name = 'NEWVISIONSOFT\Testing_Users'"
SQLCMD -S BPLQADB01 -d "Master" -Q"exec SP_RESTOREDB_ENHANCED_V4 @DB_NAME = 'sakib_cauth', @BACKUP_FILE = '%Label%\Application\DB\AMEXMasterDB\AMEXCoreAuth.bak',@MDF_LOCATION = '\\BPLQADB01\Sakib_Ahmad\MDF',@LDF_LOCATION = '\\BPLQADB01\Sakib_Ahmad\LDF',@vLogin_Name = 'NEWVISIONSOFT\Testing_Users'"
SQLCMD -S BPLQADB01 -d "Master" -Q"exec SP_RESTOREDB_ENHANCED_V4 @DB_NAME = 'sakib_cc', @BACKUP_FILE = '%Label%\Application\DB\AMEXMasterDB\AMEXCoreCollect.bak',@MDF_LOCATION = '\\BPLQADB01\Sakib_Ahmad\MDF',@LDF_LOCATION = '\\BPLQADB01\Sakib_Ahmad\LDF',@vLogin_Name = 'NEWVISIONSOFT\Testing_Users'"

goto :LabelOption
:Random
=======================Random DB==========================
SQLCMD -S BPLQADB01 -d "Master" -Q"exec sp_RestoreDB 'sakib_ci','%dbLocation%\AMEXCoreIssue.bak'"
SQLCMD -S BPLQADB01 -d "Master" -Q"exec sp_RestoreDB 'sakib_cl','%dbLocation%\AMEXCoreLibrary.bak'" 
SQLCMD -S BPLQADB01 -d "Master" -Q"exec sp_RestoreDB 'sakib_cauth','%dbLocation%\AMEXCoreAuth.bak'" 
SQLCMD -S BPLQADB01 -d "Master" -Q"exec sp_RestoreDB 'sakib_cc','%dbLocation%\AMEXCoreCollect.bak'" 

goto :LabelOption
=======================Users DB==========================
:USER
SQLCMD -S BPLQADB01 -d "Master" -Q"exec SP_RESTOREDB_ENHANCED_V4 @DB_NAME = 'sakib_ci', @BACKUP_FILE = '%dbLocation%CI.bak',@MDF_LOCATION = '\\BPLQADB01\Sakib_Ahmad\MDF',@LDF_LOCATION = '\\BPLQADB01\Sakib_Ahmad\LDF',@vLogin_Name = 'NEWVISIONSOFT\Testing_Users'"
SQLCMD -S BPLQADB01 -d "Master" -Q"exec SP_RESTOREDB_ENHANCED_V4 @DB_NAME = 'sakib_cl', @BACKUP_FILE = '%dbLocation%CL.bak',@MDF_LOCATION = '\\BPLQADB01\Sakib_Ahmad\MDF',@LDF_LOCATION = '\\BPLQADB01\Sakib_Ahmad\LDF',@vLogin_Name = 'NEWVISIONSOFT\Testing_Users'"
SQLCMD -S BPLQADB01 -d "Master" -Q"exec SP_RESTOREDB_ENHANCED_V4 @DB_NAME = 'sakib_cauth', @BACKUP_FILE = '%dbLocation%cauth.bak',@MDF_LOCATION = '\\BPLQADB01\Sakib_Ahmad\MDF',@LDF_LOCATION = '\\BPLQADB01\Sakib_Ahmad\LDF',@vLogin_Name = 'NEWVISIONSOFT\Testing_Users'"
SQLCMD -S BPLQADB01 -d "Master" -Q"exec SP_RESTOREDB_ENHANCED_V4 @DB_NAME = 'sakib_cc', @BACKUP_FILE = '%dbLocation%CC.bak',@MDF_LOCATION = '\\BPLQADB01\Sakib_Ahmad\MDF',@LDF_LOCATION = '\\BPLQADB01\Sakib_Ahmad\LDF',@vLogin_Name = 'NEWVISIONSOFT\Testing_Users'"

goto :LabelOption

:LabelOption

if /I "%labelOption%"=="Restore" goto CONTINUE
if /I "%labelOption%"=="Change" goto UpdateLabel

:UpdateLabel
rem==================================================================================================================
REM CALL below batch files from this batch file 
REM pass value in this file which will CALL below batches passing given value

rem CALL E:\Shortcuts\Workflows\DSL_AMEX\Copy_security_pages.cmd %Label%

rem CALL E:\Shortcuts\Workflows\DSL_AMEX\Copy_BATCH_and_VBS.cmd %Label%

CALL BatchScript\Copy_AMEX_DSLs.bat %Label%

timeout 10

CALL BatchScript\Copy_BATCH_and_VBS.bat %Label%

ECHO updating Thales and KMS in DSLs
timeout 10
CALL BatchScript\update_kms_thales.bat
ECHO Thales and KMS is updated in DSLs
timeout 10

echo ==================================================================================================================


:CONTINUE

ECHO(
ECHO(
ECHO(
timeout 5

CALL BatchScript\Synonyms.BAT

ECHO Check Restore result and Synonyms result, If DB is restored successfully then, press any key...
timeout 10
rem==================================================================================================================
REM start CI appserver, CC appserver, CreateCase, TNP
CALL D:\RunSetup\CI\1_________Start_Appserver_TNP.bat
timeout 10
rem==================================================================================================================
ECHO start Tview
START D:\Platformcode\tview.exe

ECHO Set Date Time in Tview
CALL D:\Platformcode\dt.bat %Date% %Time%
