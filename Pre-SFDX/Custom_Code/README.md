# Pre Dairy Portal - Custom Code

> 개발자가 직접 작성한 커스텀 Apex 클래스, Trigger 및 LWC 컴포넌트 모음

**프로젝트**: Pre Dairy Experience Cloud Portal  
**개발자**: JUN JEONGBAE  
**작성일**: 2025-12-29

---

## 📂 폴더 구조

```
Custom_Code/
├── Apex_Classes/           # Apex 클래스 (4개)
│   ├── AccountAssignmentService.cls
│   ├── LeadSharingService.cls
│   ├── PortalDashboardController.cls
│   └── PortalDashboardControllerTest.cls
│
├── Triggers/               # Apex Triggers (2개)
│   ├── AccountTrigger.trigger
│   └── LeadDistanceSharingTrigger.trigger
│
└── LWC_Components/         # Lightning Web Components (6개)
    ├── portalDashboard/
    ├── portalCaseDetail/
    ├── portalNewCaseForm/
    ├── portalNewOrderForm/
    ├── portalHeader/
    └── portalFooter/
```

---

## 🎯 Apex Classes

### 1. AccountAssignmentService.cls

**목적**: Account 생성/주소 변경 시 가장 가까운 배송 대리점 자동 배정

**주요 기능**:
- BillingLatitude/Longitude 기반 거리 계산
- DISTANCE 함수로 가장 가까운 대리점 조회
- Delivery_Agent__c 필드 자동 업데이트

**Trigger 연동**: AccountTrigger

---

### 2. LeadSharingService.cls

**목적**: Lead 좌표와 Industry 기반으로 가까운 담당자 3명에게 자동 공유

**주요 기능**:
- Industry별 Assignment_Master__c 조회
- 거리순 TOP 3 담당자 찾기
- LeadShare 생성 (Edit 권한)

**타입**: Invocable Method (Process Builder/Flow에서 호출 가능)

---

### 3. PortalDashboardController.cls

**목적**: Experience Cloud Portal의 메인 컨트롤러

**주요 메서드**:
1. `getRelatedRecords()` - Dashboard 데이터 조회 (Order, Case, Contract)
2. `getCaseFeed()` - Case 피드 통합 조회 (Comment, Chatter, Email)
3. `addFeedPost()` - Case에 Chatter 포스트 추가
4. `getActiveContracts()` - 활성화된 Contract 목록
5. `getPricebookProducts()` - Contract의 Pricebook 상품 조회
6. `createOrder()` - Order + OrderItem 생성
7. `uploadFiles()` - Case에 파일 첨부

**보안**:
- `with sharing` 클래스
- `without sharing` Inner Classes (DataFetcher, FileUploader)
- Portal User AccountId 자동 검증

---

### 4. PortalDashboardControllerTest.cls

**목적**: PortalDashboardController 테스트 클래스

---

## ⚡ Triggers

### 1. AccountTrigger.trigger

**Object**: Account  
**Event**: after insert, after update

**로직**:
- Insert: Type != 'Delivery Agent'인 Account 생성 시
- Update: 주소 변경 또는 Delivery_Agent__c가 null일 때
- AccountAssignmentService.assignDeliveryAgent() 호출

---

### 2. LeadDistanceSharingTrigger.trigger

**Object**: Lead  
**Event**: after insert, after update

**로직**:
- Latitude, Longitude, Industry 확인
- Assignment_Master__c에서 거리순 TOP 3 조회
- LeadShare 생성
- **Custom Notification 전송**: 'Lead_Assignment_Notification'

---

## 🌐 LWC Components

### 1. portalDashboard

**목적**: Portal 메인 Dashboard

**기능**:
- Order, Case, Contract 목록 표시
- Tab 전환 (Orders, Cases, Contracts)
- 새 Order/Case 생성 폼 표시

**Apex 연동**: `getRelatedRecords()`

---

### 2. portalCaseDetail

**목적**: Case 상세 페이지

**기능**:
- Case 상세 정보 표시
- Feed 히스토리 표시 (Comment, Chatter, Email)
- 댓글 추가
- 파일 첨부

**Apex 연동**: `getCaseFeed()`, `addFeedPost()`, `uploadFiles()`

---

### 3. portalNewCaseForm

**목적**: 새 Case 생성 폼

**기능**:
- Case 생성 (lightning-record-edit-form)
- 파일 첨부 (다중 파일 지원)
- AccountId 자동 설정

**Apex 연동**: `uploadFiles()`

---

### 4. portalNewOrderForm

**목적**: 새 Order 생성 폼

**기능**:
- Contract 선택
- Pricebook 상품 목록 표시
- 상품 선택 + 수량 입력
- Order + OrderItem 생성

**Apex 연동**: `getActiveContracts()`, `getPricebookProducts()`, `createOrder()`

---

### 5. portalHeader

**목적**: Portal 헤더 컴포넌트

**기능**:
- 로고 표시
- 네비게이션 (Home, Orders, Support)
- 로그아웃 버튼

---

### 6. portalFooter

**목적**: Portal 푸터 컴포넌트

**기능**:
- 회사 정보 표시
- 푸터 링크

---

## 🔧 필수 Custom Objects & Fields

### Account

| 필드명 | API명 | 타입 | 설명 |
|--------|-------|------|------|
| 배송 대리점 | Delivery_Agent__c | Lookup(Account) | 배정된 배송 대리점 |
| 가용 여부 | Is_Available__c | Checkbox | 배송점 가용 상태 |

### Lead

| 필드명 | API명 | 타입 | 설명 |
|--------|-------|------|------|
| 위도 | Latitude | Number | Lead 위치 위도 |
| 경도 | Longitude | Number | Lead 위치 경도 |

### Order

| 필드명 | API명 | 타입 | 설명 |
|--------|-------|------|------|
| 배송현황 | Delivery_Staus__c | Picklist | Ready, Delivered |

### Assignment_Master__c (Custom Object)

| 필드명 | API명 | 타입 | 설명 |
|--------|-------|------|------|
| 담당자 | Manager__c | Lookup(User) | 배정할 담당자 |
| 업종 | Industry__c | Picklist | 담당 업종 |
| 위치 | Location__c | Geolocation | 근무지 좌표 |

---

## 🚀 배포 방법

### 1. Salesforce CLI 사용

```bash
# 전체 배포
cd C:\Pre_dev\Pre_Dev
sf project deploy start

# 특정 클래스만 배포
sf project deploy start --source-dir force-app/main/default/classes/PortalDashboardController.cls

# 특정 LWC만 배포
sf project deploy start --source-dir force-app/main/default/lwc/portalDashboard
```

### 2. VS Code에서 배포

1. 파일 우클릭
2. "SFDX: Deploy Source to Org" 선택

---

## 📚 참고 문서

- **상세 기술 문서**: `/.salesforce/Custom_Apex_Classes_Documentation.md`
- **Lead Duplicate Rules**: `/.salesforce/Lead_Required_Fields_and_Duplicate_Rules.md`
- **Retrieved Code Summary**: `/.salesforce/Retrieved_Apex_Code_Summary.md`
- **ERD Analysis**: `/.salesforce/ERD_Analysis.md`

---

## ⚠️ 주의사항

1. **Geocoding 설정 필수**:
   - Account 및 Lead의 BillingAddress → Latitude/Longitude 자동 변환 필요
   - Data.com 또는 Google Maps API 연동

2. **Custom Notification Type**:
   - Setup → Custom Notifications → 'Lead_Assignment_Notification' 생성 필요

3. **Portal User 권한**:
   - Contact.AccountId가 반드시 설정되어야 함
   - Portal Profile에 적절한 권한 부여

4. **Pricebook 설정**:
   - Contract에 Pricebook2Id가 반드시 설정되어야 Order 생성 가능

---

## 🐛 트러블슈팅

**문제**: "Access Denied" 에러  
**해결**: Portal User의 Contact.AccountId 확인

**문제**: 배송점이 배정되지 않음  
**해결**: BillingLatitude/Longitude 및 Is_Available__c=true인 대리점 확인

**문제**: Lead가 공유되지 않음  
**해결**: Assignment_Master__c 데이터 및 Custom Notification Type 확인

**문제**: Order 생성 실패  
**해결**: Contract의 Pricebook2Id 및 PricebookEntry 활성 상태 확인

---

## 📞 문의

**개발자**: JUN JEONGBAE  
**이메일**: [이메일 주소]  
**프로젝트**: Pre Dairy Portal System

---

**문서 버전**: 1.0  
**최종 업데이트**: 2025-12-29
