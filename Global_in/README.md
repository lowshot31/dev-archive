# 🌐 Global_in 프로젝트

웹 크롤링 및 이커머스 플랫폼을 위한 통합 프로젝트입니다.

## 📋 프로젝트 개요

Global_in은 이커머스 플랫폼의 상품 카테고리 데이터를 수집하고 관리하며, 실제 판매 플랫폼을 운영하기 위한 통합 프로젝트입니다.

## 📁 프로젝트 구조

```
Global_in/
├── project_crawling/     # 카테고리 데이터 처리 및 DB 저장
│   ├── category.py       # 카테고리 계층 구조 생성 및 DB 연동
│   ├── emart.py          # 이마트 상품 크롤링
│   ├── gs25.py           # GS25 상품 크롤링
│   ├── cu.py             # CU 편의점 크롤링
│   └── drivers.py        # Selenium 드라이버 설정
└── Sell_Buy/             # Spring Boot 이커머스 플랫폼
    ├── src/              # Java 소스 코드
    ├── build.gradle      # Gradle 빌드 설정
    └── README.md         # Sell_Buy 프로젝트 문서
```

### 하위 프로젝트

#### 1. project_crawling
Python 기반의 웹 크롤링 및 카테고리 데이터 관리 시스템입니다.
- 엑셀 데이터를 기반으로 계층적 카테고리 구조 생성
- 이마트, GS25, CU 등 주요 유통업체 상품 크롤링
- Oracle Cloud Database에 데이터 저장

[📖 자세히 보기 →](./project_crawling/README.md)

#### 2. Sell_Buy
Spring Boot 3.4 기반의 풀스택 이커머스 웹 애플리케이션입니다.
- AWS 클라우드 인프라 통합 (S3, SQS, ECR)
- Spring Security 기반 인증/권한 관리
- WebSocket 실시간 통신
- Redis 세션 관리

[📖 자세히 보기 →](./Sell_Buy/README.md)

## 🛠️ 기술 스택

### project_crawling
- **Python 3.x**: 메인 프로그래밍 언어
- **Pandas**: 엑셀 데이터 처리
- **Selenium**: 동적 웹 페이지 크롤링
- **Oracle Cloud Database**: 데이터 저장소

### Sell_Buy
- **Spring Boot 3.4.1**: 백엔드 프레임워크
- **Java 17**: LTS 버전
- **AWS (S3, SQS, ECR)**: 클라우드 인프라
- **Redis**: 세션 관리 및 캐싱
- **Oracle Database**: 메인 데이터베이스
- **JSP + Bootstrap**: 프론트엔드

## 🚀 주요 기능

### 데이터 수집 (project_crawling)
- **카테고리 계층 구조 생성**: 엑셀 파일에서 대/중/소분류 데이터 로드 및 계층화
- **웹 크롤링**: 주요 유통업체 상품 정보 자동 수집
- **데이터베이스 연동**: Oracle Cloud DB에 자동 저장

### 이커머스 플랫폼 (Sell_Buy)
- **사용자 인증**: Spring Security 기반 로그인/회원가입
- **상품 관리**: CRUD 기능 및 카테고리별 분류
- **주문 처리**: 장바구니, 주문, 결제 프로세스
- **실시간 통신**: WebSocket 기반 알림 및 채팅
- **파일 관리**: AWS S3 연동 이미지 업로드
- **메시지 큐**: AWS SQS를 통한 비동기 처리

## ⚙️ 설치 및 실행

### project_crawling

```bash
# 1. 의존성 설치
pip install pandas openpyxl oracledb selenium

# 2. ChromeDriver 설정
# chromedriver를 project_crawling/chromedriver/ 디렉토리에 배치

# 3. 실행
cd project_crawling
python category.py
```

### Sell_Buy

```bash
# 1. 빌드
cd Sell_Buy
./gradlew build

# 2. 실행
./gradlew bootRun

# 3. Docker 이미지 빌드 (Jib)
./gradlew jib
```

## 📊 데이터베이스 스키마

### Oracle Cloud Database

**project_crawling 테이블:**
- `category`: 카테고리 정보 (category_id, name, path, super_category_id)

**Sell_Buy 테이블:**
- `users`: 사용자 정보
- `products`: 상품 정보
- `orders`: 주문 정보
- `categories`: 카테고리 정보 (project_crawling에서 수집한 데이터 활용)

## 🔍 프로젝트 연계

1. **데이터 수집**: `project_crawling`으로 카테고리 및 상품 데이터 수집
2. **데이터 저장**: Oracle Cloud Database에 저장
3. **데이터 활용**: `Sell_Buy` 플랫폼에서 수집된 데이터를 기반으로 상품 전시

## 🚧 향후 계획

- [ ] project_crawling과 Sell_Buy 간 자동 데이터 동기화
- [ ] 크롤링 스케줄러 추가 (정기적 데이터 업데이트)
- [ ] Sell_Buy REST API 문서화
- [ ] Kubernetes 배포 설정
- [ ] 모니터링 및 로깅 시스템 구축

## 📝 참고사항

- Oracle Cloud Database 연결을 위해 TCPS 프로토콜 사용
- AWS 자격 증명은 환경 변수 또는 IAM Role로 관리
- 크롤링 시 각 사이트의 robots.txt 및 이용약관 준수 필요

## 📞 문의

프로젝트 관련 문의사항은 이슈를 등록해주세요.

---

**© 2025 Global_in Project**
