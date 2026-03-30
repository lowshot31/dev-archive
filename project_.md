# 🥛 Pre 유제품 CRM 프로젝트

**프로젝트명**: Pre Dairy CRM & Portal System  
**개발 기간**: 2025.12 ~ 2026.01 (2개월)  
**개발자**: 전정배 (JUN JEONGBAE)  
**목적**: B2B 유제품 영업 프로세스 자동화 및 고객 셀프서비스 포털 구축

---

## 📖 1. 개요

### 🏢 비즈니스 배경

**프레(Pre)**는 연 매출 750억 원 규모의 유기농 유제품 중견 기업입니다.

**문제 상황**:

- 고객관리팀: 전화/이메일 문의를 **수기로 내부 전달**
- 영업팀: **엑셀로 고객·계약 관리** → 데이터 분산
- 배송팀: ERP 사용 중이나 **영업팀과 데이터 단절**

**해결 목표**:

```
홈페이지 문의 → Lead 생성 → Account 전환 → Contract 체결 → Order 생성 → 납품 완료
```

**전 과정을 Salesforce CRM으로 자동화**

---

### 🎯 개인 핵심 성과

**"어떻게 하면 모든 영업사원에게 공정하게 기회를 배분할 수 있을까?"** 에 대한 고민을 기술적으로 해결했습니다.

- **공정한 리드 배정 시스템 설계**: 주관적 판단이나 인맥이 아닌, **'업종 적합성 + 물리적 거리'** 기반의 객관적 알고리즘(DISTANCE 함수)을 설계하여 영업 기회 분배의 형평성 확보
- **배정 프로세스의 투명성 및 탈중앙화**: 사람의 개입 없이 시스템이 자동으로 리드와 영업사원을 매칭(Manual Sharing)함으로써 배정 과정에서의 편향성 및 부정 방지
- **기회 선점 알고리즘 (First-come, First-served)**: 가장 인접한 업종 전문가 3명에게 동시에 권한을 공유하여, 적극적인 영업사원이 기회를 얻을 수 있는 선순환 구조 마련 LIMIT 기반으로 향후 사원이 늘어나도 유지보수 용이
- **비즈니스 가치 증명**: 공정한 기회 배분 시스템 도입으로 수기 배정에 따른 병목 현상 제거 및 데이터 정합성 (Data Integrity) 강화 달성

---

## 🏗️ 2. 시스템 아키텍처

### 전체 구조

```
┌─────────────────────────────────────────────┐
│         Pre (웹사이트 - FastAPI)              │
│  - 제품 소개                                  │
│  - 견적 문의 (Web-to-Lead + 카카오 주소 API)  │
│  - 고객 지원 (Mailto)                        │
└──────────────────┬──────────────────────────┘
                   │ HTTPS POST
                   ↓
┌─────────────────────────────────────────────┐
│      Salesforce CRM (Pre-SFDX)              │
├─────────────────────────────────────────────┤
│  📌 Core Objects                            │
│    Lead → Account → Contract → Order        │
│                └─> Case                     │
│                                             │
│  ⚙️ Automation (Apex Triggers)              │
│    - AccountTrigger: 배송점 자동 배정         │
│    - LeadDistanceSharingTrigger: 담당자 공유 │
│                                  및 알림     │
│                                             │
│  🎨 UI Layer (LWC)                          │
│    - portalDashboard: 주문/Case 목록         │
│    - portalNewOrderForm: 주문 생성           │
│    - portalNewCaseForm: Case 접수            │
│    - portalCaseDetail: Case 히스토리         │
│                                             │
│  🌐 Experience Cloud Portal                 │
│    - 계약 고객 전용 포털                     │
│    - 셀프서비스 (주문/문의)                  │
└─────────────────────────────────────────────┘
```

### 2-Tier 설계 이유

| 시스템                | 목적                | 사용자             | 기술                  |
| --------------------- | ------------------- | ------------------ | --------------------- |
| **Pre (웹사이트)**    | 잠재 고객 문의 접수 | 비로그인 방문자    | FastAPI + HTML/CSS/JS |
| **Pre-SFDX (Portal)** | 계약 고객 주문/관리 | 계약 고객 (로그인) | Salesforce + LWC      |

**Why?**

- Web-to-Lead는 **무료**지만, Experience Cloud Portal은 **라이선스 비용** 발생

- 잠재 고객용 문의 폼은 외부 웹사이트로 비용 절감 ✅

---

## 📋 3. 기획 & 설계 (1.5분)

### 3.1 데이터 모델

```
Lead (리드 - 잠재 고객)
  ↓ Convert
Account (고객사)
  ├─> Contact (담당자)
  ├─> Contract (계약)
  │     └─> Order (주문)
  │           └─> OrderItem (주문 상품)
  └─> Case (문의/이슈)

Assignment_Master__c (담당자 마스터)
  └─> Manager__c (User)
```

### 3.2 핵심 Custom Fields

**Account**:

- `Delivery_Agent__c` (Lookup to Account): 배정된 배송 대리점
- `Is_Available__c` (Checkbox): 배송점 가용 여부

**Order**:

- `Delivery_Status__c` (Picklist): Ready / Delivered

**Assignment_Master\_\_c** (Custom Object):

- `Manager__c` (Lookup to User): 담당 영업 사원
- `Industry__c` (Picklist): 담당 업종 (Education, Food & Beverage 등)
- `Location__c` (Geolocation): 담당자 근무지 좌표

### 3.3 자동화 워크플로우

#### ① 신규 리드 처리

```
[홈페이지 문의]
    ↓ Web-to-Lead (HTTP POST)
[Salesforce Lead 자동 생성]
    ↓ Geocoding (1분 대기)
[LeadSharingService.shareLeads()]
    ↓ DISTANCE 함수로 가까운 담당자 3명 조회
[LeadShare 생성 (Manual Sharing, Edit 권한)]
```

#### ② 배송 대리점 배정

```
[Account 생성 또는 주소 변경]
    ↓ AccountTrigger (after insert/update)
[AccountAssignmentService.assignDeliveryAgent()]
    ↓ DISTANCE 함수로 가장 가까운 배송점 조회
[Delivery_Agent__c 필드 자동 업데이트]
```

---

## 💻 4. 구현

### 4.1 Pre (웹사이트 - FastAPI)

#### 기술 스택

- **Backend**: FastAPI + Uvicorn (HTTPS)
- **Frontend**: Vanilla JavaScript (ES6+), HTML5, CSS3
- **통합**: Salesforce Web-to-Lead, 카카오 Postcode API

#### 핵심 구현: contact.html

**1. 카카오 주소 검색 API 연동**

```javascript
function openPostcode() {
  let companyKeyword = document.getElementById("company").value;
  new daum.Postcode({
    oncomplete: function (data) {
      // 주소 데이터 파싱
      let region = data.sido; // "서울"
      let district = data.sigungu; // "강남구"
      let fullAddress = data.roadAddress;

      // Salesforce 필드에 자동 입력
      document.getElementById("street").value = fullAddress;
      document.getElementById("city").value = district;
      document.getElementById("state_code").value = sidoMap[region].code; // "SEOUL"
    },
  }).open({ q: companyKeyword });
}
```

**2. Salesforce 직접 제출**

```html
<form
  action="https://webto.salesforce.com/servlet/servlet.WebToLead"
  method="POST"
  onsubmit="return handleSubmit(event)"
>
  <input type="hidden" name="oid" value="00DgK00000FxdUX" />
  <input type="hidden" name="retURL" id="retURL" />
  <input type="hidden" name="state_code" id="state_code" />

  <!-- 사용자 입력 -->
  <input type="text" id="company" name="company" required />
  <button type="button" onclick="openPostcode()">🔍 주소검색</button>
  <input type="text" id="street" name="street" readonly />

  <button type="submit">간편 견적 문의하기</button>
</form>
```

**Why 카카오 API?**

- ✅ 주소 입력 오류 **원천 차단** (오타, 형식 불일치 방지)
- ✅ 시/도 코드 **자동 변환** ("서울" → "SEOUL")
- ✅ Geocoding 데이터로 **거리 기반 배정** 가능

---

### 4.2 Pre-SFDX (Salesforce CRM + Portal)

#### 기술 스택

- **Platform**: Salesforce
- **Frontend**: Lightning Web Components (LWC) - 6개 컴포넌트
- **Backend**: Apex - 3개 핵심 클래스
- **Portal**: Experience Cloud

#### 핵심 Apex 클래스

**1. PortalDashboardController** (Portal 데이터 조회)

```apex
public with sharing class PortalDashboardController {

    @AuraEnabled(cacheable=true)
    public static Map<String, Object> getRelatedRecords() {
        String accountId = getUserAccountId(); // 보안 검증

        return new Map<String, Object>{
            'orders' => DataFetcher.getOrders(accountId),
            'cases' => DataFetcher.getCases(accountId),
            'contracts' => DataFetcher.getContracts(accountId)
        };
    }

    // Inner Class: without sharing (Portal 권한 우회)
    public without sharing class DataFetcher {
        public static List<Order> getOrders(String accountId) {
            return [SELECT Id, OrderNumber, TotalAmount
                    FROM Order
                    WHERE AccountId = :accountId
                    ORDER BY CreatedDate DESC LIMIT 10];
        }
    }
}
```

**Why with/without sharing?**

- Portal User는 기본 권한이 **매우 제한적**
- `with sharing` Main Class에서 **AccountId 검증** (보안)
- `without sharing` Inner Class에서 **실제 데이터 조회** (권한 우회)
- 모든 SOQL에 `WHERE AccountId = :accountId` 필터 **필수** ✅

**2. AccountAssignmentService** (배송점 자동 배정)

```apex
public class AccountAssignmentService {
    public static void assignDeliveryAgent(List<Account> accounts) {
        for (Account acc : accounts) {
            if (acc.BillingLatitude == null) continue;

            // DISTANCE 함수로 가장 가까운 배송점 조회
            Account nearestAgent = [
                SELECT Id
                FROM Account
                WHERE Type = 'Delivery Agent'
                  AND Is_Available__c = true
                ORDER BY DISTANCE(BillingAddress,
                         GEOLOCATION(:acc.BillingLatitude,
                                     :acc.BillingLongitude), 'km')
                LIMIT 1
            ];

            acc.Delivery_Agent__c = nearestAgent.Id;
        }
        update accounts;
    }
}
```

**3. LeadSharingService** (담당자 자동 공유)

```apex
public class LeadSharingService {
    @InvocableMethod
    public static void shareLeads(List<Id> leadIds) {
        List<Lead> leads = [SELECT Id, Industry, Latitude, Longitude
                            FROM Lead WHERE Id IN :leadIds];

        List<LeadShare> sharesToCreate = new List<LeadShare>();

        for (Lead l : leads) {
            // Industry & 거리 기반으로 담당자 3명 조회
            List<Assignment_Master__c> reps = [
                SELECT Manager__c
                FROM Assignment_Master__c
                WHERE Industry__c = :l.Industry
                ORDER BY DISTANCE(Location__c,
                         GEOLOCATION(:l.Latitude, :l.Longitude), 'km')
                LIMIT 3
            ];

            for (Assignment_Master__c rep : reps) {
                sharesToCreate.add(new LeadShare(
                    LeadId = l.Id,
                    UserOrGroupId = rep.Manager__c,
                    LeadAccessLevel = 'Edit'
                ));
            }
        }
        insert sharesToCreate;
    }
}
```

#### 핵심 LWC 컴포넌트

**portalDashboard.js** (대시보드)

```javascript
import { LightningElement, wire } from "lwc";
import getRelatedRecords from "@salesforce/apex/PortalDashboardController.getRelated Records";
import { refreshApex } from "@salesforce/apex";

export default class PortalDashboard extends LightningElement {
  wiredDashboardResult;

  @wire(getRelatedRecords)
  wiredDashboard(result) {
    this.wiredDashboardResult = result;
    if (result.data) {
      this.orders = result.data.orders;
      this.cases = result.data.cases;
    }
  }

  handleOrderSuccess() {
    refreshApex(this.wiredDashboardResult); // 자동 새로고침
  }
}
```

**Why refreshApex?**

- ❌ `location.reload()`: 전체 페이지 리로드 (3~5초)
- ✅ `refreshApex()`: 변경된 데이터만 갱신 (~0.5초)
- Lightning Data Service 캐시 활용 → 성능 최적화

---

## 🎯 5. 주요 성과 & 향후 계획

### 정성적 성과

- 조직 간 **실시간 정보 공유** (Chatter)
- 배송 대리점 자동 배정으로 **물류 효율** 향상
- 고객 셀프서비스로 **고객 만족도** 향상

---

## 💡 Q&A 대비 핵심 답변

### Q1. 왜 Pre와 Pre-SFDX를 분리했나요?

**A**: **비용 절감** + **보안 강화**

- **Pre (웹사이트)**: 잠재 고객(비로그인) 문의 → Web-to-Lead (무료)
- **Pre-SFDX (Portal)**: 계약 고객(로그인) 주문/관리 → Experience Cloud (유료)

잠재 고객용 단순 문의 폼은 외부 웹사이트로 처리하여 **라이선스 비용 절감** ✅

---

### Q2. 카카오 Postcode API를 추가한 이유는?

**A**: **데이터 정확도 향상** + **사용자 경험 개선**

**표준 Web-to-Lead만 사용 시**:

- 주소를 직접 입력 → 오타 및 형식 불일치 발생
- 시/도, 시/군/구 수동 입력 → 사용자 불편

**카카오 API 추가 시**:

```
1. 🔍 주소검색 버튼 클릭
2. 팝업에서 건물명/도로명 검색
3. 클릭 한 번으로 모든 주소 필드 자동 입력
   - 도로명주소, 우편번호
   - 시/도 ("서울" → "SEOUL" 자동 변환)
   - Geolocation (위도/경도) → 거리 기반 배정 가능
```

→ **무료 API**로 추가 비용 없이, **주소 입력 오류 원천 차단** ✅

---

### Q3. with sharing과 without sharing을 혼용한 이유는?

**A**: **Portal 사용자 권한 제약** + **데이터 보안** 동시 만족

**문제**:

- Portal User는 기본 권한이 매우 제한적
- `with sharing`만 사용 시 본인 데이터도 조회 못할 수 있음

**해결**:

```apex
public with sharing class PortalDashboardController {

    // 1단계: AccountId 검증 (보안)
    private static String getUserAccountId() {
        return [SELECT Contact.AccountId FROM User
                WHERE Id = :UserInfo.getUserId()].Contact.AccountId;
    }

    // 2단계: without sharing Inner Class로 실제 조회
    public without sharing class DataFetcher {
        public static List<Order> getOrders(String accountId) {
            // WHERE AccountId = :accountId 필터 적용 (보안)
            return [SELECT Id FROM Order WHERE AccountId = :accountId];
        }
    }
}
```

→ 권한 우회가 아닌, **검증된 권한 상승** ✅

---

### Q4. Lead 공유를 왜 "1분 후"에 실행하나요?

**A**: **Salesforce Geocoding 완료 시간** 대기

**문제**:

```apex
// Lead 생성 직후
Lead newLead = new Lead(
    Street = '서울시 강남구 테헤란로 123',
    Latitude = null,  // ❌ 아직 Geocoding 안 됨
    Longitude = null
);
insert newLead;

// 즉시 거리 계산 시도
// ❌ DISTANCE 함수 실패 (Latitude/Longitude가 null)
```

**Salesforce Geocoding 동작**:

1. Lead 생성 시 주소 필드 입력
2. **비동기 프로세스**가 Geocoding 수행 (수십 초 소요)
3. Latitude/Longitude 자동 업데이트

**해결**:

```apex
// Process Builder 설정
1. Lead Created
2. Scheduled Action: 1 Minute After Creation
3. Invoke Apex: LeadSharingService.shareLeads
```

→ Geocoding 완료 후 **거리 기반 담당자 배정** 가능 ✅

---

### Q5. 이 프로젝트에서 가장 어려웠던 점은?

**A**: **Portal 사용자의 제한된 권한과 보안 요구사항을 동시에 만족시키는 것**

Portal 사용자는 Salesforce 내부 사용자보다 훨씬 제한된 권한을 가지고 있어, `with sharing` 클래스에서는 본인 데이터조차 조회하지 못하는 경우가 발생했습니다.

이를 해결하기 위해:

1. **Main Class (`with sharing`)**: 사용자 검증 및 AccountId 추출
2. **Inner Class (`without sharing`)**: 검증된 AccountId로만 데이터 조회
3. **모든 SOQL**: `WHERE AccountId = :userAccountId` 필터 **필수**

→ 권한 우회가 아닌, **검증된 권한 상승**을 구현했습니다.

---

### Q6. 영업사원 간의 "공정한 기회 분배"를 위해 구체적으로 어떤 로직을 사용했나요?

**A**: **'업종 전문성'**과 **'물리적 근접성'**이라는 두 가지 객관적 지표를 결합했습니다.

1.  **필터링**: 먼저 리드의 `Industry`(업종)와 일치하는 전문성을 가진 영업사원 그룹을 `Assignment_Master__c`에서 필터링합니다.
2.  **정렬 및 공유**: 필터링된 그룹 내에서 영업사원의 좌표와 리드의 주소지 사이의 거리를 `DISTANCE` 함수로 계산하여, 가장 가까운 **상위 3명**에게만 해당 리드에 대한 편집 권한(`LeadShare`)을 자동으로 부여합니다.
3.  **효과**: 특정 인원에게 리드가 쏠리는 현상을 방지하고, 리드와 가장 소통하기 유리한 위치에 있는 전문가에게 기회를 제공함으로써 성사율과 공정성을 동시에 잡았습니다.

---

### Q7. 이 프로젝트를 개선한다면?

**A**: 현장에서 얻은 피드백을 바탕으로 2가지 개선을 고려하고 있습니다.

1. **ERP 연동**: 현재 수동으로 처리되는 배송 상태 업데이트를 배송지 단말기(ERP)와 실시간 연동하여 데이터 동기화
2. **Mobile 최적화**: Salesforce Mobile App을 커스터마이징하여 배송 기사가 현장에서 즉시 영수증 첨부 및 완료 처리가 가능하도록 구현

---

## 📚 참고 문서

- [Pre Home 상세(웹)](./Pre_Home/README.md)
- [Pre-SFDX 상세(앱)](./Pre_Dev/.agent/Pre_Portal_System_Mockup.md)
- [Salesforce Developer Guide](https://developer.salesforce.com/)
- [Lightning Web Components Guide](https://lwc.dev/)

---

**문서 버전**: 1.0 (발표용)  
**최종 수정일**: 2026-01-06  
**작성자**: 전정배 (JUN JEONGBAE)
