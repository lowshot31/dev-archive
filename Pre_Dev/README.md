# 🥛 Pre Dairy (Salesforce CRM 백엔드 & 포털)

본 디렉토리는 **Pre Dairy B2B 셀프서비스 포털** 프로젝트의 Salesforce 백엔드 로직(Apex, SOQL) 및 포털 UI(LWC) 소스 코드를 포함하고 있습니다.

## 📖 통합 문서 안내 (필독)

기획 배경, 전체 2-Tier 시스템 아키텍처, 데이터 모델, 핵심 기술 챌린지 및 Q&A 등 전체 프로젝트에 대한 구체적인 명세는 루트 디렉토리에 통합되어 있습니다. 

👉 **[통합 프로젝트 명세서 (project_.md) 읽어보기](../project_.md)**

---

## 📁 주요 소스 코드 구조

- `force-app/main/default/classes/`: Apex 컨트롤러 및 서비스 클래스 (거리 기반 리드 배정, 자동 공유 등)
- `force-app/main/default/lwc/`: Lightning Web Components (고객용 Experience Cloud 대시보드 컴포넌트)
- `force-app/main/default/triggers/`: 자동화 트랜잭션 트리거 로직

*본 코드는 표준 Salesforce DX (SFDX) 프로젝트 구조로 구성되어 있습니다.*
