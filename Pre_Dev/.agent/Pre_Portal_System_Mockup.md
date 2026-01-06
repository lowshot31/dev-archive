# Pre Portal System - 상세 목업 문서

## 📋 목차
1. [시스템 개요](#시스템-개요)
2. [아키텍처 구조](#아키텍처-구조)
3. [Apex Controller 상세](#apex-controller-상세)
4. [LWC 컴포넌트 상세](#lwc-컴포넌트-상세)
5. [데이터 플로우](#데이터-플로우)
6. [UI/UX 디자인 가이드](#uiux-디자인-가이드)
7. [배포 및 테스트](#배포-및-테스트)

---

## 시스템 개요

### 프로젝트명
**Pre Portal System** - Experience Cloud 기반 고객 포털

### 목적
B2B 고객들이 주문(Order), 케이스(Case), 계약(Contract) 정보를 조회하고, 케이스 상담 내역을 실시간으로 확인하며 새로운 댓글을 작성할 수 있는 셀프서비스 포털

### 주요 기능
- ✅ 대시보드: Orders, Cases, Contracts 통합 뷰
- ✅ 케이스 상세: 채팅 스타일의 상담 내역 조회
- ✅ 통합 피드: CaseComment, FeedItem, FeedComment, EmailMessage 통합
- ✅ 실시간 댓글 작성 및 새로고침
- ✅ 반응형 헤더/푸터 (모바일 지원)
- ✅ 사용자 이름 표시 및 로그아웃

---

## 아키텍처 구조

### 시스템 구성도

```
┌─────────────────────────────────────────────────────────────┐
│                    Experience Cloud Portal                   │
├─────────────────────────────────────────────────────────────┤
│                                                               │
│  ┌──────────────┐  ┌──────────────┐  ┌──────────────┐      │
│  │ portalHeader │  │ portalFooter │  │ inquiryForm  │      │
│  └──────────────┘  └──────────────┘  └──────────────┘      │
│                                                               │
│  ┌───────────────────────────────────────────────────────┐  │
│  │            portalDashboard (Main Component)           │  │
│  │  ┌─────────────────────────────────────────────────┐ │  │
│  │  │  Overview Tab  │  Orders  │  Cases  │ Contracts │ │  │
│  │  └─────────────────────────────────────────────────┘ │  │
│  │                                                        │  │
│  │  ┌─────────────────────────────────────────────────┐ │  │
│  │  │         portalCaseDetail (Child Component)      │ │  │
│  │  │  - Case Header (Status, Priority, Date)         │ │  │
│  │  │  - Chat Feed (Comments, Posts, Emails)          │ │  │
│  │  │  - Input Area (New Comment)                     │ │  │
│  │  └─────────────────────────────────────────────────┘ │  │
│  └───────────────────────────────────────────────────────┘  │
│                                                               │
└───────────────────────┬───────────────────────────────────────┘
                        │
                        ▼
        ┌───────────────────────────────────┐
        │  PortalDashboardController (Apex) │
        ├───────────────────────────────────┤
        │  • getRelatedRecords()            │
        │  • getCaseFeed()                  │
        │  • addFeedPost()                  │
        │  • createOrder()                  │
        └───────────────┬───────────────────┘
                        │
                        ▼
        ┌───────────────────────────────────┐
        │     Salesforce Standard Objects   │
        ├───────────────────────────────────┤
        │  • Order                          │
        │  • Case                           │
        │  • Contract                       │
        │  • CaseComment                    │
        │  • FeedItem                       │
        │  • FeedComment                    │
        │  • EmailMessage                   │
        └───────────────────────────────────┘
```

### 기술 스택
- **Frontend**: Lightning Web Components (LWC)
- **Backend**: Apex (with sharing)
- **Platform**: Salesforce Experience Cloud
- **Styling**: SLDS (Salesforce Lightning Design System) + Custom CSS
- **Navigation**: NavigationMixin
- **Data Binding**: @wire, @track, @api

---

## Apex Controller 상세

### PortalDashboardController.cls

#### 클래스 구조

```apex
public with sharing class PortalDashboardController {
    // Inner Classes
    - FeedWrapper (Comparable)
    - DashboardData
    
    // Public Methods
    - getCaseFeed(String caseId)
    - addFeedPost(String caseId, String body)
    - getRelatedRecords(String accountId)
    - createOrder(Map<String, Object> orderDetails)
}
```

#### 1. getCaseFeed() - 통합 피드 조회

**목적**: 케이스의 모든 상담 내역을 시간순으로 통합하여 반환

**파라미터**:
- `caseId` (String): 조회할 케이스 ID

**반환값**: `List<FeedWrapper>`

**데이터 소스**:
```apex
A. CaseComment - 표준 케이스 댓글
   SELECT Id, CommentBody, CreatedDate, CreatedBy.Name, CreatedBy.Id
   FROM CaseComment
   WHERE ParentId = :caseId

B. FeedItem - Chatter 포스트
   SELECT Id, Body, CreatedDate, CreatedBy.Name, CreatedBy.Id
   FROM FeedItem
   WHERE ParentId = :caseId AND Visibility = 'AllUsers'

C. FeedComment - Chatter 포스트의 댓글
   SELECT Id, CommentBody, CreatedDate, CreatedBy.Name, CreatedBy.Id
   FROM FeedComment
   WHERE ParentId = :caseId

D. EmailMessage - 이메일 히스토리
   SELECT Id, TextBody, CreatedDate, FromName, FromAddress, Incoming
   FROM EmailMessage
   WHERE ParentId = :caseId AND IsExternallyVisible = true
```

**처리 로직**:
1. 4개 소스에서 데이터 조회
2. HTML 태그 제거 (`replaceAll('<[^>]+>', '')`)
3. FeedWrapper 객체로 변환
4. CreatedDate 기준 내림차순 정렬 (최신순)

**FeedWrapper 구조**:
```apex
public class FeedWrapper implements Comparable {
    @AuraEnabled public String id;           // 레코드 ID
    @AuraEnabled public String body;         // 본문 내용
    @AuraEnabled public DateTime createdDate; // 생성일시
    @AuraEnabled public String authorName;   // 작성자 이름
    @AuraEnabled public String authorId;     // 작성자 ID
    @AuraEnabled public String type;         // 타입 (Comment/Post/Reply/Email In/Email Out)
}
```

#### 2. addFeedPost() - 새 댓글 작성

**목적**: 포털 사용자가 케이스에 새로운 댓글 작성

**파라미터**:
- `caseId` (String): 대상 케이스 ID
- `body` (String): 댓글 내용

**처리 로직**:
```apex
FeedItem fi = new FeedItem();
fi.ParentId = caseId;
fi.Body = body;
fi.Type = 'TextPost';
fi.Visibility = 'AllUsers';  // 포털 사용자 가시성 보장
insert fi;
```

**중요 포인트**:
- `Visibility = 'AllUsers'` 설정 필수 (포털 사용자 접근 권한)
- FeedItem 사용 (CaseComment 대신) → Chatter 통합

#### 3. getRelatedRecords() - 대시보드 데이터 조회

**목적**: 계정의 주문, 케이스, 계약 정보 조회

**파라미터**:
- `accountId` (String, optional): 계정 ID (미제공 시 현재 사용자의 Contact.AccountId 사용)

**반환값**: `DashboardData`

**DashboardData 구조**:
```apex
public class DashboardData {
    @AuraEnabled public List<Order> orders;
    @AuraEnabled public List<Case> cases;
    @AuraEnabled public List<Contract> contracts;
}
```

**조회 쿼리**:
```apex
// Orders (최근 10개)
SELECT Id, OrderNumber, Status, TotalAmount, EffectiveDate
FROM Order
WHERE AccountId = :targetAccountId
ORDER BY EffectiveDate DESC
LIMIT 10

// Cases (최근 10개)
SELECT Id, CaseNumber, Subject, Status, Priority, CreatedDate
FROM Case
WHERE AccountId = :targetAccountId
ORDER BY CreatedDate DESC
LIMIT 10

// Contracts (최근 10개)
SELECT Id, ContractNumber, Status, StartDate, EndDate
FROM Contract
WHERE AccountId = :targetAccountId
ORDER BY StartDate DESC
LIMIT 10
```

#### 4. createOrder() - 주문 생성

**목적**: 포털에서 새 주문 생성

**파라미터**:
- `orderDetails` (Map<String, Object>): 주문 정보
  - AccountId (optional)
  - Status (optional, default: 'Draft')
  - EffectiveDate (optional, String format)

**처리 로직**:
1. AccountId 확인 (미제공 시 현재 사용자의 Contact.AccountId 사용)
2. Status 설정 (기본값: 'Draft')
3. EffectiveDate 변환 (String → Date)
4. Order 레코드 insert

---

## LWC 컴포넌트 상세

### 1. portalHeader

#### 목적
고정 헤더 - 로고, 네비게이션, 사용자 정보, 로그아웃

#### 주요 속성
```javascript
@api logoUrl;                    // 로고 이미지 URL
@track isScrolled = false;       // 스크롤 상태
@track isMobileMenuOpen = false; // 모바일 메뉴 상태
@track userName;                 // 사용자 이름
```

#### Wire Service
```javascript
@wire(getRecord, { recordId: USER_ID, fields: [NAME_FIELD] })
wiredUser({ error, data }) {
    if (data) {
        this.userName = data.fields.Name.value;
    }
}
```

#### 네비게이션 메서드
```javascript
// Dashboard (Overview 탭)
navigateToHome(event) {
    this[NavigationMixin.Navigate]({
        type: 'comm__namedPage',
        attributes: { name: 'Home' },
        state: { tab: 'overview', t: Date.now() }
    });
}

// Orders 탭
navigateToOrder(event) {
    state: { tab: 'orders', t: Date.now() }
}

// Cases 탭
navigateToSupport(event) {
    state: { tab: 'cases', t: Date.now() }
}
```

**타임스탬프 사용 이유**: `t: Date.now()`를 추가하여 같은 페이지 내에서도 Wire Service가 state 변경을 감지하도록 강제

#### 로그아웃
```javascript
handleLogout() {
    const sitePrefix = window.location.pathname.substring(0, 
        window.location.pathname.indexOf('/s/'));
    window.location.href = sitePrefix + '/secur/logout.jsp';
}
```

#### HTML 구조
```html
<header class={headerClass}>
    <div class="header-inner">
        <a onclick={navigateToHome} class="logo">
            <img src="/sfsites/c/file-asset/pre_logo">
        </a>
        
        <nav class={navClass}>
            <ul class="nav-list">
                <li><a onclick={navigateToHome}>Dashboard</a></li>
                <li><a onclick={navigateToOrder}>Orders</a></li>
                <li><a onclick={navigateToSupport}>Support</a></li>
            </ul>
            
            <div class="user-container">
                <span class="user-name">{userName}</span>
                <a onclick={handleLogout} class="btn-logout">Logout</a>
            </div>
        </nav>
        
        <button class={menuToggleClass} onclick={toggleMenu}>
            <!-- Mobile menu toggle -->
        </button>
    </div>
</header>
```

#### CSS 하이라이트
```css
:host {
    --color-primary: #2d4a3e;      /* 다크 그린 */
    --color-primary-dark: #1e352a; /* 더 진한 그린 */
    --color-accent: #7cb342;       /* 라이트 그린 */
}

.header {
    position: fixed;
    background: var(--color-primary-dark);
    backdrop-filter: blur(12px);
}

.btn-logout {
    background: transparent;
    border: 1px solid rgba(255, 255, 255, 0.3);
    color: white;
}

.btn-logout:hover {
    background: var(--color-accent);
    border-color: var(--color-accent);
}
```

---

### 2. portalDashboard

#### 목적
메인 대시보드 - 주문/케이스/계약 조회 및 케이스 상세 뷰 전환

#### 주요 속성
```javascript
@api recordId;                    // Account ID (Experience Cloud에서 자동 주입)

// Pagination
pageSize = 5;
@track orderState = this.initPaginationState();
@track caseState = this.initPaginationState();
@track contractState = this.initPaginationState();

// UI State
@track isLoading = true;
@track showModal = false;
@track activeTab = 'overview';

// View Mode
@track viewMode = 'dashboard';    // 'dashboard' | 'case_detail'
@track selectedCase = null;

// Data
@track orders = [];
@track cases = [];
@track contracts = [];
```

#### Wire Services

**1. URL State 감지**
```javascript
@wire(CurrentPageReference)
getStateParameters(currentPageReference) {
    if (currentPageReference) {
        const tabParam = (currentPageReference.state.tab || 'overview').toLowerCase();
        if (['orders', 'cases', 'contracts', 'overview'].includes(tabParam)) {
            this.activeTab = tabParam;
        }
        // 항상 대시보드 뷰로 리셋
        this.viewMode = 'dashboard';
        this.selectedCase = null;
    }
}
```

**2. 데이터 조회**
```javascript
@wire(getRelatedRecords, { accountId: '$recordId' })
wiredData(result) {
    this.wiredResult = result;
    const { data, error } = result;
    if (data) {
        this.orders = data.orders || [];
        this.cases = data.cases || [];
        this.contracts = data.contracts || [];
        
        this.setPaginationData('orderState', this.orders);
        this.setPaginationData('caseState', this.cases);
        this.setPaginationData('contractState', this.contracts);
        this.isLoading = false;
    }
}
```

#### 페이지네이션 로직

**State 구조**:
```javascript
{
    data: [],           // 전체 데이터
    currentPage: 1,     // 현재 페이지
    totalPages: 1,      // 총 페이지 수
    visibleData: [],    // 현재 페이지 데이터
    disablePrev: true,  // 이전 버튼 비활성화
    disableNext: true   // 다음 버튼 비활성화
}
```

**페이지 이동**:
```javascript
handleNext(event) {
    const type = event.target.dataset.type; // 'order', 'case', 'contract'
    const stateName = type + 'State';
    const state = this[stateName];
    
    if (state.currentPage < state.totalPages) {
        state.currentPage++;
        this.updateVisibleData(stateName);
    }
}

updateVisibleData(stateName) {
    const state = this[stateName];
    const start = (state.currentPage - 1) * this.pageSize;
    const end = start + this.pageSize;
    
    state.visibleData = state.data.slice(start, end);
    state.disablePrev = state.currentPage <= 1;
    state.disableNext = state.currentPage >= state.totalPages;
    
    this[stateName] = { ...state }; // 반응성 트리거
}
```

#### 케이스 상세 전환

**Row Action 처리**:
```javascript
handleRowAction(event) {
    const actionName = event.detail.action.name;
    const row = event.detail.row;
    if (actionName === 'view_case') {
        this.selectedCase = row;
        this.viewMode = 'case_detail';
    }
}

handleBackToDashboard() {
    this.viewMode = 'dashboard';
    this.selectedCase = null;
}
```

#### HTML 구조
```html
<lightning-card title="Portal Dashboard">
    <!-- Case Detail View -->
    <template lwc:if={isCaseDetailView}>
        <c-portal-case-detail
            case-id={selectedCase.Id}
            case-subject={selectedCase.Subject}
            case-status={selectedCase.Status}
            case-number={selectedCase.CaseNumber}
            case-priority={selectedCase.Priority}
            case-created-date={selectedCase.CreatedDate}
            onback={handleBackToDashboard}>
        </c-portal-case-detail>
    </template>
    
    <!-- Dashboard View -->
    <template lwc:if={isDashboardView}>
        <lightning-tabset active-tab-value={activeTab}>
            <!-- Overview Tab -->
            <lightning-tab label="Overview" value="overview">
                <div class="slds-grid slds-gutters">
                    <!-- Recent Orders -->
                    <div class="slds-col slds-size_1-of-3">
                        <lightning-datatable
                            data={visibleOrdersSummary}
                            columns={orderColumns}>
                        </lightning-datatable>
                    </div>
                    <!-- Recent Cases -->
                    <!-- Recent Contracts -->
                </div>
            </lightning-tab>
            
            <!-- Orders Tab -->
            <lightning-tab label="Orders" value="orders">
                <lightning-datatable
                    data={orderState.visibleData}
                    columns={orderColumns}>
                </lightning-datatable>
                <!-- Pagination Controls -->
            </lightning-tab>
            
            <!-- Cases Tab -->
            <!-- Contracts Tab -->
        </lightning-tabset>
    </template>
</lightning-card>
```

#### 컬럼 정의
```javascript
const CASE_COLUMNS = [
    { 
        label: 'Case Number', 
        type: 'button', 
        typeAttributes: { 
            label: { fieldName: 'CaseNumber' }, 
            variant: 'base',
            name: 'view_case'  // Row action 트리거
        } 
    },
    { label: 'Subject', fieldName: 'Subject', type: 'text' },
    { label: 'Status', fieldName: 'Status', type: 'text' },
    { label: 'Priority', fieldName: 'Priority', type: 'text' }
];
```

---

### 3. portalCaseDetail

#### 목적
케이스 상세 정보 및 채팅 스타일 피드 표시

#### 주요 속성
```javascript
// API Properties (부모로부터 전달)
@api caseId;
@api caseSubject;
@api caseStatus;
@api caseNumber;
@api casePriority;
@api caseCreatedDate;

// Tracked Properties
@track comments = [];
@track newComment = '';
@track isLoading = true;

wiredCommentsResult;
currentUserId = USER_ID;
```

#### Wire Service
```javascript
@wire(getCaseFeed, { caseId: '$caseId' })
wiredComments(result) {
    this.wiredCommentsResult = result;
    const { data, error } = result;
    if (data) {
        this.comments = data.map(item => {
            const isMe = item.authorId === this.currentUserId;
            return {
                Id: item.id,
                CommentBody: item.body,
                authorName: item.authorName,
                cssClass: isMe ? 'feed-item outbound' : 'feed-item inbound',
                formattedDate: new Date(item.createdDate).toLocaleString()
            };
        });
        this.isLoading = false;
    }
}
```

**데이터 매핑**:
- `isMe`: 현재 사용자가 작성한 댓글인지 판별
- `cssClass`: 본인 댓글은 'outbound' (오른쪽 정렬), 타인 댓글은 'inbound' (왼쪽 정렬)
- `formattedDate`: 날짜 포맷팅

#### 댓글 작성
```javascript
handleAddComment() {
    if (!this.newComment || !this.newComment.trim()) return;
    
    this.isLoading = true;
    addFeedPost({ caseId: this.caseId, body: this.newComment })
        .then(() => {
            this.newComment = '';
            return refreshApex(this.wiredCommentsResult);
        })
        .catch(error => {
            this.dispatchEvent(new ShowToastEvent({
                title: 'Error',
                message: 'Failed to add message',
                variant: 'error'
            }));
        })
        .finally(() => {
            this.isLoading = false;
        });
}
```

**refreshApex**: Wire 서비스 데이터를 수동으로 새로고침하여 최신 댓글 목록 반영

#### HTML 구조
```html
<div class="case-detail-container">
    <!-- Header Section -->
    <div class="case-header">
        <a onclick={handleBack} class="back-link">
            <lightning-icon icon-name="utility:back" size="xx-small"></lightning-icon>
            Back to Dashboard
        </a>
        <h1>{caseSubject}</h1>
        
        <div class="status-row">
            <div>
                <p class="label">Status</p>
                <p class="value"><span class="status-badge">{caseStatus}</span></p>
            </div>
            <div>
                <p class="label">Date Opened</p>
                <p class="value">{caseCreatedDate}</p>
            </div>
            <div>
                <p class="label">Priority</p>
                <p class="value">{casePriority}</p>
            </div>
        </div>
    </div>
    
    <!-- Chat Feed Section -->
    <div class="chat-feed">
        <!-- Comment Input -->
        <div class="input-area">
            <lightning-input 
                placeholder="Add a comment..."
                value={newComment}
                onchange={handleCommentChange}
                oncommit={handleAddComment}>
            </lightning-input>
            <button class="send-btn" onclick={handleAddComment}>
                <lightning-icon icon-name="utility:arrow_up"></lightning-icon>
            </button>
        </div>
        
        <!-- Feed Items -->
        <div class="feed-list">
            <template for:each={comments} for:item="comment">
                <div key={comment.Id} class={comment.cssClass}>
                    <div class="avatar-container">
                        <lightning-icon icon-name="standard:user"></lightning-icon>
                    </div>
                    <div class="message-content">
                        <div class="message-header">
                            <span class="author-name">{comment.authorName}</span>
                            <span class="message-date">{comment.formattedDate}</span>
                        </div>
                        <div class="message-body">
                            <lightning-formatted-text value={comment.CommentBody}>
                            </lightning-formatted-text>
                        </div>
                    </div>
                </div>
            </template>
        </div>
    </div>
</div>
```

#### CSS 하이라이트 (채팅 스타일)
```css
.feed-item {
    display: flex;
    gap: 12px;
    margin-bottom: 16px;
}

.feed-item.outbound {
    flex-direction: row-reverse;  /* 오른쪽 정렬 */
}

.feed-item.outbound .message-content {
    background: #0176d3;  /* 파란색 말풍선 */
    color: white;
}

.feed-item.inbound .message-content {
    background: #f3f3f3;  /* 회색 말풍선 */
    color: #333;
}

.message-content {
    max-width: 70%;
    padding: 12px 16px;
    border-radius: 16px;
}

.send-btn {
    width: 40px;
    height: 40px;
    border-radius: 50%;
    background: #0176d3;
    border: none;
    cursor: pointer;
}
```

---

### 4. portalFooter

#### 목적
고정 푸터 - 회사 정보, 링크, 연락처

#### HTML 구조
```html
<footer class="footer">
    <div class="footer-grid">
        <!-- Brand -->
        <div class="footer-brand">
            <img src="/sfsites/c/file-asset/pre_logo">
            <p>유기농, 특별함이 아닌 일상이 되다.</p>
        </div>
        
        <!-- Quick Links -->
        <div class="footer-column">
            <h4>바로가기</h4>
            <ul>
                <li><a href="#">회사 소개</a></li>
                <li><a href="#">제품 안내</a></li>
            </ul>
        </div>
        
        <!-- Products -->
        <div class="footer-column">
            <h4>제품</h4>
            <ul>
                <li><a href="#">유기농 우유</a></li>
                <li><a href="#">저지방 우유</a></li>
            </ul>
        </div>
        
        <!-- Support -->
        <div class="footer-column">
            <h4>고객 지원</h4>
            <ul>
                <li><a href="#">1588-0000</a></li>
                <li><a href="#">sales@pre-dairy.com</a></li>
            </ul>
        </div>
    </div>
    
    <div class="footer-bottom">
        <p>&copy; 2024 Pre Dairy Company. All rights reserved.</p>
    </div>
</footer>
```

---

## 데이터 플로우

### 1. 대시보드 로딩 플로우

```
User 접속
    ↓
Experience Cloud → portalDashboard 렌더링
    ↓
@wire(CurrentPageReference) → activeTab 설정
    ↓
@wire(getRelatedRecords, { accountId: '$recordId' })
    ↓
PortalDashboardController.getRelatedRecords(accountId)
    ↓
User.Contact.AccountId 조회 (accountId가 없는 경우)
    ↓
Order, Case, Contract 쿼리 (각 10개)
    ↓
DashboardData 반환
    ↓
portalDashboard: orders, cases, contracts 설정
    ↓
setPaginationData() → 페이지네이션 State 초기화
    ↓
UI 렌더링 (Overview/Orders/Cases/Contracts 탭)
```

### 2. 케이스 상세 조회 플로우

```
User: Case Number 클릭
    ↓
handleRowAction(event)
    ↓
selectedCase = row
viewMode = 'case_detail'
    ↓
portalCaseDetail 렌더링
    ↓
@wire(getCaseFeed, { caseId: '$caseId' })
    ↓
PortalDashboardController.getCaseFeed(caseId)
    ↓
┌─────────────────────────────────────────┐
│ A. CaseComment 조회                     │
│ B. FeedItem 조회 (Visibility='AllUsers')│
│ C. FeedComment 조회                     │
│ D. EmailMessage 조회 (IsExternallyVisible=true) │
└─────────────────────────────────────────┘
    ↓
HTML 태그 제거, FeedWrapper 변환
    ↓
CreatedDate DESC 정렬
    ↓
List<FeedWrapper> 반환
    ↓
portalCaseDetail: comments 설정
    ↓
isMe 판별 → cssClass 설정 (outbound/inbound)
    ↓
UI 렌더링 (채팅 스타일 피드)
```

### 3. 댓글 작성 플로우

```
User: 댓글 입력 → Send 버튼 클릭
    ↓
handleAddComment()
    ↓
Validation: newComment.trim() 체크
    ↓
isLoading = true
    ↓
addFeedPost({ caseId, body: newComment })
    ↓
PortalDashboardController.addFeedPost(caseId, body)
    ↓
FeedItem 생성
    ParentId = caseId
    Body = body
    Type = 'TextPost'
    Visibility = 'AllUsers'  ← 중요!
    ↓
insert FeedItem
    ↓
Success → refreshApex(wiredCommentsResult)
    ↓
getCaseFeed() 재호출
    ↓
최신 댓글 목록 반영
    ↓
newComment = '' (입력창 초기화)
isLoading = false
```

### 4. 네비게이션 플로우

```
User: Header의 "Dashboard" 클릭
    ↓
navigateToHome(event)
    ↓
NavigationMixin.Navigate({
    type: 'comm__namedPage',
    attributes: { name: 'Home' },
    state: { tab: 'overview', t: Date.now() }
})
    ↓
URL 변경: /s/home?tab=overview&t=1234567890
    ↓
@wire(CurrentPageReference) 트리거
    ↓
getStateParameters(currentPageReference)
    ↓
activeTab = 'overview'
viewMode = 'dashboard'
selectedCase = null
    ↓
UI 업데이트 (Overview 탭 활성화)
```

---

## UI/UX 디자인 가이드

### 색상 팔레트

```css
/* Primary Colors */
--color-primary: #2d4a3e;        /* 다크 그린 (헤더 배경) */
--color-primary-dark: #1e352a;   /* 더 진한 그린 (헤더 스크롤) */
--color-accent: #7cb342;         /* 라이트 그린 (액센트, 호버) */

/* Neutral Colors */
--color-white: #ffffff;
--color-gray-light: #f3f3f3;     /* 인바운드 메시지 배경 */
--color-gray-dark: #333333;

/* Salesforce SLDS */
--slds-c-button-brand-color-background: #0176d3;  /* 아웃바운드 메시지, 전송 버튼 */
```

### 타이포그래피

```css
/* Headings */
.slds-text-heading_medium {
    font-size: 1.25rem;
    font-weight: 600;
    line-height: 1.5;
}

.slds-text-heading_small {
    font-size: 1rem;
    font-weight: 600;
}

/* Body */
body {
    font-family: 'Salesforce Sans', Arial, sans-serif;
    font-size: 0.875rem;
    line-height: 1.5;
}

/* Labels */
.label {
    font-size: 0.75rem;
    color: #706e6b;
    text-transform: uppercase;
    letter-spacing: 0.5px;
}
```

### 간격 시스템

```css
--space-xs: 0.5rem;   /* 8px */
--space-md: 1.5rem;   /* 24px */
--space-lg: 2rem;     /* 32px */
--space-xl: 3rem;     /* 48px */
```

### 반응형 브레이크포인트

```css
/* Mobile First */
@media (max-width: 768px) {
    /* 모바일 스타일 */
    .header-inner {
        flex-direction: column;
    }
    
    .nav {
        position: fixed;
        top: var(--header-height);
        left: 0;
        right: 0;
        transform: translateY(-100%);
    }
    
    .nav.active {
        transform: translateY(0);
    }
}

@media (min-width: 769px) {
    /* 데스크톱 스타일 */
    .menu-toggle {
        display: none;
    }
}
```

### 애니메이션

```css
/* Transitions */
--transition-normal: 0.3s ease;
--transition-fast: 0.15s ease;

/* Hover Effects */
.nav-link::after {
    content: '';
    width: 0;
    height: 2px;
    background: var(--color-accent);
    transition: width var(--transition-normal);
}

.nav-link:hover::after {
    width: 100%;
}

/* Button Hover */
.btn-logout:hover {
    transform: translateY(-1px);
    box-shadow: 0 4px 12px rgba(0, 0, 0, 0.1);
}
```

### 채팅 UI 패턴

```css
/* 말풍선 스타일 */
.message-content {
    max-width: 70%;
    padding: 12px 16px;
    border-radius: 16px;
    word-wrap: break-word;
}

/* 본인 메시지 (오른쪽) */
.feed-item.outbound {
    flex-direction: row-reverse;
    justify-content: flex-start;
}

.feed-item.outbound .message-content {
    background: #0176d3;
    color: white;
    border-bottom-right-radius: 4px;
}

/* 타인 메시지 (왼쪽) */
.feed-item.inbound .message-content {
    background: #f3f3f3;
    color: #333;
    border-bottom-left-radius: 4px;
}

/* 전송 버튼 */
.send-btn {
    width: 40px;
    height: 40px;
    border-radius: 50%;
    background: #0176d3;
    display: flex;
    align-items: center;
    justify-content: center;
    transition: all 0.2s;
}

.send-btn:hover {
    background: #014f8e;
    transform: scale(1.05);
}
```

---

## 배포 및 테스트

### 배포 순서

1. **Apex 클래스 배포**
   ```bash
   sfdx force:source:deploy -p force-app/main/default/classes/PortalDashboardController.cls
   ```

2. **LWC 컴포넌트 배포**
   ```bash
   sfdx force:source:deploy -p force-app/main/default/lwc/portalHeader
   sfdx force:source:deploy -p force-app/main/default/lwc/portalFooter
   sfdx force:source:deploy -p force-app/main/default/lwc/portalCaseDetail
   sfdx force:source:deploy -p force-app/main/default/lwc/portalDashboard
   ```

3. **Static Resources 배포**
   ```bash
   sfdx force:source:deploy -p force-app/main/default/staticresources/pre_logo
   ```

### 테스트 클래스

#### PortalDashboardControllerTest.cls

**테스트 데이터 설정**:
```apex
@testSetup
static void setupData() {
    Account testAccount = new Account(Name = 'Test Account');
    insert testAccount;
    
    Contact testContact = new Contact(
        LastName = 'Test Contact',
        AccountId = testAccount.Id
    );
    insert testContact;
    
    Order testOrder = new Order(
        AccountId = testAccount.Id,
        EffectiveDate = Date.today(),
        Status = 'Requested'
    );
    insert testOrder;
    
    Case testCase = new Case(
        AccountId = testAccount.Id,
        Subject = 'Test Case',
        Status = 'New'
    );
    insert testCase;
    
    Contract testContract = new Contract(
        AccountId = testAccount.Id,
        StartDate = Date.today(),
        ContractTerm = 12
    );
    insert testContract;
}
```

**테스트 메서드**:
```apex
@isTest
static void testGetRelatedRecords() {
    Account acc = [SELECT Id FROM Account LIMIT 1];
    
    Test.startTest();
    PortalDashboardController.DashboardData data = 
        PortalDashboardController.getRelatedRecords(acc.Id);
    Test.stopTest();
    
    System.assertNotEquals(null, data);
    System.assertEquals(1, data.orders.size());
    System.assertEquals(1, data.cases.size());
    System.assertEquals(1, data.contracts.size());
}

@isTest
static void testCreateOrder() {
    Account acc = [SELECT Id FROM Account LIMIT 1];
    Map<String, Object> orderDetails = new Map<String, Object>();
    orderDetails.put('AccountId', acc.Id);
    orderDetails.put('Status', 'Requested');
    orderDetails.put('EffectiveDate', String.valueOf(Date.today()));
    
    Test.startTest();
    Order newOrder = PortalDashboardController.createOrder(orderDetails);
    Test.stopTest();
    
    System.assertNotEquals(null, newOrder.Id);
    System.assertEquals(acc.Id, newOrder.AccountId);
}
```

### Experience Cloud 설정

#### 1. 사이트 생성
- Setup → Digital Experiences → All Sites → New
- Template: Customer Service (Aura)
- Name: Pre Portal

#### 2. 컴포넌트 추가
- Builder → Components → Custom Components
- `portalHeader` → Header 영역에 드래그
- `portalDashboard` → Main 영역에 드래그
- `portalFooter` → Footer 영역에 드래그

#### 3. 페이지 설정
- Home Page:
  - URL: `/s/home`
  - Components: portalHeader, portalDashboard, portalFooter

#### 4. 권한 설정
- Sharing Settings:
  - Order: Public Read Only (Account 기준)
  - Case: Public Read/Write (Account 기준)
  - Contract: Public Read Only (Account 기준)
  - FeedItem: Public Read/Write
  - CaseComment: Public Read/Write

#### 5. Profile 설정
- Customer Community Plus Profile:
  - Apex Class Access: PortalDashboardController
  - Object Permissions:
    - Order: Read
    - Case: Read, Create, Edit
    - Contract: Read
    - FeedItem: Read, Create
    - CaseComment: Read, Create

### 테스트 시나리오

#### 시나리오 1: 대시보드 조회
1. 포털 사용자로 로그인
2. 홈페이지 접속
3. Overview 탭에서 최근 Orders, Cases, Contracts 확인
4. Orders 탭 클릭 → 전체 주문 목록 확인
5. 페이지네이션 테스트 (Next/Previous)

**예상 결과**:
- ✅ 사용자 이름이 헤더에 표시됨
- ✅ 각 탭에 데이터가 정상 표시됨
- ✅ 페이지네이션이 정상 작동함

#### 시나리오 2: 케이스 상세 조회
1. Cases 탭 클릭
2. Case Number 클릭
3. 케이스 상세 화면 확인
4. 과거 댓글 확인 (CaseComment, FeedItem, EmailMessage 통합)
5. "Back to Dashboard" 클릭

**예상 결과**:
- ✅ 케이스 정보 (Status, Priority, Date) 표시됨
- ✅ 모든 유형의 댓글이 시간순으로 표시됨
- ✅ 본인 댓글은 오른쪽, 타인 댓글은 왼쪽에 표시됨
- ✅ 뒤로가기 시 대시보드로 복귀

#### 시나리오 3: 댓글 작성
1. 케이스 상세 화면에서 댓글 입력
2. Send 버튼 클릭
3. 새로고침 확인

**예상 결과**:
- ✅ 댓글이 즉시 피드에 추가됨
- ✅ 입력창이 초기화됨
- ✅ Salesforce 표준 화면에서도 댓글 확인 가능

#### 시나리오 4: 네비게이션
1. Header의 "Dashboard" 클릭
2. "Orders" 클릭
3. "Support" 클릭
4. 로고 클릭

**예상 결과**:
- ✅ 각 링크 클릭 시 해당 탭으로 이동
- ✅ 케이스 상세 화면에서도 네비게이션 작동
- ✅ 로고 클릭 시 Overview 탭으로 이동

#### 시나리오 5: 모바일 반응형
1. 브라우저 창 크기를 768px 이하로 조정
2. 햄버거 메뉴 클릭
3. 네비게이션 메뉴 확인
4. 메뉴 항목 클릭

**예상 결과**:
- ✅ 모바일 메뉴가 정상 표시됨
- ✅ 메뉴 토글이 작동함
- ✅ 메뉴 클릭 시 자동으로 닫힘

---

## 주요 기술 포인트

### 1. Wire Service 활용
- `@wire(getRecord)`: 사용자 정보 조회
- `@wire(CurrentPageReference)`: URL State 감지
- `@wire(getRelatedRecords)`: 대시보드 데이터 조회
- `@wire(getCaseFeed)`: 케이스 피드 조회

### 2. 반응성 관리
- `@track`: 객체/배열 변경 감지
- `@api`: 부모-자식 컴포넌트 통신
- Spread Operator (`{ ...state }`): 강제 반응성 트리거

### 3. 데이터 통합
- 4개 소스 (CaseComment, FeedItem, FeedComment, EmailMessage) 통합
- FeedWrapper로 표준화
- Comparable 인터페이스로 정렬

### 4. 보안
- `with sharing`: Row-Level Security 적용
- `Visibility = 'AllUsers'`: 포털 사용자 가시성
- `IsExternallyVisible = true`: 이메일 외부 노출 제어

### 5. 사용자 경험
- 채팅 스타일 UI (카카오톡 유사)
- 실시간 새로고침 (`refreshApex`)
- 페이지네이션 (대용량 데이터 처리)
- 반응형 디자인 (모바일 지원)

---

## 향후 개선 사항

### 기능 개선
- [ ] 케이스 생성 기능 추가
- [ ] 주문 생성 모달 개선 (제품 선택, 수량 입력)
- [ ] 파일 첨부 기능 (ContentVersion)
- [ ] 알림 기능 (Bell Icon + 미확인 댓글 카운트)
- [ ] 검색 기능 (케이스/주문 검색)

### 성능 최적화
- [ ] Lazy Loading (무한 스크롤)
- [ ] 캐싱 전략 (cacheable=true 최적화)
- [ ] 이미지 최적화 (WebP 포맷)
- [ ] Code Splitting (LWC 모듈 분리)

### UI/UX 개선
- [ ] 다크 모드 지원
- [ ] 다국어 지원 (Custom Labels)
- [ ] 접근성 개선 (ARIA 속성)
- [ ] 애니메이션 추가 (Framer Motion 스타일)

### 보안 강화
- [ ] CSRF 토큰 검증
- [ ] Rate Limiting (API 호출 제한)
- [ ] 입력 값 Sanitization
- [ ] XSS 방어 강화

---

## 참고 자료

### Salesforce 공식 문서
- [Lightning Web Components Developer Guide](https://developer.salesforce.com/docs/component-library/documentation/en/lwc)
- [Experience Cloud Developer Guide](https://developer.salesforce.com/docs/atlas.en-us.exp_cloud_lc.meta/exp_cloud_lc/)
- [Apex Developer Guide](https://developer.salesforce.com/docs/atlas.en-us.apexcode.meta/apexcode/)

### 디자인 시스템
- [Salesforce Lightning Design System](https://www.lightningdesignsystem.com/)
- [SLDS Component Blueprints](https://www.lightningdesignsystem.com/components/overview/)

### 코드 예제
- [LWC Recipes](https://github.com/trailheadapps/lwc-recipes)
- [Experience Cloud Recipes](https://github.com/trailheadapps/experience-cloud-recipes)

---

## 버전 히스토리

### v1.0.0 (2024-12-26)
- ✅ 초기 릴리스
- ✅ 대시보드 기본 기능 구현
- ✅ 케이스 상세 및 피드 통합
- ✅ 헤더/푸터 컴포넌트
- ✅ 반응형 디자인

### v1.1.0 (계획)
- 케이스 생성 기능
- 파일 첨부 지원
- 알림 기능

---

## 문의 및 지원

### 개발팀
- **프로젝트**: Pre Portal System
- **플랫폼**: Salesforce Experience Cloud
- **프레임워크**: Lightning Web Components

### 기술 스택
- Apex (Backend)
- LWC (Frontend)
- SLDS (Design System)
- Experience Cloud (Platform)

---

**문서 작성일**: 2024-12-26  
**문서 버전**: 1.0.0  
**작성자**: AI Assistant (Antigravity)
