#!/bin/bash
# crypto-cs GitHub 초기화 스크립트
# 사용법: 터미널에서 crypto-cs 폴더에서 실행

cd "c:/crypto-cs" || exit 1

# 1. git 초기화
git init

# 2. .gitignore 확인
echo "✅ .gitignore 확인"
cat .gitignore

# 3. 초기 커밋
git add README.md .gitignore docs/
git commit -m "docs: init crypto-cs workflow documentation

- README with architecture overview and setup guide
- Architecture & data flow diagrams (Mermaid)
- Test case matrix (32 scenarios)
- .gitignore for workflow JSON files (contain secrets)"

# 4. 워크플로우 파일 추가 (시크릿 제거 후)
echo ""
echo "⚠️  워크플로우 JSON에 시크릿이 하드코딩되어 있습니다."
echo "   시크릿을 환경변수로 교체한 후에 추가하세요:"
echo ""
echo "   1. Slack Bot Token → \$env.SLACK_BOT_TOKEN"
echo "   2. Etherscan Key   → \$env.ETHERSCAN_API_KEY"
echo "   3. Channel ID      → \$env.SLACK_CS_CHANNEL"
echo ""
echo "교체 완료 후:"
echo "   git add 'My workflow(1).json'"
echo "   git commit -m 'feat: add n8n workflow (secrets removed)'"

# 5. GitHub 리모트 추가
echo ""
echo "GitHub repo 생성 후:"
echo "   git remote add origin https://github.com/YOUR_USERNAME/crypto-cs.git"
echo "   git branch -M main"
echo "   git push -u origin main"
