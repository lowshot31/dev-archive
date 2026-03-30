# Salesforce Org ERD - Pre Dairy System

## 📋 문서 정보
- **Org Name**: predairy-dev-ed
- **작성일**: 2025-12-29
- **용도**: Figma ERD 다이어그램 참조용

---

## 🗂️ 오브젝트 개요

### 표준 오브젝트 (Standard Objects)
| Object | Label | Key Prefix | 설명 |
|--------|-------|------------|------|
| Lead | Lead | 00Q | 잠재 고객 정보 |
| Account | Account | 001 | 거래처/고객사 |
| Contact | Contact | 003 | 연락처 (담당자) |
| Opportunity | Opportunity | 006 | 영업 기회 |
| Contract | Contract | 800 | 계약서 |
| Order | Order | 801 | 주문 |
| OrderItem | Order Product | - | 주문 품목 |
| Case | Case | 500 | 고객 문의/이슈 |
| Product2 | Product | 01t | 제품 |
| User | User | 005 | 시스템 사용자 |

### 커스텀 오브젝트 (Custom Objects)
| Object | Label (한글) | Key Prefix | 설명 |
|--------|--------------|------------|------|
| Assignment_Master__c | Assignment Master | a03 | 배정 마스터 |
| Sales_Target__c | 목표 매출 | a01 | 영업 목표 관리 |
| Delivery_Log__c | 배송운영 | a00 | 배송 로그 |
| Delivery_Log_Item__c | 배송 운영 품목 | a02 | 배송 품목 상세 |

---

## 🔗 관계도 (Relationships)

### 핵심 관계 다이어그램

```
┌─────────────────────────────────────────────────────────────────────────────────┐
│                            SALES PROCESS                                        │
│                                                                                 │
│   ┌─────────┐         Convert           ┌─────────────┐                        │
│   │  Lead   │ ─────────────────────────▶ │   Account   │                        │
│   │         │                           │             │                        │
│   │  • Name │                           │  • Name     │◀──────────────┐        │
│   │  • Company│                         │  • Industry │               │        │
│   │  • Status │                         │  • Type     │               │        │
│   │  • 관심제품│                         │  • RecordType│              │        │
│   └─────────┘                           └──────┬──────┘               │        │
│        │                                       │                      │        │
│        │ Convert                          Has Many                    │        │
│        ▼                                       ▼                      │        │
│   ┌─────────────┐                        ┌─────────────┐              │        │
│   │   Contact   │◀───────────────────────│ Opportunity │              │        │
│   │             │        Related          │             │              │        │
│   │  • Name     │                        │  • Name     │              │        │
│   │  • Email    │                        │  • Amount   │              │        │
│   │  • Phone    │                        │  • Stage    │              │        │
│   │  • 포털유저 │                         │  • 월예상수량│              │        │
│   └─────────────┘                        └──────┬──────┘              │        │
│                                                 │                      │        │
│                                            Closed Won                  │        │
│                                                 ▼                      │        │
│                                          ┌─────────────┐              │        │
│                                          │  Contract   │──────────────┘        │
│                                          │             │  BelongsTo            │
│                                          │  • Status   │                       │
│                                          │  • StartDate│                       │
│                                          │  • EndDate  │                       │
│                                          │  • 유효여부 │                        │
│                                          └──────┬──────┘                       │
│                                                 │                               │
│                                            Has Many                             │
│                                                 ▼                               │
│                                          ┌─────────────┐                       │
│                                          │    Order    │                       │
│                                          │             │                       │
│                                          │  • Status   │                       │
│                                          │  • TotalAmt │                       │
│                                          │  • 배송현황 │                        │
│                                          └──────┬──────┘                       │
│                                                 │                               │
│                                            Has Many                             │
│                                                 ▼                               │
│                                          ┌─────────────┐                       │
│                                          │  OrderItem  │                       │
│                                          │             │                       │
│                                          │  • Quantity │                       │
│                                          │  • UnitPrice│                       │
│                                          └─────────────┘                       │
└─────────────────────────────────────────────────────────────────────────────────┘

┌─────────────────────────────────────────────────────────────────────────────────┐
│                         CUSTOMER SERVICE                                        │
│                                                                                 │
│   ┌─────────────┐                        ┌─────────────┐                       │
│   │   Account   │───────────────────────▶│    Case     │                       │
│   └─────────────┘      Has Many          │             │                       │
│                                          │  • Subject  │                       │
│   ┌─────────────┐                        │  • Status   │                       │
│   │   Contact   │───────────────────────▶│  • Priority │                       │
│   └─────────────┘      Raised By         │  • 이슈발생일│                       │
│                                          │  • AI요약   │                       │
│                                          └──────┬──────┘                       │
│                                                 │                               │
│                                            Has Many                             │
│                              ┌──────────────────┼──────────────────┐           │
│                              ▼                  ▼                  ▼           │
│                       ┌──────────────┐   ┌──────────────┐   ┌──────────────┐  │
│                       │ CaseComment  │   │   FeedItem   │   │ EmailMessage │  │
│                       │              │   │              │   │              │  │
│                       │ • CommentBody│   │ • Body       │   │ • TextBody   │  │
│                       │ • CreatedDate│   │ • Type       │   │ • Incoming   │  │
│                       └──────────────┘   └──────────────┘   └──────────────┘  │
└─────────────────────────────────────────────────────────────────────────────────┘

┌─────────────────────────────────────────────────────────────────────────────────┐
│                          DELIVERY OPERATIONS                                    │
│                                                                                 │
│   ┌─────────────┐                        ┌─────────────────┐                   │
│   │   Account   │───────────────────────▶│  Delivery_Log__c│                   │
│   │ (Customer)  │      Has Many          │   (배송운영)     │                   │
│   └─────────────┘                        │                 │                   │
│                                          │  • 배송일       │                    │
│   ┌─────────────┐                        │  • 상태         │                    │
│   │    Order    │───────────────────────▶│  • 관련주문     │                    │
│   └─────────────┘      Related To        │  • 관련사례     │                    │
│                                          └────────┬────────┘                   │
│   ┌─────────────┐                                 │                             │
│   │    Case     │─────────────────────────────────┤ Related To                  │
│   └─────────────┘                                 │                             │
│                                              Has Many                           │
│                                                   ▼                             │
│                                          ┌─────────────────────┐               │
│                                          │Delivery_Log_Item__c │               │
│                                          │   (배송품목상세)     │                │
│                                          │                     │               │
│                                          │  • 제품명           │                │
│                                          │  • 수량             │                │
│                                          │  • Order Product    │               │
│                                          └─────────────────────┘               │
│                                                   │                             │
│                                              Lookup                             │
│                         ┌─────────────────────────┼────────────────────┐       │
│                         ▼                         ▼                    │       │
│                  ┌─────────────┐           ┌─────────────┐             │       │
│                  │  Product2   │           │  OrderItem  │◀────────────┘       │
│                  │   (제품)    │           │ (주문품목)   │                      │
│                  └─────────────┘           └─────────────┘                      │
└─────────────────────────────────────────────────────────────────────────────────┘

┌─────────────────────────────────────────────────────────────────────────────────┐
│                          SALES MANAGEMENT                                       │
│                                                                                 │
│   ┌─────────────┐                        ┌─────────────────┐                   │
│   │    User     │───────────────────────▶│ Sales_Target__c │                   │
│   │ (영업담당)   │      Owner             │   (목표매출)     │                   │
│   └─────────────┘                        │                 │                   │
│                                          │  • 연도          │                   │
│                                          │  • 월            │                   │
│                                          │  • 목표금액      │                    │
│                                          │  • 노트          │                   │
│                                          └─────────────────┘                   │
└─────────────────────────────────────────────────────────────────────────────────┘
```

---

## 📊 오브젝트별 주요 필드

### Lead
| Field API Name | Label | Type | 관계 |
|---------------|-------|------|------|
| Name | Name | Text | - |
| Company | Company | Text | - |
| Status | Lead Status | Picklist | - |
| LeadSource | Lead Source | Picklist | - |
| Region__c | 지역 | Picklist | - |
| District__c | 구 | Text | - |
| Monthly_Expected_Quantity__c | 월별 예상 수량 | Number | - |
| Product_Interest__c | 관심 제품 | MultiPicklist | - |
| Preferred_Start_Date__c | 희망 시작일 | Date | - |

### Account
| Field API Name | Label | Type | 관계 |
|---------------|-------|------|------|
| Name | Account Name | Text | - |
| Type | Type | Picklist | - |
| Industry | Industry | Picklist | - |
| BillingAddress | Billing Address | Address | - |
| ShippingAddress | Shipping Address | Address | - |
| Delivery_Agent__c | 배송대리점 | Lookup | → Account (Self) |
| Delivery_Contacts__c | 배송담당자 이름 | Lookup | → User |
| Sales_representative__c | 영업담당 | Lookup | → User |
| Preferred_Deliver_Day__c | 희망배송요일 | MultiPicklist | - |
| BizReg_Received__c | 사업자등록증 제출 | Checkbox | - |
| **RecordTypes** | | | |
| - B2B_Customer | B2B Customer | RecordType | |
| - School_Customer | School Customer | RecordType | |
| - Delivery_Agent | Delivery Agent | RecordType | |

### Contact
| Field API Name | Label | Type | 관계 |
|---------------|-------|------|------|
| Name | Name | Name | - |
| AccountId | Account | Lookup | → Account |
| Email | Email | Email | - |
| Phone | Phone | Phone | - |
| Portal_User__c | 포털 사용자 | Lookup | → User |
| Portal_User_Status__c | 포털 유저 상태 | Formula | - |
| Primary_Contact__c | Primary Contact | Checkbox | - |

### Opportunity
| Field API Name | Label | Type | 관계 |
|---------------|-------|------|------|
| Name | Opportunity Name | Text | - |
| AccountId | Account | Lookup | → Account |
| Amount | Amount | Currency | - |
| StageName | Stage | Picklist | - |
| CloseDate | Close Date | Date | - |
| ContractId | Contract | Lookup | → Contract |
| Related_Order__c | 관련 주문 | Lookup | → Order |
| Monthly_Expected_Quantity__c | 월별 예상 수량 | Number | - |
| Assigned_Delivery_Agent__c | 담당 배송대리점 | Formula | - |

### Contract
| Field API Name | Label | Type | 관계 |
|---------------|-------|------|------|
| ContractNumber | Contract Number | AutoNumber | - |
| AccountId | Account | Lookup | → Account |
| Status | Status | Picklist | - |
| StartDate | Contract Start Date | Date | - |
| EndDate | Contract End Date | Date | - |
| ContractTerm | Contract Term | Number | - |
| Is_Valid__c | 유효여부 | Formula (Boolean) | - |
| Monthly_Expected_Quantity__c | 월 예상 수량 | Number | - |
| Renewal_Triggered__c | Renewal Triggered | Checkbox | - |

### Order
| Field API Name | Label | Type | 관계 |
|---------------|-------|------|------|
| OrderNumber | Order Number | AutoNumber | - |
| AccountId | Account | Lookup | → Account |
| ContractId | Contract | Lookup | → Contract |
| Status | Status | Picklist | - |
| EffectiveDate | Order Start Date | Date | - |
| TotalAmount | Order Amount | Currency | - |
| Is_Contract_Valid__c | 계약 유효 여부 | Formula | - |
| Delivery_Staus__c | 배송현황 | Picklist | Ready/Delivered |
| Payment_Notes__c | 비고 메모 | LongTextArea | - |

### Case
| Field API Name | Label | Type | 관계 |
|---------------|-------|------|------|
| CaseNumber | Case Number | AutoNumber | - |
| AccountId | Account | Lookup | → Account |
| ContactId | Contact | Lookup | → Contact |
| Subject | Subject | Text | - |
| Description | Description | LongTextArea | - |
| Status | Status | Picklist | - |
| Priority | Priority | Picklist | - |
| Origin | Case Origin | Picklist | - |
| Issue_Date__c | 이슈 발생일 | Date | - |
| Issue_Summary__c | 이슈 요약 | LongTextArea | - |
| AI_Summary__c | 에이전트 요약 | LongTextArea | - |
| **RecordTypes** | | | |
| - RecordType | 기본 사례 | RecordType | |

### Product2
| Field API Name | Label | Type | 관계 |
|---------------|-------|------|------|
| Name | Product Name | Text | - |
| ProductCode | Product Code | Text | - |
| IsActive | Active | Checkbox | - |
| Family | Product Family | Picklist | - |
| Type | Product Type | Picklist | Base/Bundle/Set |
| ProductClass | Product Class | Picklist | Simple/VariationParent/etc |
| Product_Image__c | Product Image | Formula (Image) | - |

---

## 🔧 커스텀 오브젝트 상세

### Sales_Target__c (목표 매출)
| Field API Name | Label | Type | 관계 |
|---------------|-------|------|------|
| Name | Sales Target Name | Text | - |
| OwnerId | Owner | Lookup | → User |
| Year__c | 연도 | Picklist | 2024/2025/2026 |
| Month__c | 월 | Picklist | 1월-12월 |
| Target_Amount__c | 목표 금액 | Currency | - |
| Notes__c | 노트 | LongTextArea | - |

### Delivery_Log__c (배송운영)
| Field API Name | Label | Type | 관계 |
|---------------|-------|------|------|
| Name | Delivery Log Name | Text | - |
| Customer__c | 거래처 | Lookup | → Account |
| Delivery_Date__c | 배송 날짜 | Date | - |
| Status__c | 상태 | Picklist | 배송완료/배송전/이슈발생 |
| Related_Order__c | 관련 주문 | Lookup | → Order |
| Related_Case__c | 관련 사례 | Lookup | → Case |
| Driver__c | 배송기사 | Lookup | → User |
| Notes__c | 특이사항 | LongTextArea | - |
| Delivery_Sequence__c | 배송순서 | Number | - |

### Delivery_Log_Item__c (배송 운영 품목)
| Field API Name | Label | Type | 관계 |
|---------------|-------|------|------|
| Name | Item Name | Text | - |
| Delivery_Log__c | Delivery Log | Master-Detail | → Delivery_Log__c |
| Product__c | 제품명 | Lookup | → Product2 |
| Quantity__c | 수량 | Number | - |
| Order_Product__c | Order Product | Lookup | → OrderItem |

### Assignment_Master__c (Assignment Master)
| Field API Name | Label | Type | 관계 |
|---------------|-------|------|------|
| Name | Name | Text | - |
| Location__c | Location | Geolocation | - |
| (기타 필드는 추가 조회 필요) | | | |

---

## 🔀 관계 요약표

| From Object | Relationship | To Object | Type | Field Name |
|-------------|-------------|-----------|------|------------|
| Contact | N:1 | Account | Lookup | AccountId |
| Contact | N:1 | User | Lookup | Portal_User__c |
| Opportunity | N:1 | Account | Lookup | AccountId |
| Opportunity | N:1 | Contract | Lookup | ContractId |
| Opportunity | N:1 | Order | Lookup | Related_Order__c |
| Contract | N:1 | Account | Lookup | AccountId |
| Order | N:1 | Account | Lookup | AccountId |
| Order | N:1 | Contract | Lookup | ContractId |
| OrderItem | N:1 | Order | Master-Detail | OrderId |
| OrderItem | N:1 | Product2 | Lookup | Product2Id |
| Case | N:1 | Account | Lookup | AccountId |
| Case | N:1 | Contact | Lookup | ContactId |
| CaseComment | N:1 | Case | Lookup | ParentId |
| FeedItem | N:1 | Case | Lookup | ParentId |
| EmailMessage | N:1 | Case | Lookup | ParentId |
| Account | N:1 | Account | Lookup (Self) | Delivery_Agent__c |
| Account | N:1 | User | Lookup | Delivery_Contacts__c |
| Account | N:1 | User | Lookup | Sales_representative__c |
| Delivery_Log__c | N:1 | Account | Lookup | Customer__c |
| Delivery_Log__c | N:1 | Order | Lookup | Related_Order__c |
| Delivery_Log__c | N:1 | Case | Lookup | Related_Case__c |
| Delivery_Log__c | N:1 | User | Lookup | Driver__c |
| Delivery_Log_Item__c | N:1 | Delivery_Log__c | Master-Detail | Delivery_Log__c |
| Delivery_Log_Item__c | N:1 | Product2 | Lookup | Product__c |
| Delivery_Log_Item__c | N:1 | OrderItem | Lookup | Order_Product__c |
| Sales_Target__c | N:1 | User | Lookup | OwnerId |

---

## 🎨 Figma 컬러 가이드

### Object Type Colors
| Type | Color | Hex |
|------|-------|-----|
| Standard Core (Account, Contact) | Blue | #0176D3 |
| Standard Business (Opportunity, Order) | Green | #2E844A |
| Custom Objects | Purple | #7C41A3 |
| Junction/Detail Objects | Gray | #706E6B |
| Feed/Activity Objects | Orange | #F39C12 |

### Relationship Line Styles
| Type | Style |
|------|-------|
| Master-Detail | Solid thick line |
| Lookup | Solid thin line |
| Self-Lookup | Dashed line with loop |
| Formula Reference | Dotted line |

---

## 📝 노트

1. **Portal 통합**: Contact → Portal_User__c를 통해 Experience Cloud 사용자와 연동
2. **배송 프로세스**: Account → Order → Delivery_Log__c → Delivery_Log_Item__c 순으로 추적
3. **영업 프로세스**: Lead → Account + Contact + Opportunity → Contract → Order
4. **케이스 관리**: Account/Contact → Case → (CaseComment, FeedItem, EmailMessage) 통합 피드
5. **Self-Lookup**: Account.Delivery_Agent__c는 배송대리점 Account를 참조

---

**생성일**: 2024-12-29  
**Org**: predairy-dev-ed.develop.my.salesforce.com
