// Test getUserAccountId for portal user
User portalUser = [SELECT Id, Contact.AccountId, AccountId FROM User WHERE Id = '005gK00000a2hjPQAQ'];
System.debug('Portal User Id: ' + portalUser.Id);
System.debug('Portal User Contact.AccountId: ' + portalUser.Contact.AccountId);
System.debug('Portal User AccountId: ' + portalUser.AccountId);

// Simulate getUserAccountId logic
if (portalUser.Contact != null && portalUser.Contact.AccountId != null) {
    System.debug('Result: ' + portalUser.Contact.AccountId);
} else {
    System.debug('Result: ' + portalUser.AccountId);
}
