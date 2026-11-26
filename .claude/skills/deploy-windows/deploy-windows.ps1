<#
Build the Windows release, zip it, and (with -Publish) push the unzipped build to a new orphan
branch + tag on GitHub and create a GitHub Release with the zip.
See SKILL.md in this folder.
#>
param(
    [switch]$Publish,
    [switch]$SkipBuild,
    [string]$Repo = 'nhhoang1811vn/StockandInventoryOffline'
)

$ErrorActionPreference = 'Stop'

function Run {
    # Runs a native command and fails the script on a non-zero exit code.
    param([string]$Exe, [string[]]$Arguments)
    & $Exe @Arguments
    if ($LASTEXITCODE -ne 0) { throw "$Exe $($Arguments -join ' ') failed (exit $LASTEXITCODE)" }
}

function TryRun {
    # Runs a native command, ignores failure and output (Windows PowerShell 5.1 turns
    # native stderr into errors under -ErrorAction Stop).
    param([string]$Exe, [string[]]$Arguments)
    $old = $ErrorActionPreference
    $ErrorActionPreference = 'Continue'
    try { & $Exe @Arguments *> $null } finally { $ErrorActionPreference = $old }
    $global:LASTEXITCODE = 0
}

$root = (git rev-parse --show-toplevel).Trim()
Set-Location $root

# --- version, names ---
$m = Select-String -Path 'pubspec.yaml' -Pattern '^version:\s*(\d+\.\d+\.\d+)\+\d+' | Select-Object -First 1
if (-not $m) { throw 'Could not read version from pubspec.yaml' }
$ver = $m.Matches[0].Groups[1].Value
$tag = "v${ver}w"
$branch = "windows/v$ver"
$releaseDir = Join-Path $root 'build\windows\x64\runner\Release'
$zipPath = Join-Path $root "dist\StockandInventory-$ver-windows.zip"
$remoteUrl = "https://github.com/$Repo.git"

Write-Host "Version $ver -> tag $tag, branch $branch"
$dirty = @(git status --porcelain).Count
Write-Host "Uncommitted changes in working tree: $dirty (the build uses the working tree as it is)"

# --- github remote, refuse an existing branch/tag ---
$remotes = @(git remote)
if ($remotes -notcontains 'github') {
    Run git @('remote', 'add', 'github', $remoteUrl)
    Write-Host "Added remote 'github' -> $remoteUrl"
} else {
    $existing = (git remote get-url github).Trim()
    if ($existing -ne $remoteUrl) { throw "Remote 'github' points to $existing, expected $remoteUrl" }
}
$found = git ls-remote --heads --tags github "refs/heads/$branch" "refs/tags/$tag"
if ($LASTEXITCODE -ne 0) { throw 'Could not reach GitHub (git ls-remote failed)' }
if ($found) { throw "Branch $branch or tag $tag already exists on GitHub:`n$found" }

# --- build ---
if (-not $SkipBuild) {
    Run flutter @('build', 'windows', '--release')
}
$exe = Join-Path $releaseDir 'StockandInventory.exe'
if (-not (Test-Path $exe)) { throw "Missing $exe. Run without -SkipBuild." }
$big = Get-ChildItem -Path $releaseDir -Recurse -File | Where-Object { $_.Length -gt 100MB }
if ($big) { throw "Files over GitHub's 100 MB limit: $($big.FullName -join ', ')" }

# --- zip ---
if (-not $SkipBuild -or -not (Test-Path $zipPath)) {
    New-Item -ItemType Directory -Force -Path (Split-Path $zipPath) | Out-Null
    if (Test-Path $zipPath) { Remove-Item $zipPath -Force }
    Compress-Archive -Path (Join-Path $releaseDir '*') -DestinationPath $zipPath
}
$zipMb = [math]::Round((Get-Item $zipPath).Length / 1MB, 1)
Write-Host "Zip: $zipPath ($zipMb MB)"

if (-not $Publish) {
    Write-Host 'Phase 1 done. Nothing was pushed. Re-run with -Publish -SkipBuild to publish.'
    return
}

# --- publish ---
Run gh @('auth', 'status')

$tmp = Join-Path $env:TEMP "winrel-$ver"
if (Test-Path $tmp) {
    TryRun git @('worktree', 'remove', '--force', $tmp)
    if (Test-Path $tmp) { Remove-Item $tmp -Recurse -Force }
    TryRun git @('worktree', 'prune')
}

try {
    Run git @('worktree', 'add', '--orphan', '-b', $branch, $tmp)
    robocopy $releaseDir $tmp /E /NFL /NDL /NJH /NJS /NP | Out-Null
    if ($LASTEXITCODE -ge 8) { throw "robocopy failed (exit $LASTEXITCODE)" }
    $global:LASTEXITCODE = 0

    Push-Location $tmp
    try {
        Run git @('-c', 'core.autocrlf=false', 'add', '-A')
        Run git @('-c', 'core.autocrlf=false', 'commit', '-m', "Windows release v$ver")
        Run git @('tag', '-a', $tag, '-m', "Windows release v$ver")
        Run git @('push', 'github', "refs/heads/$branch", "refs/tags/$tag")
    } finally {
        Pop-Location
    }

    $notes = "Windows build of Stock & Inventory $ver. Unzip and run StockandInventory.exe. " +
             "The unzipped files are also on branch $branch."
    Run gh @('release', 'create', $tag, $zipPath, '--repo', $Repo, '--verify-tag',
             '--title', "Stock & Inventory $ver (Windows)", '--notes', $notes)
} finally {
    TryRun git @('worktree', 'remove', '--force', $tmp)
    TryRun git @('worktree', 'prune')
    TryRun git @('branch', '-D', $branch)
}

Write-Host "Done: https://github.com/$Repo/releases/tag/$tag"
Write-Host "Reminder: Config.windowsReleaseUrl still points to the previous tag."
