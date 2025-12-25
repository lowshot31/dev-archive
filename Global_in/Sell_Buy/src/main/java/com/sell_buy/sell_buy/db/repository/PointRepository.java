package com.sell_buy.sell_buy.db.repository;

import com.sell_buy.sell_buy.db.entity.Point;
import org.springframework.data.jpa.repository.JpaRepository;

public interface PointRepository extends JpaRepository<Point, Long> {
}
