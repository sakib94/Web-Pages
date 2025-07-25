color 3F
echo off

set label = %~1

REM Copy security pages to Reprot Folder:
REM =======================VMCPLABELS=======================
xcopy /s/y "%Label%\Reporting\Reports\Report_Files\BatchScript" "D:\ReportDelivery\DataReports"
xcopy /s/y "%Label%\Reporting\Reports\Report_Files\VBScript" "D:\ReportDelivery\DataFeed"

echo HI! your Security Pages have been copied successfully

