# Batch Mermaid Diagram Generator
# Converts all .mmd files in the current directory to PNG/SVG
# Usage: .\batch-generate.ps1
# Usage: .\batch-generate.ps1 -Format svg
# Usage: .\batch-generate.ps1 -Format png -Theme dark

param(
    [Parameter(Mandatory=$false)]
    [ValidateSet("png", "svg", "pdf")]
    [string]$Format = "png",
    
    [Parameter(Mandatory=$false)]
    [string]$ConfigFile = "mermaid-config.json",
    
    [Parameter(Mandatory=$false)]
    [string]$Theme = "default"
)

# Get all .mmd files in current directory
$mmdFiles = Get-ChildItem -Filter "*.mmd" -File

if ($mmdFiles.Count -eq 0) {
    Write-Warning "No .mmd files found in the current directory."
    exit 0
}

Write-Host "Found $($mmdFiles.Count) Mermaid diagram file(s)" -ForegroundColor Green

foreach ($file in $mmdFiles) {
    $inputFile = $file.Name
    $baseName = $file.BaseName
    $outputFile = "$baseName.$Format"
    
    Write-Host "`n🔄 Processing: $inputFile" -ForegroundColor Yellow
    
    # Use the generate-diagram.ps1 script
    try {
        & ".\generate-diagram.ps1" -InputFile $inputFile -OutputFile $outputFile -Format $Format -ConfigFile $ConfigFile -Theme $Theme
    } catch {
        Write-Error "Failed to process $inputFile : $_"
    }
}

Write-Host "`n✅ Batch conversion completed!" -ForegroundColor Green