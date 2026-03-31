@echo off
setlocal

set "VSWHERE=%ProgramFiles(x86)%\Microsoft Visual Studio\Installer\vswhere.exe"
if not exist "%VSWHERE%" (
  echo Could not find vswhere.exe. Install Visual Studio Build Tools with C++ workload.
  exit /b 1
)

for /f "usebackq tokens=*" %%I in (`"%VSWHERE%" -latest -products * -property installationPath`) do set "VSINSTALL=%%I"
if not defined VSINSTALL (
  echo Visual Studio installation not found.
  exit /b 1
)

set "VSDEVCMD=%VSINSTALL%\Common7\Tools\VsDevCmd.bat"
if not exist "%VSDEVCMD%" (
  echo VsDevCmd.bat not found at "%VSDEVCMD%".
  exit /b 1
)

call "%VSDEVCMD%" >nul
where cl.exe >nul 2>&1
if errorlevel 1 (
  echo MSVC compiler not found. Install "Desktop development with C++" in Visual Studio Installer.
  exit /b 9009
)

cl.exe /Zi /EHsc /nologo /Fe:"%~dpn1.exe" "%~f1"
exit /b %errorlevel%
