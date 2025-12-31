public with sharing class PortalDashboardController {
    
    // 1. Fully Unified Feed Methods (All comments, emails, and chatter)
    @AuraEnabled(cacheable=true)
    public static List<FeedWrapper> getCaseFeed(String caseId) {
        // Security: Verify the Case belongs to the user's Account
        Case c = [SELECT Id, AccountId FROM Case WHERE Id = :caseId LIMIT 1];
        String userAccountId = getUserAccountId();
        if (c.AccountId != userAccountId) {
            throw new AuraHandledException('Access Denied: You do not have permission to view this case.');
        }
        
        List<FeedWrapper> feedList = new List<FeedWrapper>();
        try {
            // A. Fetch Case Comments (Standard Comments)
            for(CaseComment cc : [SELECT Id, CommentBody, CreatedDate, CreatedBy.Name, CreatedBy.Id FROM CaseComment WHERE ParentId = :caseId]) {
                feedList.add(new FeedWrapper(cc.Id, cc.CommentBody, cc.CreatedDate, cc.CreatedBy.Name, cc.CreatedBy.Id, 'Comment'));
            }
            
            // B. Fetch Feed Items (Chatter Posts)
            for(FeedItem fi : [SELECT Id, Body, CreatedDate, CreatedBy.Name, CreatedBy.Id FROM FeedItem WHERE ParentId = :caseId AND Visibility = 'AllUsers']) {
                String bodyText = fi.Body != null ? fi.Body.replaceAll('<[^>]+>', '') : '';
                if(String.isNotBlank(bodyText)) {
                    feedList.add(new FeedWrapper(fi.Id, bodyText, fi.CreatedDate, fi.CreatedBy.Name, fi.CreatedBy.Id, 'Post'));
                }
            }

            // C. Fetch Feed Comments (Replies to Chatter Posts)
            for(FeedComment fc : [SELECT Id, CommentBody, CreatedDate, CreatedBy.Name, CreatedBy.Id FROM FeedComment WHERE ParentId = :caseId]) {
                String bodyText = fc.CommentBody != null ? fc.CommentBody.replaceAll('<[^>]+>', '') : '';
                if(String.isNotBlank(bodyText)) {
                    feedList.add(new FeedWrapper(fc.Id, bodyText, fc.CreatedDate, fc.CreatedBy.Name, fc.CreatedBy.Id, 'Reply'));
                }
            }

            // D. Fetch Email Messages (Email-to-Case history)
            for(EmailMessage em : [SELECT Id, TextBody, CreatedDate, FromName, FromAddress, Incoming FROM EmailMessage WHERE ParentId = :caseId AND IsExternallyVisible = true]) {
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
        // Security: Verify the Case belongs to the user's Account
        Case c = [SELECT Id, AccountId FROM Case WHERE Id = :caseId LIMIT 1];
        String userAccountId = getUserAccountId();
        if (c.AccountId != userAccountId) {
            throw new AuraHandledException('Access Denied: You do not have permission to post to this case.');
        }
        
        try {
            FeedItem fi = new FeedItem();
            fi.ParentId = caseId;
            fi.Body = body;
            fi.Type = 'TextPost';
            fi.Visibility = 'AllUsers'; // AccountId의 유저만 볼 수 있게 
            insert fi;
        } catch (Exception e) {
            throw new AuraHandledException('Error adding post: ' + e.getMessage());
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
                              ORDER BY CreatedDate DESC LIMIT 10];
                              
                data.cases = [SELECT Id, CaseNumber, Subject, Status, Priority, CreatedDate 
                             FROM Case 
                             WHERE AccountId = :accountId 
                             ORDER BY CreatedDate DESC LIMIT 10];
                             
                data.contracts = [SELECT Id, ContractNumber, Status, StartDate, EndDate 
                                 FROM Contract 
                                 WHERE AccountId = :accountId 
                                 ORDER BY StartDate DESC LIMIT 10];
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
    public static Order createOrder(String accountId, String contractId, Date effectiveDate, String description, List<Map<String, Object>> products) {
        try {
            // Security: Use logged-in user's AccountId
            String targetAccountId = getUserAccountId();
            
            // Validate Contract is required
            if (String.isBlank(contractId)) {
                throw new AuraHandledException('계약서를 선택해주세요.');
            }
            
            // Validate products
            if (products == null || products.isEmpty()) {
                throw new AuraHandledException('최소 1개 이상의 상품을 선택해주세요.');
            }
            
            // Get Contract and verify it belongs to user's Account
            Contract c = [SELECT Id, AccountId, Pricebook2Id 
                          FROM Contract 
                          WHERE Id = :contractId LIMIT 1];
                          
            if (c.AccountId != targetAccountId) {
                throw new AuraHandledException('Access Denied: Contract does not belong to your account.');
            }
            
            Order newOrder = new Order();
            newOrder.AccountId = targetAccountId;
            newOrder.Status = 'Requested';
            newOrder.EffectiveDate = effectiveDate != null ? effectiveDate : Date.today();
            newOrder.ContractId = contractId;
            newOrder.Pricebook2Id = c.Pricebook2Id; // Use Contract's Pricebook
            
            // Add Description if exists
            if (String.isNotBlank(description)) {
                newOrder.Description = description;
            }
            
            insert newOrder;
            
            // Create OrderItems
            List<OrderItem> orderItems = new List<OrderItem>();
            for (Map<String, Object> product : products) {
                OrderItem oi = new OrderItem();
                oi.OrderId = newOrder.Id;
                oi.PricebookEntryId = (String) product.get('pricebookEntryId');
                oi.Quantity = (Decimal) product.get('quantity');
                oi.UnitPrice = (Decimal) product.get('unitPrice');
                orderItems.add(oi);
            }
            
            if (!orderItems.isEmpty()) {
                insert orderItems;
            }
            
            return newOrder;
        } catch (Exception e) {
            throw new AuraHandledException('Error creating order: ' + e.getMessage());
        }
    }

    @AuraEnabled
    public static void uploadFiles(String recordId, List<Map<String, String>> files) {
        // Security: Verify the Case belongs to the user's Account before uploading files
        Case c = [SELECT Id, AccountId FROM Case WHERE Id = :recordId LIMIT 1];
        String userAccountId = getUserAccountId();
        if (c.AccountId != userAccountId) {
            throw new AuraHandledException('Access Denied: You do not have permission to upload files to this case.');
        }
        
        // Use inner class instance to bypass sharing rules for ContentVersion insertion
        FileUploader uploader = new FileUploader();
        uploader.insertFiles(recordId, files);
    }
    
    // Inner class without sharing to handle ContentVersion insertion
    public without sharing class FileUploader {
        public void insertFiles(String recordId, List<Map<String, String>> files) {
            try {
                List<ContentVersion> cvList = new List<ContentVersion>();
                for (Map<String, String> f : files) {
                    ContentVersion cv = new ContentVersion();
                    cv.Title = f.get('fileName');
                    cv.PathOnClient = f.get('fileName');
                    cv.VersionData = EncodingUtil.base64Decode(f.get('base64Data'));
                    cv.FirstPublishLocationId = recordId; // Link directly to the record
                    cvList.add(cv);
                }
                if (!cvList.isEmpty()) {
                    insert cvList;
                }
            } catch (Exception e) {
                throw new AuraHandledException('Error uploading files: ' + e.getMessage());
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
}