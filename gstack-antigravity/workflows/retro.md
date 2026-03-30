---
description: 주간 회고. 이번 주 뭘 했고, 뭘 배웠고, 다음 주 뭘 할지. "회고", "retro", "이번 주 정리" 할 때 사용.
---

# /retro — 주간 회고

## Step 1: 데이터 수집

### Git 통계

에이전트는 사용자의 OS 환경에 맞는 명령어를 실행하여 통계를 수집한다.

#### 🪟 Windows (PowerShell)
```powershell
# 이번 주 커밋
git log --since="1 week ago" --oneline --author="$(git config user.name)"

# 변경량
git log --since="1 week ago" --author="$(git config user.name)" --shortstat

# 자주 수정한 파일 Top 20
git log --since="1 week ago" --author="$(git config user.name)" --name-only --format="" | Where-Object { $_ -ne "" } | Group-Object | Sort-Object Count -Descending | Select-Object -First 20 Name, Count
```

#### 🍎 macOS / 🐧 Linux (Bash)
```bash
# 이번 주 커밋
git log --since="1 week ago" --oneline --author="$(git config user.name)"

# 변경량
git log --since="1 week ago" --author="$(git config user.name)" --shortstat

# 자주 수정한 파일 Top 20
git log --since="1 week ago" --author="$(git config user.name)" --name-only --format="" | sort | uniq -c | sort -rn | head -20
```

### 프로젝트 상태
- `TODOS.md` 확인 (있으면)
- 열린 이슈/PR 확인 (있으면)

---

## Step 2: 요약 생성

```
╔═══════════════════════════════════════════╗
║           주간 회고 — YYYY-MM-DD          ║
╠═══════════════════════════════════════════╣
║                                           ║
║  📊 이번 주 숫자                           ║
║  ─────────────────────                    ║
║  커밋:     N개                             ║
║  파일:     +NNNN / -NNNN                  ║
║  테스트:   N → N (+N 추가)                 ║
║                                           ║
║  🚀 배포한 것                              ║
║  ─────────────────────                    ║
║  1. [기능/수정 1]                          ║
║  2. [기능/수정 2]                          ║
║  3. [기능/수정 3]                          ║
║                                           ║
║  📚 배운 것                                ║
║  ─────────────────────                    ║
║  1. [교훈 1]                               ║
║  2. [교훈 2]                               ║
║                                           ║
║  ⚠️ 주의할 것                              ║
║  ─────────────────────                    ║
║  1. [기술 부채 / 리스크]                    ║
║                                           ║
║  🎯 다음 주 계획                            ║
║  ─────────────────────                    ║
║  1. [작업 1]                               ║
║  2. [작업 2]                               ║
║                                           ║
╚═══════════════════════════════════════════╝
```

---

## Step 3: 건강 지표

### 코드 건강
- **테스트 추세**: 테스트 수가 늘고 있는가, 줄고 있는가?
- **같은 파일 반복 수정**: 같은 파일을 3번 이상 고쳤으면 → 아키텍처 스멜
- **TODO 추세**: TODO가 늘고 있는가, 줄고 있는가?

### 성장 기회
- 이번 주 가장 어려웠던 부분은? → 학습 기회
- 반복 작업이 있었는가? → 자동화 기회
- 리뷰에서 잡힌 버그 패턴은? → 예방 가능한 실수

---

## Step 4: TODOS.md 업데이트

회고 결과를 `TODOS.md`에 반영 (파일이 있으면):
- 완료된 항목 체크
- 새로 발견된 작업 추가
- 우선순위 재조정
