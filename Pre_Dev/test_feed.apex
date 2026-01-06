// Test adding a FeedItem to Case
String caseId = '500gK00000ZEgT5QAL';

try {
    FeedItem fi = new FeedItem();
    fi.ParentId = caseId;
    fi.Body = 'Test from Apex: ' + DateTime.now();
    fi.Type = 'TextPost';
    fi.Visibility = 'AllUsers';
    insert fi;
    System.debug('SUCCESS: FeedItem created with Id: ' + fi.Id);
} catch (Exception e) {
    System.debug('ERROR: ' + e.getMessage());
}
