# Watch the desktop memo and publish it to GitHub Pages.
# History is kept to a single commit (amend + force push) so old memo text does not pile up publicly.
param(
    [string]$Source = (Join-Path ([Environment]::GetFolderPath('Desktop')) 'web-memo.txt'),
    [int]$IntervalSec = 3
)

$ErrorActionPreference = 'Continue'
$repo = $PSScriptRoot
$dest = Join-Path $repo 'memo.txt'

# Console write, not Write-Output: output inside Publish would otherwise become part of its return value
function Log($msg) {
    $line = "[{0}] {1}" -f (Get-Date -Format 'yyyy-MM-dd HH:mm:ss'), $msg
    [Console]::WriteLine($line)
}

function Publish {
    Copy-Item -LiteralPath $Source -Destination $dest -Force
    git -C $repo add memo.txt | Out-Null
    git -C $repo diff --cached --quiet
    if ($LASTEXITCODE -eq 0) { Log 'no change'; return $true }
    git -C $repo commit --amend --no-edit --quiet
    for ($i = 1; $i -le 3; $i++) {
        git -C $repo push --force --quiet origin main 2>&1 | Out-Null
        if ($LASTEXITCODE -eq 0) { Log 'published'; return $true }
        Log "push failed (try $i)"
        Start-Sleep -Seconds (5 * $i)
    }
    return $false
}

if (-not (Test-Path -LiteralPath $Source)) { New-Item -ItemType File -Path $Source | Out-Null }
Log "watching $Source"

$last = $null
while ($true) {
    try {
        $stamp = (Get-Item -LiteralPath $Source -ErrorAction Stop).LastWriteTimeUtc
        if ($stamp -ne $last) {
            Start-Sleep -Seconds 1   # let the editor finish writing
            if (Publish) { $last = $stamp }
        }
    } catch {
        Log "error: $($_.Exception.Message)"
    }
    Start-Sleep -Seconds $IntervalSec
}
