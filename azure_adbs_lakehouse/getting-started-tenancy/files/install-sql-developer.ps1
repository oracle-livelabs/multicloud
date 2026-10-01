$ErrorActionPreference = 'Stop'
$InstallRoot = 'C:\software'
$ZipPath = Join-Path $InstallRoot 'sqldeveloper-26.2.0.186.2220-x64.zip'
$SqlDeveloperZipUri = 'https://download.oracle.com/otn_software/java/sqldeveloper/sqldeveloper-26.2.0.186.2220-x64.zip'
$SqlDeveloperExe = Join-Path $InstallRoot 'sqldeveloper\sqldeveloper.exe'

New-Item -ItemType Directory -Path $InstallRoot -Force | Out-Null

if (-not (Test-Path -LiteralPath $SqlDeveloperExe)) {
    Invoke-WebRequest -Uri $SqlDeveloperZipUri -OutFile $ZipPath
    Expand-Archive -LiteralPath $ZipPath -DestinationPath $InstallRoot -Force
    Remove-Item -LiteralPath $ZipPath -Force
}

Start-Process -FilePath $SqlDeveloperExe
