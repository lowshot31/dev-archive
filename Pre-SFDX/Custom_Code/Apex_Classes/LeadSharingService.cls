public class LeadSharingService {
    @InvocableMethod(label='Share Leads by Distance' description='1분 뒤 좌표를 확인하여 담당자 공유')
    public static void shareLeads(List<Id> leadIds) {
        List<LeadShare> sharesToCreate = new List<LeadShare>();
        
        // 1분 뒤 시점의 리드 정보를 다시 쿼리 (좌표 포함)
        List<Lead> leads = [SELECT Id, Latitude, Longitude, Industry FROM Lead WHERE Id IN :leadIds];

        for (Lead l : leads) {
            if (l.Latitude != null && l.Longitude != null && l.Industry != null) {
                // 거리순 상위 3명 조회
                List<Assignment_Master__c> nearbyReps = [
                    SELECT Manager__c 
                    FROM Assignment_Master__c 
                    WHERE Industry__c = :l.Industry 
                    ORDER BY DISTANCE(Location__c, GEOLOCATION(:l.Latitude, :l.Longitude), 'km') ASC 
                    LIMIT 3
                ];

                for (Assignment_Master__c master : nearbyReps) {
                    sharesToCreate.add(new LeadShare(
                        LeadId = l.Id,
                        UserOrGroupId = master.Manager__c,
                        LeadAccessLevel = 'Edit',
                        RowCause = Schema.LeadShare.RowCause.Manual
                    ));
                }
            }
        }

        if (!sharesToCreate.isEmpty()) {
            Database.insert(sharesToCreate, false);
        }
    }
}