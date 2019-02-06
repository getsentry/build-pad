Set-PSDebug -Trace 1
$ErrorActionPreference = "Stop"

# FIXME
# rm C:\Python36\python.exe
echo (Get-Command python).source
rm "C:\Program Files (x86)\Microsoft Visual Studio\Shared\Python36_64\python.exe"


mkdir -p build
Set-Location -Path .\build

git clone https://chromium.googlesource.com/chromium/tools/depot_tools.git

$env:PATH += ";$(Get-Location)\depot_tools"
$env:VSINSTALLDIR = "$env:VS140COMNTOOLS"
Remove-Item env:PYTHON_HOME
Get-ChildItem env:

# Get-ChildItem -Path $env:VSSDK140Install
# Get-ChildItem -Path $env:VSSDK140Install\..\VC

.\depot_tools\fetch.bat crashpad
if ($LASTEXITCODE -ne 0) { exit 1 }

Set-Location -Path .\crashpad

# Build crashpad
..\depot_tools\gn.bat gen out\Default
if ($LASTEXITCODE -ne 0) { exit 1 }

..\depot_tools\ninja.exe -C out\Default
if ($LASTEXITCODE -ne 0) { exit 1 }
