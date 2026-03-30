<#
.SYNOPSIS
    gstack-antigravity 자동 설치 스크립트
.DESCRIPTION
    워크플로우와 빌더 규칙을 Antigravity 디렉토리에 복사합니다.
.EXAMPLE
    .\install.ps1
    .\install.ps1 -SkipRules    # 빌더 규칙 복사 건너뛰기
#>

param(
    [switch]$SkipRules
)

$ErrorActionPreference = "Stop"

Write-Host ""
Write-Host "╔═══════════════════════════════════════════╗" -ForegroundColor Cyan
Write-Host "║   gstack-antigravity installer            ║" -ForegroundColor Cyan
Write-Host "╚═══════════════════════════════════════════╝" -ForegroundColor Cyan
Write-Host ""

# 경로 설정
$WorkflowSource = Join-Path $PSScriptRoot "workflows"
$RulesSource = Join-Path $PSScriptRoot "rules" "custom_rules.md"
$WorkflowDest = Join-Path $env:USERPROFILE ".gemini" "antigravity" "global_workflows"
$RulesDest = Join-Path $env:USERPROFILE ".agent" "custom_rules.md"

# 워크플로우 디렉토리 확인
if (-not (Test-Path $WorkflowDest)) {
    Write-Host "[!] Antigravity global_workflows 디렉토리가 없습니다: $WorkflowDest" -ForegroundColor Yellow
    Write-Host "    Antigravity가 설치되어 있는지 확인하세요." -ForegroundColor Yellow
    New-Item -ItemType Directory -Force -Path $WorkflowDest | Out-Null
    Write-Host "[✓] 디렉토리 생성됨" -ForegroundColor Green
}

# 워크플로우 복사
Write-Host ""
Write-Host "[1/2] 워크플로우 복사 중..." -ForegroundColor White

$workflows = Get-ChildItem -Path $WorkflowSource -Filter "*.md"
$count = 0
foreach ($wf in $workflows) {
    Copy-Item -Path $wf.FullName -Destination $WorkflowDest -Force
    $count++
    Write-Host "  ✓ $($wf.Name)" -ForegroundColor Green
}
Write-Host "  → $count 개 워크플로우 설치 완료" -ForegroundColor Cyan

# 빌더 규칙 복사
if (-not $SkipRules) {
    Write-Host ""
    Write-Host "[2/2] 빌더 규칙 복사 중..." -ForegroundColor White

    $agentDir = Join-Path $env:USERPROFILE ".agent"
    if (-not (Test-Path $agentDir)) {
        New-Item -ItemType Directory -Force -Path $agentDir | Out-Null
    }

    # 기존 파일 백업
    if (Test-Path $RulesDest) {
        $backupPath = "$RulesDest.backup.$(Get-Date -Format 'yyyyMMdd-HHmmss')"
        Copy-Item -Path $RulesDest -Destination $backupPath -Force
        Write-Host "  ⚠ 기존 규칙 백업됨: $backupPath" -ForegroundColor Yellow
    }

    Copy-Item -Path $RulesSource -Destination $RulesDest -Force
    Write-Host "  ✓ custom_rules.md" -ForegroundColor Green
    Write-Host "  → 빌더 규칙 설치 완료" -ForegroundColor Cyan
} else {
    Write-Host ""
    Write-Host "[2/2] 빌더 규칙 스킵 (-SkipRules)" -ForegroundColor Gray
}

# 완료
Write-Host ""
Write-Host "╔═══════════════════════════════════════════╗" -ForegroundColor Green
Write-Host "║   ✅ 설치 완료!                            ║" -ForegroundColor Green
Write-Host "║                                           ║" -ForegroundColor Green
Write-Host "║   Antigravity를 재시작하면 적용됩니다.      ║" -ForegroundColor Green
Write-Host "║                                           ║" -ForegroundColor Green
Write-Host "║   사용 가능한 커맨드:                       ║" -ForegroundColor Green
Write-Host "║   /office-hours   아이디어 검증             ║" -ForegroundColor Green
Write-Host "║   /plan-review    통합 리뷰                 ║" -ForegroundColor Green
Write-Host "║   /investigate    디버깅                    ║" -ForegroundColor Green
Write-Host "║   /review         코드 리뷰                 ║" -ForegroundColor Green
Write-Host "║   /ship           PR & 배포                 ║" -ForegroundColor Green
Write-Host "║   /retro          주간 회고                  ║" -ForegroundColor Green
Write-Host "║   /security-audit 보안 감사                  ║" -ForegroundColor Green
Write-Host "╚═══════════════════════════════════════════╝" -ForegroundColor Green
Write-Host ""
