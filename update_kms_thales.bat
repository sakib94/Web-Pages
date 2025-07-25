REM ###################### Update kms in CI_Main.DSL ######################

"%~dp0Find_Replace.exe" --cl --dir "D:\ApplicationDsls\Modularization\CoreIssue" --fileMask "CI_Main.DSL"  --excludeFileMask "*.dll, *.exe" --find "m_AttrValue \"vmiolab27\"" --replace "m_AttrValue \"VMIOLAB27\""

REM ###################### Update thalesIP in CI_Main.DSL ######################

"%~dp0Find_Replace.exe" --cl --dir "D:\ApplicationDsls\Modularization\CoreIssue" --fileMask "CI_Main.DSL"  --excludeFileMask "*.dll, *.exe" --find "m_AttrValue \"64.16.215.163\"" --replace "m_AttrValue \"10.120.0.206\""


REM ###################### Update kms in Collection.DSL ######################

"%~dp0Find_Replace.exe" --cl --dir "D:\ApplicationDsls\CC" --fileMask "Collections.DSL"  --excludeFileMask "*.dll, *.exe" --find "m_AttrValue \"vmtmkms9\"" --replace "m_AttrValue \"VMIOLAB27\""

REM ###################### Update kms in Collection.DSL ######################

"%~dp0Find_Replace.exe" --cl --dir "D:\ApplicationDsls\CoreAuth" --fileMask "wfCommonAuth.DSL"  --excludeFileMask "*.dll, *.exe" --find "m_AttrValue \"vmtmkms9\"" --replace "m_AttrValue \"VMIOLAB27\""
