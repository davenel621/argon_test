param(
    [Parameter(Mandatory=$true)]
    [string]$SourceRepoUrl,
    [Parameter(Mandatory=$true, DontShow=$true)]
    [string]$SourceToken,
    [Parameter(Mandatory=$true)]
    [string]$DestinationRepoUrl,
    [Parameter(Mandatory=$true, DontShow=$true)]
    [string]$DestinationToken
)

if (-not $env:TEMP -or [string]::IsNullOrWhiteSpace($env:TEMP)) {
    $env:TEMP = Join-Path $PSScriptRoot 'tmp'
    if (-not (Test-Path $env:TEMP)) {
        New-Item -ItemType Directory -Path $env:TEMP | Out-Null
    }
}

$tempDir = New-Item -ItemType Directory -Path (Join-Path $env:TEMP (New-Guid))

try {
    if ($SourceRepoUrl -match 'github') {
        $srcUri = $SourceRepoUrl -replace 'https://', "https://x-access-token:$SourceToken@"
    } else {
        $srcUri = $SourceRepoUrl -replace 'https://', "https://$SourceToken@"
    }

    if ($DestinationRepoUrl -match 'github') {
        $dstUri = $DestinationRepoUrl -replace 'https://', "https://x-access-token:$DestinationToken@"
    } else {
        $dstUri = $DestinationRepoUrl -replace 'https://', "https://$DestinationToken@"
    }
    git clone --mirror $srcUri $tempDir
    Set-Location $tempDir
    git remote set-url origin $dstUri
    git push --mirror --force

    Write-Host "Repository migration completed successfully"
}
catch {
    Write-Error "An error occurred during the migration: $_"
    exit 1
}
finally {
    Set-Location $PSScriptRoot
    Remove-Item -Recurse -Force $tempDir
}