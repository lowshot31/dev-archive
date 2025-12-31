trigger AccountTrigger on Account (after insert, after update) {
    List<Account> accsToProcess = new List<Account>();

    for (Account acc : Trigger.new) {
        if (Trigger.isInsert) {
            // [1] 신규 생성 시 리스트에 추가
            // 단, 본인이 대리점인 경우는 제외
            if (acc.Type != 'Delivery Agent') {
                accsToProcess.add(acc);
            }
        } 
        else if (Trigger.isUpdate) {
            Account oldAcc = Trigger.oldMap.get(acc.Id);

            // [2] 주소가 변경되었는지 확인
            Boolean isAddressChanged = acc.BillingStreet != oldAcc.BillingStreet;
            
            // [3] 배송점 필드가 비어있는지 확인
            Boolean isAgentMissing = acc.Delivery_Agent__c == null;

            // 주소가 바뀌었거나 배송점이 없는데, 본인이 대리점이 아닌 경우에만 실행
            if ((isAddressChanged || isAgentMissing) && acc.Type != 'Delivery Agent') {
                accsToProcess.add(acc);
            }
        }
    }

    // 대상이 있을 경우에만 서비스 클래스 호출
    if (!accsToProcess.isEmpty()) {
        AccountAssignmentService.assignDeliveryAgent(accsToProcess);
    }
}