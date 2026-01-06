trigger LeadDistanceSharingTrigger on Lead (after insert, after update) {
    List<LeadShare> sharesToCreate = new List<LeadShare>();

    for (Lead l : Trigger.new) {
        if (l.Latitude != null && l.Longitude != null && l.Industry != null) {
            
            List<Assignment_Master__c> nearbyReps = [
                SELECT Manager__c 
                FROM Assignment_Master__c 
                WHERE Industry__c = :l.Industry 
                ORDER BY DISTANCE(Location__c, GEOLOCATION(:l.Latitude, :l.Longitude), 'km') ASC 
                LIMIT 3
            ];

            for (Assignment_Master__c master : nearbyReps) {
                // 소유자 본인 제외 로직 (에러 방지)
                if (master.Manager__c == l.OwnerId) continue;

                // LeadShare 생성 (알림은 1분 뒤 LeadSharingService에서 발송)
                LeadShare ls = new LeadShare();
                ls.LeadId = l.Id;
                ls.UserOrGroupId = master.Manager__c;
                ls.LeadAccessLevel = 'Edit';
                ls.RowCause = Schema.LeadShare.RowCause.Manual;
                sharesToCreate.add(ls);
            }
        }
    }

    if (!sharesToCreate.isEmpty()) {
        Database.insert(sharesToCreate, false);
    }
}