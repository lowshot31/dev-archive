package com.sell_buy.sell_buy.db.repository;

import com.sell_buy.sell_buy.db.entity.PointCharge;
import org.springframework.data.jpa.repository.JpaRepository;
import java.util.Optional;

public interface PointChargeRepository extends JpaRepository<PointCharge, Long> {

    // 사용자 ID로 포인트 충전 내역 조회
    Optional<PointCharge> findTopByChargerIdOrderByChargeDateDesc(Long chargerId);
}
