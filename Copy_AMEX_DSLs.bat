color 3F
echo off

set label = %~1

REM =======================VMCPLABELS=======================
xcopy /s/y "%Label%\Application\DSL" "D:\ApplicationDsls"

REM =======================XEON-S8==========================
rem xcopy /s/y "%label%\Core\DSL" "D:\ApplicationDsls"


echo HI! your AMEX DSLs have been copied successfully
