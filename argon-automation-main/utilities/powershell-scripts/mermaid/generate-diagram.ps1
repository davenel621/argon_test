# Mermaid Diagram Generator Script
# Usage: .\generate-diagram.ps1 -InputFile "diagram.mmd" -OutputFile "diagram.png"
# Usage: .\generate-diagram.ps1 -InputFile "diagram.mmd" -OutputFile "diagram.svg" -Format svg

param(
    [Parameter(Mandatory=$true)]
    [string]$InputFile,
    
    [Parameter(Mandatory=$true)]
    [string]$OutputFile,
    
    [Parameter(Mandatory=$false)]
    [ValidateSet("png", "svg", "pdf")]
    [string]$Format = "png",
    
    [Parameter(Mandatory=$false)]
    [string]$ConfigFile = "mermaid-config.json",
    
    [Parameter(Mandatory=$false)]
    [string]$Theme = "default"
)

# Check if input file exists
if (-not (Test-Path $InputFile)) {
    Write-Error "Input file '$InputFile' not found!"
    exit 1
}

# Build mmdc command
$mmdcArgs = @("-i", $InputFile, "-o", $OutputFile)

# Add config file if it exists
if (Test-Path $ConfigFile) {
    $mmdcArgs += @("-c", $ConfigFile)
    Write-Host "Using config file: $ConfigFile" -ForegroundColor Green
}

# Add theme
if ($Theme -ne "default") {
    $mmdcArgs += @("-t", $Theme)
    Write-Host "Using theme: $Theme" -ForegroundColor Green
}

# Execute mmdc command
Write-Host "Generating diagram..." -ForegroundColor Yellow
Write-Host "Input: $InputFile" -ForegroundColor Cyan
Write-Host "Output: $OutputFile" -ForegroundColor Cyan
Write-Host "Format: $Format" -ForegroundColor Cyan

try {
    & mmdc $mmdcArgs
    Write-Host "✅ Diagram generated successfully!" -ForegroundColor Green
} catch {
    Write-Error "❌ Failed to generate diagram: $_"
    exit 1
}