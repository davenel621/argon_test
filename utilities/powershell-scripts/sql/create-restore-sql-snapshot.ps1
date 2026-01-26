param(
    [Parameter(Mandatory=$false)]
    [string]$snapshotToRestore,
    [Parameter(Mandatory=$true)]
    [string]$semVer,
    [Parameter(Mandatory=$true)]
    [string]$ghRunId,
    [Parameter(Mandatory=$true)]
    [string]$serverInstance,
    [Parameter(Mandatory=$true)]
    [string]$databaseName
)

Write-Host "Installing SqlServer module..."
try {
    Install-Module -Name SqlServer -Scope CurrentUser -Force -AllowClobber -ErrorAction Stop
    Write-Host "SqlServer module installed successfully."
    Import-Module SqlServer -ErrorAction Stop
} catch {
    Write-Warning "Failed to install SqlServer module. Trying SQLPS..."
    try {
        Install-Module -Name SQLPS -Scope CurrentUser -Force -AllowClobber -ErrorAction Stop
        Write-Host "SQLPS module installed successfully."
        Import-Module SQLPS -ErrorAction Stop
    } catch {
        Write-Error "Failed to install both SqlServer and SQLPS modules. Exiting script."
        exit 1
    }
}

if (-not $snapshotToRestore) {
    $snapshotName   = "$(Get-Date -Format 'yyyyMMdd_HHmmss')_${semVer}_${ghRunId}"

    $dbFiles = Invoke-Sqlcmd -ServerInstance $serverInstance -Database $databaseName -Query "
    SELECT name, physical_name 
    FROM sys.master_files 
    WHERE database_id = DB_ID('$databaseName') AND type_desc = 'ROWS'
    "

    $snapshotFiles = $dbFiles | ForEach-Object {
        $originalFile = $_.physical_name
        $snapshotFile = "$($originalFile)_$($snapshotName).ss"
        "    (NAME = N'$($_.name)', FILENAME = N'$snapshotFile')"
    } -join ",`n"

    $snapshotQuery = @"
CREATE DATABASE [$snapshotName] ON
$snapshotFiles
AS SNAPSHOT OF [$databaseName];
"@

    Write-Host "Creating snapshot $snapshotName for $databaseName..."
    Invoke-Sqlcmd -ServerInstance $serverInstance -Query $snapshotQuery
    Write-Host "Snapshot $snapshotName created."
}

elseif ($snapshotToRestore) {
    Write-Host "Restoring database $databaseName from snapshot $snapshotToRestore..."

    $restoreQuery = @"
RESTORE DATABASE [$databaseName] FROM DATABASE_SNAPSHOT = N'$snapshotToRestore';
"@

    Invoke-Sqlcmd -ServerInstance $serverInstance -Query $restoreQuery
    Write-Host "Database $databaseName restored from snapshot $snapshotToRestore."
}