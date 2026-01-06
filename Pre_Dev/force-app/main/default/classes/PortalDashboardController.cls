public with sharing class PortalDashboardController {
    
    @AuraEnabled
    public static List<FeedWrapper> getCaseFeed(String caseId) {
        // Use without sharing to fetch feed data for portal users
        FeedFetcher fetcher = new FeedFetcher();
        return fetcher.fetchCaseFeed(caseId);
    }
    
    // Inner class without sharing to fetch case feed for portal users
    public without sharing class FeedFetcher {
        public List<FeedWrapper> fetchCaseFeed(String caseId) {
            // Security: Verify the Case belongs to the user's Account
            List<Case> cases = [SELECT Id, AccountId FROM Case WHERE Id = :caseId LIMIT 1];
            if (cases.isEmpty()) {
                throw new AuraHandledException('Case not found.');
            }
            
            Case c = cases[0];
            String userAccountId = getUserAccountId();
            
            // Allow if userAccountId is blank (for admin users) or matches case account
            if (String.isNotBlank(userAccountId) && c.AccountId != userAccountId) {
                throw new AuraHandledException('Access Denied: You do not have permission to view this case.');
            }
            
            List<FeedWrapper> feedList = new List<FeedWrapper>();
            try {
                // A. Fetch Case Comments (Standard Comments)
                for(CaseComment cc : [SELECT Id, CommentBody, CreatedDate, CreatedBy.Name, CreatedBy.Id 
                                       FROM CaseComment 
                                       WHERE ParentId = :caseId AND IsPublished = true]) {
                    feedList.add(new FeedWrapper(cc.Id, cc.CommentBody, cc.CreatedDate, cc.CreatedBy.Name, cc.CreatedBy.Id, 'Comment'));
                }
                
                // B. Fetch Feed Items (Chatter Posts) - Get IDs for FeedComment query later
                List<Id> feedItemIds = new List<Id>();
                for(FeedItem fi : [SELECT Id, Body, CreatedDate, CreatedBy.Name, CreatedBy.Id 
                                   FROM FeedItem 
                                   WHERE ParentId = :caseId AND Visibility = 'AllUsers']) {
                    feedItemIds.add(fi.Id);
                    String bodyText = fi.Body != null ? fi.Body.replaceAll('<[^>]+>', '') : '';
                    if(String.isNotBlank(bodyText)) {
                        feedList.add(new FeedWrapper(fi.Id, bodyText, fi.CreatedDate, fi.CreatedBy.Name, fi.CreatedBy.Id, 'Post'));
                    }
                }

                // C. Fetch Feed Comments (Replies to Chatter Posts) - Use FeedItemId, not ParentId
                if (!feedItemIds.isEmpty()) {
                    for(FeedComment fc : [SELECT Id, CommentBody, CreatedDate, CreatedBy.Name, CreatedBy.Id 
                                           FROM FeedComment 
                                           WHERE FeedItemId IN :feedItemIds]) {
                        String bodyText = fc.CommentBody != null ? fc.CommentBody.replaceAll('<[^>]+>', '') : '';
                        if(String.isNotBlank(bodyText)) {
                            feedList.add(new FeedWrapper(fc.Id, bodyText, fc.CreatedDate, fc.CreatedBy.Name, fc.CreatedBy.Id, 'Reply'));
                        }
                    }
                }

                // D. Fetch Email Messages (Email-to-Case history)
                for(EmailMessage em : [SELECT Id, TextBody, CreatedDate, FromName, FromAddress, Incoming 
                                       FROM EmailMessage 
                                       WHERE ParentId = :caseId AND IsExternallyVisible = true]) {
                    String author = String.isNotBlank(em.FromName) ? em.FromName : em.FromAddress;
                    feedList.add(new FeedWrapper(em.Id, em.TextBody, em.CreatedDate, author, 'email_source', em.Incoming ? 'Email In' : 'Email Out'));
                }
                
                // Comprehensive Sort by Date Desc (Newest Top)
                feedList.sort(); 
            } catch (Exception e) {
                throw new AuraHandledException('Error fetching history: ' + e.getMessage());
            }
            return feedList;
        }
    }

    public class FeedWrapper implements Comparable {
        @AuraEnabled public String id;
        @AuraEnabled public String body;
        @AuraEnabled public DateTime createdDate;
        @AuraEnabled public String authorName;
        @AuraEnabled public String authorId;
        @AuraEnabled public String type;

        public FeedWrapper(String id, String body, DateTime dt, String name, String aid, String type) {
            this.id = id;
            this.body = body;
            this.createdDate = dt;
            this.authorName = name;
            this.authorId = aid;
            this.type = type;
        }

        public Integer compareTo(Object compareTo) {
            FeedWrapper other = (FeedWrapper)compareTo;
            if (this.createdDate == other.createdDate) return 0;
            // Descending order (Newest first)
            return this.createdDate > other.createdDate ? -1 : 1;
        }
    }

    @AuraEnabled
    public static void addFeedPost(String caseId, String body) {
        // Use without sharing class to handle both Case query and CaseComment creation
        // Portal users may not have direct access to Case records in with sharing context
        CommentPoster poster = new CommentPoster();
        poster.createCaseComment(caseId, body);
    }
    
    // Inner class without sharing to handle CaseComment insertion for portal users
    public without sharing class CommentPoster {
        public void createCaseComment(String caseId, String body) {
            try {
                // Query Case with AccountId for security check
                List<Case> cases = [SELECT Id, AccountId FROM Case WHERE Id = :caseId LIMIT 1];
                if (cases.isEmpty()) {
                    throw new AuraHandledException('Case not found.');
                }
                
                Case c = cases[0];
                
                // Get current user's AccountId directly in without sharing context
                String userAccountId = null;
                List<User> users = [SELECT Contact.AccountId, AccountId FROM User WHERE Id = :UserInfo.getUserId() LIMIT 1];
                if (!users.isEmpty()) {
                    User u = users[0];
                    if (u.Contact != null && u.Contact.AccountId != null) {
                        userAccountId = u.Contact.AccountId;
                    } else {
                        userAccountId = u.AccountId;
                    }
                }
                
                // For portal users, verify the case belongs to their account
                // Allow if userAccountId is blank (for admin users) or matches case account
                if (String.isNotBlank(userAccountId) && c.AccountId != userAccountId) {
                    throw new AuraHandledException('Access Denied: You do not have permission to post to this case.');
                }
                
                // Create CaseComment
                CaseComment cc = new CaseComment();
                cc.ParentId = caseId;
                cc.CommentBody = body;
                cc.IsPublished = true; // Makes it visible to portal users
                insert cc;
            } catch (Exception e) {
                throw new AuraHandledException('Error adding comment: ' + e.getMessage());
            }
        }
    }

    // --- Dashboard Data Logic ---
    public class DashboardData {
        @AuraEnabled public List<Order> orders;
        @AuraEnabled public List<Case> cases;
        @AuraEnabled public List<Contract> contracts;
        public DashboardData() {
            this.orders = new List<Order>();
            this.cases = new List<Case>();
            this.contracts = new List<Contract>();
        }
    }

    @AuraEnabled(cacheable=true)
    public static DashboardData getRelatedRecords(String accountId) {
        // Security: Get user's AccountId
        String targetAccountId = accountId;
        if (String.isBlank(targetAccountId)) {
            targetAccountId = getUserAccountId();
        }
        if (String.isBlank(targetAccountId)) {
            return new DashboardData();
        }
        
        // Use inner class to fetch data without sharing restrictions
        DataFetcher fetcher = new DataFetcher();
        return fetcher.fetchDashboardData(targetAccountId);
    }
    
    // Inner class to fetch dashboard data without sharing
    public without sharing class DataFetcher {
        public DashboardData fetchDashboardData(String accountId) {
            DashboardData data = new DashboardData();
            try {
                data.orders = [SELECT Id, OrderNumber, Status, TotalAmount, EffectiveDate, 
                                     Delivery_Staus__c, Description, CreatedDate
                              FROM Order 
                              WHERE AccountId = :accountId 
                              ORDER BY CreatedDate DESC];
                              
                data.cases = [SELECT Id, CaseNumber, Subject, Status, Priority, CreatedDate,
                                    Description, Owner.Name,
                                    Issue_Date__c, Related_Product__c, Related_Product__r.Name,
                                    (SELECT Id FROM ContentDocumentLinks LIMIT 1)
                             FROM Case 
                             WHERE AccountId = :accountId 
                             ORDER BY CreatedDate DESC];
                             
                data.contracts = [SELECT Id, ContractNumber, Status, StartDate, EndDate 
                                 FROM Contract 
                                 WHERE AccountId = :accountId 
                                 ORDER BY StartDate DESC];
            } catch (Exception e) {
                throw new AuraHandledException('Error: ' + e.getMessage());
            }
            return data;
        }
    }

    @AuraEnabled(cacheable=true)
    public static List<Contract> getActiveContracts(String accountId) {
        String targetAccountId = accountId;
        if (String.isBlank(targetAccountId)) {
            targetAccountId = getUserAccountId();
        }
        try {
            return [SELECT Id, ContractNumber, Status, StartDate, EndDate, Pricebook2Id
                    FROM Contract 
                    WHERE AccountId = :targetAccountId 
                    AND Status = 'Activated'
                    ORDER BY StartDate DESC];
        } catch (Exception e) {
            throw new AuraHandledException('Error fetching contracts: ' + e.getMessage());
        }
    }

    @AuraEnabled(cacheable=true)
    public static List<PricebookEntry> getPricebookProducts(String pricebook2Id, String contractId) {
        try {
            // Contract is required to get products
            if (String.isBlank(contractId)) {
                return new List<PricebookEntry>();
            }
            
            // Get Contract's Pricebook2Id
            Contract c = [SELECT Pricebook2Id FROM Contract WHERE Id = :contractId LIMIT 1];
            
            if (c.Pricebook2Id == null) {
                throw new AuraHandledException('선택한 계약서에 가격표가 연결되어 있지 않습니다.');
            }
            
            return [SELECT Id, Product2Id, Product2.Name, UnitPrice, IsActive
                    FROM PricebookEntry 
                    WHERE Pricebook2Id = :c.Pricebook2Id
                    AND IsActive = true
                    ORDER BY Product2.Name ASC];
        } catch (Exception e) {
            throw new AuraHandledException('Error fetching products: ' + e.getMessage());
        }
    }

    @AuraEnabled
    public static Order createOrder(String accountId, String contractId, 
                                     List<Map<String, Object>> products, String description) {
        try {
            // Security: Verify user has access to this account
            String userAccountId = getUserAccountId();
            System.debug('createOrder - userAccountId: ' + userAccountId);
            
            if (String.isBlank(userAccountId)) {
                throw new IllegalArgumentException('사용자 계정 정보를 찾을 수 없습니다. (Portal User로 로그인해주세요)');
            }
            
            // Override accountId with the one from server-side verification
            // This prevents mismatch errors between LWC parameter and server-side logic
            String targetAccountId = userAccountId;
            
            // Validate Contract
            if (String.isBlank(contractId)) {
                throw new IllegalArgumentException('계약서를 선택해주세요.');
            }
            
            // Validate products
            if (products == null || products.isEmpty()) {
                throw new IllegalArgumentException('최소 1개 이상의 상품을 선택해주세요.');
            }
            
            // Get Contract and verify it belongs to user's Account
            List<Contract> contracts = [SELECT Id, AccountId, Pricebook2Id 
                                      FROM Contract 
                                      WHERE Id = :contractId LIMIT 1];
                                      
            if (contracts.isEmpty()) {
                throw new IllegalArgumentException('선택한 계약서를 찾을 수 없습니다.');
            }
            
            Contract c = contracts[0];
            if (c.AccountId != userAccountId) {
                throw new IllegalArgumentException('해당 계약서에 대한 권한이 없습니다.');
            }
            if (String.isBlank(c.Pricebook2Id)) {
                throw new IllegalArgumentException('선택한 계약서에 연결된 가격표(Pricebook)가 없습니다.');
            }
            
            Order newOrder = new Order();
            newOrder.AccountId = targetAccountId;
            newOrder.ContractId = contractId;
            newOrder.Status = 'Requested';
            newOrder.EffectiveDate = Date.today();
            newOrder.Description = description;
            newOrder.Pricebook2Id = c.Pricebook2Id;
            newOrder.Delivery_Staus__c = 'Ready'; // Default delivery status
            
            insert newOrder;
            
            // Create Order Products
            // First, collect all PricebookEntryIds to query Product2Id
            Set<String> pricebookEntryIds = new Set<String>();
            for (Map<String, Object> prod : products) {
                String pbeId = (String)prod.get('pricebookEntryId');
                if (String.isNotBlank(pbeId)) {
                    pricebookEntryIds.add(pbeId);
                }
            }
            
            // Query PricebookEntry to get Product2Id
            Map<String, String> pbeToProduct = new Map<String, String>();
            for (PricebookEntry pbe : [SELECT Id, Product2Id FROM PricebookEntry WHERE Id IN :pricebookEntryIds]) {
                pbeToProduct.put(pbe.Id, pbe.Product2Id);
            }
            
            List<OrderItem> orderItems = new List<OrderItem>();
            for (Map<String, Object> prod : products) {
                String pbeId = (String)prod.get('pricebookEntryId');
                OrderItem oi = new OrderItem();
                oi.OrderId = newOrder.Id;
                oi.Product2Id = pbeToProduct.get(pbeId); // Get from PricebookEntry
                oi.Quantity = (Decimal)prod.get('quantity');
                oi.UnitPrice = (Decimal)prod.get('unitPrice');
                oi.PricebookEntryId = pbeId;
                orderItems.add(oi);
            }
            
            if (!orderItems.isEmpty()) {
                insert orderItems;
            }
            
            return newOrder;
        } catch (Exception e) {
            String errorMsg = e.getMessage();
            System.debug('Order Creation Error: ' + errorMsg);
            System.debug('Stack Trace: ' + e.getStackTraceString());
            
            // AuraHandledException은 그냥 던지면 "Script-thrown exception"으로 표시됩니다.
            // 반드시 setMessage()를 사용해야 실제 메시지가 브라우저에 전달됩니다.
            AuraHandledException auraEx = new AuraHandledException(errorMsg);
            auraEx.setMessage('Error creating order: ' + errorMsg + ' (Type: ' + e.getTypeName() + ')');
            throw auraEx;
        }
    }

    @AuraEnabled
    public static void uploadFiles(String recordId, List<Map<String, String>> files) {
        try {
            if (String.isBlank(recordId) || files == null || files.isEmpty()) return;
            
            // Move ALL logic to the without sharing context to avoid permission traps
            FileUploader uploader = new FileUploader();
            uploader.verifyAndInsert(recordId, files, UserInfo.getUserId());
        } catch (Exception e) {
            System.debug('CRITICAL ERROR: ' + e.getMessage());
            AuraHandledException auraEx = new AuraHandledException(e.getMessage());
            auraEx.setMessage(e.getMessage()); // Ensure message is passed to LWC
            throw auraEx;
        }
    }
    
    public without sharing class FileUploader {
        public void verifyAndInsert(String recordId, List<Map<String, String>> files, Id userId) {
            // 1. Get User AccountId without sharing
            User u = [SELECT Contact.AccountId, AccountId FROM User WHERE Id = :userId LIMIT 1];
            String userAccId = (u.Contact != null && u.Contact.AccountId != null) ? u.Contact.AccountId : u.AccountId;

            // 2. Fetch Case without sharing
            List<Case> targetCases = [SELECT Id, AccountId FROM Case WHERE Id = :recordId LIMIT 1];
            if (targetCases.isEmpty()) {
                throw new AuraHandledException('해당 케이스를 찾을 수 없습니다.');
            }
            
            // 3. Ownership Check
            if (String.isNotBlank(userAccId) && targetCases[0].AccountId != userAccId) {
                throw new AuraHandledException('본인 계정의 케이스가 아닙니다.');
            }

            // 4. Insert Files
            List<ContentVersion> cvList = new List<ContentVersion>();
            for (Map<String, String> f : files) {
                String base64 = f.get('base64Data');
                if (String.isBlank(base64)) continue;
                
                ContentVersion cv = new ContentVersion();
                cv.Title = f.get('fileName');
                cv.PathOnClient = f.get('fileName');
                cv.VersionData = EncodingUtil.base64Decode(base64);
                cv.Origin = 'H'; 
                cv.FirstPublishLocationId = recordId; 
                cvList.add(cv);
            }
            if (!cvList.isEmpty()) {
                insert cvList;
            }
        }
    }

    
    // Helper method to get current user's AccountId
    private static String getUserAccountId() {
        User u = [SELECT Contact.AccountId, AccountId FROM User WHERE Id = :UserInfo.getUserId() LIMIT 1];
        if (u.Contact != null && u.Contact.AccountId != null) {
            return u.Contact.AccountId;
        }
        return u.AccountId;
    }
    
    // --- Create Case ---
    @AuraEnabled
    public static Case createCase(String accountId, String subject, String priority, 
                                   String reason, String description, Date issueDate, 
                                   String relatedProductId) {
        try {
            // Security: Get verified User AccountId
            String userAccountId = getUserAccountId();
            
            if (String.isBlank(userAccountId)) {
                throw new IllegalArgumentException('사용자 계정 정보를 찾을 수 없습니다. (포털 사용자 정보를 확인해주세요)');
            }
            
            // Override with verified ID to prevent manipulation or mismatch errors
            String targetAccountId = userAccountId;
            
            // Validate required fields
            if (String.isBlank(subject)) {
                throw new IllegalArgumentException('문의 제목을 입력해주세요.');
            }
            
            Case newCase = new Case();
            newCase.AccountId = targetAccountId;
            newCase.Subject = subject;
            newCase.Priority = priority;
            newCase.Reason = reason;
            newCase.Description = description;
            newCase.Issue_Date__c = issueDate;
            newCase.Related_Product__c = relatedProductId;
            newCase.Origin = 'Web';
            newCase.Status = 'New';
            
            insert newCase;
            
            return newCase;
        } catch (Exception e) {
            String errorMsg = e.getMessage();
            System.debug('Case Creation Error: ' + errorMsg);
            
            AuraHandledException auraEx = new AuraHandledException(errorMsg);
            auraEx.setMessage('문의 접수 실패: ' + errorMsg);
            throw auraEx;
        }
    }
}