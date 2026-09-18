[CmdletBinding()]
param(
    [switch]$Msix,
    [ValidatePattern('^[1-9][0-9]*\.[0-9]+\.[0-9]+\.0$')]
    [string]$MsixVersion = '1.0.4.0',
    [ValidateSet('ParisoftAI.ElectricianExamPrepNEC')]
    [string]$IdentityName = 'ParisoftAI.ElectricianExamPrepNEC',
    [ValidateSet('CN=BAFD5734-F723-4C9B-9352-3ED618975B07')]
    [string]$Publisher = 'CN=BAFD5734-F723-4C9B-9352-3ED618975B07',
    [ValidateSet('ParisoftAI')]
    [string]$PublisherDisplayName = 'ParisoftAI'
)

$ErrorActionPreference = 'Stop'
Set-StrictMode -Version Latest
if (-not $IsWindows) { throw 'This script requires Windows and PowerShell 7.' }
foreach ($part in $MsixVersion.Split('.')) {
    if ([long]$part -gt 65535) { throw 'MSIX version components must be at most 65535.' }
}

Push-Location (Split-Path $PSScriptRoot -Parent)
try {
    if (-not (Test-Path .env)) { throw 'Create the required .env asset before building.' }
    $buildName = ($MsixVersion.Split('.')[0..2] -join '.')
    & flutter build windows --release "--build-name=$buildName" --build-number=0
    if ($LASTEXITCODE -ne 0) { throw 'Windows release build failed.' }

    if ($Msix) {
        $arguments = @('run', 'msix:create', '--store', '--build-windows', 'false', '--version', $MsixVersion)
        if ($IdentityName) { $arguments += @('--identity-name', $IdentityName) }
        if ($Publisher) { $arguments += @('--publisher', $Publisher) }
        if ($PublisherDisplayName) { $arguments += @('--publisher-display-name', $PublisherDisplayName) }
        & dart @arguments
        if ($LASTEXITCODE -ne 0) { throw 'MSIX packaging failed.' }
        & python ./scripts/validate_windows_package.py 'build/windows/x64/runner/Release/electrician-exam-prep-nec.msix' $MsixVersion
        if ($LASTEXITCODE -ne 0) { throw 'MSIX validation failed.' }
    }
} finally {
    Pop-Location
}
