[CmdletBinding()]
param(
    [switch]$Msix,
    [ValidatePattern('^[1-9][0-9]*\.[0-9]+\.[0-9]+\.0$')]
    [string]$MsixVersion = '1.0.3.0',
    [string]$IdentityName,
    [string]$Publisher,
    [string]$PublisherDisplayName
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
        $arguments = @('run', 'msix:create', '--build-windows', 'false', '--version', $MsixVersion)
        if ($IdentityName) { $arguments += @('--identity-name', $IdentityName) }
        if ($Publisher) { $arguments += @('--publisher', $Publisher) }
        if ($PublisherDisplayName) { $arguments += @('--publisher-display-name', $PublisherDisplayName) }
        & dart @arguments
        if ($LASTEXITCODE -ne 0) { throw 'MSIX packaging failed.' }
        if (-not (Test-Path 'build/windows/x64/runner/Release/*.msix')) {
            throw 'MSIX packaging did not produce a package in the release folder.'
        }
    }
} finally {
    Pop-Location
}
