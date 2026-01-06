# Developer Console에서 가져온 Apex 코드 목록

## 📥 성공적으로 가져온 모든 Apex 클래스 및 Trigger

### 🔧 **커스텀 Apex 클래스 (Custom Classes)**

#### 1. **LeadSharingService.cls**
- **위치**: `force-app/main/default/classes/LeadSharingService.cls`
- **기능**: 거리 기반 Lead 공유 서비스
- **타입**: Invocable Method
- **로직**:
  - Lead의 좌표(Latitude, Longitude) 및 Industry 확인
  - Assignment_Master__c에서 Industry가 일치하는 담당자 중 거리순 상위 3명 조회
  - LeadShare 레코드 생성하여 자동 공유 (Manual sharing)

#### 2. **AccountAssignmentService.cls**
- **위치**: `force-app/main/default/classes/AccountAssignmentService.cls`
- **기능**: Account에 가장 가까운 배송 대리점 자동 배정
- **타입**: Service Class
- **로직**:
  - Account의 BillingLatitude/Longitude 확인
  - Type='Delivery Agent' AND Is_Available__c=true인 Account 중 가장 가까운 1곳 조회
  - Delivery_Agent__c 필드 업데이트

#### 3. **PortalDashboardController.cls**
- **위치**: `force-app/main/default/classes/PortalDashboardController.cls`
- **기능**: Portal Dashboard 데이터 및 기능 제공
- **주요 메서드**:
  - `getRelatedRecords()`: Order, Case, Contract 데이터 조회
  - `getCaseFeed()`: Case 피드 조회 (Comments, FeedItems, EmailMessages)
  - `addFeedPost()`: Case에 피드 포스트 추가
  - `createOrder()`: Order 및 OrderItem 생성
  - `getPricebookProducts()`: Contract의 Pricebook 상품 조회
  - `uploadFiles()`: Case에 파일 첨부

#### 4. **PortalDashboardControllerTest.cls**
- **위치**: `force-app/main/default/classes/PortalDashboardControllerTest.cls`
- **기능**: PortalDashboardController 테스트 클래스

---

### ⚡ **Apex Triggers**

#### 1. **LeadDistanceSharingTrigger.trigger**
- **위치**: `force-app/main/default/triggers/LeadDistanceSharingTrigger.trigger`
- **Object**: Lead
- **Event**: after insert, after update
- **기능**:
  - Lead의 Latitude, Longitude, Industry가 있을 경우
  - Assignment_Master__c에서 Industry가 일치하는 거리순 상위 3명 조회
  - LeadShare 생성하여 자동 공유
  - **Custom Notification 전송**: 'Lead_Assignment_Notification' 타입으로 담당자에게 알림

#### 2. **AccountTrigger.trigger**
- **위치**: `force-app/main/default/triggers/AccountTrigger.trigger`
- **Object**: Account
- **Event**: after insert, after update
- **기능**:
  - **Insert**: Type != 'Delivery Agent'인 Account 생성 시 배송점 배정
  - **Update**: 주소 변경 또는 Delivery_Agent__c가 비어있을 경우 재배정
  - AccountAssignmentService.assignDeliveryAgent() 호출

---

### 🌐 **Experience Cloud 관련 클래스 (Auto-generated)**

다음 클래스들은 Experience Cloud 생성 시 자동으로 생성된 클래스입니다:

1. **CommunitiesLandingController.cls** - 커뮤니티 랜딩 페이지
2. **CommunitiesLandingControllerTest.cls**
3. **CommunitiesLoginController.cls** - 커뮤니티 로그인
4. **CommunitiesLoginControllerTest.cls**
5. **CommunitiesSelfRegConfirmController.cls** - 자가 등록 확인
6. **CommunitiesSelfRegConfirmControllerTest.cls**
7. **CommunitiesSelfRegController.cls** - 자가 등록
8. **CommunitiesSelfRegControllerTest.cls**
9. **ForgotPasswordController.cls** - 비밀번호 찾기
10. **ForgotPasswordControllerTest.cls**
11. **LightningForgotPasswordController.cls**
12. **LightningForgotPasswordControllerTest.cls**
13. **LightningLoginFormController.cls**
14. **LightningLoginFormControllerTest.cls**
15. **LightningSelfRegisterController.cls**
16. **LightningSelfRegisterControllerTest.cls**
17. **MicrobatchSelfRegController.cls**
18. **MicrobatchSelfRegControllerTest.cls**
19. **MyProfilePageController.cls** - 프로필 페이지
20. **MyProfilePageControllerTest.cls**
21. **SiteLoginController.cls** - 사이트 로그인
22. **SiteLoginControllerTest.cls**
23. **SiteRegisterController.cls** - 사이트 등록
24. **SiteRegisterControllerTest.cls**

---

## 📊 주요 비즈니스 로직 흐름

### 1️⃣ **Lead 자동 공유 프로세스**

```
Lead 생성/수정
│
├─ LeadDistanceSharingTrigger (Trigger)
│   ├─ 좌표 및 Industry 확인
│   ├─ Assignment_Master__c 조회 (거리순 TOP 3)
│   ├─ LeadShare 생성 (Manual sharing)
│   └─ Custom Notification 전송
│
└─ LeadSharingService (Invocable Method)
    └─ Process Builder 또는 Flow에서 호출 가능
```

### 2️⃣ **Account 배송점 배정 프로세스**

```
Account 생성/주소 변경
│
├─ AccountTrigger (Trigger)
│   ├─ Type != 'Delivery Agent' 확인
│   ├─ 주소 변경 또는 Delivery_Agent__c 비어있음 확인
│   └─ AccountAssignmentService.assignDeliveryAgent() 호출
│
└─ AccountAssignmentService (Service Class)
    ├─ BillingLatitude/Longitude 확인
    ├─ 가장 가까운 Available Delivery Agent 조회
    └─ Delivery_Agent__c 필드 업데이트
```

### 3️⃣ **Portal Order 생성 프로세스**

```
Portal 주문 접수
│
├─ PortalDashboardController.createOrder()
│   ├─ Contract 선택 확인 (필수)
│   ├─ Contract의 Pricebook2Id 확인
│   ├─ Order 생성 (Status='Requested')
│   └─ OrderItem 생성 (선택한 상품들)
│
└─ getPricebookProducts()
    ├─ Contract ID 기반 Pricebook2Id 조회
    └─ PricebookEntry 목록 반환
```

---

## 🔗 관련 Custom Objects

### Assignment_Master__c
- **Manager__c**: User lookup
- **Industry__c**: Picklist
- **Location__c**: Geolocation (위도/경도)

### Account
- **Delivery_Agent__c**: Account lookup
- **Is_Available__c**: Checkbox (배송점 가용 여부)
- **Type**: Picklist ('Delivery Agent' 등)

### Lead
- **Latitude**: Decimal
- **Longitude**: Decimal
- **Industry**: Picklist

---

## 💡 개발 팁

### Apex 코드 가져오기 명령어:
```bash
# 특정 클래스 가져오기
sf project retrieve start --metadata ApexClass:클래스명

# 모든 Apex 클래스 가져오기
sf project retrieve start --metadata ApexClass

# Apex Trigger 가져오기
sf project retrieve start --metadata ApexTrigger

# 모든 메타데이터 가져오기
sf project retrieve start
```

### 배포 명령어:
```bash
# 변경사항 배포
sf project deploy start

# 특정 파일만 배포
sf project deploy start --source-dir force-app/main/default/classes/LeadSharingService.cls
```

---

## 📌 주의사항

1. **LeadDistanceSharingTrigger**는 Custom Notification Type 'Lead_Assignment_Notification'가 Setup에 생성되어 있어야 합니다.
2. **AccountAssignmentService**는 Account에 BillingLatitude/Longitude가 자동으로 채워지는 Geocoding 설정이 필요합니다.
3. **PortalDashboardController**는 Community/Experience Cloud 사용자 전용이며, AccountId 기반 보안 검증을 수행합니다.

---

Generated: 2025-12-29
