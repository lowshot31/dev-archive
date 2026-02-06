# 🥛 Pre - 유기농 유제품 회사 홈페이지

> "유기농, 특별함이 아닌 일상이 되다"

FastAPI 기반의 유기농 유제품 전문 기업 홈페이지입니다. Salesforce와 연동하여 견적 문의 및 고객 지원 기능을 제공합니다.

## 📋 프로젝트 개요

Pre는 유기농 유제품을 판매하는 가상의 기업 홈페이지로, 다음과 같은 기능을 제공합니다:

- **회사 소개**: 기업 비전 및 가치 소개
- **제품 소개**: 유기농 유제품 라인업 전시
- **견적 문의**: Salesforce Web-to-Lead 연동
- **고객 센터**: Salesforce Web-to-Case 연동

## 🛠️ 기술 스택

### Backend
- **FastAPI**: 고성능 Python 웹 프레임워크
- **Uvicorn**: ASGI 서버
- **Jinja2**: 템플릿 엔진

### Frontend
- **HTML5/CSS3**: 반응형 웹 디자인
- **JavaScript**: 동적 UI 인터랙션

### 통합
- **Salesforce**: CRM 연동 (Web-to-Lead, Web-to-Case)
- **ngrok**: 로컬 서버 외부 접속 터널링

## 🚀 빠른 시작

## 🚀 빠른 시작

### 1. FastAPI 서버 실행
```bash
cd c:\Pre_HomePage
python -m uvicorn app:app --host 0.0.0.0 --port 8000
```
- 로컬 접속: http://localhost:8000

---

### 2. 외부 접속 (ngrok)
```bash
# 다른 터미널에서 실행
cd c:\Pre_HomePage
.\ngrok http 8000
```
- ngrok 화면에 표시되는 `https://xxx.ngrok-free.app` 주소로 외부 접속

---

## 📁 프로젝트 구조
```
c:\Pre_HomePage\
├── app.py              # FastAPI 메인
├── static/             # CSS, JS, 이미지
│   ├── css/index.css
│   ├── js/main.js
│   └── img/
└── templates/          # Jinja2 템플릿
    ├── base.html
    ├── index.html      # 메인
    ├── about.html      # 회사정보
    ├── products.html   # 제품소개
    ├── contact.html    # 견적문의 (Web-to-Lead)
    └── support.html    # 고객센터 (Web-to-Case)
```

---

## ⚙️ Salesforce 연동
`templates/contact.html`, `templates/support.html`에서:
```html
<input type="hidden" name="oid" value="YOUR_ORG_ID_HERE">
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
