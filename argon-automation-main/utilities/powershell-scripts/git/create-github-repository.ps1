param(
    [Parameter(Mandatory=$true, DontShow=$true)]
    [string]$GitHubToken,
    [Parameter(Mandatory=$true)]
    [string]$OrgName,
    [Parameter(Mandatory=$true)]
    [string]$TemplateRepo,
    [Parameter(Mandatory=$true)]
    [string]$RepoName,
    [Parameter(Mandatory=$true)]
    [string]$TeamSlug,
    [Parameter(Mandatory=$false)]
    [string]$Description = "",
    [Parameter(Mandatory=$false)]
    [bool]$Private = $true
)

$headers = @{
    Authorization = "Bearer $GitHubToken"
    Accept        = "application/vnd.github+json"
    'User-Agent'  = 'PowerShell-Script'
}

$generateRepoUri = "https://api.github.com/repos/$OrgName/$TemplateRepo/generate"
$generateRepoBody = @{
    owner       = $OrgName
    name        = $RepoName
    description = $Description
    include_all_branches = $false
    private     = $Private
} | ConvertTo-Json

try {
    $response = Invoke-RestMethod -Uri $generateRepoUri -Method Post -Headers $headers -Body $generateRepoBody -ContentType 'application/json'
    Write-Host "Repository '$RepoName' created from template '$TemplateOwner/$TemplateRepo' in organization '$OrgName'."
    Write-Host "Response: $response"
} catch {
    Write-Error "Failed to create repository from template: $_"
    exit 1
}

$addTeamUri = "https://api.github.com/orgs/$OrgName/teams/$TeamSlug/repos/$OrgName/$RepoName"
$addTeamBody = @{ permission = 'admin' } | ConvertTo-Json

try {
    $response = Invoke-WebRequest -Uri $addTeamUri -Method Put -Headers $headers -Body $addTeamBody -ContentType 'application/json'
    Write-Host "Team '$TeamSlug' added to repo '$OrgName/$RepoName' with 'admin' access."
    Write-Host "Status Code: $($response.StatusCode)"
} catch {
    Write-Error "Failed to add team to repository: $_"
    exit 1
}

Write-Host "Checking repository readiness..."
$timeout = 300
$interval = 5
$elapsedTime = 0
while ($elapsedTime -lt $timeout) {
    try {
        $repoCheckUri = "https://api.github.com/repos/$OrgName/$RepoName"
        $repoResponse = Invoke-WebRequest -Uri $repoCheckUri -Headers $headers -Method Get
        if ($repoResponse.StatusCode -eq 200) {
            Write-Host "Repository is ready."
            break
        }
    } catch {
        Write-Host "Repository not ready yet. Retrying in $interval seconds..."
    }
    Start-Sleep -Seconds $interval
    $elapsedTime += $interval
}
if ($elapsedTime -ge $timeout) {
    Write-Error "Timeout reached while waiting for repository readiness."
    exit 1
}
Start-Sleep -Seconds 15
Write-Host "Continuing with the next action."

Write-Host "Waiting for README.md to be available..."
$readmeUri = "https://api.github.com/repos/$OrgName/$RepoName/contents/README.md"
$readmeTimeout = 300
$readmeInterval = 5
$readmeElapsedTime = 0
$currentSha = $null

while ($readmeElapsedTime -lt $readmeTimeout) {
    try {
        $readmeResponse = Invoke-WebRequest -Uri $readmeUri -Headers $headers -Method Get
        if ($readmeResponse.StatusCode -eq 200) {
            $readmeJson = $readmeResponse.Content | ConvertFrom-Json
            $currentSha = $readmeJson.sha
            Write-Host "README.md is now available."
            break
        }
    } catch {
        Write-Host "README.md not available yet. Retrying in $readmeInterval seconds..."
    }
    Start-Sleep -Seconds $readmeInterval
    $readmeElapsedTime += $readmeInterval
}

if ($readmeElapsedTime -ge $readmeTimeout -or $null -eq $currentSha) {
    Write-Error "Timeout reached while waiting for README.md to be available."
    exit 1
}

$newReadmeContent = "# $RepoName`n$Description`n"


$encodedContent = [Convert]::ToBase64String([System.Text.Encoding]::UTF8.GetBytes($newReadmeContent))

$updateReadmeBody = @{
    message   = "Update README title and description"
    content   = $encodedContent
    sha       = $currentSha
    committer = @{
        name  = "Automation Script"
        email = "noreply@$OrgName.com"
    }
} | ConvertTo-Json

try {
    $updateResponse = Invoke-WebRequest -Uri $readmeUri -Method Put -Headers $headers -Body $updateReadmeBody -ContentType 'application/json'
    Write-Host "README.md updated successfully."
    Write-Host "Status Code: $($updateResponse.StatusCode)"
} catch {
    Write-Error "Failed to update README.md: $_"
    exit 1
}

$repositoryUrl = "https://github.com/$OrgName/$RepoName"
Write-Host "$RepoName created successfully"
Write-Host "Repository URL: $repositoryUrl"
Write-Output $repositoryUrl