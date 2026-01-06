public class AccountAssignmentService {
    public static void assignDeliveryAgent(List<Account> newAccounts) {
        List<Account> accountsToUpdate = new List<Account>();

        for (Account acc : newAccounts) {
            // [조건 확인]
            // 1. 타입이 'DeliveryAgent'가 아닐 것 (본인이 대리점이면 패스)
            // 2. 좌표(BillingLatitude)가 존재할 것
            if (acc.Type != 'Delivery Agent' && acc.BillingLatitude != null) {
                
                // 가장 가까운 가동 중인 대리점 1곳 조회
                List<Account> closestAgents = [
                    SELECT Id, Name 
                    FROM Account 
                    WHERE Type = 'Delivery Agent' 
                    AND Is_Available__c = true 
                    AND Id != :acc.Id 
                    ORDER BY DISTANCE(BillingAddress, GEOLOCATION(:acc.BillingLatitude, :acc.BillingLongitude), 'km') ASC 
                    LIMIT 1
                ];

                if (!closestAgents.isEmpty()) {
                    // 업데이트를 위해 새 객체 생성 (ID와 배정할 대리점 ID만 지정)
                    accountsToUpdate.add(new Account(
                        Id = acc.Id,
                        Delivery_Agent__c = closestAgents[0].Id
                    ));
                    System.debug('### 배정 완료: ' + acc.Name + ' -> ' + closestAgents[0].Name);
                } else {
                    System.debug('### 배정 실패: 주변에 가용한 대리점이 없음');
                }
            } else {
                System.debug('### 스킵: 타입이 대리점이거나 좌표가 없음 (' + acc.Name + ')');
            }
        }

        // 실제 DB 업데이트
        if (!accountsToUpdate.isEmpty()) {
            update accountsToUpdate;
        }
    }
}