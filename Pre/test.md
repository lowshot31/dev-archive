sequenceDiagram
    participant User as User (Experience Cloud/Web)
    participant SF as Salesforce (LWC/Apex)
    participant API as External Middleware (FastAPI)
    participant Kakao as Kakao Address API

    User->>SF: 주소 입력 요청
    SF->>Kakao: Address Search Request
    Kakao-->>SF: Address Data & Geolocation
    SF->>SF: Apex Logic: Geolocation 기반 대리점 배정
    
    Note over SF, API: 실시간 데이터 동기화
    SF->>API: REST API Callout (Order/Lead Data)
    API-->>API: 외부 DB 연동 및 추가 로직 처리
    API-->>SF: Response (Status: Success/Fail)
    
    SF->>User: 실시간 상태 반영 및 포털 업데이트
