// Test as Portal User: 정 다은 (005gK00000a2hjPQAQ)
// Account: 산본중학교 (001gK00000WN2bOQAT)
// Case: 00001065 (500gK00000ZEgT5QAL)

User portalUser = [SELECT Id, Name, ContactId, Contact.AccountId FROM User WHERE Id = '005gK00000a2hjPQAQ'];
System.debug('Portal User: ' + portalUser.Name);
System.debug('Portal User AccountId: ' + portalUser.Contact.AccountId);

System.runAs(portalUser) {
    String caseId = '500gK00000ZEgT5QAL';
    
    try {
        // Check if user can see the case
        List<Case> cases = [SELECT Id, AccountId FROM Case WHERE Id = :caseId];
        System.debug('Cases found: ' + cases.size());
        if (cases.size() > 0) {
            System.debug('Case AccountId: ' + cases[0].AccountId);
        }
        
        // Try to create CaseComment
        CaseComment cc = new CaseComment();
        cc.ParentId = caseId;
        cc.CommentBody = 'Test from portal user: ' + DateTime.now();
        cc.IsPublished = true;
        insert cc;
        
        System.debug('SUCCESS: CaseComment created with Id: ' + cc.Id);
    } catch (Exception e) {
        System.debug('ERROR Type: ' + e.getTypeName());
        System.debug('ERROR Message: ' + e.getMessage());
        System.debug('ERROR Stack: ' + e.getStackTraceString());
    }
}
