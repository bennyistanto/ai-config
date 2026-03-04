# Deploy RDLS Claude Code config into a target project
# Usage: .\deploy.ps1 -Target C:\path\to\target-project
#
# This copies CLAUDE.md, commands, agents, and reference docs
# from ai-config into the target project's Claude Code locations.

param(
    [Parameter(Mandatory=$true, HelpMessage="Path to target project")]
    [string]$Target
)

$ErrorActionPreference = "Stop"
$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path

if (-not (Test-Path $Target -PathType Container)) {
    Write-Error "Target directory does not exist: $Target"
    exit 1
}

Write-Host "Deploying RDLS Claude Code config to: $Target"

# Create .claude directories
New-Item -ItemType Directory -Force -Path "$Target\.claude\commands" | Out-Null
New-Item -ItemType Directory -Force -Path "$Target\.claude\agents" | Out-Null

# Deploy CLAUDE.md (project root)
Copy-Item "$ScriptDir\CLAUDE.md" "$Target\CLAUDE.md"
Write-Host "  -> CLAUDE.md"

# Deploy reference docs into .claude/
$refDocs = @(
    "module-reference.md",
    "schema-reference.md",
    "constraints-reference.md",
    "naming-reference.md",
    "signals-reference.md",
    "configs-detail-reference.md"
)
foreach ($doc in $refDocs) {
    Copy-Item "$ScriptDir\$doc" "$Target\.claude\$doc"
}
Write-Host "  -> .claude\*.md ($($refDocs.Count) reference docs)"

# Deploy commands
$commands = Get-ChildItem "$ScriptDir\commands\*.md"
foreach ($cmd in $commands) {
    Copy-Item $cmd.FullName "$Target\.claude\commands\$($cmd.Name)"
    Write-Host "  -> .claude\commands\$($cmd.Name)"
}

# Deploy agents
$agents = Get-ChildItem "$ScriptDir\agents\*.md"
foreach ($agent in $agents) {
    Copy-Item $agent.FullName "$Target\.claude\agents\$($agent.Name)"
    Write-Host "  -> .claude\agents\$($agent.Name)"
}

Write-Host ""
Write-Host "Done. Deployed to ${Target}:"
Write-Host "  - CLAUDE.md (project instructions)"
Write-Host "  - .claude\commands\ ($($commands.Count) commands)"
Write-Host "  - .claude\agents\ ($($agents.Count) agents)"
Write-Host "  - .claude\*.md ($($refDocs.Count) reference docs)"
