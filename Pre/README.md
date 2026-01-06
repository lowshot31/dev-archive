# Pre 유제품 홈페이지 실행 가이드

## 🚀 빠른 시작

### 1. 서버 실행

```bash
cd c:\Pre_HomePage
python app.py
```

- **로컬 접속**: https://localhost:8000 또는 https://127.0.0.1:8000
- 자체 서명 인증서 사용 (브라우저 경고 무시하고 진행)

---

### 2. 외부 접속 (ngrok)

**외부에서 접속하거나 모바일로 테스트할 때**

```bash
# 다른 터미널에서 실행
cd c:\Pre_HomePage
.\ngrok http https://localhost:8000
```

- ngrok 화면에 표시되는 `https://xxx.ngrok-free.app` 주소로 접속
- 모든 이미지와 리소스가 정상 로드됨

---

## 📁 프로젝트 구조

```
c:\Pre_HomePage\
├── app.py              # FastAPI 메인 및 라우팅 로직
├── PROJECT_DETAIL.md   # [NEW] 프로젝트 상세 명세서 (기능 및 JS 로직 상세)
├── static/             # 정적 자원 (CSS, JS, 이미지)
│   ├── css/index.css   # 전역 스타일 및 디자인 시스템
│   ├── js/main.js      # 전역 UI 인터랙션 핸들러
│   └── img/            # 제품 및 디자인 에셋
└── templates/          # Jinja2 HTML 템플릿
    ├── base.html       # 공통 레이아웃 및 네비게이션
    ├── index.html      # 메인 홈 페이지
    ├── about.html      # 회사 소개 및 연혁 (Timeline)
    ├── products.html   # 제품 목록 및 동적 필터링
    ├── contact.html    # 견적 문의 (Web-to-Lead/주소검색/태그UI)
    └── support.html    # 고객 센터 (Web-to-Case/FAQ)
```

> **상세 기능 가이드**: 각 페이지의 상세 로직과 JavaScript 동작 방식은 [PROJECT_DETAIL.md](./PROJECT_DETAIL.md) 파일에서 확인하실 수 있습니다.

---

## ⚙️ Salesforce 연동

`templates/contact.html`, `templates/support.html`에서:

```html
<input type="hidden" name="oid" value="YOUR_ORG_ID_HERE" />
```

→ Salesforce Org ID로 교체

---

## 🔧 문제 해결

### 서버가 안 뜰 때

```bash
pip install fastapi uvicorn jinja2 python-multipart
```

### 포트 확인

```bash
netstat -ano | findstr :8000
```

### ngrok authtoken 설정

```bash
.\ngrok config add-authtoken YOUR_TOKEN
```
