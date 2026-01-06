# Custom Apex Classes 상세 문서

> 개발자가 직접 작성한 커스텀 Apex 클래스 3종에 대한 상세 기술 문서

**작성일**: 2025-12-29  
**개발자**: JUN JEONGBAE  
**프로젝트**: Pre Dairy Portal System
---
## 📑 목차
1. [AccountAssignmentService](#1-accountassignmentservice)
2. [LeadSharingService](#2-leadsharingservice)
3. [PortalDashboardController](#3-portaldashboardcontroller)
---
## 1. AccountAssignmentService
### 📌 개요
**파일**: `force-app/main/default/classes/AccountAssignmentService.cls`  
**목적**: Account가 생성되거나 주소가 변경될 때, 가장 가까운 배송 대리점을 자동으로 배정하는 서비스 클래스
### 🎯 비즈니스 요구사항
- 새로운 고객(Account)이 생성되면 근처의 배송 대리점을 자동 배정
- 고객 주소가 변경되면 더 가까운 대리점으로 재배정
- 배송 대리점은 가용 상태(Is_Available__c = true)인 대리점만 대상
- 거리 기반 계산 사용 (Geolocation DISTANCE 함수)
### 📊 아키텍처

```
AccountTrigger (Trigger)
    │
    ├─ After Insert/Update
    │
    └─> AccountAssignmentService.assignDeliveryAgent()
            │
            ├─ BillingLatitude/Longitude 확인
            ├─ DISTANCE 함수로 가장 가까운 대리점 조회
            └─ Delivery_Agent__c 필드 업데이트
```
### 💻 코드 분석
#### 주요 메서드: `assignDeliveryAgent()`
```apex
public static void assignDeliveryAgent(List<Account> newAccounts)
```
**파라미터**:
- `newAccounts`: 배정 대상 Account 리스트
**처리 로직**:
1. **조건 검사**:
   ```apex
   if (acc.Type != 'Delivery Agent' && acc.BillingLatitude != null)
   ```
   - 본인이 배송 대리점이 아닐 것
   - BillingLatitude가 존재할 것 (Geocoding 완료)
2. **가장 가까운 대리점 조회**:
   ```apex
   List<Account> closestAgents = [
       SELECT Id, Name 
       FROM Account 
       WHERE Type = 'Delivery Agent' 
       AND Is_Available__c = true 
       AND Id != :acc.Id 
       ORDER BY DISTANCE(BillingAddress, 
                        GEOLOCATION(:acc.BillingLatitude, :acc.BillingLongitude), 
                        'km') ASC 
       LIMIT 1
   ];
   ```
3. **Delivery_Agent__c 필드 업데이트**:
   ```apex
   accountsToUpdate.add(new Account(
       Id = acc.Id,
       Delivery_Agent__c = closestAgents[0].Id
   ));
   ```
### 🔧 필수 Custom Fields
#### Account Object
| 필드명 | API명 | 타입 | 설명 |
|--------|-------|------|------|
| 배송 대리점 | `Delivery_Agent__c` | Lookup(Account) | 배정된 배송 대리점 |
| 가용 여부 | `Is_Available__c` | Checkbox | 배송점 가용 상태 |
| - | `BillingLatitude` | Number(8,6) | 청구 주소 위도 (표준 필드) |
| - | `BillingLongitude` | Number(9,6) | 청구 주소 경도 (표준 필드) |
#### Account Record Type / Picklist
| 필드 | 값 | 설명 |
|------|-----|------|
| Type | `'Delivery Agent'` | 배송 대리점 타입 |
### ⚙️ 의존성
1. **AccountTrigger** (필수)
   - After Insert: 새 Account 생성 시 호출
   - After Update: 주소 변경 또는 Delivery_Agent__c가 null일 때 호출
2. **Geocoding 설정** (권장)
   - Salesforce Data.com 또는 Google Maps API 연동
   - BillingAddress → BillingLatitude/Longitude 자동 변환
### 📝 사용 예시
```apex
// Trigger에서 호출
trigger AccountTrigger on Account (after insert, after update) {
    List<Account> accsToProcess = new List<Account>();
    
    for (Account acc : Trigger.new) {
        if (Trigger.isInsert && acc.Type != 'Delivery Agent') {
            accsToProcess.add(acc);
        } 
        else if (Trigger.isUpdate) {
            Account oldAcc = Trigger.oldMap.get(acc.Id);
            if ((acc.BillingStreet != oldAcc.BillingStreet || 
                 acc.Delivery_Agent__c == null) && 
                acc.Type != 'Delivery Agent') {
                accsToProcess.add(acc);
            }
        }
    }
    
    if (!accsToProcess.isEmpty()) {
        AccountAssignmentService.assignDeliveryAgent(accsToProcess);
    }
}
```
### ⚠️ 주의사항
1. **Geocoding 필수**: BillingLatitude/Longitude가 없으면 배정되지 않음
2. **Is_Available__c 관리**: 대리점의 가용 상태를 정확히 관리해야 함
3. **재귀 방지**: Trigger 내에서 본인 Account를 다시 업데이트하지 않도록 주의
4. **Bulk 처리**: List로 처리하므로 Governor Limits 고려
### 🐛 트러블슈팅
**문제**: 배송점이 배정되지 않음  
**해결**:
- BillingLatitude/Longitude 확인
- Is_Available__c = true인 배송점이 있는지 확인
- Type = 'Delivery Agent'인 Account가 있는지 확인
**문제**: 너무 먼 배송점이 배정됨  
**해결**:
- DISTANCE 함수가 정상 작동하는지 확인
- 가까운 곳에 Is_Available__c = true인 대리점이 있는지 확인

---
## 2. LeadSharingService
### 📌 개요
**파일**: `force-app/main/default/classes/LeadSharingService.cls`  
**목적**: Lead의 좌표와 Industry 정보를 기반으로 가까운 담당자 3명에게 자동으로 공유하는 Invocable Method
### 🎯 비즈니스 요구사항
- Lead가 생성되면 해당 Industry의 담당자에게 자동 배정
- 거리순으로 가까운 상위 3명에게 Edit 권한으로 공유
- Lead Owner는 제외 (중복 방지)
- Process Builder 또는 Flow에서 호출 가능
### 📊 아키텍처
```
Process Builder / Flow / Trigger
    │
    └─> LeadSharingService.shareLeads(List<Id> leadIds)
            │
            ├─ 1분 후 좌표 확인 (지오코딩 완료 대기)
            ├─ Industry별 Assignment_Master__c 조회
            ├─ 거리순 TOP 3 담당자 찾기
            └─ LeadShare 생성 (Manual sharing)
```
### 💻 코드 분석
#### 주요 메서드: `shareLeads()`
```apex
@InvocableMethod(label='Share Leads by Distance' 
                 description='1분 뒤 좌표를 확인하여 담당자 공유')
public static void shareLeads(List<Id> leadIds)
```
**Invocable Annotation**:
- `label`: Process Builder/Flow에서 표시되는 이름
- `description`: 메서드 설명
**파라미터**:
- `leadIds`: 공유할 Lead ID 리스트
**처리 로직**:
1. **Lead 정보 재조회** (1분 후):
   ```apex
   List<Lead> leads = [
       SELECT Id, Latitude, Longitude, Industry 
       FROM Lead 
       WHERE Id IN :leadIds
   ];
   ```
   > 💡 Geocoding이 완료될 시간을 주기 위해 1분 후 조회
2. **가까운 담당자 조회**:
   ```apex
   List<Assignment_Master__c> nearbyReps = [
       SELECT Manager__c 
       FROM Assignment_Master__c 
       WHERE Industry__c = :l.Industry 
       ORDER BY DISTANCE(Location__c, 
                        GEOLOCATION(:l.Latitude, :l.Longitude), 
                        'km') ASC 
       LIMIT 3
   ];
   ```
3. **LeadShare 생성**:
   ```apex
   sharesToCreate.add(new LeadShare(
       LeadId = l.Id,
       UserOrGroupId = master.Manager__c,
       LeadAccessLevel = 'Edit',
       RowCause = Schema.LeadShare.RowCause.Manual
   ));
   ```
### 🔧 필수 Custom Objects & Fields
#### Lead Object
| 필드명 | API명 | 타입 | 설명 |
|--------|-------|------|------|
| 위도 | `Latitude` | Number(10,7) | Lead 위치 위도 (표준) |
| 경도 | `Longitude` | Number(10,7) | Lead 위치 경도 (표준) |
| 업종 | `Industry` | Picklist | Lead 업종 (표준) |
#### Assignment_Master__c (Custom Object)
| 필드명 | API명 | 타입 | 설명 |
|--------|-------|------|------|
| 담당자 | `Manager__c` | Lookup(User) | 배정할 영업 담당자 |
| 업종 | `Industry__c` | Picklist | 담당 업종 |
| 위치 | `Location__c` | Geolocation | 담당자 근무지 좌표 |
### ⚙️ 의존성
1. **Assignment_Master__c 데이터**:
   - Industry별로 담당자와 Location이 설정되어 있어야 함
2. **Lead Geocoding**:
   - Lead Address → Latitude/Longitude 자동 변환 필요
3. **Sharing Settings**:
   - Lead OWD: Private 또는 Public Read Only
   - Manual Sharing 허용
### 📝 사용 예시
#### Process Builder에서 사용
1. **Object**: Lead
2. **Criteria**: Created or Edited
3. **Criteria**:
   - `[Lead].Address` IS CHANGED = True
4. **Action**: Apex
   - Apex Class: LeadSharingService
   - Method: shareLeads
   - Lead ID: `[Lead].Id`
#### Flow에서 사용
```
Start
  │
  ├─ Get Records: Lead (Filter: Address Changed)
  │
  ├─ Wait: 1 Minute
  │
  └─ Action: ShareLeads
       Input: {!$Record.Id}
```
#### Trigger에서 직접 사용
```apex
// 즉시 호출하지 말고 Invocable Method 사용 권장
// Trigger는 LeadDistanceSharingTrigger 참조
```
### 🎨 고급 기능
**1분 대기 로직을 Process Builder에서 구현**:
```
Process Builder:
1. Entry Criteria: Lead Created/Updated
2. Scheduled Action: 1 Minute After Trigger
3. Action: Invoke Apex (shareLeads)
```
### ⚠️ 주의사항
1. **Invocable Method 제약**:
   - `@future` 또는 `@AuraEnabled`와 함께 사용 불가
   - 동기 실행됨
2. **Governor Limits**:
   - SOQL: 1번 (Lead 조회) + N번 (각 Lead당 Assignment_Master 조회)
   - DML: 1번 (LeadShare insert)
3. **중복 공유 방지**:
   - LeadShare는 중복 insert 시 에러 발생하지 않음 (기존 레코드 유지)
### 🐛 트러블슈팅
**문제**: Lead가 공유되지 않음  
**해결**:
- Latitude/Longitude 확인
- Industry 값 확인
- Assignment_Master__c에 해당 Industry 데이터 있는지 확인
**문제**: "Too many SOQL queries" 에러  
**해결**:
- Bulk 처리 최적화: Lead를 Industry별로 그룹핑하여 조회 횟수 감소
---
## 3. PortalDashboardController
### 📌 개요
**파일**: `force-app/main/default/classes/PortalDashboardController.cls`  
**목적**: Experience Cloud Portal에서 고객이 자신의 Order, Case, Contract 정보를 조회하고 관리할 수 있도록 하는 컨트롤러 클래스
### 🎯 비즈니스 요구사항
- Portal 사용자가 자신의 Order, Case, Contract를 조회
- Case에 댓글/피드 추가 및 조회
- 새로운 Order 생성 (Contract 기반)
- Case에 파일 첨부
- **보안**: 반드시 본인 Account의 데이터만 조회/수정
### 📊 아키텍처
```
Experience Cloud Portal (LWC)
    │
    ├─ portalDashboard
    │   └─> getRelatedRecords()
    │
    ├─ portalCaseDetail
    │   ├─> getCaseFeed()
    │   ├─> addFeedPost()
    │   └─> uploadFiles()
    │
    └─ portalNewOrderForm
        ├─> getActiveContracts()
        ├─> getPricebookProducts()
        └─> createOrder()
```
### 💻 주요 메서드 분석
#### 1. getRelatedRecords()
```apex
@AuraEnabled(cacheable=true)
public static DashboardData getRelatedRecords(String accountId)
```
**기능**: Dashboard에 표시할 Order, Case, Contract 데이터 조회
**보안**:
- `getUserAccountId()`로 현재 사용자의 AccountId 자동 조회
- `with sharing` 클래스이지만 `without sharing` Inner Class 사용
**반환 데이터**:
```apex
public class DashboardData {
    @AuraEnabled public List<Order> orders;      // 최신 10개
    @AuraEnabled public List<Case> cases;        // 최신 10개
    @AuraEnabled public List<Contract> contracts; // 최신 10개
}
```
**Order 필드**:
- `OrderNumber, Status, TotalAmount, EffectiveDate`
- `Delivery_Staus__c` (커스텀)
- `Description, CreatedDate`
**정렬**: `ORDER BY CreatedDate DESC` (최신순)
---
#### 2. getCaseFeed()

```apex
@AuraEnabled(cacheable=true)
public static List<FeedWrapper> getCaseFeed(String caseId)
```
**기능**: Case의 모든 히스토리를 통합하여 반환
**조회 대상**:
- **CaseComment**: 표준 케이스 댓글
- **FeedItem**: Chatter 포스트
- **FeedComment**: Chatter 댓글
- **EmailMessage**: 이메일 메시지 (Email-to-Case)
**Feed Wrapper 구조**:
```apex
public class FeedWrapper implements Comparable {
    @AuraEnabled public String id;
    @AuraEnabled public String body;
    @AuraEnabled public DateTime createdDate;
    @AuraEnabled public String authorName;
    @AuraEnabled public String authorId;
    @AuraEnabled public String type; // 'Comment', 'Post', 'Reply', 'Email In', 'Email Out'
}
```
**정렬**: `createdDate` 내림차순 (최신 먼저)
**보안 검증**:
```apex
Case c = [SELECT Id, AccountId FROM Case WHERE Id = :caseId LIMIT 1];
if (c.AccountId != userAccountId) {
    throw new AuraHandledException('Access Denied');
}
```
---
#### 3. addFeedPost()
```apex
@AuraEnabled
public static void addFeedPost(String caseId, String body)
```
**기능**: Case에 Chatter 포스트 추가
**생성 로직**:
```apex
FeedItem fi = new FeedItem();
fi.ParentId = caseId;
fi.Body = body;
fi.Type = 'TextPost';
fi.Visibility = 'AllUsers'; // Portal 사용자도 볼 수 있음
insert fi;
```
**보안**: Case AccountId 검증
---
#### 4. getActiveContracts()
```apex
@AuraEnabled(cacheable=true)
public static List<Contract> getActiveContracts(String accountId)
```
**기능**: 활성화된 Contract 목록 조회
**필터**: `Status = 'Activated'`
**반환 필드**:
- `Id, ContractNumber, Status, StartDate, EndDate`
- `Pricebook2Id` (Order 생성 시 필요)
---
#### 5. getPricebookProducts()
```apex
@AuraEnabled(cacheable=true)
public static List<PricebookEntry> getPricebookProducts(String pricebook2Id, String contractId)
```
**기능**: Contract의 Pricebook에서 상품 목록 조회
**로직**:
```apex
// Contract 필수
if (String.isBlank(contractId)) {
    return new List<PricebookEntry>();
}

// Contract의 Pricebook2Id 조회
Contract c = [SELECT Pricebook2Id FROM Contract WHERE Id = :contractId LIMIT 1];

// Pricebook2Id가 없으면 에러
if (c.Pricebook2Id == null) {
    throw new AuraHandledException('가격표가 연결되어 있지 않습니다.');
}

// 활성 상품만 조회
return [SELECT Id, Product2Id, Product2.Name, UnitPrice, IsActive
        FROM PricebookEntry 
        WHERE Pricebook2Id = :c.Pricebook2Id AND IsActive = true
        ORDER BY Product2.Name ASC];
```
**특징**:
- Standard Pricebook 사용 안 함 (Contract의 Pricebook만 사용)
- `@AuraEnabled(cacheable=true)`: Wire adapter에서 사용 가능
---
#### 6. createOrder()
```apex
@AuraEnabled
public static Order createOrder(String accountId, String contractId, 
                               Date effectiveDate, String description, 
                               List<Map<String, Object>> products)
```
**기능**: Order 및 OrderItem 생성
**파라미터**:
- `contractId`: **필수**
- `effectiveDate`: 주문 일자 (기본값: 오늘)
- `description`: 주문 내용
- `products`: 선택한 상품 리스트
  ```javascript
  [
    {
      pricebookEntryId: '01u...',
      quantity: 10,
      unitPrice: 1200
    }
  ]
  ```
**처리 로직**:
1. **Contract 검증**:
   ```apex
   if (String.isBlank(contractId)) {
       throw new AuraHandledException('계약서를 선택해주세요.');
   }
   
   Contract c = [SELECT Id, AccountId, Pricebook2Id 
                 FROM Contract WHERE Id = :contractId LIMIT 1];
                 
   if (c.AccountId != targetAccountId) {
       throw new AuraHandledException('Access Denied');
   }
   ```
2. **Order 생성**:
   ```apex
   Order newOrder = new Order();
   newOrder.AccountId = targetAccountId;
   newOrder.Status = 'Requested';
   newOrder.EffectiveDate = effectiveDate != null ? effectiveDate : Date.today();
   newOrder.ContractId = contractId;
   newOrder.Pricebook2Id = c.Pricebook2Id; // Contract의 Pricebook 사용
   newOrder.Description = description;
   insert newOrder;
   ```
3. **OrderItem 생성**:
   ```apex
   List<OrderItem> orderItems = new List<OrderItem>();
   for (Map<String, Object> product : products) {
       OrderItem oi = new OrderItem();
       oi.OrderId = newOrder.Id;
       oi.PricebookEntryId = (String) product.get('pricebookEntryId');
       oi.Quantity = (Decimal) product.get('quantity');
       oi.UnitPrice = (Decimal) product.get('unitPrice');
       orderItems.add(oi);
   }
   insert orderItems;
   ```
**반환**: 생성된 `Order` 객체
---
#### 7. uploadFiles()
```apex
@AuraEnabled
public static void uploadFiles(String recordId, List<Map<String, String>> files)
```
**기능**: Case에 파일 첨부
**파라미터**:
- `recordId`: Case ID
- `files`: 파일 리스트
  ```javascript
  [
    {
      fileName: 'document.pdf',
      base64Data: 'JVBERi0xLjQK...'
    }
  ]
  ```
**처리 로직**:
```apex
// Inner class without sharing 사용
public without sharing class FileUploader {
    public void insertFiles(String recordId, List<Map<String, String>> files) {
        List<ContentVersion> cvList = new List<ContentVersion>();
        for (Map<String, String> f : files) {
            ContentVersion cv = new ContentVersion();
            cv.Title = f.get('fileName');
            cv.PathOnClient = f.get('fileName');
            cv.VersionData = EncodingUtil.base64Decode(f.get('base64Data'));
            cv.FirstPublishLocationId = recordId; // Case에 직접 연결
            cvList.add(cv);
        }
        insert cvList;
    }
}
```
**보안**: Case AccountId 검증 후 `without sharing` Inner Class로 ContentVersion insert
---
### 🔒 보안 아키텍처
#### with sharing vs without sharing
**Main Class**: `with sharing`
```apex
public with sharing class PortalDashboardController {
    // 보안 검증 수행
    String userAccountId = getUserAccountId();
    if (c.AccountId != userAccountId) {
        throw new AuraHandledException('Access Denied');
    }
}
```
**Inner Classes**: `without sharing`
```apex
public without sharing class DataFetcher {
    // Sharing Rule 우회하여 데이터 조회
    // 단, Main Class에서 이미 보안 검증 완료
}
```
**이유**:
- Portal 사용자는 제한된 권한을 가짐
- Sharing Rule로 인해 본인 데이터도 조회 못할 수 있음
- Main Class에서 AccountId 검증 후, Inner Class로 실제 CRUD 수행
#### getUserAccountId()
```apex
private static String getUserAccountId() {
    User u = [SELECT Contact.AccountId, AccountId 
              FROM User WHERE Id = :UserInfo.getUserId() LIMIT 1];
    if (u.Contact != null && u.Contact.AccountId != null) {
        return u.Contact.AccountId; // Portal User
    }
    return u.AccountId; // Internal User
}
```
**Portal User**: `User.Contact.AccountId` 사용  
**Internal User**: `User.AccountId` 사용 (fallback)
---
### 🔧 필수 Custom Fields
#### Order Object
| 필드명 | API명 | 타입 | 설명 |
|--------|-------|------|------|
| 배송현황 | `Delivery_Staus__c` | Picklist | Ready(배송전), Delivered(배송완료) |
---
### 📝 LWC에서 사용 예시
#### Dashboard 데이터 조회
```javascript
import getRelatedRecords from '@salesforce/apex/PortalDashboardController.getRelatedRecords';

export default class PortalDashboard extends LightningElement {
    @wire(getRelatedRecords, { accountId: '$accountId' })
    wiredData({ error, data }) {
        if (data) {
            this.orders = data.orders;
            this.cases = data.cases;
            this.contracts = data.contracts;
        }
    }
}
```
#### Order 생성
```javascript
import createOrder from '@salesforce/apex/PortalDashboardController.createOrder';

handleSubmit() {
    const products = this.selectedProducts.map(p => ({
        pricebookEntryId: p.pricebookEntryId,
        quantity: p.quantity,
        unitPrice: p.unitPrice
    }));
    
    createOrder({
        accountId: null, // 서버에서 getUserAccountId() 사용
        contractId: this.selectedContractId,
        effectiveDate: this.orderDate,
        description: this.description,
        products: products
    })
    .then(result => {
        this.showToast('성공', 'Order가 생성되었습니다', 'success');
    })
    .catch(error => {
        this.showToast('오류', error.body.message, 'error');
    });
}
```
---
### ⚠️ 주의사항

1. **Cacheable Methods**:
   - `getRelatedRecords`, `getCaseFeed`, `getActiveContracts`, `getPricebookProducts`는 `cacheable=true`
   - 파라미터가 같으면 캐시된 데이터 반환
   - 데이터 변경 후 `refreshApex()` 호출 필요

2. **Governor Limits**:
   - `getCaseFeed()`: 4회 SOQL (CaseComment, FeedItem, FeedComment, EmailMessage)
   - Bulk 처리 고려

3. **Order Status**:
   - `'Requested'`는 유효한 picklist 값이어야 함
   - Salesforce Setup에서 Order Status picklist 확인

4. **Pricebook 의존성**:
   - Contract에 Pricebook2Id가 반드시 설정되어 있어야 함
   - Standard Pricebook 사용 안 함
---
### 🐛 트러블슈팅

**문제**: "Access Denied" 에러  
**해결**:
- Portal 사용자의 AccountId 확인
- Contact.AccountId가 올바르게 설정되어 있는지 확인

**문제**: Order 생성 시 "bad value for restricted picklist field: Requested"  
**해결**:
- Setup → Object Manager → Order → Status 필드 picklist 확인
- 'Requested' 값이 있는지 확인, 없으면 추가 또는 다른 값 사용

**문제**: 상품 목록이 표시되지 않음  
**해결**:
- Contract의 Pricebook2Id 확인
- Pricebook2에 IsActive=true인 PricebookEntry가 있는지 확인
---
## 📊 전체 시스템 아키텍처

```
┌─────────────────────────────────────────────────────────────┐
│                  Experience Cloud Portal                    │
│                                                             │
│  ┌──────────────┐  ┌──────────────┐  ┌──────────────┐    │
│  │ Dashboard    │  │ Case Detail  │  │ New Order    │    │
│  │              │  │              │  │              │    │
│  │ - Orders     │  │ - Feed       │  │ - Contracts  │    │
│  │ - Cases      │  │ - Comments   │  │ - Products   │    │
│  │ - Contracts  │  │ - Emails     │  │ - Submit     │    │
│  └──────┬───────┘  └──────┬───────┘  └──────┬───────┘    │
│         │                 │                 │             │
└─────────┼─────────────────┼─────────────────┼─────────────┘
          │                 │                 │
          ▼                 ▼                 ▼
┌─────────────────────────────────────────────────────────────┐
│         PortalDashboardController (with sharing)            │
│                                                             │
│  ┌───────────────────┐  ┌───────────────────┐             │
│  │ DataFetcher       │  │ FileUploader      │             │
│  │ (without sharing) │  │ (without sharing) │             │
│  └───────────────────┘  └───────────────────┘             │
└─────────────────────────────────────────────────────────────┘
          │
          ▼
┌─────────────────────────────────────────────────────────────┐
│               Salesforce Standard Objects                   │
│                                                             │
│  ┌─────────┐  ┌─────────┐  ┌──────────┐  ┌──────────────┐│
│  │ Account │  │ Contact │  │ Contract │  │ Pricebook2   ││
│  └─────────┘  └─────────┘  └──────────┘  └──────────────┘│
│                                                             │
│  ┌─────────┐  ┌─────────┐  ┌──────────┐                   │
│  │ Order   │  │ Case    │  │ Lead     │                   │
│  └─────────┘  └─────────┘  └──────────┘                   │
└─────────────────────────────────────────────────────────────┘
          │
          ▼
┌─────────────────────────────────────────────────────────────┐
│                  Automation Layer                           │
│                                                             │
│  ┌───────────────┐  ┌───────────────────────────────────┐ │
│  │ AccountTrigger│  │ LeadDistanceSharingTrigger        │ │
│  └───────┬───────┘  └───────┬───────────────────────────┘ │
│          │                  │                              │
│          ▼                  ▼                              │
│  ┌───────────────┐  ┌───────────────────────────────────┐ │
│  │ AccountAssign │  │ LeadSharingService                │ │
│  │ mentService   │  │ (Invocable Method)                │ │
│  └───────────────┘  └───────────────────────────────────┘ │
└─────────────────────────────────────────────────────────────┘
```

---

## 📚 참고 자료

- [Salesforce Apex Developer Guide](https://developer.salesforce.com/docs/atlas.en-us.apexcode.meta/apexcode/)
- [Experience Cloud Implementation Guide](https://developer.salesforce.com/docs/atlas.en-us.communities_dev.meta/communities_dev/)
- [SOQL and SOSL Reference](https://developer.salesforce.com/docs/atlas.en-us.soql_sosl.meta/soql_sosl/)

---

**문서 버전**: 1.0  
**최종 업데이트**: 2025-12-29  
**작성자**: JUN JEONGBAE
