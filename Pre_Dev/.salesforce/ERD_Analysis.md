# Pré 세일즈포스 ERD 분석

## 📊 주요 객체 관계 (ERD 기반)

### 1. Lead → Contact → Account 흐름
- **Lead** (리드): 잠재 고객 정보
  - Company, Name, Status, Email
- **Contact** (연락처): 전환된 실제 고객
  - AccountId (Lookup to Account)
  - Name, Email, Mobile
- **Account** (거래처): 고객 회사
  - Name, Type, Industry, Address

### 2. 영업 프로세스 (Sales Process)
```
Account → Opportunity → Contract → Order
         ↓
      Product2 (상품)
```

- **Opportunity** (영업기회)
  - AccountId (Lookup)
  - StageName, CloseDate, Amount
  - OpportunityId → Opportunity 연결

- **Contract** (계약서)
  - AccountId (Lookup)
  - StartDate, ContractTerm, Status

- **Order** (주문)
  - AccountId (Lookup)
  - ContractId (Lookup) - 계약서 기반 주문
  - EffectiveDate, Status, TotalAmount

### 3. 고객 지원 (Customer Support)
```
Account → Case
         ↑
      OrderId (Lookup) - 주문 기반 문의
```

- **Case** (문의/사례)
  - AccountId (Lookup)
  - OrderId (Lookup) - **주문과 연결 가능**
  - Status, Priority

### 4. 추가 객체
- **Product2** (상품 마스터)
  - ProductCode, Name, Family, IsActive
- **Assignment_Master** (커스텀 객체)
  - Name, Location__c (Geo)
  - Manager__c (Lookup to User)

## 🎯 포털에서 구현해야 할 Order 생성 기능

### Order 생성 시 필요한 필드
1. **AccountId** (필수) - 자동 입력 (로그인 유저의 Account)
2. **ContractId** (선택) - 드롭다운으로 해당 Account의 활성 계약서 선택
3. **EffectiveDate** (필수) - 주문 날짜
4. **Status** (필수) - 기본값 'Draft'
5. **TotalAmount** (선택) - 주문 총액

### Order와 Case 연계
- Case 생성 시 **OrderId** 필드 추가하여 특정 주문과 연결 가능
- 예: "2024년 12월 주문건에 대한 배송 문의"

## 📝 구현 계획
1. ✅ Case 생성 기능 (완료)
2. 🔄 Order 생성 기능 (다음 단계)
   - portalNewOrderForm.js/html/css 생성
   - PortalDashboardController에 createOrder 메서드 보완
3. 🔄 Case 생성 시 Order 선택 옵션 추가
