@echo off
set ver=v7
title Digital ^& KMS 2038 Activation Windows 10 %ver% by mephistooo2 - TNCTR.com
mode con cols=70 lines=2
color 4e
:init
setlocal DisableDelayedExpansion
set cmdInvoke=1
set winSysFolder=System32
set "batchPath=%~0"
for %%k in (%0) do set batchName=%%~nk
set "vbsGetPrivileges=%temp%\OEgetPriv_%batchName%.vbs"
setlocal EnableDelayedExpansion

:checkPrivileges
echo ADMIN RIGHTS ACTIVATE...
NET FILE 1>NUL 2>NUL
if '%errorlevel%' == '0' ( goto gotPrivileges ) else ( goto getPrivileges )

:getPrivileges
if '%1'=='ELEV' (echo ELEV & shift /1 & goto gotPrivileges)
ECHO Set UAC = CreateObject^("Shell.Application"^) > "%vbsGetPrivileges%"
ECHO args = "ELEV " >> "%vbsGetPrivileges%"
ECHO For Each strArg in WScript.Arguments >> "%vbsGetPrivileges%"
ECHO args = args ^& strArg ^& " "  >> "%vbsGetPrivileges%"
ECHO Next >> "%vbsGetPrivileges%"
if '%cmdInvoke%'=='1' goto InvokeCmd 
ECHO UAC.ShellExecute "!batchPath!", args, "", "runas", 1 >> "%vbsGetPrivileges%"
goto ExecElevation

:InvokeCmd
ECHO args = "/c """ + "!batchPath!" + """ " + args >> "%vbsGetPrivileges%"
ECHO UAC.ShellExecute "%SystemRoot%\%winSysFolder%\cmd.exe", args, "", "runas", 1 >> "%vbsGetPrivileges%"

:ExecElevation
"%SystemRoot%\%winSysFolder%\WScript.exe" "%vbsGetPrivileges%" %*
exit /B

:gotPrivileges
setlocal & cd /d %~dp0
if '%1'=='ELEV' (del "%vbsGetPrivileges%" 1>nul 2>nul  &  shift /1)
::===============================================================================================================
:Digital
set "DIGI=1"
goto HWIDActivate
:HWIDActivate
mode con cols=75 lines=32
for /f "tokens=2 delims==" %%a in ('wmic path Win32_OperatingSystem get BuildNumber /value') do (
  set /a WinBuild=%%a
)

if %winbuild% LSS 10240 (
echo Not detected Windows 10. 
echo.
echo Digital License/KMS38 Activation is Not Supported.
)

CALL :DetectEdition

If defined KMS38 (
set "A2=KMS38"
set "A3=GVLK"
set "A4=Volume:GVLK"
set "A5=digi-ltsbc-kms38.exe"
set "A6= >nul 2>&1"
)
If defined DIGI (
set "B2=Digital License"
set "B3=Retail-OEM_Key"
set "B4=Retail"
set "B5=digi-ltsbc-kms38.exe"
)
::===========================================================
call:%A3%%B3%

for /f "tokens=1-4 usebackq" %%a in ("editions") do (if ^[%%a^]==^[%osedition%^] (
    set edition=%%a
    set sku=%%b 
    set Key=%%c
    goto:parseAndPatch))
echo:
echo %osedition% %vera% %A2%%B2% Activation is Not Supported.
echo:
Endlocal
TIMEOUT /T 4
exit
::===========================================================
:parseAndPatch
echo.
echo ===========================================================================
echo            Windows 10 %osedition% %vera% %A2%%B2% Activation
echo ===========================================================================
echo.
echo Cleaning ClipsSVC...
sc stop clipsvc >nul 2>&1
del /f /s /q "%allusersprofile%\Microsoft\Windows\ClipSVC\tokens.dat" >nul 2>&1
echo.
echo Installing key %key%
cscript /nologo %windir%\system32\slmgr.vbs -ipk %key% >nul 2>&1
echo.

echo Create GenuineTicket.XML file for Windows 10 %edition% %vera%

for /f "tokens=2 delims==" %%a IN ('"wmic Path Win32_OperatingSystem Get OperatingSystemSKU /format:LIST"')do (set SKU=%%a)
if not exist sku.txt echo | set /p "dummyName=%SKU%">bin\sku.txt
echo. >> bin\sku.txt
echo Retail >> bin\sku.txt

cd bin\
start /wait digi-ltsbc-kms38.exe
timeout /t 3 >nul 2>&1
cd..

echo GenuineTicket.XML file is installing for Windows 10 %edition% %vera%
clipup -v -o -altto %~dp0bin\
echo.

del /f /q bin\sku.txt >nul 2>&1
del /f /q "editions" >nul 2>&1

echo Activating...
echo.
cscript /nologo %windir%\system32\slmgr.vbs -ato >nul 2>&1
cscript /nologo %windir%\system32\slmgr.vbs -xpr
If defined DIGI goto :Done

for /f "tokens=2 delims==" %%A in ('"wmic path SoftwareLicensingProduct where (Description like '%%KMSCLIENT%%' and Name like 'Windows%%' and PartialProductKey is not NULL) get GracePeriodRemaining /VALUE" ') do set "gpr=%%A"
if %gpr% GTR 259200 echo Windows 10 %edition% %vera% is KMS38 activated. &goto:Done 
echo.
if %gpr% LEQ 259200 Goto:Rearm
:Rearm
echo Windows 10 %edition% %vera% KMS38 is not activated.
echo.
echo Applying slmgr /rearm to fix activation...
cscript /nologo %windir%\system32\slmgr.vbs -rearm >nul 2>&1
echo.
echo Restarting the system...
shutdown.exe /r /soft
echo.
::===============================================================================================================
:Done
TIMEOUT /T 4
exit
::===============================================================================================================
:DetectEdition
FOR /F "TOKENS=2 DELIMS==" %%A IN ('"WMIC PATH SoftwareLicensingProduct WHERE (Name LIKE 'Windows%%' AND PartialProductKey is not NULL) GET LicenseFamily /VALUE"') DO IF NOT ERRORLEVEL 1 SET "osedition=%%A"
if not defined osedition (FOR /F "TOKENS=3 DELIMS=: " %%A IN ('DISM /English /Online /Get-CurrentEdition 2^>nul ^| FIND /I "Current Edition :"') DO SET "osedition=%%A")

if %winbuild% EQU 10240 (
if "%osedition%"=="EnterpriseS" set "osedition=EnterpriseS2015"
if "%osedition%"=="EnterpriseSN" set "osedition=EnterpriseSN2015"
)
if %winbuild% EQU 14393 (
if "%osedition%"=="EnterpriseS" set "osedition=EnterpriseS2016"
if "%osedition%"=="EnterpriseSN" set "osedition=EnterpriseSN2016"
)
if %winbuild% GEQ 17763 (
if "%osedition%"=="EnterpriseS" set "osedition=EnterpriseS2019"
if "%osedition%"=="EnterpriseSN" set "osedition=EnterpriseSN2019"
)
exit /b
::===============================================================================================================
:Retail-OEM_Key
rem              Edition          SKU            Retail/OEM_Key         
(                                                                       
echo Core                         101      YTMG3-N6DKC-DKB77-7M9GH-8HVX7
echo CoreN                         98      4CPRK-NM3K3-X6XXQ-RXX86-WXCHW
echo CoreCountrySpecific           99      N2434-X9D7W-8PF6X-8DV9T-8TYMD
echo CoreSingleLanguage           100      BT79Q-G7N6G-PGBYW-4YWX6-6F4BT
echo Education                    121      YNMGQ-8RYV3-4PGQ3-C8XTP-7CFBY
echo EducationN                   122      84NGF-MHBT6-FXBX8-QWJK7-DRR8H
echo Enterprise                     4      XGVPP-NMH47-7TTHJ-W3FW7-8HV2C
echo EnterpriseN                   27      3V6Q6-NQXCX-V8YXR-9QCYV-QPFCT
echo EnterpriseS2015              125      FWN7H-PF93Q-4GGP8-M8RF3-MDWWW
echo EnterpriseSN2015             126      8V8WN-3GXBH-2TCMG-XHRX3-9766K
echo EnterpriseS2016              125      NK96Y-D9CD8-W44CQ-R8YTK-DYJWX
echo EnterpriseSN2016             126      2DBW3-N2PJG-MVHW3-G7TDK-9HKR4
echo Professional                  48      VK7JG-NPHTM-C97JM-9MPGT-3V66T
echo ProfessionalN                 49      2B87N-8KFHP-DKV6R-Y2C8J-PKCKT
echo ProfessionalEducation        164      8PTT6-RNW4C-6V7J2-C2D3X-MHBPB
echo ProfessionalEducationN       165      GJTYN-HDMQY-FRR76-HVGC7-QPF8P
echo ProfessionalWorkstation      161      DXG7C-N36C4-C4HTG-X4T3X-2YV77
echo ProfessionalWorkstationN     162      WYPNQ-8C467-V2W6J-TX4WX-WT2RQ
echo ServerRdsh                   175      NJCF7-PW8QT-3324D-688JX-2YV66
                                                                        
) > "editions" &exit /b                                                                                 
::===============================================================================================================
:GVLK
rem              Edition          SKU                  GVLK             
(                                                                       
echo Core                         101      TX9XD-98N7V-6WMQ6-BX7FG-H8Q99
echo CoreN                         98      3KHY7-WNT83-DGQKR-F7HPR-844BM
echo CoreCountrySpecific           99      PVMJN-6DFY6-9CCP6-7BKTT-D3WVR
echo CoreSingleLanguage           100      7HNRX-D7KGG-3K4RQ-4WPJ4-YTDFH
echo Education                    121      NW6C2-QMPVW-D7KKK-3GKT6-VCFB2
echo EducationN                   122      2WH4N-8QGBV-H22JP-CT43Q-MDWWJ
echo Enterprise                     4      NPPR9-FWDCX-D2C8J-H872K-2YT43
echo EnterpriseN                   27      DPH2V-TTNVB-4X9Q3-TJR4H-KHJW4
echo EnterpriseS2016              125      DCPHK-NFMTC-H88MJ-PFHPY-QJ4BJ
echo EnterpriseSN2016             126      QFFDN-GRT3P-VKWWX-X7T3R-8B639
echo EnterpriseS2019              125      M7XTQ-FN8P6-TTKYV-9D4CC-J462D
echo EnterpriseSN2019             126      92NFX-8DJQP-P6BBQ-THF9C-7CG2H
echo Professional                  48      W269N-WFGWX-YVC9B-4J6C9-T83GX
echo ProfessionalN                 49      MH37W-N47XK-V7XM9-C7227-GCQG9
echo ProfessionalEducation        164      6TP4R-GNPTD-KYYHQ-7B7DP-J447Y
echo ProfessionalEducationN       165      YVWGF-BXNMC-HTQYQ-CPQ99-66QFC
echo ProfessionalWorkstation      161      NRG8B-VKK3Q-CXVCJ-9G2XF-6Q84J
echo ProfessionalWorkstationN     162      9FNHH-K3HBT-3W4TD-6383H-6XYWF
echo ServerStandard                 7      N69G4-B89J2-4G8F4-WWYCC-J464C
echo ServerStandardCore            13      N69G4-B89J2-4G8F4-WWYCC-J464C
echo ServerDatacenter               8      WMDGN-G9PQG-XVVXX-R3X43-63DFG
echo ServerDatacenterCore          12      WMDGN-G9PQG-XVVXX-R3X43-63DFG
echo ServerSolution                52      WVDHN-86M7X-466P6-VHXV7-YY726
echo ServerSolutionCore            53      WVDHN-86M7X-466P6-VHXV7-YY726
echo ServerRdsh                   175      7NBT4-WGBQX-MP4H7-QXFF8-YP3KX

) > "editions" &exit /b   
::===============================================================================================================