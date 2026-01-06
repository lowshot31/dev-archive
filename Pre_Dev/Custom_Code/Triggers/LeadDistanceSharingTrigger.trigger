trigger LeadDistanceSharingTrigger on Lead (after insert, after update) {
    List<LeadShare> sharesToCreate = new List<LeadShare>();
    
    // 1. [Setup]에서 만든 알림 타입 정보 가져오기
    CustomNotificationType notificationType = 
        [SELECT Id, DeveloperName FROM CustomNotificationType WHERE DeveloperName='Lead_Assignment_Notification' LIMIT 1];

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

                // 2. LeadShare 생성
                LeadShare ls = new LeadShare();
                ls.LeadId = l.Id;
                ls.UserOrGroupId = master.Manager__c;
                ls.LeadAccessLevel = 'Edit';
                ls.RowCause = Schema.LeadShare.RowCause.Manual;
                sharesToCreate.add(ls);

                // 3. [Notification 추가] 해당 매니저에게 알림 전송 설정
                Messaging.CustomNotification notification = new Messaging.CustomNotification();
                notification.setTitle('새로운 근거리 리드 배정 알림');
                notification.setBody(l.Company + ' (' + l.Industry + ') 리드가 귀하에게 공유되었습니다. 거리를 확인하고 응대해 주세요.');
                notification.setNotificationTypeId(notificationType.Id);
                notification.setTargetId(l.Id); // 알림 클릭 시 해당 리드로 이동

                try {
                    notification.send(new Set<String>{master.Manager__c});
                } catch (Exception e) {
                    System.debug('Notification Error: ' + e.getMessage());
                }
            }
        }
    }

    if (!sharesToCreate.isEmpty()) {
        Database.insert(sharesToCreate, false);
    }
}