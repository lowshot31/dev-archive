# Pre Dairy Company - 프로젝트 상세 명세서

본 문서는 Pre Dairy Company 홈페이지의 기술 스택, 페이지 구성 및 주요 로직에 대한 상세 가이드를 제공합니다.

---

## 🛠 기술 스택 (Technology Stack)

- **Backend**: Python 3.x, FastAPI
- **Template Engine**: Jinja2
- **Frontend**: Vanilla HTML5, CSS3, JavaScript (ES6+)
- **External APIs**:
  - Salesforce Web-to-Lead (영업 리드 수집)
  - Salesforce Web-to-Case (고객 지원 접수)
  - 카카오 우편번호 서비스 API (주소 검색)
- **Deployment**: Local HTTPS (via uvicorn & SSL certificates), ngrok (외부 터널링)

---

## 📂 파일별 기능 상세 설명

### 1. Backend & Configuration

- **`app.py`**:
  - FastAPI 서버의 진입점.
  - `/`, `/about`, `/products`, `/contact`, `/support` 등 모든 엔드포인트 라우팅 정의.
  - `StaticFiles`를 이용해 이미지, CSS, JS 파일 제공.
  - SSL 설정(`key.pem`, `cert.pem`)을 통해 로컬 개발 환경에서도 HTTPS 통신 가능하게 구현.

### 2. Frontend Templates (`templates/`)

#### 🏗 `base.html` (공통 레이아웃)

- 사이트 전체의 헤더와 푸터를 정의하는 마스터 템플릿.
- **주요 기능**:
  - **네비게이션**: 현재 활성 페이지(`active_page`)에 따른 메뉴 하이라이트.
  - **Salesforce 로그인**: Experience Cloud 사이트(`s/login/`)로 직결되는 로그인 버튼 연동.
  - **반응형 디자인**: 모바일 화면에서의 햄버거 메뉴 토글 로직 포함.

#### 🏠 `index.html` (메인이동)

- 브랜드 아이덴티티를 보여주는 첫 관문.
- **구성**:
  - **Hero Section**: 고화질 배경 이미지와 브랜드 슬로건("유기농, 특별함이 아닌 일상이 되다").
  - **Product Preview**: 주요 유제품(유기농, 락토프리 등)의 베스트 셀러 전시.
  - **Partners Card**: 학교 급식, 대형 유통사 등 주요 파트너십 요약.

#### 🏢 `about.html` (회사 소개)

- 기업의 가치와 성장을 시각화.
- **구성**:
  - **비전/미션**: 아이콘 기반의 그리드 레이아웃으로 핵심 가치(지속 가능성, 품질 최우선) 전달.
  - **연혁(Timeline)**: 설립(2010년)부터 현재까지의 주요 마일스톤을 수직 타임라인으로 표현.
  - **파트너십 그리드**: 상세 파트너 정보 제공.

#### 🥛 `products.html` (제품 목록)

- 전체 제품 라인업 전시 및 필터 기능 제공.
- **주요 기능**:
  - **Category Filter**: 버튼 클릭 시 `main.js`의 필터링 로직을 호출하여 화면 리로드 없이 제품 분류(우유, 치즈, 버터 등).
  - **Badge System**: 'BEST', 'NEW' 등 제품 상태 표시 리본.

#### 📋 `contact.html` (견적 문의 - **핵심 데이터 수집**)

- Salesforce **Web-to-Lead** 연동을 위한 복합 양식.
- **특화 로직**:
  - **카카오 주소검색 (`openPostcode`)**: 사용자가 주소를 검색하면 시/도, 시/군/구, 상세주소를 추출하여 Salesforce 표준 필드에 자동 매핑.
  - **다중 선택 제품 태그**: 드롭다운에서 제품을 선택하면 화면에 태그 형식으로 추가되고, 제출 시 세미콜론(`;`) 구분값으로 변환되어 Salesforce에 전송.
  - **자동 포매팅**: 전화번호 입력 시 실시간으로 하이픈(`-`) 삽입.
  - **유효성 검사**: 필수 필드 누락 시 에러 메시지 표시 및 해당 위치로 부드러운 스크롤 이동.

#### 🎧 `support.html` (고객 센터)

- Salesforce **Web-to-Case** 연동 양식.
- **구성**:
  - **FAQ 아코디언**: 사용자가 자주 묻는 질문을 클릭하여 내용을 펼쳐볼 수 있는 인터랙션.
  - **문의 접수**: 고객의 불편 사항이나 제안을 Case 객체로 직접 접수.

---

## 🧠 JavaScript & UI 로직 상세

### 📂 `static/js/main.js` (전역 스크립트)

- **Header Scroll Effect**: 스크롤 시 유리 질감(`backdrop-filter`) 가동 및 상단 고정 효과.
- **Scroll Reveal**: 페이지 스크롤에 맞춰 요소들이 아래에서 위로 서서히 나타나는 애니메이션 엔진.
- **Product Filter Engine**: 카테고리 데이터 속성(`data-category`)을 기반으로 DOM 요소를 동적으로 숨김/표시.

### 📂 `contact.html` 인라인 스크립트 (폼 엔진)

- **Salesforce 특화 기능**:
  - `handleSubmit`: 제출 전 모든 커스텀 유효성 검사를 수행하고, 성공 시 1.5초 후 폼을 전송하여 사용자 경험 개선.
  - `Product Tag System`: `selectedProducts` 배열을 통해 선택된 품목을 관리하고 UI를 실시간 업데이트.
  - **Debug Mode**: 폼 제출 시 지정된 이메일로 Salesforce 필드 매핑 정보를 전송하여 트러블슈팅 지원.

---

## 🎨 Design System (`index.css`)

- **Primary Color**: `#2D4A3E` (짙은 숲색 - 신뢰와 자연의 느낌)
- **Accent Color**: `#B59A7D` (차분한 베이지 - 부드러운 유제품의 느낌)
- **UI 패턴**:
  - **Glassmorphism**: 헤더와 카드 요소에 적용.
  - **Spacing System**: `var(--space-md)`, `var(--space-lg)` 등 변수 기반의 일정한 레이아웃 유지.
  - **Typography**: 가독성 높은 `Pretendard`/`Inter` 스타일 폰트 적용.
