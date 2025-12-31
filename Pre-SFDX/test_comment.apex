// Test CaseComment creation as portal user simulation
String caseId = '500gK00000ZEgT5QAL';

try {
    // Simulate what the controller does
    CaseComment cc = new CaseComment();
    cc.ParentId = caseId;
    cc.CommentBody = 'Test comment from Apex: ' + DateTime.now();
    cc.IsPublished = true;
    insert cc;
    System.debug('SUCCESS: CaseComment created with Id: ' + cc.Id);
} catch (Exception e) {
    System.debug('ERROR: ' + e.getMessage());
    System.debug('ERROR TYPE: ' + e.getTypeName());
    System.debug('STACK TRACE: ' + e.getStackTraceString());
}
