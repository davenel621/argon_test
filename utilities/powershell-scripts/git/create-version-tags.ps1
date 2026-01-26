param(
    [Parameter(Mandatory=$true)]
    [string]$CommitMessage,
    [Parameter(Mandatory=$true)]
    [string]$MergeCommitSha
)

$conventionalCommitType = ($CommitMessage -split ':')[0].ToLower()

$segmentToIncrement = ''

if ($conventionalCommitType -like '*!*') {
    $segmentToIncrement = 'major'
} elseif ($conventionalCommitType -like '*feat*') {
    $segmentToIncrement = 'minor'
} else {
    $segmentToIncrement = 'patch'
}

$currentVersion = git tag | Where-Object { $_ -match '^v\d+\.\d+\.\d+$' } | Sort-Object { [version]($_ -replace '^v','') } -Descending | Select-Object -First 1

$newVersion = ''

if ($currentVersion) {
    $versionNumbers = ($currentVersion -replace '^v','').Split('.')
    $major = [int]$versionNumbers[0]
    $minor = [int]$versionNumbers[1]
    $patch = [int]$versionNumbers[2]

    switch ($segmentToIncrement) {
        'major' {
            $major++
            $minor = 0
            $patch = 0
        }
        'minor' {
            $minor++
            $patch = 0
        }
        'patch' {
            $patch++
        }
        default {
            Write-Error "Unknown segment to increment: $segmentToIncrement"
            exit 1
        }
    }

    $newVersion = "v$major.$minor.$patch"
} else {
    $newVersion = "v0.1.0"
}

git tag $newVersion $MergeCommitSha

$latestTags = git tag | Where-Object { $_ -eq 'latest' }
foreach ($tag in $latestTags) {
    git tag -d $tag
    git push origin :refs/tags/$tag
}

git tag latest $MergeCommitSha

git push origin --tags