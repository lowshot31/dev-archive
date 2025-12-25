package com.sell_buy.sell_buy.db.repository;

import com.sell_buy.sell_buy.db.entity.PointTransferred;
import org.springframework.data.jpa.repository.JpaRepository;
import java.util.Optional;

public interface PointTransferredRepository extends JpaRepository<PointTransferred, Long> {

    // 특정 사용자 간의 마지막 결제 내역 조회
    Optional<PointTransferred> findTopBySenderIdAndReceiverIdOrderByTransferDateDesc(Long senderId, Long receiverId);
}
