public class LeadSharingService {
    @InvocableMethod(label='Share Leads by Distance' description='1분 뒤 좌표를 확인하여 담당자 공유')
    public static void shareLeads(List<Id> leadIds) {
        List<LeadShare> sharesToCreate = new List<LeadShare>();
        
        // CustomNotification 타입 조회
        CustomNotificationType notificationType;
        try {
            notificationType = [
                SELECT Id, DeveloperName 
                FROM CustomNotificationType 
                WHERE DeveloperName = 'Lead_Assignment_Notification' 
                LIMIT 1
            ];
        } catch (Exception e) {
            System.debug('CustomNotificationType not found: ' + e.getMessage());
            notificationType = null;
        }
        
        // 1분 뒤 시점의 리드 정보를 다시 쿼리 (좌표 포함)
        List<Lead> leads = [
            SELECT Id, Latitude, Longitude, Industry, Company, Name, OwnerId
            FROM Lead 
            WHERE Id IN :leadIds
        ];

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
                    // 소유자 본인 제외
                    if (master.Manager__c == l.OwnerId) continue;
                    
                    // LeadShare 생성
                    sharesToCreate.add(new LeadShare(
                        LeadId = l.Id,
                        UserOrGroupId = master.Manager__c,
                        LeadAccessLevel = 'Edit',
                        RowCause = Schema.LeadShare.RowCause.Manual
                    ));
                    
                    // CustomNotification 발송
                    if (notificationType != null) {
                        Messaging.CustomNotification notification = new Messaging.CustomNotification();
                        notification.setTitle('새로운 근거리 리드 배정 알림');
                        notification.setBody(
                            l.Company + ' (' + l.Industry + ') 리드가 귀하에게 공유되었습니다. 거리를 확인하고 응대해 주세요.'
                        );
                        notification.setNotificationTypeId(notificationType.Id);
                        notification.setTargetId(l.Id);

                        try {
                            notification.send(new Set<String>{master.Manager__c});
                        } catch (Exception e) {
                            System.debug('Notification Error for User ' + master.Manager__c + ': ' + e.getMessage());
                        }
                    }
                }
            }
        }

        if (!sharesToCreate.isEmpty()) {
            Database.insert(sharesToCreate, false);
        }
    }
}