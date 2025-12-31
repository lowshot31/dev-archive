# Lead 필수 필드 및 중복 검사 규칙

## 📋 Lead 필수 필드 (Required Fields)

### 표준 필수 필드:
1. **LastName** - 성 (필수)
2. **Company** - 회사명 (필수)

### 선택적 필드 (하지만 권장):
- FirstName - 이름
- Email - 이메일
- Phone - 전화번호
- Status - 리드 상태 (기본값: Open - Not Contacted)

### 커스텀 필드:
- **Region__c** - 지역 (선택)
- **District__c** - 구역 (선택)
- **Product_Interest__c** - 관심 제품 (다중선택, 선택)
- **Monthly_Expected_Quantity__c** - 월별 예상 수량 (선택)
- **Preferred_Start_Date__c** - 선호 시작일 (선택)

## 🔍 Standard Lead Duplicate Rule 분석

### Duplicate Rule 설정:
- **Rule Name**: Standard Lead Duplicate Rule
- **Description**: Identify leads that duplicate other leads and contacts
- **Active**: ✅ Yes
- **Action On Create**: **Allow** (중복이 발견되어도 생성 허용)
- **Action On Edit**: **Allow** (중복이 발견되어도 수정 허용)
- **Operations On Create**: Alert + Report (알림과 리포트 생성)
- **Operations On Edit**: Alert + Report

### Matching Rules (중복 검사 규칙):
1. **Standard Contact Matching Rule** - Contact와 비교
2. **Standard Lead Matching Rule** - Lead와 비교

## 🎯 Standard Lead Matching Rule 상세

Salesforce의 Standard Lead Matching Rule은 다음 조건으로 중복을 검사합니다:

### 검사 조건 (OR 로직):

#### 조건 1: Email 매칭
```
Lead.Email = 기존 Lead.Email
```
- 동일한 이메일 주소가 있으면 중복으로 판단

#### 조건 2: Company + Last Name 매칭
```
Lead.Company = 기존 Lead.Company
AND
Lead.LastName = 기존 Lead.LastName
```
- 동일한 회사명 + 동일한 성이 있으면 중복으로 판단

### 중복 검사 예시:

#### ✅ 생성 가능 (중복 아님):
```
Lead 1: Email=test@test.com, Company=당중초등학교, LastName=홍길동
Lead 2: Email=test@pre.com,  Company=산본초등학교, LastName=홍길동
→ 이메일 다름, 회사명 다름 → 생성 허용
```

#### ⚠️ 중복 감지 (하지만 생성 허용):
```
Lead 1: Email=test@test.com, Company=당중초등학교, LastName=홍길동
Lead 2: Email=test@test.com, Company=산본초등학교, LastName=김철수
→ 이메일 동일 → 중복 감지 → Alert 발생 → 생성 허용 (Action=Allow)
```

```
Lead 1: Email=test1@test.com, Company=당중초등학교, LastName=홍길동
Lead 2: Email=test2@test.com, Company=당중초등학교, LastName=홍길동
→ 회사+성 동일 → 중복 감지 → Alert 발생 → 생성 허용 (Action=Allow)
```

## 🚨 Web-to-Lead가 실패하는 경우

### Lead가 생성되지 않는 주요 원인:

1. **필수 필드 누락**
   - LastName 또는 Company가 비어있음
   - 해결: Web-to-Lead 폼에 필수 필드 포함 확인

2. **Validation Rule 위반**
   - 커스텀 Validation Rule 조건 미충족
   - 해결: Setup → Object Manager → Lead → Validation Rules 확인

3. **Web-to-Lead 설정 오류**
   - 잘못된 OrgID
   - 필드명 오타
   - 해결: Web-to-Lead 폼 재생성

4. **Daily Limit 초과**
   - Salesforce Web-to-Lead 일일 제한: 500개
   - 해결: 다음 날 다시 시도

5. **reCAPTCHA 실패**
   - Bot으로 판단되어 차단
   - 해결: reCAPTCHA 검증 통과 필요

## 💡 권장사항

### Web-to-Lead 폼 필수 항목:
```html
<!-- 필수 -->
<input type="hidden" name="oid" value="YOUR_ORG_ID">
<input type="hidden" name="retURL" value="SUCCESS_URL">

<!-- 필수 필드 -->
<input type="text" name="last_name" required>
<input type="text" name="company" required>

<!-- 권장 필드 -->
<input type="text" name="first_name">
<input type="email" name="email">
<input type="tel" name="phone">
```

### 중복 방지 전략:

**Option 1**: 이메일 필수 입력 + 이메일 검증
- Email 필드를 required로 설정
- 사용자에게 중복 가능성 안내

**Option 2**: Duplicate Rule Action 변경
- Allow → Block으로 변경하여 중복 생성 차단
- 단점: 정당한 Lead도 차단될 수 있음

**Option 3**: Before Insert Trigger 구현
- 커스텀 로직으로 중복 검사
- 더 세밀한 제어 가능

## 📊 디버깅 방법

### 1. Debug Log 확인:
```
Setup → Debug Logs → New Trace Flag
→ User: Automated Process
→ Start/End Time 설정
→ Lead 생성 시도
→ Debug Log 확인
```

### 2. Failed Email 알림 설정:
```
Setup → Email Administration → Deliverability
→ Lead Assignment Email Notification 활성화
```

### 3. Apex 테스트:
```apex
Lead testLead = new Lead(
    LastName = 'Test',
    Company = 'Test Company',
    Email = 'test@example.com'
);
try {
    insert testLead;
    System.debug('Lead created: ' + testLead.Id);
} catch (Exception e) {
    System.debug('Error: ' + e.getMessage());
}
```

## 🔗 참고 자료

- [Salesforce Lead Object Documentation](https://developer.salesforce.com/docs/atlas.en-us.object_reference.meta/object_reference/sforce_api_objects_lead.htm)
- [Duplicate Management Guide](https://help.salesforce.com/s/articleView?id=sf.duplicate_management.htm)
- [Web-to-Lead Best Practices](https://help.salesforce.com/s/articleView?id=sf.setting_up_web-to-lead.htm)
