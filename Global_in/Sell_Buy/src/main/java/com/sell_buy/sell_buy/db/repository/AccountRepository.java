package com.sell_buy.sell_buy.db.repository;

import com.sell_buy.sell_buy.db.entity.Point;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.Optional;

public interface AccountRepository extends JpaRepository<Point, Long> {

    // 사용자 ID로 포인트 조회
    Optional<Point> findByMemId(Long memId);
}
