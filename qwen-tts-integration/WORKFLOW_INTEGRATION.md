# 📚 워크플로우 통합 매뉴얼 (Workflow Integrated Manual)

이 문서는 프로젝트 내의 `.agent/workflows` 디렉토리에 정의된 워크플로우와 보안 가이드를 통합하여 정리한 것입니다. 각 섹션은 해당 워크플로우 파일의 내용을 포함하며, 원본 파일로의 링크를 제공합니다.

---

## 🚀 Essentials (필수 워크플로우)

> **원본 파일**: [.agent/workflows/essentials.md](.agent/workflows/essentials.md)

개발 프로세스의 기본이 되는 "Essentials" 스타터 팩입니다. 효율적이고 체계적인 개발을 위해 다음 항목들을 준수합니다.

- **`concise-planning`**: 모든 작업은 철저한 계획 수립에서 시작합니다. (Always start with a plan.)
- **`lint-and-validate`**: 자동화된 도구를 통해 코드 품질을 깨끗하게 유지합니다. (Keep your code clean automatically.)
- **`git-pushing`**: 작업 내용을 안전하게 저장하고 관리합니다. (Save your work safely.)
- **`kaizen`**: 지속적인 개선(Kaizen) 마인드셋을 갖습니다. (Continuous improvement mindset.)
- **`systematic-debugging`**: 체계적인 접근 방식으로 프로처럼 디버깅합니다. (Debug like a pro.)

---

## 🛡️ Security & Compliance (보안 및 규정 준수)

> **원본 파일**: [.agent/workflows/securitycompliance.md](.agent/workflows/securitycompliance.md)

보안 엔지니어링 및 안전한 애플리케이션 개발을 위한 포괄적인 가이드입니다.

### 🕵️‍♂️ 보안 엔지니어 팩 (The "Security Engineer" Pack)

침투 테스트, 보안 감사, 시스템 강화를 위한 전문적인 방법론을 포함합니다.

1.  **`ethical-hacking-methodology`**: 윤리적 해킹의 바이블 (The Bible of ethical hacking).
2.  **`burp-suite-testing`**: 웹 취약점 스캐닝 및 테스트 (Web vulnerability scanning).
3.  **`top-web-vulnerabilities`**: OWASP 기준 취약점 분류체계 (OWASP-aligned vulnerability taxonomy).
4.  **`linux-privilege-escalation`**: 고급 리눅스 보안 평가 및 권한 상승 분석 (Advanced Linux security assessment).
5.  **`cloud-penetration-testing`**: AWS, Azure, GCP 클라우드 보안 테스트 (AWS/Azure/GCP security).
6.  **`security-auditor`**: 포괄적인 보안 감사 수행 (Comprehensive security audits).
7.  **`vulnerability-scanner`**: 고급 취약점 분석 도구 활용 (Advanced vulnerability analysis).

### 🔐 보안 개발자 팩 (The "Security Developer" Pack)

처음부터 안전한 애플리케이션을 구축하기 위한 개발자 전용 가이드입니다.

1.  **`api-security-best-practices`**: 안전한 API 설계 패턴 (Secure API design patterns).
2.  **`auth-implementation-patterns`**: JWT, OAuth2, 세션 관리 구현 패턴 (Auth implementation patterns).
3.  **`backend-security-coder`**: 안전한 백엔드 코딩 관행 (Secure backend coding practices).
4.  **`frontend-security-coder`**: XSS 방지 및 클라이언트 보안 (Client-side security).
5.  **`cc-skill-security-review`**: 기능 구현 시 보안 체크리스트 (Security checklist for features).
6.  **`pci-compliance`**: 지불 카드 산업 보안 표준 준수 (Payment card security standards).

---

## 💡 참고 사항

이 문서는 프로젝트의 `.agent/workflows` 폴더 내에 있는 워크플로우 정의 파일들을 기반으로 작성되었습니다. 새로운 워크플로우가 추가되면 이 문서도 함께 업데이트되어야 합니다.
