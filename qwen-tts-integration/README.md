# 🎙️ Qwen3-TTS System Integration & Optimization

오픈소스 AI 음성 합성 모델인 **Qwen3-TTS**를 로컬(WSL) 환경에 구축하고, 한국어 음성 출력 버그 수정 및 시스템 통합을 수행한 프로젝트입니다.

## 🚀 Project Overview
- **목적**: 최신 LLM 기반 TTS 모델의 한국어 지원 한계를 극복하고, 로컬 API 서버로서의 활용성 검증.
- **핵심 성과**: 
    - 한국어 음성 합성 시 발생하는 인코딩 및 세그멘테이션 오류 해결.
    - WSL 환경에서의 오디오 드라이버 연동 및 최적화 가이드 작성.
    - REST API 인터페이스 정의 및 문서화 (Technical Writing).

## 📂 주요 문서 (Technical Documentation)
직접 작성하고 정립한 기술 문서들입니다:
1. **[README_API.md](./README_API.md)**: 외부 서비스 연동을 위한 상세 API 명세서.
2. **[WSL_MIGRATION_GUIDE.md](./WSL_MIGRATION_GUIDE.md)**: Windows-WSL 환경 간의 마이그레이션 및 오디오 설정 가이드.
3. **[Qwen3-TTS Optimization Report.md](./Qwen3-TTS%20Optimization%20Report.md)**: 모델 추론 속도 및 음성 품질 개선 리포트.
4. **[WORKFLOW_INTEGRATION.md](./WORKFLOW_INTEGRATION.md)**: 전체 시스템 아키텍처 및 데이터 흐름 정의.
5. **[LEARNING_GUIDE.md](./LEARNING_GUIDE.md)**: 모델 구조 이해 및 트러블슈팅 과정을 담은 학습 가이드.

## 🛠 Troubleshooting & Value
- **Issue**: 한국어 텍스트 입력 시 특정 문구에서 음성이 뭉개지거나 중단되는 현상 발생.
- **Analysis**: 모델의 토크나이저와 오디오 포스트 프로세싱 단계에서의 인코딩 불일치 확인.
- **Solution**: 오디오 프레임 버퍼 크기 조정 및 인코딩 전처리 로직 수정을 통해 안정적인 음성 출력 구현.
- **Impact**: 기술적 난이도가 높은 AI 모델을 독립적으로 분석하고, 실제 사용 가능한 수준으로 환경을 구축하는 문제 해결 역량 입증.
