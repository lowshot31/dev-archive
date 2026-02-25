# Qwen3-TTS API & Web Studio

Qwen3-TTS 모델 기반의 TTS(Text-to-Speech) 서비스입니다.  
시스템 내장 화자와 사용자 커스텀 보이스 클로닝을 모두 지원합니다.

---

## 아키텍처

```
┌─────────────────────────────────────────────────────────────┐
│                    Astro Web UI (:4321)                      │
│  ┌─────────────────┐  ┌──────────────────────────────────┐  │
│  │  Content Editor  │  │       Mastering Studio           │  │
│  │  Voice Library   │  │  Player · Volume · Export WAV    │  │
│  └─────────────────┘  └──────────────────────────────────┘  │
└────────────────────────────┬────────────────────────────────┘
                             │ HTTP API
┌────────────────────────────▼────────────────────────────────┐
│                  FastAPI Server (:8000)                      │
│  ┌──────────┐  ┌────────────────┐  ┌─────────────────────┐ │
│  │ routes.py│  │ dual_tts_svc.py│  │  voice_manager.py   │ │
│  │  API 라우팅  │  │  모델 스왑 관리    │  │  커스텀 보이스 관리   │ │
│  └──────────┘  └────────┬───────┘  └─────────────────────┘ │
│                         │                                   │
│              ┌──────────▼──────────┐                        │
│              │   tts_service.py    │                        │
│              │  스트리밍/WAV/문장분리  │                        │
│              └──────────┬──────────┘                        │
│                         │ (모델 스왑)                        │
│         ┌───────────────┼───────────────┐                   │
│         ▼               ▼               │                   │
│  CustomVoice 모델   Base 모델           │                   │
│  (시스템 화자)      (보이스 클로닝)       │                   │
│  VRAM에 하나만 로드 ◄─── 자동 전환 ──►   │                   │
└─────────────────────────────────────────────────────────────┘
```

---

## 모델 스왑 시스템

VRAM 효율을 위해 **한 번에 하나의 모델만** 로드합니다.

| 보이스 타입   | 모델          | voice_id 패턴 | 동작                                                     |
| ------------- | ------------- | ------------- | -------------------------------------------------------- |
| 시스템 화자   | `CustomVoice` | `speaker_*`   | `generate_custom_voice()`                                |
| 커스텀 보이스 | `Base`        | `voice_*`     | `create_voice_clone_prompt()` → `generate_voice_clone()` |

```
[시스템 화자 선택] → ensure_custom_voice_model() → CustomVoice 로드
[커스텀 보이스 선택] → ensure_base_model() → 기존 모델 해제 → Base 로드
[같은 모델이면] → 스킵 (재로드 없음)
```

---

## 프로젝트 구조

```
Qwen3-TTS/
├── api/                          # FastAPI 백엔드
│   ├── __init__.py               # 패키지 초기화
│   ├── main.py                   # FastAPI 앱 설정, 서버 시작
│   ├── routes.py                 # API 엔드포인트 정의
│   ├── models.py                 # Pydantic 요청/응답 모델
│   ├── tts_service.py            # TTS 핵심 서비스 (스트리밍, WAV, 문장 분리)
│   ├── dual_tts_service.py       # 듀얼 모델 스왑 서비스 (TTSService 상속)
│   └── voice_manager.py          # 커스텀 보이스 등록/관리/프롬프트 캐싱
│
├── web/                          # Astro 프론트엔드
│   ├── src/
│   │   ├── pages/
│   │   │   └── index.astro       # 메인 UI (에디터, 보이스 라이브러리, 플레이어)
│   │   └── layouts/
│   │       └── Layout.astro      # 레이아웃 템플릿
│   └── package.json
│
├── data/                         # 데이터 저장
│   ├── voices_db.json            # 커스텀 보이스 메타데이터 (시스템 화자 제외)
│   └── voices/                   # 커스텀 보이스 WAV 파일
│
├── qwen_tts/                     # Qwen3-TTS 모델 코어 (수정 금지)
│
├── README_API.md                 # API 상세 문서
├── QUICKSTART_API.md             # API 퀵스타트 가이드
└── requirements_api.txt          # Python 의존성
```

---

## 실행 방법

### 1. 백엔드 (FastAPI)

```bash
# conda 환경 활성화
conda activate qwen3-tts

# 서버 실행
python -m uvicorn api.main:app --host 0.0.0.0 --port 8000 --reload
```

### 2. 프론트엔드 (Astro)

```bash
# 별도 터미널에서 (conda 불필요)
cd web
npm run dev
```

- **백엔드**: http://localhost:8000 (API 문서: http://localhost:8000/docs)
- **프론트엔드**: http://localhost:4321

---

## API 엔드포인트

| Method     | Endpoint             | 설명                               |
| ---------- | -------------------- | ---------------------------------- |
| `GET`      | `/`                  | 서버 상태 확인                     |
| `GET/POST` | `/tts/generate`      | TTS 음성 생성 (스트리밍/일반)      |
| `POST`     | `/voices/register`   | 커스텀 보이스 등록                 |
| `GET`      | `/voices`            | 보이스 목록 조회 (시스템 + 커스텀) |
| `DELETE`   | `/voices/{voice_id}` | 커스텀 보이스 삭제                 |

### TTS 생성 예시

```python
import requests

# 시스템 화자 (CustomVoice 모델 자동 로드)
response = requests.get(
    "http://localhost:8000/tts/generate",
    params={
        "text": "안녕하세요",
        "voice_id": "speaker_sohee",
        "language": "Korean",
        "stream": True
    }
)

# 커스텀 보이스 (Base 모델 자동 스왑)
response = requests.get(
    "http://localhost:8000/tts/generate",
    params={
        "text": "안녕하세요",
        "voice_id": "voice_0f56b83c2923",
        "language": "Korean",
        "stream": True
    }
)
```

---

## 시스템 내장 화자

| voice_id           | 이름                     | 언어     |
| ------------------ | ------------------------ | -------- |
| `speaker_sohee`    | Qwen3 Korean (Sohee)     | Korean   |
| `speaker_ryan`     | Qwen3 English (Ryan)     | English  |
| `speaker_serena`   | Qwen3 English (Serena)   | English  |
| `speaker_ono_anna` | Qwen3 Japanese (Anna)    | Japanese |
| `speaker_uncle_fu` | Qwen3 Chinese (Uncle Fu) | Chinese  |

---

## 핵심 파일 설명

### `api/dual_tts_service.py`

`TTSService`를 상속하여 모델 스왑 기능만 추가.  
기존의 스트리밍, WAV 헤더 생성, 문장 분리 로직을 그대로 재사용합니다.

### `api/tts_service.py`

TTS 핵심 로직이 모두 포함된 기본 서비스 클래스.

- `_split_sentences()`: 문장 단위 분할 (min 80자 기준 합침)
- `_make_wav_header()`: 스트리밍용 WAV 헤더 생성
- `stream_voice_clone()`: 커스텀 보이스 스트리밍
- `stream_custom_voice()`: 시스템 화자 스트리밍

### `api/voice_manager.py`

커스텀 보이스 등록, 삭제, 목록 조회, 프롬프트 캐싱을 관리.  
`data/voices_db.json`에 메타데이터를 저장합니다.

---

## 기술 스택

- **Backend**: FastAPI, uvicorn, torch, soundfile, numpy
- **Frontend**: Astro, Vanilla JavaScript
- **TTS Model**: Qwen3-TTS (CustomVoice + Base)
- **GPU**: CUDA (VRAM 6GB+ 권장)
