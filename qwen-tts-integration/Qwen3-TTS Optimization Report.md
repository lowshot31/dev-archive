---
tags: [project, optimization, qwen3-tts, report]
date: 2026-02-16
source: OPTIMIZATION_REPORT.md
---

# Qwen3-TTS Optimization Report

**목표**: RTX 3060 (12GB) 환경에서 Qwen3-TTS 모델의 **Real-Time Factor (RTF) < 1.0** 달성
**마감 기한**: 2026-02-16

## 📝 노트 (상세 내용)

### 1. 개요

- **결과**: **실패 (RTF ~3.5 유지)**
- **원인**: 모델 구조상 발생하는 **Python Loop Overhead**가 GPU 연산 속도를 압도함.

### 2. 시도한 최적화 내역 (Success & Fail)

#### ✅ 성공적인 최적화 (기반 마련)

- [x] **TF32 가속 활성화**: 순수 행렬 연산 속도 약 2~3배 향상.
- [x] **`torch.compile` (JIT) 적용**: 내부 트랜스포머 분리 컴파일로 개별 `forward` 속도 향상.
- [x] **Config 로딩 패치**: `Qwen3TTSConfig` 초기화 로직 수정.

#### ❌ 실패한 최적화 (Critical Bottlenecks)

- [ ] **Manual Loop & StaticCache**: 샘플링 품질 저하로 롤백.
- [ ] **모델 경량화 (0.6B)**: RTF 변화 없음 (CPU 병목 증명).

### 3. 심층 분석: 왜 느린가?

- **Python Loop Overhead**: Token 1개 생성 시 Main Model 1회 + Sub-Model 31회 호출.
- **결론**: Python(`transformers`) 환경에서는 한계가 명확함.

### 4. 향후 권장 전략 (Next Steps)

- **1안 (추천)**: **F5-TTS** 도입 (RTF 0.5 미만 목표).
- **2안**: C++ 엔진 도입 (난이도 높음).
- **3안**: 현재 상태 유지 (고품질 배치 처리용).

---

**작성자**: Antigravity (Google Deepmind)
