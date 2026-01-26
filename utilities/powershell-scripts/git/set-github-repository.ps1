param(
    [Parameter(Mandatory=$true, DontShow=$true)]
    [string]$GitHubToken,
    [Parameter(Mandatory=$true)]
    [string]$RepoOwner,
    [Parameter(Mandatory=$true)]
    [string]$RepoName,
    [Parameter(Mandatory=$true)]
    [string]$OrgName,
    [Parameter(Mandatory=$false)]
    [string]$TeamSlug
)

$headers = @{
    Authorization = "Bearer $GitHubToken"
    Accept        = "application/vnd.github+json"
    'User-Agent'  = 'PowerShell-Script'
}

$autoDeleteHeadBranchesUri = "https://api.github.com/repos/$RepoOwner/$RepoName"
$autoDeleteHeadBranchesBody = @{
    delete_branch_on_merge = $true
} | ConvertTo-Json

try {
    $response = Invoke-WebRequest -Uri $autoDeleteHeadBranchesUri -Method Patch -Headers $headers -Body $autoDeleteHeadBranchesBody -ContentType 'application/json'
    Write-Host "'Automatically delete head branches' enabled for '$RepoOwner/$RepoName'."
    Write-Host "Status Code: $($response.StatusCode)"
} catch {
    Write-Error "Failed to enable 'Automatically delete head branches': $_"
    exit 1
}

if ($TeamSlug) {
    $addTeamUri = "https://api.github.com/orgs/$Org/teams/$TeamSlug/repos/$RepoOwner/$RepoName"
    $addTeamBody = @{ permission = 'admin' } | ConvertTo-Json
    
    try {
        $response = Invoke-WebRequest -Uri $addTeamUri -Method Put -Headers $headers -Body $addTeamBody -ContentType 'application/json'
        Write-Host "Team '$TeamSlug' added to repo '$RepoOwner/$RepoName' with 'admin' access."
        Write-Host "Status Code: $($response.StatusCode)"
    } catch {
        Write-Error "Failed to add team to repository: $_"
    }
}

$rulesetsUri = "https://api.github.com/repos/$RepoOwner/$RepoName/rulesets"
$coreBranchProtectionsBody = @{
    name = "Core Branch Protections"
    target = "branch"
    enforcement = "active"
    conditions = @{
        ref_name = @{
            include = @("refs/heads/main")
            exclude = @()
        }
    }
    rules = @(
        @{
            type = "deletion"
        },
        @{
            type = "non_fast_forward"
        },
        @{
            type = "pull_request"
            parameters = @{
                required_approving_review_count           = 1
                dismiss_stale_reviews_on_push             = $true
                require_code_owner_review                 = $false
                require_last_push_approval                = $true
                required_review_thread_resolution         = $true
                automatic_copilot_code_review_enabled     = $true
                allowed_merge_methods                     = @("squash")
            }
        }
    )
    bypass_actors = @()
}

$coreBranchProtectionsBodyJson = $coreBranchProtectionsBody | ConvertTo-Json -Depth 10

try {
    $response = Invoke-WebRequest -Uri $rulesetsUri -Method Post -Headers $headers -Body $coreBranchProtectionsBodyJson -ContentType 'application/json'
    Write-Host "Branch ruleset 'Core Branch Protections' created for '$RepoOwner/$RepoName'."
    Write-Host "Status Code: $($response.StatusCode)"
} catch {
    Write-Error "Failed to create branch ruleset: $_"
    exit 1
}

$branchNamingConventionBody = @{
    name = "Branch Naming Convention"
    target = "branch"
    enforcement = "active"
    conditions = @{
        ref_name = @{
            exclude = @("refs/heads/main")
            include = @("~ALL")
        }
    }
    rules = @(
        @{
            type = "branch_name_pattern"
            parameters = @{
                operator = "regex"
                pattern = "users\/(.+)\/(.+)"
                negate = $false
                name = "All branches must follow the following convention: users/some-user/some-description"
            }
        }
    )
    bypass_actors = @()
}

$branchNamingConventionBodyJson = $branchNamingConventionBody | ConvertTo-Json -Depth 10

try {
    $response = Invoke-WebRequest -Uri $rulesetsUri -Method Post -Headers $headers -Body $branchNamingConventionBodyJson -ContentType 'application/json'
    Write-Host "Branch ruleset 'Branch Naming Convention' created for '$RepoOwner/$RepoName'."
    Write-Host "Status Code: $($response.StatusCode)"
} catch {
    Write-Error "Failed to create branch ruleset: $_"
    exit 1
}