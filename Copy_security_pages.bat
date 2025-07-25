color 3F

echo off

REM Copy security pages to Reprot Folder:
xcopy /s/y "\\xeon-s8\Labels\BANKCARD\CreditProcessing\Labels\SRS_CreditProcessing_15.00.25.02.01_Consolidated\Security pages\CoreIssue" "\\sahmad\PublishCodes\Reports_CI_Credit"
xcopy /s/y "\\xeon-s8\Labels\BANKCARD\CreditProcessing\Labels\SRS_CreditProcessing_15.00.25.02.01_Consolidated\Security pages\CoreIssue" "\\sahmad\PublishCodes\Reports_CC_Credit"


echo HI! your Security Pages have been copied successfully

pause